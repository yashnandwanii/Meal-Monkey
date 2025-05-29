// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class CategoryController extends GetxController{
  RxString _category = ''.obs;

  String get categoryValue => _category.value;

  set updateCategory(String value) {
    _category.value = value;
  }

  RxString title = ''.obs;
  String get titleValue => title.value;
  set updateTitle(String value) {
    title.value = value;
  }
}