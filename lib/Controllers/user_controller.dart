// user_controller.dart
import 'package:get/get.dart';

class UserController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;

  void setUser(String userName, String userEmail) {
    name.value = userName;
    email.value = userEmail;
  }
}
