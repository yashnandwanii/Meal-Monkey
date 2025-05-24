// import 'package:get/get.dart';

// class AuthController extends GetxController {
//   // final loginloading = false.obs;
//   // final registerloading = false.obs;
//   // Future<void> register(String name, String email, String password) async {
//   //   try {
//   //     registerloading.value = true;
//   //     final AuthResponse data = await SupabaseService.client.auth.signUp(
//   //       password: password,
//   //       email: email,
//   //       data: {
//   //         'name': name,
//   //       },
//   //     );
//   //     registerloading.value = false;
//   //     if (data.user != null) {
//   //       StorageServices.session
//   //           .write(StorageKeys.userSession, data.session!.toJson());
//   //       Get.offAllNamed(RouteNames.onboarding);
//   //       showSnackbar('Success', 'Register success');
//   //     }
      
//   //   } on AuthException catch (e) {
//   //     registerloading.value = false;
//   //     print(e.message);
//   //   }
//   // }

//   // Future<void> login(String email, String password) async {
//   //   try {
//   //     loginloading.value = true;
//   //     final AuthResponse data =
//   //         await SupabaseService.client.auth.signInWithPassword(
//   //       password: password,
//   //       email: email,
//   //     );
//   //     loginloading.value = false;
//   //     if (data.user != null) {
//   //       StorageServices.session
//   //           .write(StorageKeys.userSession, data.session!.toJson());
//   //       Get.offAllNamed(RouteNames.home);
//   //       showSnackbar('Success', 'Login success');
//   //     }
//   //   } on AuthException catch (e) {
//   //     loginloading.value = false;
//   //     showSnackbar('Error', e.message);
//   //   }
//   // }
// }
