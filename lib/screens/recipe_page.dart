import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_in_lab_activity/models/recipe.dart';
import 'package:flutter_in_lab_activity/repositories/recipe_repository.dart';
import 'package:flutter_in_lab_activity/widgets/recipe_list_item.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<Recipe> availableRecipes = [];
  final RecipeRepository _recipeRepository = RecipeRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void getAvailableRecipes() async {
    // get the list of todo items from the database
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('recipes').get();

    // clear the existing list of todo items
    availableRecipes.clear();

    // add the todo items from the database to the list of todo items
    querySnapshot.docs.forEach((doc) {
      availableRecipes.add(
        Recipe(
          title: doc['title'],
          description: doc['description'],
          ingredients: doc['ingredients'],
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getAvailableRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Recipe App')),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
            decoration: const BoxDecoration(
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                      ),
                      for (var recipe in availableRecipes)
                        RecipeListItem(
                          recipe: recipe,
                          onDeleteRecipe: _handleDeleteRecipe,
                          onUpdateRecipe: _handleUpdateRecipe,
                        ),
                    ],
                  ),
                ),
                // container for the text field and add button
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          // container for the text field
                          child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              margin: const EdgeInsets.only(
                                top: 20,
                                left: 20,
                                bottom: 20,
                              ),
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _titleController,
                                    decoration: const InputDecoration(
                                        hintText: 'Add a new title',
                                        border: InputBorder.none),
                                  ),
                                  TextField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                        hintText: 'Add the description',
                                        border: InputBorder.none),
                                  ),
                                ],
                              )),
                        ),
                        // container for add button
                        Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                              right: 20,
                              bottom: 20,
                            ),
                            child: ElevatedButton(
                              child: const Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                _addRecipe(_titleController.text,
                                    _descriptionController.text, List.empty());
                                _titleController.clear();
                                _descriptionController.clear();
                              },
                            ))
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // add recipe
  void _addRecipe(
      String title, String description, List<String> ingredients) async {
    // check if the title is empty, show an error message if it is empty
    if (title.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Error'),
              content: Text('Please enter a title for the recipe'),
            );
          });
    } else {
      // insert recipe to the database
      await _recipeRepository.addRecipe(Recipe(
          title: title, description: description, ingredients: ingredients));
      getAvailableRecipes();
    }
  }

  // update recipe
  void _handleUpdateRecipe(Recipe recipe) {
    // display the task in the text field and update the task when the update button is pressed
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update Recipe'),
            content: TextField(
              // set the initial value of the text field to the selected task
              controller: _titleController..text = recipe.title,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () async {
                  String selected = recipe.title;
                  recipe.title = _titleController.text;
                  await _recipeRepository.updateRecipe(recipe);
                  getAvailableRecipes();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    _titleController.clear();
  }

  // delete recipe
  void _handleDeleteRecipe(Recipe recipe) {
    // get confirmation from the user and delete the todo item if confirmed
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Recipe'),
            content: const Text('Are you sure you want to delete this recipe?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  _recipeRepository.deleteRecipe(recipe);
                  getAvailableRecipes();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
