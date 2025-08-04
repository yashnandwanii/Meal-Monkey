import Rating from '../models/rating.model.js';
import Restaurent from '../models/restaurent.model.js';
import Food from '../models/food.model.js';

const addRating = async (req, res) => {
    const newRating = new Rating({
        userId: req.body.id,
        ratingType: req.body.ratingType,
        product: req.body.product,
        rating: req.body.rating
    });
    try {
        await newRating.save();

        if(req.body.ratingType === 'Restaurant') {
            const restaurents = await Rating.aggregate([
                { $match: { product: req.body.product, ratingType: 'Restaurant' } },
                { $group: { _id: '$product', averageRating: { $avg: '$rating' } } }
            ]);

            if(restaurents.length > 0) {
                const averageRating = restaurents[0].averageRating;
                await Restaurent.findByIdAndUpdate(
                    req.body.product,
                    { $set: { rating: averageRating } },
                    { new: true }
                );
            }
        }else if(req.body.ratingType === 'Food') {
            const foods = await Rating.aggregate([
                { $match: { product: req.body.product, ratingType: 'Food' } },
                { $group: { _id: '$product', averageRating: { $avg: '$rating' } } }
            ]);

            if(foods.length > 0) {
                const averageRating = foods[0].averageRating;
                await Food.findByIdAndUpdate(
                    req.body.product,
                    { $set: { rating: averageRating } },
                    { new: true }
                );
            }
        }
        // if(req.body.ratingType === 'Driver') {
        //     const drivers = await Rating.aggregate([
        //         { $match: { product: req.body.product, ratingType: 'Food' } },
        //         { $group: { _id: '$product', averageRating: { $avg: '$rating' } } }
        //     ]);

        //     if(drivers.length > 0) {
        //         const averageRating = drivers[0].averageRating;
        //         await Food.findByIdAndUpdate(
        //             req.body.product,
        //             { $set: { rating: averageRating } },
        //             { new: true }
        //         );
        //     }
        // }
            
        res.status(201).json({
            status: true,
            message: "Rating added successfully",
            
        });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
}

const checkRating = async (req, res) => {  
    const ratingType = req.query.ratingType;
    const product = req.query.product;
    try {
        const existingRating = await Rating.findOne({
            userId: req.body.id,
            ratingType: ratingType,
            product: product
        });

        if (existingRating) {
            return res.status(200).json({
                status: true,
                message: "You have already rated this product",
                data: existingRating
            });
        } else {
            return res.status(404).json({
                status: false,
                message: "No rating found for this user"
            });
        }
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
}

export default {
    addRating,
    checkRating
};