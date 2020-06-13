import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/screens/category/detail_view/detail_view.dart';
import 'package:scanner_mobile/src/shared/bloc/base/provider_bloc.dart';
import 'package:scanner_mobile/src/shared/bloc/category/category_bloc.dart';
import 'package:scanner_mobile/src/shared/models/categories/category_model.dart';
import 'package:scanner_mobile/src/shared/models/category/category_bloc_model.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryModel categoryModel;
  final String token;
  final VoidCallback onWilPop;

  const CategoryScreen({
    Key key,
    @required this.categoryModel,
    @required this.token,
    @required this.onWilPop
  }): super(key: key);

  Widget _createBody(BuildContext context, List<String> imageUrls, CategoryBloc bloc) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: _buildImagesLayout(context, imageUrls, bloc)
    );
  }

  Widget _buildImagesLayout(BuildContext context, List<String> imageUrls, CategoryBloc bloc) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: orientation == Orientation.portrait ? 3 : 4
      ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Card(
            child: Image.network(
              imageUrls[index],
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            )
          ),
          onTap: () => bloc.openDetailView(imageUrls[index])
        );
      },
      itemCount: imageUrls.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    CategoryBloc bloc = CategoryBloc(categoryModel, token);
    bloc.getImages();

    return BlocProvider<CategoryBloc>(
      bloc: bloc,
      child: StreamBuilder<CategoryBlocModel>(
        stream: bloc.categoryBlocModelStream,
        initialData: bloc.categoryBlocModel,
        builder: (context, snapshotCategoryModel) {
          CategoryBlocModel categoryBlocModel = snapshotCategoryModel.data;

          return StreamBuilder<bool>(
            stream: bloc.listLoadingStream,
            initialData: true,
            builder: (context, snapshotListLoading) {
              bool isListLoading = snapshotListLoading.data;

              return StreamBuilder<String>(
                stream: bloc.detailViewStream,
                builder: (context, snapshotDetailView) {
                  String imageUrl = snapshotDetailView.data;
                  Widget detailView = imageUrl != null ?
                    DetailView(imageUrl: imageUrl, bloc: bloc) :
                    Container(width: 0, height: 0);


                  return Stack(
                    children: [
                      WillPopScope(
                        onWillPop: () async {
                          onWilPop();

                          return true;
                        },
                        child: Scaffold(
                          appBar: AppBar(
                            title: Text(categoryModel.name),
                            centerTitle: true
                          ),
                          body: isListLoading ?
                            BlocProvider.createLoadingContainer() :
                            _createBody(context, categoryBlocModel.categoryImages, bloc)
                        )
                      ),
                      detailView
                    ]
                  );
                }
              );
            }
          );
        }
      )
    );
  }
}