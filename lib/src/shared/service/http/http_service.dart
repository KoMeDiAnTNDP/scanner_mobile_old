import 'dart:io';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:scanner_mobile/src/shared/models/Errors.dart';
import 'package:scanner_mobile/src/shared/models/categories/categories_images_response.dart';
import 'package:scanner_mobile/src/shared/models/categories/categories_list_response.dart';
import 'package:scanner_mobile/src/shared/models/http/response.dart';
import 'package:scanner_mobile/src/shared/models/http/http_method.dart';
import 'package:scanner_mobile/src/shared/models/http/token_response.dart';

class HttpService {
  static const String PROTOCOL = 'https';
  static const String HOST = '7588b420503b.ngrok.io';
  static Map<String, String> authHeaders(String token) => {
    'Authorization': 'Bearer $token'
  };
  static const Map<String, String> DEFAULT_HEADERS = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  Future<ResponseWithError<TResponse>> makeRequest<TResponse>(
      HttpMethod method,
      String path, {
        String token,
        Map body,
        Map<String, String> params,
        bool isMultipart = false
      }) async {
    String url = _makeUrl(path, params: params);
    dynamic response;

    switch (method) {
      case HttpMethod.GET:
        response = await _makeGetRequest(url, token: token);
        break;
      case HttpMethod.POST:
        response = await _makePostRequest(url, body, isMultipart, token: token);
        break;
    }

    ResponseWithError<TResponse> result;

    if (response.statusCode == HttpStatus.ok) {
      if (isMultipart) {
        return null;
      }

      Map jsonResponse = convert.jsonDecode(response.body);

      switch (TResponse) {
        case TokenResponse:
          TResponse response = TokenResponse.fromMap(jsonResponse) as TResponse;
          result = ResponseWithError<TResponse>(response: response);
          break;
        case CategoriesListResponse:
          TResponse response = CategoriesListResponse.fromMap(jsonResponse) as TResponse;
          result = ResponseWithError<TResponse>(response: response);
          break;
        case CategoryImagesResponse:
          TResponse response = CategoryImagesResponse.fromMap(jsonResponse) as TResponse;
          result = ResponseWithError<TResponse>(response: response);
          break;
      }

      if (result.response == null) {
        result = ResponseWithError<TResponse>(errorMessage: Errors.ERROR_INVALID_RESPONSE);
      }
    }
    else {
      try {
        Map jsonResponse = convert.jsonDecode(response.body);
        result = ResponseWithError(errorMessage: jsonResponse['errorMessage']);
      }
      catch (error) {
        print(error);
        result = ResponseWithError(errorMessage: Errors.ERROR_SOMETHING_WENT_WRONG);
      }
    }

    return result;
  }

  Future<Response> _makeGetRequest(String url, {String token}) async {
    Map<String,String> headers = token != null ? authHeaders(token) : null;
    Response response = await get(url, headers: headers);

    return response;
  }

  Future<dynamic> _makePostRequest(
      String url,
      Map body,
      bool isMultipart, {
        String token
      }) async {
    Map<String, String> headers = token != null ? authHeaders(token) : DEFAULT_HEADERS;

    if (isMultipart) {
      StreamedResponse streamedResponse = await _sendFile(url, body['files'], headers);

      return streamedResponse;
    }

    Response response = await post(url, headers: headers, body: convert.jsonEncode(body));

    return response;
  }

  Future<StreamedResponse> _sendFile(
      String url,
      List<List<int>> listBytes,
      Map<String, String> authHeaders
      ) async {
    MultipartRequest request = MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = authHeaders['Authorization'];

    for (int i = 0; i < listBytes.length; i++) {
      List<int> bytes = listBytes[i];
      MultipartFile multipartFile = MultipartFile.fromBytes('files', bytes, filename: 'image$i');
      request.files.add(multipartFile);
    }

    StreamedResponse streamedResponse = await request.send();

    return streamedResponse;
  }

  String _makeUrl(String path, {Map<String, String> params}) {
    return Uri(
      scheme: PROTOCOL,
      host: HOST,
      path: path,
      queryParameters: params
    ).toString();
  }
}