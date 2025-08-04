
import Restaurent from "../models/restaurent.model.js";

const addRestaurent = async (req, res) => { 
    const { title, time, imageUrl, pickup, delivery, isAvailable, owner, code, logoUrl, coords } = req.body;

    if (!title || !time || !imageUrl || !owner || !code || !logoUrl || !coords || !coords.latitude || !coords.longitude || !coords.address || !coords.title) {
        return res.status(400).json({status : false, message: "All fields are required" });
    }
    try {
        const existingRestaurent = await Restaurent.findOne({
            title: title,
            owner: owner
        });
        if (existingRestaurent) {
            return res.status(400).json({ status: false, message: "Restaurent with this title already exists" });
        }
        const newRestaurent = new Restaurent(req.body);
        await newRestaurent.save();
        res.status(201).json({status:true, message: "Restaurent added successfully", restaurent: newRestaurent });
    } catch (error) {
        res.status(500).json({ message: "Error adding restaurent", error: error.message });
    }
}

const getRandomRestaurents = async (req, res) => {
    let code = req.params.code;
    if (!code) {
        return res.status(400).json({ message: "Code is required" });
    }
    try {
        let randomRestaurents = [];
        randomRestaurents = await Restaurent.aggregate([
            { $match: { code: code, isAvailable: true } },
            { $sample: { size: 5 } },
            { $project: { __v: 0 } }
        ]);

        if (randomRestaurents.length === 0) {
            randomRestaurents = await Restaurent.aggregate([
                { $match: { isAvailable: true } },
                { $sample: { size: 5 } },
                { $project: { __v: 0 } }
            ]);
        }

        res.status(200).json(randomRestaurents);
    } catch (error) {
        res.status(500).json({ message: "Error fetching random restaurants", error: error.message });
    }
};

const getRestaurentById = async (req, res) => {
    const id = req.params.id;
    if (!id) {
        return res.status(400).json({ message: "Restaurent ID is required" });
    }
    try {
        
        const restaurent = await Restaurent.findById(id);
        if (!restaurent) {
            return res.status(404).json({ message: "Restaurent not found" });
        }
        res.status(200).json(restaurent);
    } catch (error) {
        res.status(500).json({status:false, message: "Error fetching restaurent", error: error.message });
    }
}

const getAllNearByRestaurents = async (req, res) => {  // #here
    const code = req.params.code;
    if (!code) {
        return res.status(400).json({ message: "Code is required" });
    }
    try {
        let allNearByRestaurents = [];
        allNearByRestaurents = await Restaurent.aggregate([
            { $match: { code: code, isAvailable: true } },
            { $project: { __v: 0 } }
        ]);

        if (allNearByRestaurents.length === 0) {
            allNearByRestaurents = await Restaurent.aggregate([
                { $match: { isAvailable: true } },
                { $project: { __v: 0 } }
            ]);
        }

        res.status(200).json(allNearByRestaurents);
    } catch (error) {
        res.status(500).json({ message: "Error fetching restaurent", error: error.message });
    }
}

export default {
    addRestaurent,
    getAllNearByRestaurents,
    getRestaurentById,
    getRandomRestaurents
};