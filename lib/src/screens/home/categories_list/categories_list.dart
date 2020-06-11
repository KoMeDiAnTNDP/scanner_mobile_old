import 'package:flutter/material.dart';
import 'package:scanner_mobile/src/screens/category/category_screen.dart';
import 'package:scanner_mobile/src/screens/home/categories_list/categories_list_item.dart';
import 'package:scanner_mobile/src/shared/models/categories/category_model.dart';

class CategoriesList extends StatelessWidget {
  final List<CategoryModel> categories;
  final String token;

  static const String MEDICAL = 'assets/images/snake.svg';
  static const String Contract = 'assets/images/paper.svg';

  const CategoriesList({
    Key key,
    this.categories,
    this.token
  }): super(key: key);

  String _chooseImageAsset(String category) {
    if (category == 'Contract') {
      return Contract;
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
                builder: (context) => CategoryScreen(categoryModel: categories[index], token: token)
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