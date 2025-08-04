import Address  from '../models/address.model.js';

const addAddress = async (req, res) => {
    const newAddress = new Address({    
        userId: req.user.id,
        addressLine1: req.body.addressLine1,
        postalCode: req.body.postalCode,
        deliveryInstructions: req.body.deliveryInstructions,
        default: req.body.default,
        latitude: req.body.latitude,
        longitude: req.body.longitude
    });

    try {
        if(newAddress.default) {
            await Address.updateMany({ userId: req.user.id}, { default: false });
        }
        newAddress.save();
        return res.status(201).json({ status: true, message: "Address added successfully", address: newAddress });
    } catch (error) {
         console.error("Error adding address:", error);
        return res.status(500).json({ status: false, message: "Internal server error" });
    }
}

const getAddresses = async (req, res) => {
    try {
        const addresses = await Address.find({ userId: req.user.id });
        return res.status(200).json(addresses);
    } catch (error) {
        console.error("Error fetching addresses:", error);
        return res.status(500).json({ status: false, message: "Internal server error" });
    }
}

const deleteAddress = async (req, res) => {
    const addressId = req.params.id;

    if (!addressId) {
        return res.status(400).json({ status: false, message: "Address ID is required" });
    }

    try {
        const address = await Address.findByIdAndDelete(addressId);
        if (!address) {
            return res.status(404).json({ status: false, message: "Address not found" });
        }
        return res.status(200).json({ status: true, message: "Address deleted successfully" });
    } catch (error) {
        console.error("Error deleting address:", error);
        return res.status(500).json({ status: false, message: "Internal server error" });
    }
}

const setAddressAsDefault = async (req, res) => {
    const addressId = req.params.id;

    if (!addressId) {
        return res.status(400).json({ status: false, message: "Address ID is required" });
    }

    try {
        await Address.updateMany({ userId: req.user.id }, { default: false });
        const updatedAddress = await Address.findByIdAndUpdate(addressId, { default: true }, { new: true });

        if (!updatedAddress) {
            return res.status(404).json({ status: false, message: "Address not found" });
        }
        return res.status(200).json({ status: true, message: "Address set as default successfully", address: updatedAddress });
    } catch (error) {
        console.error("Error setting address as default:", error);
        return res.status(500).json({ status: false, message: "Internal server error" });
    }
}

const getDefaultAddress = async (req, res) => {
    const userId = req.user.id;
    try {
        const defaultAddress = await Address.findOne({ userId: userId, default: true });
        if (!defaultAddress) {
            return res.status(404).json({ status: false, message: "Default address not found" });
        }
        return res.status(200).json(defaultAddress );
    } catch (error) {
        console.error("Error fetching default address:", error);
        return res.status(500).json({ status: false, message: "Internal server error" });
    }
}

export default {
    addAddress,
    getAddresses,
    deleteAddress,
    setAddressAsDefault,
    getDefaultAddress,

};