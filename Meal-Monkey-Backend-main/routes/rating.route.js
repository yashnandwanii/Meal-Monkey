import express from 'express';
import ratingController from '../controllers/rating.controller.js';

const router = express.Router();

router.post('/', ratingController.addRating);

router.get('/', ratingController.checkRating);

export default router;