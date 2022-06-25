import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_yeniden_ogreniyorum/constants/routes.dart';
import 'package:flutter_yeniden_ogreniyorum/firebase_options.dart';

import 'package:flutter_yeniden_ogreniyorum/widgets/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: Column(
        children: [
          TextField(
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            controller: _email,
            decoration: const InputDecoration(
              hintText: "Enter your email here",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password here",
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  await showErrorDialog(context, "Weak Password");
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(context, "Email already in use");
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(
                      context, "This is an invalid email adress");
                } else {
                  await showErrorDialog(context, "Error: ${e.code}");
                }
              } catch (e) {
                await showErrorDialog(context, "Error: ${e.toString()}");
              }
            },
            child: const Text("Register"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: Text("Already registered? Login here!"),
          ),
        ],
      ),
    );
  }
}
