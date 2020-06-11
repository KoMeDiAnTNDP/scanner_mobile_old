class CategoryImagesResponse {
  final List<String> categoryImages;

  const CategoryImagesResponse({this.categoryImages});

  factory CategoryImagesResponse.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    return CategoryImagesResponse(
      categoryImages: List<String>.from(data['image_urls'])
    );
  }
}