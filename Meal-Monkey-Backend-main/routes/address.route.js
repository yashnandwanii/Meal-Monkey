import express from 'express';
import addressController from '../controllers/address.controller.js';  
import {verifyTokenAndAuthorization} from '../middlewares/verifyToken.js';


const router = express.Router();

router.post('/', verifyTokenAndAuthorization, addressController.addAddress);
router.get('/default', verifyTokenAndAuthorization, addressController.getDefaultAddress);
router.delete('/:id', verifyTokenAndAuthorization, addressController.deleteAddress);
router.get('/all', verifyTokenAndAuthorization, addressController.getAddresses);
router.patch('/default/:id', verifyTokenAndAuthorization, addressController.setAddressAsDefault);

export default router; 