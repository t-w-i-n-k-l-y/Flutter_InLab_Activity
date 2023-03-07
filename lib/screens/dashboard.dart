import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_in_lab_activity/screens/recipe_page.dart';
import 'package:flutter_in_lab_activity/screens/login.dart';

class Dashboard extends StatelessWidget {
  final User? user;
  const Dashboard(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome, ${user!.email}"),
            ElevatedButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecipePage()));
                },
                child: const Text("View Recipes")),
            ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  await FirebaseAuth.instance.signOut();

                  navigator.pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text("Logout")),
          ],
        ),
      ),
    );
  }
}
