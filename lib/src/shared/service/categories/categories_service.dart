import 'package:image_picker/image_picker.dart';

import 'package:scanner_mobile/src/shared/models/categories/categories_images_response.dart';
import 'package:scanner_mobile/src/shared/models/categories/categories_list_response.dart';
import 'package:scanner_mobile/src/shared/models/http/http_method.dart';
import 'package:scanner_mobile/src/shared/models/http/response.dart';
import 'package:scanner_mobile/src/shared/service/categories/categories_service_interface.dart';
import 'package:scanner_mobile/src/shared/service/http/http_service.dart';

class CategoriesService implements ICategoriesService {
  final HttpService _httpService = HttpService();
  final String token;

  CategoriesService(this.token);

  @override
  Future<ResponseWithError<CategoriesListResponse>> getCategories() async {
    ResponseWithError<CategoriesListResponse> response = await _httpService.makeRequest(
      HttpMethod.GET,
      ICategoriesService.GET_CATEGORIES_PATH,
      token: this.token
    );

    return response;
  }

  @override
  Future<ResponseWithError<CategoryImagesResponse>> getImages(int categoryId) async {
    Map<String, String> params = {
      'category_id': categoryId.toString()
    };
    ResponseWithError<CategoryImagesResponse> response = await _httpService.makeRequest(
      HttpMethod.GET,
      ICategoriesService.GET_IMAGES_PATH,
      token: this.token,
      params: params
    );

    return response;
  }

  @override
  Future<void> uploadDocuments(List<PickedFile> files) async {
    Map body = {
      'files': files
    };
    await _httpService.makeRequest(
      HttpMethod.POST,
      ICategoriesService.UPLOAD_DOCUMENTS_PATH,
      token: this.token,
      body: body
    );
  }
}