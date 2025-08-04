import Cart from '../models/cart.model.js';
import mongoose from 'mongoose';

const addProductToCart = async (req, res) => {
    const userId = req.user.id;
    const { productId, additives, quantity, totalPrice } = req.body;

    if (!productId || !mongoose.Types.ObjectId.isValid(productId)) {
        return res.status(400).json({ message: "Invalid or missing productId" });
    }

    try {
        let existingProduct = await Cart.findOne({ userId, productId });

        if (existingProduct) {
            existingProduct.quantity += quantity;
            if (additives !== undefined) {
                existingProduct.additives = additives;
            }
            existingProduct.totalPrice = totalPrice ?? calculateTotalPrice(existingProduct.quantity, existingProduct.additives);           
            await existingProduct.save();
            return res.status(200).json(existingProduct);
        }

        const newCart = new Cart({
            userId,
            productId,
            additives: additives || [],
            quantity,
            totalPrice: totalPrice ?? calculateTotalPrice(quantity, additives || [])
        });

        const savedCart = await newCart.save();
        const count = await Cart.countDocuments({ userId });

        return res.status(201).json({ savedCart, count });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};


function calculateTotalPrice(quantity, additives) {
    const basePrice = 5.00; 
    const additivePrice = 1.00 * (additives ? additives.length : 0);
    return quantity * (basePrice + additivePrice);
}

const deleteProductFromCart = async (req, res) => {
   const cartItemId = req.params.id;
    const userId = req.user.id;
    
     try {
          const cartItem = await Cart.findByIdAndDelete({ _id: cartItemId });
    
          if (!cartItem) {
                return res.status(404).json({ message: 'Product not found in cart' });
          }
        const count = await Cart.countDocuments({ userId: userId });
          
          return res.status(200).json({status:true, count });
     } catch (error) {
          res.status(500).json({ message: error.message });
     }
}
const getCart = async (req, res) => {
    const userId = req.user.id;
    try {
        const cart = await Cart.find({ userId: userId }).populate({
            path: 'productId',
            select: 'title restaurent rating ratingCount imageUrl',
            populate: {
                path:'restaurent',
                select: 'time coords',
            }
        });

        return res.status(200).json(cart || []);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
}

const clearCart = async (req, res) => {
    const userId = req.user.id;  
    try {
        const deletedCart = await Cart.deleteMany({ userId: userId });

        if (deletedCart.deletedCount === 0) {
            return res.status(404).json({ message: 'Cart is already empty' });
        }
        return res.status(200).json({ message: 'Cart cleared successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: error.message });
    }
}

const getCartCount = async (req, res) => {
    const userId = req.user.id;
    try{
        const count = await Cart.countDocuments({userId:userId});
        return res.status(200).json({ count: count });
    }catch (error) {
        res.status(500).json({ message: error.message });
    }
}

const decreaseProductQuantity = async (req, res) => {
    const userId = req.user.id;
    const id = req.params.id;

    try {
        const cartItem = await Cart.findById(id);

        if (!cartItem) {
            return res.status(404).json({ message: 'Product not found in cart' });
        }
        const productPrice = cartItem.totalPrice / cartItem.quantity;
        if (cartItem.quantity > 1) {
            cartItem.quantity -= 1;
            cartItem.totalPrice -= productPrice;
            await cartItem.save();
            return res.status(200).json(cartItem);
        } else {
            await Cart.findOneAndDelete({_id:id});
            return res.status(200).json({ message: 'Product removed from cart' });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
}   

export default {    
    addProductToCart, // done
    deleteProductFromCart,  
    getCart, // done
    clearCart, // done
    getCartCount,  // done
    decreaseProductQuantity //done
};