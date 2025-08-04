import express from 'express';
import authController from '../controllers/auth.controller.js';

const router = express.Router();

router.post('/register', authController.createUser);

router.post('/login', authController.loginUser);

export default router; 