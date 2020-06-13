import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/screens/category/category_screen.dart';
import 'package:scanner_mobile/src/screens/home/categories_list/categories_list_item.dart';
import 'package:scanner_mobile/src/shared/models/categories/category_model.dart';

class CategoriesList extends StatelessWidget {
  final List<CategoryModel> categories;
  final String token;
  final VoidCallback onWillPop;

  static const String MEDICAL = 'assets/images/snake.svg';
  static const String CONTRACT = 'assets/images/paper.svg';

  const CategoriesList({
    Key key,
    @required this.categories,
    @required this.token,
    @required this.onWillPop
  }): super(key: key);

  String _chooseImageAsset(String category) {
    if (category == 'Contract') {
      return CONTRACT;
    }

    return MEDICAL;
  }

  @override
  Widget build(BuildContext context) {
    categories.sort();
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: CategoriesListItem(
            title: categories[index].name,
            image: _chooseImageAsset(categories[index].name)
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryScreen(
                  categoryModel: categories[index],
                  token: token,
                  onWilPop: onWillPop
                )
              )
            );
          }
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.grey),
      itemCount: categories.length
    );
  }
}