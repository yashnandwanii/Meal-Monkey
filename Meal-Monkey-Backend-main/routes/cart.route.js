import express from 'express';
import cartController from '../controllers/cart.controller.js';
import { verifyTokenAndAuthorization } from '../middlewares/verifyToken.js';

const router = express.Router();

router.post('/', verifyTokenAndAuthorization, cartController.addProductToCart);
router.delete('/:id', verifyTokenAndAuthorization, cartController.deleteProductFromCart);
router.get('/decrement/:id', verifyTokenAndAuthorization, cartController.decreaseProductQuantity);
router.get('/', verifyTokenAndAuthorization, cartController.getCart);
router.delete('/clear/:id', verifyTokenAndAuthorization, cartController.clearCart);
router.get('/count', verifyTokenAndAuthorization, cartController.getCartCount);

export default router;
