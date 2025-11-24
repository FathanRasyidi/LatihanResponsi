import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt index = 0.obs;

  void changeIndex(int i) {
    index.value = i;
  }
}
