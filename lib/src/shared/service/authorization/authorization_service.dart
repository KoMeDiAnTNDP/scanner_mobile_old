import 'package:scanner_mobile/src/shared/models/http/response.dart';
import 'package:scanner_mobile/src/shared/models/http/http_method.dart';
import 'package:scanner_mobile/src/shared/models/http/token_response.dart';
import 'package:scanner_mobile/src/shared/service/authorization/authorization_service_interface.dart';
import 'package:scanner_mobile/src/shared/service/http/http_service.dart';

class AuthorizationService implements IAuthorizationService {
  final HttpService _httpService = HttpService();
  
  @override
  Future<ResponseWithError<TokenResponse>> signIn(String email, String password) async {
    Map body = {
      'email': email,
      'password': password
    };
    ResponseWithError tokenResponse = await _httpService.makeRequest<TokenResponse>(
      HttpMethod.POST,
      IAuthorizationService.LOGIN_PATH,
      body: body
    );
    
    return tokenResponse;
  }

  @override
  Future<ResponseWithError<TokenResponse>> signUp(String email, String password, String username) async {
    Map body = {
      'email': email,
      'password': password,
      'username': username
    };
    ResponseWithError tokenResponse = await _httpService.makeRequest<TokenResponse>(
      HttpMethod.POST,
      IAuthorizationService.REGISTRATION_PATH,
      body: body
    );

    return tokenResponse;
  }
  
}