import 'package:flutter/material.dart';
import 'package:flutter_yeniden_ogreniyorum/constants/routes.dart';
import 'package:flutter_yeniden_ogreniyorum/services/auth/auth_exception.dart';
import 'package:flutter_yeniden_ogreniyorum/services/auth/auth_service.dart';
import 'package:flutter_yeniden_ogreniyorum/utilities/dialogs/error_dialog.dart';

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
                AuthService.firebase()
                    .createUser(email: email, password: password);
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(context, "Weak Password");
              } on EmailAlreadyUseAuthException {
                await showErrorDialog(context, "Email already in use");
              } on InvalidEmailAuthException {
                await showErrorDialog(
                    context, "This is an invalid email adress");
              } on GenericAuthException {
                await showErrorDialog(context, "Failed to register!");
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
