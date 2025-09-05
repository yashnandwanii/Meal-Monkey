import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/hooks/fetch_user_reviews.dart';
import 'package:food_delivery_app/models/reviews_response.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReviewsPage extends HookWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchUserReviews();
    List<ReviewResponse>? reviews = hookResults.data;
    bool isLoading = hookResults.isLoading;
    Exception? error = hookResults.error;

    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        backgroundColor: offWhite,
        elevation: 0,
        title: Text(
          'My Reviews',
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
          IconButton(
            icon: Icon(Icons.add, color: Tcolor.primary),
            onPressed: () {
              _showAddReviewDialog(context);
            },
          ),
        ],
      ),
      body: _buildReviewsList(
          context, reviews, isLoading, error, hookResults.refetch),
    );
  }

  Widget _buildReviewsList(
    BuildContext context,
    List<ReviewResponse>? reviews,
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
              'Loading your reviews...',
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
              'Failed to load reviews',
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

    if (reviews == null || reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start reviewing your orders to see them here.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => _showAddReviewDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Tcolor.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text('Write Your First Review'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => refetch?.call(),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return _buildReviewTile(review);
        },
      ),
    );
  }

  Widget _buildReviewTile(ReviewResponse review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.foodName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      review.restaurantName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20.sp,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (review.comment.isNotEmpty)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                review.comment,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
              ),
            ),
          if (review.images.isNotEmpty) ...[
            SizedBox(height: 12.h),
            SizedBox(
              height: 80.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8.w),
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        review.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            color: Colors.grey[400],
                            size: 32.sp,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM dd, yyyy').format(review.createdAt),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Tcolor.primary,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      _editReview(review);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      _deleteReview(review.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    // TODO: Implement add review dialog
    Get.snackbar(
      'Add Review',
      'Add review functionality coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Tcolor.primary.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _editReview(ReviewResponse review) {
    // TODO: Implement edit review functionality
    Get.snackbar(
      'Edit Review',
      'Edit review functionality coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _deleteReview(String reviewId) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete Review'),
          content: Text('Are you sure you want to delete this review?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement delete review
                Navigator.of(dialogContext).pop();
                Get.snackbar(
                  'Delete Review',
                  'Delete review functionality coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
