import 'package:flutter/material.dart';
import 'package:flutter_yeniden_ogreniyorum/constants/routes.dart';
import 'package:flutter_yeniden_ogreniyorum/services/auth/auth_service.dart';

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({Key? key}) : super(key: key);

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verify"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "We've sent you an email verification.Please open it to verify your account.",
            ),
            const Text(
              "If you haven't received a verification email yet,press the button below",
            ),
            ElevatedButton(
              onPressed: () async {
                AuthService.firebase().sendEmailVerification();
              },
              child: const Text("Send email verification"),
            ),
            ElevatedButton(
              onPressed: () async {
                AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("Restart"),
            ),
          ],
        ),
      ),
    );
  }
}
