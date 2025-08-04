import express from 'express';
import userController from '../controllers/user.controller.js';
import {verifyToken, verifyTokenAndAuthorization} from '../middlewares/verifyToken.js';

const router = express.Router();

router.get('/', verifyTokenAndAuthorization, userController.getUser);

router.delete('/',verifyTokenAndAuthorization, userController.deleteUser);
router.get('/verify/:otp', verifyToken, userController.verifyUser);
router.post('/verifyPhone/:phone', verifyTokenAndAuthorization, userController.verifyPhone);


export default router; 