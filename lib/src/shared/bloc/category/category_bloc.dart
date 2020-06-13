import 'dart:async';

import 'package:scanner_mobile/src/shared/bloc/base/bloc.dart';
import 'package:scanner_mobile/src/shared/models/categories/categories_images_response.dart';
import 'package:scanner_mobile/src/shared/models/categories/category_model.dart';
import 'package:scanner_mobile/src/shared/models/category/category_bloc_model.dart';
import 'package:scanner_mobile/src/shared/models/http/response.dart';
import 'package:scanner_mobile/src/shared/service/categories/categories_service.dart';

class CategoryBloc extends Bloc {
  CategoryBlocModel categoryBlocModel;

  final StreamController<CategoryBlocModel> _categoryBlocModelController = StreamController<CategoryBlocModel>.broadcast();
  final StreamController<bool> _listLoadingController = StreamController<bool>.broadcast();
  final StreamController<String> _detailViewController = StreamController<String>.broadcast();

  Stream<CategoryBlocModel> get categoryBlocModelStream => _categoryBlocModelController.stream;
  Stream<bool> get listLoadingStream => _listLoadingController.stream;
  Stream<String> get detailViewStream => _detailViewController.stream;

  CategoriesService _categoriesService;

  CategoryBloc(CategoryModel categoryModel, String token) {
    categoryBlocModel = CategoryBlocModel(categoryModel: categoryModel);
    _categoriesService = CategoriesService(token);
  }

  Future<void> getImages() async {
    _listLoadingController.sink.add(true);
    ResponseWithError<CategoryImagesResponse> imagesResponse =
      await _categoriesService.getImages(categoryBlocModel.categoryModel.id);

    if (imagesResponse.errorMessage != null) {
      showError(imagesResponse.errorMessage);

      return;
    }

    categoryBlocModel.categoryImages = [...imagesResponse.response.categoryImages];
    _categoryBlocModelController.sink.add(categoryBlocModel);
    _listLoadingController.sink.add(false);
  }

  void openDetailView(String imageUrl) {
    _detailViewController.sink.add(imageUrl);
  }

  void closeDetailView() {
    _detailViewController.sink.add(null);
  }

  @override
  void dispose() {
    super.dispose();

    _categoryBlocModelController.close();
    _listLoadingController.close();
    _detailViewController.close();
  }
}