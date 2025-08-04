import express from 'express';
import {
    createPaymentOrder,
    verifyPayment,
    handlePaymentFailure,
    razorpayWebhook
} from '../controllers/payment.controller.js';
import { verifyToken } from '../middlewares/verifyToken.js';

const router = express.Router();

// Webhook route (no auth required)
router.post('/webhook', razorpayWebhook);

// Protected routes
router.use(verifyToken);

router.post('/create-order', createPaymentOrder);
router.post('/verify', verifyPayment);
router.post('/failure', handlePaymentFailure);

export default router;
