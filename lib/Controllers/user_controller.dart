// user_controller.dart
import 'package:get/get.dart';
class UserController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var isLoggedIn = false.obs;

  void setUser(String userName, String userEmail) {
    name.value = userName;
    email.value = userEmail;
    isLoggedIn.value = true;
  }

  void clearUser() {
    name.value = '';
    email.value = '';
    isLoggedIn.value = false;
  }
}
