import 'package:flutter/material.dart';
import 'package:scanner_mobile/src/shared/bloc/base/provider_bloc.dart';
import 'package:scanner_mobile/src/shared/bloc/category/category_bloc.dart';
import 'package:scanner_mobile/src/shared/models/categories/category_model.dart';
import 'package:scanner_mobile/src/shared/models/category/category_bloc_model.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryModel categoryModel;
  final String token;

  const CategoryScreen({
    Key key,
    this.categoryModel,
    this.token
  }): super(key: key);

  Widget _createBody(BuildContext context, List<String> imageUrls, CategoryBloc bloc) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: RaisedButton(
                    elevation: 5.0,
                    child: Text('Camera'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0)
                    ),
                    color: Colors.grey,
                    onPressed: () {}
                  )
                ),
                RaisedButton(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0)
                  ),
                  color: Colors.grey,
                  child: Text('Gallery'),
                  onPressed: () => bloc.chooseImagesFromGallery(context)
                )
              ]
            )
          ),
          _buildImagesLayout(context, imageUrls)
        ]
      )
    );
  }

  Widget _buildImagesLayout(BuildContext context, List<String> imageUrls) {
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
            child: Image.network(imageUrls[index])
          ),
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
        builder: (context, snapshot) {
          CategoryBlocModel categoryBlocModel = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text(categoryModel.name),
              centerTitle: true
            ),
            body: _createBody(context, categoryBlocModel.categoryImages, bloc)
          );
        }
      )
    );
  }
}