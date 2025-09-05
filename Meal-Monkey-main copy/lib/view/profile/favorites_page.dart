import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/hooks/fetch_user_favorites.dart';
import 'package:food_delivery_app/models/favorites_response.dart';
import 'package:get/get.dart';

class FavoritesPage extends HookWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchUserFavorites();
    List<FavoriteResponse>? favorites = hookResults.data;
    bool isLoading = hookResults.isLoading;
    Exception? error = hookResults.error;

    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        backgroundColor: offWhite,
        elevation: 0,
        title: Text(
          'My Favorites',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Tcolor.primary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Tcolor.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (favorites != null && favorites.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Tcolor.primary),
              onPressed: () {
                _showClearFavoritesDialog(context);
              },
            ),
        ],
      ),
      body:
          _buildFavoritesList(favorites, isLoading, error, hookResults.refetch),
    );
  }

  Widget _buildFavoritesList(
    List<FavoriteResponse>? favorites,
    bool isLoading,
    Exception? error,
    VoidCallback? refetch,
  ) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Tcolor.primary),
            SizedBox(height: 16.h),
            Text(
              'Loading your favorites...',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Colors.red[300],
            ),
            SizedBox(height: 16.h),
            Text(
              'Failed to load favorites',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: refetch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Tcolor.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (favorites == null || favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start adding your favorite foods to see them here.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => refetch?.call(),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return _buildFavoriteTile(favorite);
        },
      ),
    );
  }

  Widget _buildFavoriteTile(FavoriteResponse favorite) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              bottomLeft: Radius.circular(12.r),
            ),
            child: Container(
              width: 100.w,
              height: 100.w,
              child: favorite.food.imageUrl.isNotEmpty
                  ? Image.network(
                      favorite.food.imageUrl[0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.fastfood,
                            color: Colors.grey[400],
                            size: 32.sp,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.fastfood,
                        color: Colors.grey[400],
                        size: 32.sp,
                      ),
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favorite.food.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        favorite.food.rating.toString(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        favorite.food.time,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '\$${favorite.food.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Tcolor.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 24.sp,
                ),
                onPressed: () {
                  _removeFavorite(favorite.id);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Tcolor.primary,
                  size: 24.sp,
                ),
                onPressed: () {
                  _addToCart(favorite.food);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _removeFavorite(String favoriteId) {
    // TODO: Implement remove favorite functionality
    Get.snackbar(
      'Remove Favorite',
      'Remove favorite functionality coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _addToCart(dynamic food) {
    // TODO: Implement add to cart functionality
    Get.snackbar(
      'Add to Cart',
      'Add to cart functionality coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Tcolor.primary.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _showClearFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear All Favorites'),
          content: Text('Are you sure you want to remove all your favorites?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement clear all favorites
                Navigator.of(context).pop();
                Get.snackbar(
                  'Clear Favorites',
                  'Clear favorites functionality coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                );
              },
              child: Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
