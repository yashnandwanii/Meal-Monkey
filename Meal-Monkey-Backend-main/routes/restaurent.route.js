import express from 'express';
import {verifyTokenAndAuthorization} from '../middlewares/verifyToken.js';

import restaurentController from '../controllers/restaurent.controller.js';

const router = express.Router();

router.post('/',verifyTokenAndAuthorization, restaurentController.addRestaurent);

router.get('/:code', restaurentController.getRandomRestaurents);

router.get('/all/:code', restaurentController.getAllNearByRestaurents);

router.get('/byId/:id', restaurentController.getRestaurentById);


export default router;