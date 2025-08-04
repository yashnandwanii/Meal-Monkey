import Food from '../models/food.model.js'; 

const addFood = async (req, res) => {
    const { title, foodTags, foodType, imageUrl, category, time, code, restaurent, price, description, additives } = req.body;
    console.log("Request Body:", req.body);
    

    if (!title || !foodTags || !foodType|| !imageUrl || !category || !time || !code || !restaurent || !price || !description  || !additives) {
        return res.status(400).json({ status: false, message: "All fields are required" });
    }
    try {
        const existingFood = await Food.findOne({ title: title, restaurent: restaurent });
        if (existingFood) {
            return res.status(400).json({ status: false, message: "Food with this title already exists" });
        }


        const newFood = new Food(req.body);
        console.log("New Food Object:", newFood);
        
        await newFood.save();
        res.status(201).json(newFood);
    } catch (error) {
        res.status(500).json({ message: "Error adding food", error: error.message });
    }
}

const getFoodById = async (req, res) => {
    const foodId = req.params.id;

    if (!foodId) {
        return res.status(400).json({ status: false, message: "Food ID is required" });
    }

    try {
        const food = await Food.findById(foodId).select("-__v");
        if (!food) {
            return res.status(404).json({ status: false, message: "Food not found" });
        }
        res.status(200).json({ status: true, food });
    } catch (error) {
        res.status(500).json({ message: "Error fetching food", error: error.message });
    }
}

const getAllFoodsByCode = async (req, res) => {
    const code = req.params.code;
    
    if (!code) {
        return res.status(400).json({ status: false, message: "Code is required" });
    }

    try {
        const foods = await Food.find({ code: code, isAvailable: true }).select("-__v");
        //console.log(foods);
        
        if (foods.length === 0) {
            return res.status(404).json({ status: false, message: "No foods found for this code" });
        }
        res.status(200).json(foods);
    } catch (error) {
        res.status(500).json({ message: "Error fetching foods by code", error: error.message });
    }
}

const getRandomFoodsByCategoryAndCode = async (req, res) => {
    const {code} = req.params;
    if (!code) {
        return res.status(400).json({ status: false, message: "Code is required" });
    }
    try {
        let foods;
        foods = await Food.aggregate([
            {
                $match: { code: code, isAvailable: true }
            },
            {
                $sample: { size: 5 } // Get 5 random foods
            },
            {
                $project: { __v: 0, }
            }
        ])

        if(!foods || foods.length === 0) {
            foods = await Food.aggregate([
                {$match: { isAvailable: true }},
                {$sample: { size: 10 }} 
            ])
        }
    
        res.status(200).json(foods);
    } catch (error) {
        res.status(500).json({ status:false, message: "Error fetching random foods", error: error.message });
    }
}

const getFoodsByCategoryAndCode = async (req, res) => {
    const {category, code} = req.params;

    if (!category || !code) {
        return res.status(400).json({ status: false, message: "Category and code are required" });
    }

    try {
        const foods = await Food.aggregate([
            {
                $match: { category: category, code: code, isAvailable: true }
            },
            {
                $project: { __v: 0,}
            }
        ]);
        

        if (foods.length === 0) {
            return res.status(404).json({ status: false, message: "No foods found for this category and code" });
        }
        res.status(200).json(foods);
    } catch (error) {
        res.status(500).json({ message: "Error fetching foods by category", error: error.message });
    }
}

// New function to get foods by category only
const getFoodsByCategory = async (req, res) => {
    const {category} = req.params;

    if (!category) {
        return res.status(400).json({ status: false, message: "Category is required" });
    }

    try {
        console.log(`Searching for foods with category: ${category}`);
        
        // First try to find foods by exact category match
        let foods = await Food.aggregate([
            {
                $match: { category: category, isAvailable: true }
            },
            {
                $project: { __v: 0,}
            }
        ]);

        console.log(`Found ${foods.length} foods by exact category match`);

        // If no foods found by exact category match, try to find by food types and tags
        if (foods.length === 0) {
            console.log('No exact matches found, trying content-based filtering...');
            
            foods = await Food.aggregate([
                {
                    $match: { 
                        isAvailable: true,
                        $or: [
                            { category: category },
                            { foodType: { $in: [new RegExp(category, 'i')] } },
                            { foodTags: { $in: [new RegExp(category, 'i')] } },
                            { title: { $regex: new RegExp(category, 'i') } }
                        ]
                    }
                },
                {
                    $project: { __v: 0,}
                }
            ]);
            
            console.log(`Found ${foods.length} foods by content-based filtering`);
        }

        // Log found foods for debugging
        if (foods.length > 0) {
            console.log('Found foods:');
            foods.forEach(food => {
                console.log(`- ${food.title} (category: ${food.category}, tags: ${food.foodTags})`);
            });
        }

        if (foods.length === 0) {
            return res.status(404).json({ 
                status: false, 
                message: `No foods found for category: ${category}`,
                debug: {
                    searchedCategory: category,
                    totalFoodsInDB: await Food.countDocuments({ isAvailable: true })
                }
            });
        }
        
        res.status(200).json(foods);
    } catch (error) {
        console.error('Error in getFoodsByCategory:', error);
        res.status(500).json({ message: "Error fetching foods by category", error: error.message });
    }
}

const getFoodsByRestaurent = async (req, res) => {
    const restaurentId = req.params.id;

    if (!restaurentId) {
        return res.status(400).json({ status: false, message: "Restaurent ID is required" });
    }

    try {
        const foods = await Food.find({ restaurent: restaurentId })
        if (foods.length === 0) {
            return res.status(404).json({ status: false, message: "No foods found for this restaurent" });
        }
        res.status(200).json(foods );
    } catch (error) {
        res.status(500).json({ message: "Error fetching foods by restaurent", error: error.message });
    }
}

const searchFoods = async (req, res) => {   
    const search = req.params.search;
    try {
        
        const results = await Food.aggregate([
            {
                $search: {
                    index: 'foods',
                    text: {
                        query: search,
                        path:{
                            wildcard:"*"
                        }
                    }
                }
            },
            
        ])
        if (results.length === 0) {
            return res.status(404).json({ status: false, message: "No foods found" });
        }
        res.status(200).json(results);
    } catch (e) {
        res.status(500).json({ status: false, message: "Error searching foods", error: e.message });
    }
}

const getRandomFoods = async (req, res) => {
  try {
    let randomFoodList = [];
    let matchQuery = { isAvailable: true };

    if (req.params.code) {
      matchQuery.code = req.params.code;
    }

    const totalCount = await Food.countDocuments(matchQuery);

    if (totalCount > 0) {
      
      randomFoodList = await Food.aggregate([
        { $match: matchQuery },
        { $sample: { size: totalCount } },
        { $project: { __v: 0 } }
      ]);
    }

    if (randomFoodList.length) {
      res.status(200).json(randomFoodList);
    } else {
      res.status(404).json({ status: false, message: "No random foods found" });
    }

  } catch (error) {
    res.status(500).json({ status: false, message: "Error fetching random foods", error: error.message });
  }
};

export default {
    addFood,
    getFoodById,
    getRandomFoodsByCategoryAndCode,
    getFoodsByCategoryAndCode,
    getFoodsByRestaurent,
    searchFoods,
    getRandomFoods,
    getAllFoodsByCode,
    getFoodsByCategory
};