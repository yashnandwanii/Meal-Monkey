import Category from '../models/category.model.js';


const createCategory = (async (req, res) => {
        const newCategory = new Category(req.body);
        try {
            await newCategory.save();
            res.status(201).json({
                status: 'true',
                message: 'Category created successfully'
            });
        } catch (error) {
            res.status(500).json({ 
                status: 'false',
                message: error.message 
            });
        }
    });

const getAllCategories = ( async(req, res) => {
        try {
            const categories = await Category.find({title:{$ne: "More"}}, {__v: 0});
            res.status(200).json(categories);
        } catch (error) {
            res.status(500).json({status:false,  message: error.message });
        }
    });
    
const getRandomCategories = async (req, res) => {
  try {
    let categories = await Category.aggregate([
      { $match: { value: { $not: /^more$/i } } }
    ]);

    const moreCategory = await Category.findOne({ value: { $regex: /^more$/i } }, { __v: 0 });

    if (moreCategory) {
      categories.push(moreCategory);
    }

    res.status(200).json(categories);
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
};

export default {
    createCategory,
    getAllCategories,
    getRandomCategories
};
