import dotenv from 'dotenv';
dotenv.config();

import Razorpay from 'razorpay';
import crypto from 'crypto';
import Order from '../models/order.model.js';
import User from '../models/user.model.js';

// Initialize Razorpay instance with secure environment variables
const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_KEY_SECRET,
});

// Create order and Razorpay order in one flow
export const createPaymentOrder = async (req, res) => {
  try {
    const {
      userId,
      restaurantId,
      restaurantName,
      orderItems,
      orderTotal,
      deliveryFee,
      grandTotal,
      deliveryAddressId,
      deliveryAddress,
      restaurantCoords,
      recipientCoords,
      notes = '',
      currency = 'INR'
    } = req.body;

    // Validate required fields
    if (!userId || !restaurantId || !orderItems || !grandTotal) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields: userId, restaurantId, orderItems, grandTotal',
      });
    }

    // Validate user exists
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    console.log('Creating order for user:', userId, 'restaurant:', restaurantId);

    // Create order in database first (in PENDING state)
    const orderData = {
      userId,
      orderItems: orderItems.map(item => ({
        foodId: item.foodId,
        foodName: item.foodName,
        quantity: item.quantity,
        price: item.price,
        additives: item.additives || [],
        instructions: item.instructions || ''
      })),
      orderTotal,
      deliveryFee: deliveryFee || 20,
      grandTotal,
      deliveryAddress: deliveryAddressId,
      restaurantAddress: deliveryAddress,
      restaurantId,
      restaurantName,
      paymentMethod: 'Razorpay',
      paymentStatus: 'PENDING',
      orderStatus: 'PENDING',
      restaurantCoords,
      recipientCoords,
      notes,
      estimatedDeliveryTime: new Date(Date.now() + 30 * 60 * 1000) // 30 minutes from now
    };

    const order = new Order(orderData);
    const savedOrder = await order.save();

    console.log('Order saved with ID:', savedOrder._id);

    // Create Razorpay order
    const razorpayOptions = {
      amount: Math.round(grandTotal * 100), // Convert to paise
      currency,
      receipt: `order_${savedOrder._id}`,
      payment_capture: 1,
      notes: {
        orderId: savedOrder._id.toString(),
        userId: userId,
        restaurantId: restaurantId
      }
    };

    const razorpayOrder = await razorpay.orders.create(razorpayOptions);

    // Update order with Razorpay order ID
    savedOrder.razorpayOrderId = razorpayOrder.id;
    await savedOrder.save();

    console.log('Created Razorpay order:', razorpayOrder.id);

    return res.status(201).json({
      success: true,
      message: 'Order created successfully',
      data: {
        orderId: savedOrder._id.toString(),
        razorpayOrderId: razorpayOrder.id,
        amount: razorpayOrder.amount,
        currency: razorpayOrder.currency,
        key: process.env.RAZORPAY_KEY_ID
      }
    });

  } catch (error) {
    console.error('Order creation error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to create order',
      error: error.message,
    });
  }
};

// Verify payment and update order status
export const verifyPayment = async (req, res) => {
  try {
    const {
      razorpay_order_id,
      razorpay_payment_id,
      razorpay_signature,
      orderId
    } = req.body;

    console.log('Verifying payment for order:', orderId);
    console.log('Payment details:', { razorpay_order_id, razorpay_payment_id });

    // Find the order
    const order = await Order.findById(orderId);
    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    // Verify signature
    const expectedSignature = crypto
      .createHmac('sha256', process.env.RAZORPAY_KEY_SECRET)
      .update(`${razorpay_order_id}|${razorpay_payment_id}`)
      .digest('hex');

    if (expectedSignature !== razorpay_signature) {
      console.log('Payment signature verification failed');

      // Update order to failed
      order.paymentStatus = 'FAILED';
      order.orderStatus = 'CANCELLED';
      order.razorpayPaymentId = razorpay_payment_id;
      await order.save();

      return res.status(400).json({
        success: false,
        message: 'Payment verification failed',
      });
    }

    console.log('Payment verified successfully');

    // Update order with successful payment
    order.paymentStatus = 'COMPLETED';
    order.orderStatus = 'CONFIRMED';
    order.razorpayPaymentId = razorpay_payment_id;
    order.paymentDate = new Date();
    await order.save();

    // Populate order details for response
    const populatedOrder = await Order.findById(orderId)
      .populate('userId', 'phone email')
      .populate('orderItems.foodId', 'title imageUrl');

    return res.status(200).json({
      success: true,
      message: 'Payment verified and order confirmed successfully',
      data: {
        orderId: order._id.toString(),
        paymentId: razorpay_payment_id,
        orderStatus: order.orderStatus,
        paymentStatus: order.paymentStatus,
        totalAmount: order.grandTotal,
        restaurantName: order.restaurantName,
        orderDate: order.orderDate,
        estimatedDeliveryTime: order.estimatedDeliveryTime,
        orderItems: populatedOrder.orderItems
      }
    });

  } catch (error) {
    console.error('Payment verification error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to verify payment',
      error: error.message,
    });
  }
};

