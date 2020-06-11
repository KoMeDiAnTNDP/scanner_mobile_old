import 'package:scanner_mobile/src/shared/models/http/response.dart';
abstract class IAuthorizationService {
  static const String LOGIN_PATH = 'login';
  static const String REGISTRATION_PATH = 'register';

  Future<ResponseWithError> signIn(String email, String password);
  Future<ResponseWithError> signUp(String email, String password, String username);
}