class Recipe {
  String title;
  String description;
  List<String> ingredients;

  Recipe({
    required this.title, 
    this.description = '', 
    required this.ingredients
    });
}
