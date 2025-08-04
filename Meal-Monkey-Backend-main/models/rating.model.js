import mongoose from "mongoose";

const ratingSchema = new mongoose.Schema({
    userId: {
        type: String,
        required: true,
        
    },
    ratingType: {
        type: String,
        required: true,
        enum:['Restaurant', 'Dood', 'Driver']
    },
    product: {
        type: String,
        required: true
    },
    rating:{
        type: Number,      
        min: 1,
        max: 5
    }
});
const Rating = mongoose.model("Rating", ratingSchema);
export default Rating;