import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_in_lab_activity/models/recipe.dart';

class RecipeRepository {
  final CollectionReference _recipeCollection =
      FirebaseFirestore.instance.collection('recipes');

  Future<void> addRecipe(Recipe recipe) {
    return _recipeCollection.add(
      recipe
    );
  }

  Future<void> updateRecipe(Recipe recipe) {
    return _recipeCollection.doc(recipe.title).update(
      {
        'title': recipe.title,
        'description': recipe.description,
        'ingredients': recipe.ingredients,
      },
    );
  }

  Future<void> deleteRecipe(Recipe recipe) {
    return _recipeCollection.doc(recipe.title).delete();
  }
}
