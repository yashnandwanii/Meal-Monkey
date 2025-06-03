import 'package:food_delivery_app/models/additives_obs.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:get/get.dart';

class FoodsController extends GetxController {
  RxInt currentIndex = 0.obs;
  bool initialCheckValue = false;
  var additivesList = <ObsAdditives>[].obs;

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

  void loadAdditives(List<Additive> additives) {
    additivesList.clear();
    for (var additiveInfo in additives) {
      var additive = ObsAdditives(
          id: additiveInfo.id,
          title: additiveInfo.title,
          price: additiveInfo.price,
          checked: initialCheckValue,
        );
      if(additivesList.length == additives.length) {
        additivesList.refresh();
      }else{
        additivesList.add(additive);
      }

    }
  }
}
