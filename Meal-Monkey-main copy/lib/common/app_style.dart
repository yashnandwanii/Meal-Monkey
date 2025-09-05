import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appBarTextStyle(double fontSize, Color color, FontWeight fw) {
  return GoogleFonts.poppins(
    fontSize: fontSize.sp,
    color: color,
    fontWeight: fw,
  );
}
