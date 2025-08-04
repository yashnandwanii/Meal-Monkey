import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    username: {
        type: String,
       
        default:"none"
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    otp: {
        type: String,
        required: false,
    },
    fcm:{
        type: String,
        required: false,
        default: "none"
    },
    password: {
        type: String,
        required: true,
    },
    verification:{
        type: Boolean,
        default: false,
    },
    phone:{
        type: String,
        default:"1234567890"
    },
    phoneVerification:{
        type: Boolean,
        default: false,
    },
    address:{
        type:mongoose.Schema.Types.ObjectId,
        ref:"Address",
        required: false,
    },
    userType: {
        type: String,
        required: true,
        enum: ["Client", "Admin", "Vendor", "Driver"],
        default: "Client",
    },
    profile:{
        type:String,
        default:"https://images.unsplash.com/photo-1617531653332-bd46c24f2068?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Ym13fGVufDB8fDB8fHww",
    }
}, {
    timestamps: true,});
const User = mongoose.model("User", userSchema);
export default User;