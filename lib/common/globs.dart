class SVKey {
  static const mainUrl = 'http://localhost:3001';
  static const baseUrl = 'http://10.0.2.2:6013/api/';
  static const nodeUrl = mainUrl;

  static const svLogin = '${baseUrl}login';
  static const svSignUp = '${baseUrl}signup';
  static const svForgotPassWordRequest = '${baseUrl}forgot_password_request';
  static const svForgotPasswordVerify = '${baseUrl}forgot_password_verify';
  static const svForgotPasswordSetNew = '${baseUrl}forgot_password_set_new';
}

class KKey {
  static const payload = 'payload';
  static const status = 'status';
}

class Msg {
  static const enterEmail = 'Please enter your email';
  static const enterPassword =
      'Please enter your password minimum 6 characters';
  static const success = 'success';
  static const fail = 'fail';
}
