import 'package:flutter/material.dart';
import 'package:flutter_yeniden_ogreniyorum/constants/routes.dart';
import 'package:flutter_yeniden_ogreniyorum/services/auth/auth_service.dart';
import 'package:flutter_yeniden_ogreniyorum/views/email_verify_view.dart';
import 'package:flutter_yeniden_ogreniyorum/views/loading_view.dart';
import 'package:flutter_yeniden_ogreniyorum/views/login_view.dart';
import 'package:flutter_yeniden_ogreniyorum/views/notes/new_note_view.dart';
import 'package:flutter_yeniden_ogreniyorum/views/notes/notes_view.dart';
import 'package:flutter_yeniden_ogreniyorum/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const EmailVerifyView(),
        newNoteRoute: (context) => NewNoteView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const EmailVerifyView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const LoadingPage();
        }
      },
    );
  }
}
