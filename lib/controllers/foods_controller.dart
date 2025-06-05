import 'package:food_delivery_app/models/additives_obs.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:get/get.dart';

class FoodsController extends GetxController {
  RxInt currentIndex = 0.obs;
  bool initialCheckValue = false;
  var additivesList = <ObsAdditives>[].obs;
  RxDouble _totalPrice = 0.0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  RxInt count = 1.obs;

  void incrementCount() {
    count.value++;
  }

  void decrementCount() {
    if (count.value > 1) {
      count.value--;
    }
  }

  double get totalAdditivesPrice => _totalPrice.value;

  set setTotalAdditivesPrice(double price) {
    _totalPrice.value = price;
  }

  void loadAdditives(List<Additive> additives) {
    additivesList.clear();

    final newList = additives
        .map((additiveInfo) => ObsAdditives(
              id: additiveInfo.id,
              title: additiveInfo.title,
              price: additiveInfo.price,
              checked: initialCheckValue,
            ))
        .toList();

    additivesList.assignAll(newList);
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    for (var additive in additivesList) {
      if (additive.isChecked.value) {
        totalPrice += double.tryParse(additive.price) ?? 0.0;
      }
    }
    //print('Total Price: $totalPrice');
    _totalPrice.value = totalPrice;
    return totalPrice;
  }
}
