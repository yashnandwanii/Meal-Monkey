// Script to update food categories in MongoDB
// Run this script to fix the category filtering issue

import mongoose from 'mongoose';
import Food from './models/food.model.js';
import Category from './models/category.model.js';

// Connect to MongoDB (update with your connection string)
const MONGODB_URI = 'mongodb://localhost:27017/your_database_name';

async function updateFoodCategories() {
    try {
        await mongoose.connect(MONGODB_URI);
        console.log('Connected to MongoDB');

        // First, let's see what categories exist
        const categories = await Category.find({});
        console.log('Available categories:', categories.map(c => ({ id: c._id, title: c.title, value: c.value })));

        // Update food categories based on their titles and food types
        const updates = [
            {
                title: "Smoothie",
                newCategory: "drinks", // This should match a category value
                description: "Update Smoothie to Drinks category"
            },
            {
                title: "Grilled Chicken Platter", 
                newCategory: "chicken", // This should match a category value
                description: "Update Grilled Chicken Platter to Chicken category"
            }
        ];

        for (const update of updates) {
            const result = await Food.updateMany(
                { title: update.title },
                { $set: { category: update.newCategory } }
            );
            console.log(`${update.description}: ${result.modifiedCount} documents updated`);
        }

        // Verify the updates
        const foods = await Food.find({});
        console.log('Updated foods:', foods.map(f => ({ title: f.title, category: f.category })));

        console.log('Food categories updated successfully!');
    } catch (error) {
        console.error('Error updating food categories:', error);
    } finally {
        await mongoose.disconnect();
        console.log('Disconnected from MongoDB');
    }
}

// Run the script
updateFoodCategories(); 