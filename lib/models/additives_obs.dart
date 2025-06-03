import 'package:get/get.dart';

class ObsAdditives extends GetxController {
  final int id;
  final String title;
  final String price;
  RxBool isChecked = false.obs;

  ObsAdditives({
    required this.id,
    required this.title,
    required this.price,
    bool checked = false,
  }) {
    isChecked.value = checked;
  }

  void toggleChecked() {
    isChecked.value = !isChecked.value;
  }
}
