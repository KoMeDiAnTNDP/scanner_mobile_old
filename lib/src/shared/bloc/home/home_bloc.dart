import 'dart:async';

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
  final StreamController<String> _serverErrorController = StreamController<String>.broadcast();

  Stream<HomeModel> get homeModelStream => _homeModelController.stream;
  Stream<String> get serverErrorStream => _serverErrorController.stream;

  CategoriesService _categoriesService;

  HomeBloc(String token, this.tokenBloc) {
    _categoriesService = CategoriesService(token);
  }

  void getCategories() async {
    ResponseWithError<CategoriesListResponse> categories = await _categoriesService.getCategories();

    if (categories.errorMessage != null) {
      _serverErrorController.sink.add(categories.errorMessage);

      return;
    }

    homeModel.categories = [...categories.response.categoriesList];
    _homeModelController.sink.add(homeModel);
  }

  void logout() => tokenBloc.setToken(null);

  @override
  void dispose() {
    super.dispose();

    _homeModelController.close();
    _serverErrorController.close();
  }
}