class CategoryModel {
  final int id;
  final String name;

  const CategoryModel({this.id, this.name});

  factory CategoryModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    return CategoryModel(
      id: data['id'],
      name: data['name']
    );
  }
}