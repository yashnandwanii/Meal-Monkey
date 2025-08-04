// MongoDB script to create/update categories
// Run this in your MongoDB shell

// Create or update categories
db.categories.updateOne(
  { value: "chicken" },
  { 
    $set: {
      title: "Chicken",
      value: "chicken",
      imageUrl: "https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y2hpY2tlbnxlbnwwfHwwfHx8MA%3D%3D"
    }
  },
  { upsert: true }
);

db.categories.updateOne(
  { value: "drinks" },
  { 
    $set: {
      title: "Drinks",
      value: "drinks",
      imageUrl: "https://images.unsplash.com/photo-1622597467836-f3285f2131b8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    }
  },
  { upsert: true }
);

// Verify categories
print("Available categories:");
db.categories.find({}, {title: 1, value: 1, imageUrl: 1}).forEach(function(cat) {
    print("Title: " + cat.title + ", Value: " + cat.value);
}); 