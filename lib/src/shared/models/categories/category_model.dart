class CategoryModel implements Comparable<CategoryModel> {
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

  @override
  int compareTo(CategoryModel other) {
    return this.name.compareTo(other.name);
  }
}