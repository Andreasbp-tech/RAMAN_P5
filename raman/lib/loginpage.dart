import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'errormessage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      //Denne linje "pusher replacement" i navigator, så man ikke retunerer til loginpage.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
      );

      var UserUID = FirebaseAuth.instance.currentUser!
          .uid; // Vi gemmer UserUID (bliver nok smart senere;))

      // Handle successful sign-in
    } on FirebaseAuthException catch (e) {
      showMyDialog(context, 'Der skete en fejl under log-in');
    }
  }

  Future _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      FirebaseFirestore.instance
          .collection("users") //Opretter bruger i databasen under users.
          .doc(FirebaseAuth.instance.currentUser!
              .uid) //Her oprettes de med et dokument med UUID'et
          .set({
        "email": FirebaseAuth
            .instance.currentUser!.email // Gemmer brugeres e-mail i field
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Center(
              child: Text(
                'RAMAN',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 200),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
            const SizedBox(height: 45.0),
            const Center(
              child: Text(
                'Har du ikke en konto?',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Center(
              child: Text(
                'Indtast email og password ovenstående felter og tryk:',
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            TextButton(
              onPressed: _register,
              child: Text('Registrer konto'),
            ),
          ],
        ),
      ),
    );
  }
}
