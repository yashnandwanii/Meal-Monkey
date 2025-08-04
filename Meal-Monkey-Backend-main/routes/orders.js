// routes/orders.js

const express = require('express');
const router = express.Router();
const Order = require('../models/Order'); // Your Mongoose model

router.post('/save', async (req, res) => {
  try {
    const {
      paymentId,
      orderId,
      amount,
      restaurantId,
      restaurantName,
      foodId,
      foodName,
      additives,
      deliveryAddress,
      timestamp,
    } = req.body;

    const newOrder = new Order({
      paymentId,
      orderId,
      amount,
      restaurantId,
      restaurantName,
      foodId,
      foodName,
      additives,
      deliveryAddress,
      createdAt: timestamp,
    });

    await newOrder.save();
    res.status(200).json({ message: "Order saved" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to save order" });
  }
});

module.exports = router;