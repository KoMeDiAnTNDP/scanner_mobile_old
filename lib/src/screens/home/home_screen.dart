import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/screens/home/categories_list/categories_list.dart';
import 'package:scanner_mobile/src/shared/bloc/base/provider_bloc.dart';
import 'package:scanner_mobile/src/shared/bloc/home/home_bloc.dart';
import 'package:scanner_mobile/src/shared/bloc/token/token_bloc.dart';
import 'package:scanner_mobile/src/shared/models/categories/category_model.dart';
import 'package:scanner_mobile/src/shared/models/home/home_model.dart';

class HomeScreen extends StatelessWidget {
  final String token;
  final TokenBloc tokenBloc;

  const HomeScreen({
    Key key,
    @required this.token,
    @required this.tokenBloc
  }): super(key: key);

  Widget _createAppBar(HomeBloc bloc) {
    return AppBar(
      title: Text('Categories'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: RotationTransition(
            turns: AlwaysStoppedAnimation<double>(.5),
            child: Icon(Icons.exit_to_app)
          ),
          onPressed: bloc.logout
        )
      ]
    );
  }

  Widget _createListView(HomeBloc bloc, List<CategoryModel> categories) {
    if (categories != null && categories.length > 0) {
      return Container(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: CategoriesList(
          categories: categories,
          token: token,
          onWillPop: bloc.getCategories
        )
      );
    }

    return Container(
      color: Colors.white,
      child: Center(
        child: Text('You have no uploaded documents yet')
      )
    );
  }

  Widget _createBody(
      BuildContext context,
      HomeBloc bloc,
      bool isLoading,
      HomeModel homeModel) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: RaisedButton(
                    elevation: 5.0,
                    child: Text('Camera'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0)
                    ),
                    onPressed: bloc.makePhoto
                  )
                ),
                RaisedButton(
                  elevation: 5.0,
                  child: Text('Gallery'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0)
                  ),
                  onPressed: () => bloc.chooseImagesFromGallery(context)
                )
              ]
            )
          ),
          Expanded(
            child: isLoading ? BlocProvider.createLoadingContainer() : _createListView(bloc, homeModel.categories),
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = HomeBloc(token, tokenBloc);
    bloc.getCategories();

    return BlocProvider<HomeBloc>(
      bloc: bloc,
      child: StreamBuilder<HomeModel>(
        stream: bloc.homeModelStream,
        initialData: bloc.homeModel,
        builder: (context, snapshotHomeModel) {
          HomeModel homeModel = snapshotHomeModel.data;

          return StreamBuilder<bool>(
            stream: bloc.listLoadingStream,
            initialData: true,
            builder: (context, snapshotListLoading) {
              bool isListLoading = snapshotListLoading.data;

              return Scaffold(
                appBar: _createAppBar(bloc),
                body: _createBody(context, bloc, isListLoading, homeModel)
              );
            }
          );
        }
      )
    );
  }
}
