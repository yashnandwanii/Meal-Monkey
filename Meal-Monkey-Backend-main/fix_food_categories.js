// Simple script to fix food categories
// Run this in your MongoDB shell or as a Node.js script

// Update Smoothie to drinks category
db.foods.updateMany(
  { title: "Smoothie" },
  { $set: { category: "drinks" } }
);

// Update Grilled Chicken Platter to chicken category
db.foods.updateMany(
  { title: "Grilled Chicken Platter" },
  { $set: { category: "chicken" } }
);

// You can add more updates here based on your food data
// For example:
// db.foods.updateMany(
//   { title: "Pizza Margherita" },
//   { $set: { category: "pizza" } }
// );

// Verify the updates
db.foods.find({}, {title: 1, category: 1}); 