import User from '../models/user.model.js';
import jwt from 'jsonwebtoken';

const getUser = async (req, res) => {
    try{
        const user = await User.findById(req.user.id)
        .select("-password -otp -__v -createdAt "); // Exclude sensitive fields
        if (!user) {
            return res.status(404).json({ status: false, message: "User not found" });
        }
        return res.status(200).json({ status: true, user });

    }
    catch (error) {
        console.error("Error fetching user:", error);
        return res.status(500).json({ status: false, message: "Internal server error" });
    }
}

const verifyUser = async (req, res) => {
    const userOtp = req.params.otp;

    if (!userOtp) {
        return res.status(400).json({ status: false, message: "OTP is required" });
    }

    try {
        console.log("Decoded token (req.user):", req.user);

        if (!req.user || !req.user.id) {
            console.error("User ID not found in token payload");
            return res.status(401).json({ status: false, message: "Invalid or missing token" });
        }

        const userId = req.user.id;
        console.log("Looking for user with ID:", userId);
        const user = await User.findById(userId); 

        console.log("User found by ID:", user);

        if (!user) {
            console.warn("No user found with provided ID");
            return res.status(404).json({ status: false, message: "User not found" });
        }

        // Compare OTP
        console.log(`Stored OTP: ${user.otp}, Provided OTP: ${userOtp}`);
        if (user.otp !== userOtp) {
            console.warn("OTP mismatch");
            return res.status(400).json({ status: false, message: "Invalid OTP" });
        }


        // Update user verification status
        user.verification = true;
        user.otp = null; // Clear OTP after verification

        // Set default values for new users
        if (!user.profile) {
            user.profile = "https://d326nfutv7b1e.cloudfront.net/uploads/default_user.jpg";
        }
        if (!user.fcm) {
            user.fcm = "none";
        }
        if (!user.phone) {
            user.phone = "";
        }
        if (!user.phoneVerification) {
            user.phoneVerification = false;
        }

        console.log("Saving updated user to DB...");
        await user.save();
        console.log("User successfully verified and saved.");

        const token = jwt.sign({
            id: user._id,
            email: user.email,
            phone: user.phone,
            userType: user.userType
        }, process.env.JWT_SECRET, {
            expiresIn: '1d' // Token expiration time
        });
        
        // Include all required fields in response
        const response = {
            _id: user._id,
            username: user.username,
            email: user.email,
            fcm: user.fcm || "none",
            verification: true,
            phone: user.phone || "",
            phoneVerification: user.phoneVerification || false,
            userType: user.userType,
            profile: user.profile,
            token: token,
            status: true,
            message: "User verified successfully"
        };

        res.status(200).json(response);
    }
    catch (error) {
        console.error("Error during OTP verification:", error);
        return res.status(500).json({ status: false, message: "Internal server error" });
    }
}

const verifyPhone = async (req, res) => {
    const userPhone = req.params.phone;

    if (!userPhone) {
        return res.status(400).json({ status: false, message: "Phone number is required" });
    }

    try {
        const user = await User.findById(req.user.id)
             // Fetch only the phone field
        if (!user) {
            return res.status(404).json({ status: false, message: "User not found" });
        }
        // Update user verification status
        user.phoneVerification = true;
        user.phone = userPhone; // Set the phone number
        await user.save();
        
        const token = jwt.sign({
            id: user._id,
            email: user.email,
            phone: user.phone,
            userType: user.userType
        }, process.env.JWT_SECRET, {
            expiresIn: '1d' // Token expiration time
        });
        
        const { password, __v, otp, createdAt, ...others } = user._doc;
        res.status(200).json({
            ...others, 
            token,
            status: true,
            message: "User verified successfully"
        });
    }
    catch (error) {
        console.error("Error verifying phone number:", error);
        return res.status(500).json({ status: false, message: "Internal server error" });
    }
}

const deleteUser = async (req, res) => {
    try {
        const user = await User.findByIdAndDelete(req.user.id);
        if (!user) {
            return res.status(404).json({ status: false, message: "User not found" });
        }
        return res.status(200).json({ status: true, message: "User deleted successfully" });
    } catch (error) {
        console.error("Error deleting user:", error);
        return res.status(500).json({ status: false, message: "Internal server error" });
    }
}


export default {
    getUser,
    verifyUser,
    verifyPhone,
    deleteUser
};
