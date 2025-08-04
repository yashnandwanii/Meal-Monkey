import mongoose  from "mongoose";

const cartSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    productId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Food",
        required: true
    },
    additives:{
        type:Array,
        required:false,
        default: []
    },
    totalPrice: {
        type: Number,
        required: true,
    },
    quantity: {
        type: Number,
        required: true,
        
    }  
},{timestamps: true});

const Cart = mongoose.model("Cart", cartSchema);
export default Cart;