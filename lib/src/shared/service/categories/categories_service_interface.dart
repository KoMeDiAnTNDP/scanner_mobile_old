import 'package:scanner_mobile/src/shared/models/categories/categories_images_response.dart';
import 'package:scanner_mobile/src/shared/models/categories/categories_list_response.dart';
import 'package:scanner_mobile/src/shared/models/http/response.dart';

abstract class ICategoriesService {
  static const String GET_CATEGORIES_PATH = 'user/categories';
  static const String UPLOAD_DOCUMENTS_PATH = 'documents/upload';
  static const String GET_IMAGES_PATH = 'user/categories/images';

  Future<ResponseWithError<CategoriesListResponse>> getCategories();
  Future<void> uploadDocuments(List<List<int>> files);
  Future<ResponseWithError<CategoryImagesResponse>> getImages(int categoryId);
}