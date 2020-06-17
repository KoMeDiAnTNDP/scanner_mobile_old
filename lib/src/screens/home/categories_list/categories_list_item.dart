import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CategoriesListItem extends StatelessWidget {
  final String title;
  final String image;

  const CategoriesListItem({
    Key key,
    this.title,
    this.image
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).canvasColor,
            child: SvgPicture.asset(image)
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(title, style: TextStyle(color: Colors.black))
          )
        ]
      )
    );
  }

}