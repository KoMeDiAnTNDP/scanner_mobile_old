import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/shared/bloc/category/category_bloc.dart';

class DetailView extends StatelessWidget {
  final String imageUrl;
  final CategoryBloc bloc;

  const DetailView({
    Key key,
    @required this.imageUrl,
    @required this.bloc
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(.5)
        ),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: bloc.closeDetailView,
                      child: Icon(Icons.close, color: Colors.white),
                    )
                  )
                ),
                Image.network(imageUrl)
              ],
            )
          )
        )
      ]
    );
  }
}