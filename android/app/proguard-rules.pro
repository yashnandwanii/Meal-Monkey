# Fix R8 errors for Razorpay SDK expecting proguard annotations
-dontwarn proguard.annotation.**
-keep class proguard.annotation.** { *; }

# Keep Razorpay SDK classes and members
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep annotations generally
-keepattributes *Annotation*
