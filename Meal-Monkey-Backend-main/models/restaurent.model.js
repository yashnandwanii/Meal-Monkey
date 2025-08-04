import mongoose from "mongoose";

const restaurentSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        unique: true,
        trim: true
    },
    time: {
        type: String,
        required: true,
        trim: true
    },
    imageUrl: {
        type: String,
        required: true
    },
    foods: {
        type: Array,
        default: []
    },
    pickup: {
        type: Boolean,
        default: true
    },
    delivery: {
        type: Boolean,
        default: true
    },
    isAvailable: {
        type: Boolean,
        default: true
    },
    owner:{
        type:String,
        required: true,
    },
    code:{
        type: String,
        required: true,
        
    },
    logoUrl:{
        type: String,
        required: true
    },
    rating: {
        type: Number,
        default: 3,
        min: 1,
        max: 5
    },
    ratingCount: {
        type: String,
        default: 257
    },
    verification: {
        type: String,
        default: "Pending",
        enum: ["Pending", "Approved", "Rejected"]
    },
    verificationMessage: {
        type: String,
        default: "Your restaurant is under review."
    },
    coords:{
        id:{type:String},
        latitude:{ type: Number, required: true },
        longitude:{ type: Number, required: true },
        latitudeDelta:{ type: Number, default: 0.0122 },
        longitudeDelta:{ type: Number, default: 0.0122 },
        address: { type: String, required: true },
        title: { type: String, required: true }
    }
});
const Restaurent = mongoose.model("Restaurent", restaurentSchema);
export default Restaurent;