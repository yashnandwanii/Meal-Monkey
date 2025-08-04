// models/Order.js
const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  paymentId: String,
  orderId: String,
  amount: Number,
  restaurantId: String,
  restaurantName: String,
  foodId: String,
  foodName: String,
  additives: [String],
  deliveryAddress: {
    line1: String,
    postalCode: String,
  },
  createdAt: Date,
});

module.exports = mongoose.model('Order', orderSchema);