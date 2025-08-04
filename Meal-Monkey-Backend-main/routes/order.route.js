import express from 'express';
import orderController from '../controllers/order.controller.js';
import { verifyToken } from '../middlewares/verifyToken.js';

const router = express.Router();

// All routes require authentication
router.use(verifyToken);

// Create a new order
router.post('/', orderController.createOrder);

// Get all orders for the authenticated user
router.get('/', orderController.getUserOrders);

// Get order statistics for the user
router.get('/stats', orderController.getOrderStats);

// Get a specific order by ID
router.get('/:orderId', orderController.getOrderById);

// Update order status
router.put('/:orderId/status', orderController.updateOrderStatus);

// Cancel an order
router.put('/:orderId/cancel', orderController.cancelOrder);

// Rate an order
router.post('/:orderId/rate', orderController.rateOrder);

export default router;