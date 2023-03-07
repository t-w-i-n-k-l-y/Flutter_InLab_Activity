import 'package:flutter/material.dart';
import 'package:flutter_in_lab_activity/models/recipe.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final dynamic onDeleteRecipe;
  final dynamic onUpdateRecipe;

  const RecipeListItem({
    Key? key,
    required this.recipe,
    required this.onDeleteRecipe,
    required this.onUpdateRecipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
        ]),
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
        ),
        padding: const EdgeInsets.all(10),
        child: ListTile(
          onTap: () {
            onUpdateRecipe(recipe);
          },
          title: Text(
            recipe.title,
            style: const TextStyle(
              fontSize: 20,
              decoration: TextDecoration.none,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDeleteRecipe(recipe),
          ),
        ));
  }
}
