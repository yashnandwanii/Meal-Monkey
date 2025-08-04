import express from 'express';
import categoryController from '../controllers/category.controller.js';

const router = express.Router();

router.post('/', categoryController.createCategory);

router.get('/', categoryController.getAllCategories);
router.get('/random', categoryController.getRandomCategories);


export default router;