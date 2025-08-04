// MongoDB script to update food categories
// Run this in your MongoDB shell

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

// Verify the updates
print("Updated foods:");
db.foods.find({}, {title: 1, category: 1, foodTags: 1}).forEach(function(food) {
    print("Title: " + food.title + ", Category: " + food.category + ", Tags: " + food.foodTags);
}); 