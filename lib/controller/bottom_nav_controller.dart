import 'package:get/get.dart';

class BottomNavController extends GetxController {
  // reactive index for bottom navigation
  final RxInt index = 0.obs;

  void changeIndex(int i) {
    index.value = i;
  }
}
