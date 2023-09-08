import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testt/pages/home_page.dart';
import 'package:testt/pages/signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  @override
  void initState() {
    loginEmail = TextEditingController();
    loginPassword = TextEditingController();
    super.initState();
  }

  // function
  signin() async {
    try {
      await auth.signInWithEmailAndPassword(
        email: loginEmail.text,
        password: loginPassword.text,
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('error');
      }

      SnackBar(
        content: Text('Error $e'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: loginEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'email'),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: loginPassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(hintText: 'password'),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () async {
                signin();
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ),
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
