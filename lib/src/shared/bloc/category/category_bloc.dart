import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:scanner_mobile/src/shared/bloc/base/bloc.dart';
import 'package:scanner_mobile/src/shared/models/categories/categories_images_response.dart';
import 'package:scanner_mobile/src/shared/models/categories/category_model.dart';
import 'package:scanner_mobile/src/shared/models/category/category_bloc_model.dart';
import 'package:scanner_mobile/src/shared/models/http/response.dart';
import 'package:scanner_mobile/src/shared/service/categories/categories_service.dart';

class CategoryBloc extends Bloc {
  final _picker = ImagePicker();
  PickedFile _file;
  final List<Asset> _filesFromGallery = <Asset>[];

  CategoryBlocModel categoryBlocModel;

  final StreamController<CategoryBlocModel> _categoryBlocModelController = StreamController<CategoryBlocModel>.broadcast();
  final StreamController<String> _serverErrorController = StreamController<String>.broadcast();

  Stream<CategoryBlocModel> get categoryBlocModelStream => _categoryBlocModelController.stream;
  Stream<String> get serverErrorStream => _serverErrorController.stream;

  CategoriesService _categoriesService;

  CategoryBloc(CategoryModel categoryModel, String token) {
    categoryBlocModel = CategoryBlocModel(categoryModel: categoryModel);
    _categoriesService = CategoriesService(token);
  }

  void chooseImagesFromGallery(BuildContext context) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: _filesFromGallery,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Theme.of(context).primaryColor.toString(),
          actionBarTitle: 'Images',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor: '#000000'
        )
      );
    } on Exception catch(e) {
      print(e.toString());
    }
  }

  void getImages() async {
    ResponseWithError<CategoryImagesResponse> imagesResponse =
      await _categoriesService.getImages(categoryBlocModel.categoryModel.id);

    if (imagesResponse.errorMessage != null) {
      _serverErrorController.sink.add(imagesResponse.errorMessage);

      return;
    }

    categoryBlocModel.categoryImages = [...imagesResponse.response.categoryImages];
    _categoryBlocModelController.sink.add(categoryBlocModel);
  }

  @override
  void dispose() {
    super.dispose();

    _categoryBlocModelController.close();
    _serverErrorController.close();
  }
}