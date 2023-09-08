import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testt/firebase_authentication/model/user_model.dart';
import 'package:testt/pages/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController username = TextEditingController();
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  @override
  void initState() {
    username = TextEditingController();
    loginEmail = TextEditingController();
    loginPassword = TextEditingController();
    super.initState();
  }

  signup() async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: loginEmail.text,
        password: loginPassword.text,
      );
      await addUser();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (e) {
      SnackBar(
        content: Text('Error $e'),
      );
    }
  }

  addUser() async {
    UserModel user = UserModel(
      username: username.text,
      email: auth.currentUser?.email,
    );
    await db
        .collection('user')
        .doc(auth.currentUser?.uid)
        .collection('Profile')
        .add(
          user.toMap(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: username,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: 'username'),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: loginEmail,
              decoration: const InputDecoration(hintText: 'email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: loginPassword,
              decoration: const InputDecoration(hintText: 'password'),
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  signup();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              child: const Text('Sign Up'),
            )
          ],
        ),
      ),
    );
  }
}
