import 'package:scanner_mobile/src/shared/models/categories/category_model.dart';

class CategoryBlocModel {
  final CategoryModel categoryModel;
  List<String> categoryImages;

  CategoryBlocModel({this.categoryModel, this.categoryImages = const <String>[]});
}