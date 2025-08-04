import mongoose from "mongoose";

const foodSchema = new mongoose.Schema({
    title: {type: String, required: true},
    time: { type: String, required: true },
    foodTags:{
        type: Array,
        required: true
    },
    imageUrl: {
        type: Array,
        required: true
    },
    category:{
        type: String,
        ref: "Category",
        required: true
    },
    foodType:{
        type: Array,
        required: true
    },
    code:{
        type: String,
        required: true
    },
    isAvailable: {
        type: Boolean,
        default: true
    },
    restaurent:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Restaurent",
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    description: {
        type: String,
        required: true
    },
    rating: {
        type: Number,
        default: 0,
        min:1,
        max: 5
    },
    ratingCount: {
        type: Number,
        default: 3
    },  
    additives:{
        type: Array,
        default: []
    }, 
});
const Food = mongoose.model("Food", foodSchema);
export default Food;