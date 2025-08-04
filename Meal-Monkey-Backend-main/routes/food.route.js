import express from 'express';
import foodController from '../controllers/food.controller.js';
import { verifyVendorToken } from '../middlewares/verifyToken.js';

const router = express.Router();

router.post('/', verifyVendorToken, foodController.addFood);
router.get('/random', foodController.getRandomFoods);
router.get('/search', foodController.searchFoods);
router.get('/restaurent/:id', foodController.getFoodsByRestaurent);
router.get('/:id', foodController.getFoodById);
router.get('/code/:code', foodController.getAllFoodsByCode);
router.get('/category/:category', foodController.getFoodsByCategory);
router.get('/recommendation/:code', foodController.getRandomFoodsByCategoryAndCode);
router.get('/:category/:code', foodController.getFoodsByCategoryAndCode);

export default router;