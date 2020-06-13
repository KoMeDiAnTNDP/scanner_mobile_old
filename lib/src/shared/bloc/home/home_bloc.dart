import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:scanner_mobile/src/shared/bloc/base/bloc.dart';
import 'package:scanner_mobile/src/shared/bloc/token/token_bloc.dart';
import 'package:scanner_mobile/src/shared/models/categories/categories_list_response.dart';
import 'package:scanner_mobile/src/shared/models/home/home_model.dart';
import 'package:scanner_mobile/src/shared/models/http/response.dart';
import 'package:scanner_mobile/src/shared/service/categories/categories_service.dart';

class HomeBloc extends Bloc {
  final HomeModel homeModel = HomeModel();
  final TokenBloc tokenBloc;

  final StreamController<HomeModel> _homeModelController = StreamController<HomeModel>.broadcast();
  final StreamController<bool> _listLoadingController = StreamController<bool>.broadcast();

  Stream<HomeModel> get homeModelStream => _homeModelController.stream;
  Stream<bool> get listLoadingStream => _listLoadingController.stream;

  CategoriesService _categoriesService;

  HomeBloc(String token, this.tokenBloc) {
    _categoriesService = CategoriesService(token);
  }

  Future<void> getCategories() async {
    _listLoadingController.sink.add(true);
    ResponseWithError<CategoriesListResponse> categories = await _categoriesService.getCategories();

    if (categories.errorMessage != null) {
      showError('Get Categories', description: categories.errorMessage);

      return;
    }

    homeModel.categories = [...categories.response.categoriesList];
    _homeModelController.sink.add(homeModel);
    _listLoadingController.sink.add(false);
  }

  void logout() => tokenBloc.setToken(null);

  void chooseImagesFromGallery(BuildContext context) async {
    try {
      startLoading();
      List<Asset> resultList = await MultiImagePicker.pickImages(
          maxImages: 10,
          enableCamera: true,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: 'chat'),
          materialOptions: MaterialOptions(
              actionBarColor: '#${Theme.of(context).primaryColor.value.toRadixString(16)}',
              actionBarTitle: 'Images',
              allViewTitle: 'All Photos',
              useDetailsView: false,
              selectCircleStrokeColor: '#000000'
          )
      );

      List<List<int>> files = [];

      for (Asset asset in resultList) {
        ByteData byteData = await asset.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        files.add(imageData);
      }

      await _categoriesService.uploadDocuments(files);
    } on Exception catch(error) {
      showError('Images in Gallery', description: error.toString());
    }
    finally {
      stopLoading();
      await getCategories();
    }
  }

  void makePhoto() async {
    try {
      PickedFile file = await ImagePicker().getImage(source: ImageSource.camera);
      List<int> files = await file.readAsBytes();
      await _categoriesService.uploadDocuments([files]);
    }
    on Exception catch (error) {
      showError('Make Photo', description: error.toString());
    }
    finally {
      stopLoading();
      await getCategories();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _homeModelController.close();
    _listLoadingController.close();
  }
}