// Handle payment failure
export const handlePaymentFailure = async (req, res) => {
  try {
    const { orderId, error, razorpay_order_id, razorpay_payment_id } = req.body;

    console.log('Handling payment failure for order:', orderId);

    // Find and update the order
    const order = await Order.findById(orderId);
    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found',
      });
    }

    order.paymentStatus = 'FAILED';
    order.orderStatus = 'CANCELLED';
    order.razorpayPaymentId = razorpay_payment_id || null;
    order.paymentError = error?.description || 'Payment failed';
    await order.save();

    return res.status(200).json({
      success: true,
      message: 'Payment failure recorded',
      data: {
        orderId: order._id.toString(),
        orderStatus: order.orderStatus,
        paymentStatus: order.paymentStatus
      }
    });

  } catch (error) {
    console.error('Payment failure handling error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to handle payment failure',
      error: error.message,
    });
  }
};

// Razorpay webhook handler for redundancy
export const razorpayWebhook = async (req, res) => {
  try {
    const secret = process.env.RAZORPAY_WEBHOOK_SECRET;

    // Verify webhook signature
    const expectedSignature = crypto
      .createHmac('sha256', secret)
      .update(JSON.stringify(req.body))
      .digest('hex');

    const receivedSignature = req.headers['x-razorpay-signature'];

    if (expectedSignature !== receivedSignature) {
      console.log('Webhook signature verification failed');
      return res.status(400).json({ success: false, message: 'Invalid signature' });
    }

    const { event, payload } = req.body;
    console.log('Received webhook event:', event);

    switch (event) {
      case 'payment.captured':
        await handlePaymentCaptured(payload.payment.entity);
        break;
      case 'payment.failed':
        await handlePaymentFailedWebhook(payload.payment.entity);
        break;
      case 'order.paid':
        await handleOrderPaid(payload.order.entity);
        break;
      default:
        console.log('Unhandled webhook event:', event);
    }

    res.status(200).json({ success: true });

  } catch (error) {
    console.error('Webhook error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
};

// Helper functions for webhook handlers
async function handlePaymentCaptured(payment) {
  try {
    const order = await Order.findOne({ razorpayOrderId: payment.order_id });
    if (order && order.paymentStatus !== 'COMPLETED') {
      order.paymentStatus = 'COMPLETED';
      order.orderStatus = 'CONFIRMED';
      order.razorpayPaymentId = payment.id;
      order.paymentDate = new Date();
      await order.save();
      console.log('Order updated via webhook:', order._id);
    }
  } catch (error) {
    console.error('Error handling payment captured webhook:', error);
  }
}

async function handlePaymentFailedWebhook(payment) {
  try {
    const order = await Order.findOne({ razorpayOrderId: payment.order_id });
    if (order && order.paymentStatus !== 'FAILED') {
      order.paymentStatus = 'FAILED';
      order.orderStatus = 'CANCELLED';
      order.paymentError = payment.error_description || 'Payment failed';
      await order.save();
      console.log('Order marked as failed via webhook:', order._id);
    }
  } catch (error) {
    console.error('Error handling payment failed webhook:', error);
  }
}

async function handleOrderPaid(orderData) {
  try {
    const order = await Order.findOne({ razorpayOrderId: orderData.id });
    if (order && order.paymentStatus !== 'COMPLETED') {
      order.paymentStatus = 'COMPLETED';
      order.orderStatus = 'CONFIRMED';
      await order.save();
      console.log('Order confirmed via webhook:', order._id);
    }
  } catch (error) {
    console.error('Error handling order paid webhook:', error);
  }
}