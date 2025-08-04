import Order from '../models/order.model.js';
import User from '../models/user.model.js';
import Restaurant from '../models/restaurent.model.js';
import Food from '../models/food.model.js';
import Address from '../models/address.model.js';

// Create a new order
const createOrder = async (req, res) => {
  try {
    const {
      orderItems,
      orderTotal,
      deliveryFee,
      grandTotal,
      deliveryAddress,
      restaurantAddress,
      restaurantId,
      paymentMethod,
      paymentStatus,
      orderStatus,
      restaurantCoords,
      recipientCoords,
      promoCode,
      discountAmount,
      notes
    } = req.body;

    const userId = req.user.id;

    // Validate required fields
    if (!orderItems || !Array.isArray(orderItems) || orderItems.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Order items are required'
      });
    }

    if (!deliveryAddress || !restaurantId || !grandTotal) {
      return res.status(400).json({
        success: false,
        message: 'Delivery address, restaurant ID, and total amount are required'
      });
    }

    // Validate user exists
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    // Validate restaurant exists
    const restaurant = await Restaurant.findById(restaurantId);
    if (!restaurant) {
      return res.status(404).json({
        success: false,
        message: 'Restaurant not found'
      });
    }

    // Validate delivery address exists and belongs to user
    const address = await Address.findOne({ _id: deliveryAddress, userId: userId });
    if (!address) {
      return res.status(404).json({
        success: false,
        message: 'Delivery address not found or does not belong to user'
      });
    }

    // Validate food items exist
    for (const item of orderItems) {
      const food = await Food.findById(item.foodId);
      if (!food) {
        return res.status(404).json({
          success: false,
          message: `Food item with ID ${item.foodId} not found`
        });
      }
    }

    // Create order
    const order = new Order({
      userId,
      orderItems,
      orderTotal,
      deliveryFee,
      grandTotal,
      deliveryAddress,
      restaurantAddress,
      restaurantId,
      paymentMethod,
      paymentStatus,
      orderStatus,
      restaurantCoords,
      recipientCoords,
      promoCode,
      discountAmount,
      notes,
      orderDate: new Date(),
      estimatedDeliveryTime: new Date(Date.now() + 30 * 60 * 1000), // 30 minutes from now
    });

    const savedOrder = await order.save();

    // Update user's order history
    await User.findByIdAndUpdate(userId, {
      $push: { orderHistory: savedOrder._id }
    });

    res.status(201).json({
      success: true,
      message: 'Order created successfully',
      orderId: savedOrder._id,
      order: savedOrder
    });

  } catch (error) {
    console.error('Error creating order:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

// Get all orders for a user
const getUserOrders = async (req, res) => {
  try {
    const userId = req.user.id;
    const { status, page = 1, limit = 10 } = req.query;

    const query = { userId };
    if (status) {
      query.orderStatus = status;
    }

    const skip = (page - 1) * limit;

    const orders = await Order.find(query)
      .populate('restaurantId', 'title imageUrl')
      .populate('orderItems.foodId', 'title imageUrl price')
      .populate('deliveryAddress', 'addressLine1 addressLine2 city postalCode')
      .sort({ orderDate: -1 })
      .skip(skip)
      .limit(parseInt(limit));

    const totalOrders = await Order.countDocuments(query);

    res.status(200).json({
      success: true,
      orders,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(totalOrders / limit),
        totalOrders,
        hasNextPage: skip + orders.length < totalOrders,
        hasPrevPage: page > 1
      }
    });

  } catch (error) {
    console.error('Error fetching user orders:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

// Get order by ID
const getOrderById = async (req, res) => {
  try {
    const { orderId } = req.params;
    const userId = req.user.id;

    const order = await Order.findOne({ _id: orderId, userId })
      .populate('restaurantId', 'title imageUrl businessHours')
      .populate('orderItems.foodId', 'title imageUrl price description')
      .populate('deliveryAddress', 'addressLine1 addressLine2 city postalCode phoneNumber');

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }

    res.status(200).json({
      success: true,
      order
    });

  } catch (error) {
    console.error('Error fetching order:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

// Update order status
const updateOrderStatus = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { orderStatus, estimatedDeliveryTime } = req.body;
    const userId = req.user.id;

    const order = await Order.findOne({ _id: orderId, userId });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }

    // Validate order status transition
    const validStatuses = ['Placed', 'Confirmed', 'Preparing', 'Ready', 'Out for Delivery', 'Delivered', 'Cancelled'];
    if (!validStatuses.includes(orderStatus)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid order status'
      });
    }

    // Prevent status changes for delivered or cancelled orders
    if (order.orderStatus === 'Delivered' || order.orderStatus === 'Cancelled') {
      return res.status(400).json({
        success: false,
        message: 'Cannot update status of delivered or cancelled order'
      });
    }

    const updateData = { orderStatus };
    if (estimatedDeliveryTime) {
      updateData.estimatedDeliveryTime = new Date(estimatedDeliveryTime);
    }

    const updatedOrder = await Order.findByIdAndUpdate(
      orderId,
      updateData,
      { new: true }
    ).populate('restaurantId', 'title imageUrl');

    res.status(200).json({
      success: true,
      message: 'Order status updated successfully',
      order: updatedOrder
    });

  } catch (error) {
    console.error('Error updating order status:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

// Cancel order
const cancelOrder = async (req, res) => {
  try {
    const { orderId } = req.params;
    const userId = req.user.id;

    const order = await Order.findOne({ _id: orderId, userId });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }

    // Check if order can be cancelled
    const cancellableStatuses = ['Placed', 'Confirmed'];
    if (!cancellableStatuses.includes(order.orderStatus)) {
      return res.status(400).json({
        success: false,
        message: 'Order cannot be cancelled at this stage'
      });
    }

    const updatedOrder = await Order.findByIdAndUpdate(
      orderId,
      { 
        orderStatus: 'Cancelled',
        cancelledAt: new Date(),
        cancellationReason: req.body.reason || 'Cancelled by user'
      },
      { new: true }
    );

    res.status(200).json({
      success: true,
      message: 'Order cancelled successfully',
      order: updatedOrder
    });

  } catch (error) {
    console.error('Error cancelling order:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

// Rate order
const rateOrder = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { rating, feedback } = req.body;
    const userId = req.user.id;

    // Validate rating
    if (!rating || rating < 1 || rating > 5) {
      return res.status(400).json({
        success: false,
        message: 'Rating must be between 1 and 5'
      });
    }

    const order = await Order.findOne({ _id: orderId, userId });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: 'Order not found'
      });
    }

    // Check if order is delivered
    if (order.orderStatus !== 'Delivered') {
      return res.status(400).json({
        success: false,
        message: 'Can only rate delivered orders'
      });
    }

    // Check if already rated
    if (order.rating) {
      return res.status(400).json({
        success: false,
        message: 'Order has already been rated'
      });
    }

    const updatedOrder = await Order.findByIdAndUpdate(
      orderId,
      {
        rating,
        feedback,
        ratedAt: new Date()
      },
      { new: true }
    );

    res.status(200).json({
      success: true,
      message: 'Order rated successfully',
      order: updatedOrder
    });

  } catch (error) {
    console.error('Error rating order:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

// Get order statistics for user
const getOrderStats = async (req, res) => {
  try {
    const userId = req.user.id;

    const stats = await Order.aggregate([
      { $match: { userId: userId } },
      {
        $group: {
          _id: null,
          totalOrders: { $sum: 1 },
          totalSpent: { $sum: '$grandTotal' },
          averageOrderValue: { $avg: '$grandTotal' },
          completedOrders: {
            $sum: { $cond: [{ $eq: ['$orderStatus', 'Delivered'] }, 1, 0] }
          },
          cancelledOrders: {
            $sum: { $cond: [{ $eq: ['$orderStatus', 'Cancelled'] }, 1, 0] }
          }
        }
      }
    ]);

    const recentOrders = await Order.find({ userId })
      .sort({ orderDate: -1 })
      .limit(5)
      .populate('restaurantId', 'title');

    res.status(200).json({
      success: true,
      stats: stats[0] || {
        totalOrders: 0,
        totalSpent: 0,
        averageOrderValue: 0,
        completedOrders: 0,
        cancelledOrders: 0
      },
      recentOrders
    });

  } catch (error) {
    console.error('Error fetching order stats:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
};

export default {
  createOrder,
  getUserOrders,
  getOrderById,
  updateOrderStatus,
  cancelOrder,
  rateOrder,
  getOrderStats
};