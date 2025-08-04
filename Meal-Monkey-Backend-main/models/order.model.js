import mongoose from 'mongoose';

const orderItemSchema = new mongoose.Schema({
  foodId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Food',
    required: true
  },
  foodName: {
    type: String,
    required: true
  },
  quantity: {
    type: Number,
    required: true,
    min: 1
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  additives: [{
    type: String
  }],
  instructions: {
    type: String,
    default: ''
  }
});

const orderSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  orderItems: [orderItemSchema],
  orderTotal: {
    type: Number,
    required: true,
    min: 0
  },
  deliveryFee: {
    type: Number,
    required: true,
    min: 0,
    default: 20
  },
  grandTotal: {
    type: Number,
    required: true,
    min: 0
  },
  deliveryAddress: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Address',
    required: true
  },
  restaurantAddress: {
    type: String,
    required: true
  },
  restaurantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Restaurant',
    required: true
  },
  paymentMethod: {
    type: String,
    required: true,
    enum: ['Cash', 'Razorpay', 'PayPal', 'Card'],
    default: 'Razorpay'
  },
  paymentStatus: {
    type: String,
    required: true,
    enum: ['PENDING', 'COMPLETED', 'FAILED', 'REFUNDED'],
    default: 'PENDING'
  },
  orderStatus: {
    type: String,
    required: true,
    enum: ['PENDING', 'CONFIRMED', 'PREPARING', 'READY', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED'],
    default: 'PENDING'
  },
  restaurantName: {
    type: String,
    required: true
  },
  restaurantCoords: {
    type: [Number], // [longitude, latitude]
    required: true
  },
  recipientCoords: {
    type: [Number], // [longitude, latitude]
    required: true
  },
  razorpayOrderId: {
    type: String,
    default: null
  },
  razorpayPaymentId: {
    type: String,
    default: null
  },
  paymentDate: {
    type: Date,
    default: null
  },
  paymentError: {
    type: String,
    default: null
  },
  promoCode: {
    type: String,
    default: null
  },
  discountAmount: {
    type: Number,
    default: 0,
    min: 0
  },
  notes: {
    type: String,
    default: ''
  },
  orderDate: {
    type: Date,
    default: Date.now
  },
  estimatedDeliveryTime: {
    type: Date,
    required: true
  },
  actualDeliveryTime: {
    type: Date,
    default: null
  },
  cancelledAt: {
    type: Date,
    default: null
  },
  cancellationReason: {
    type: String,
    default: null
  },
  rating: {
    type: Number,
    min: 1,
    max: 5,
    default: null
  },
  feedback: {
    type: String,
    default: null
  },
  ratedAt: {
    type: Date,
    default: null
  },
  razorpayOrderId: {
    type: String,
    default: null
  },
  razorpayPaymentId: {
    type: String,
    default: null
  },
  deliveryPartnerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'DeliveryPartner',
    default: null
  },
  deliveryPartnerName: {
    type: String,
    default: null
  },
  deliveryPartnerPhone: {
    type: String,
    default: null
  },
  isUrgent: {
    type: Boolean,
    default: false
  },
  specialInstructions: {
    type: String,
    default: ''
  }
}, {
  timestamps: true
});

// Indexes for better query performance
orderSchema.index({ userId: 1, orderDate: -1 });
orderSchema.index({ restaurantId: 1, orderStatus: 1 });
orderSchema.index({ orderStatus: 1, orderDate: -1 });
orderSchema.index({ paymentStatus: 1 });
orderSchema.index({ 'restaurantCoords': '2dsphere' });
orderSchema.index({ 'recipientCoords': '2dsphere' });

// Virtual for order age
orderSchema.virtual('orderAge').get(function () {
  return Date.now() - this.orderDate.getTime();
});

// Virtual for isDelayed
orderSchema.virtual('isDelayed').get(function () {
  if (this.orderStatus === 'Delivered' || this.orderStatus === 'Cancelled') {
    return false;
  }
  return Date.now() > this.estimatedDeliveryTime.getTime();
});

// Method to calculate delivery time
orderSchema.methods.calculateDeliveryTime = function () {
  const baseTime = 30; // 30 minutes base
  const distance = this.calculateDistance();
  const additionalTime = Math.ceil(distance / 2); // 2 minutes per km
  return baseTime + additionalTime;
};

// Method to calculate distance between restaurant and delivery address
orderSchema.methods.calculateDistance = function () {
  const R = 6371; // Earth's radius in km
  const lat1 = this.restaurantCoords[1];
  const lon1 = this.restaurantCoords[0];
  const lat2 = this.recipientCoords[1];
  const lon2 = this.recipientCoords[0];

  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;

  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
};

// Pre-save middleware to update estimated delivery time
orderSchema.pre('save', function (next) {
  if (this.isNew) {
    const deliveryMinutes = this.calculateDeliveryTime();
    this.estimatedDeliveryTime = new Date(Date.now() + deliveryMinutes * 60 * 1000);
  }
  next();
});

// Static method to get order statistics
orderSchema.statics.getStats = function (userId) {
  return this.aggregate([
    { $match: { userId: mongoose.Types.ObjectId(userId) } },
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
};

// Instance method to cancel order
orderSchema.methods.cancelOrder = function (reason) {
  const cancellableStatuses = ['Placed', 'Confirmed'];
  if (!cancellableStatuses.includes(this.orderStatus)) {
    throw new Error('Order cannot be cancelled at this stage');
  }

  this.orderStatus = 'Cancelled';
  this.cancelledAt = new Date();
  this.cancellationReason = reason;

  return this.save();
};

// Instance method to rate order
orderSchema.methods.rateOrder = function (rating, feedback) {
  if (this.orderStatus !== 'Delivered') {
    throw new Error('Can only rate delivered orders');
  }

  if (this.rating) {
    throw new Error('Order has already been rated');
  }

  if (rating < 1 || rating > 5) {
    throw new Error('Rating must be between 1 and 5');
  }

  this.rating = rating;
  this.feedback = feedback;
  this.ratedAt = new Date();

  return this.save();
};

const Order = mongoose.model('Order', orderSchema);
export default Order;