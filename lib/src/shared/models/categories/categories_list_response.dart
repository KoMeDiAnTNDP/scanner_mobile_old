import 'package:scanner_mobile/src/shared/models/categories/category_model.dart';

class CategoriesListResponse {
  final List<CategoryModel> categoriesList;

  const CategoriesListResponse({this.categoriesList});

  factory CategoriesListResponse.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    List<CategoryModel> categoriesList = <CategoryModel>[];

    for (Map category in data['categories']) {
      categoriesList.add(CategoryModel.fromMap(category));
    }

    return CategoriesListResponse(
      categoriesList: categoriesList
    );
  }
}