import 'package:flutter/material.dart';
import 'package:flutter_yeniden_ogreniyorum/constants/routes.dart';
import 'package:flutter_yeniden_ogreniyorum/enums/menu_action.dart';
import 'package:flutter_yeniden_ogreniyorum/services/auth/auth_service.dart';
import 'package:flutter_yeniden_ogreniyorum/services/crud/notes_service.dart';
import 'package:flutter_yeniden_ogreniyorum/views/loading_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text("Log out"),
                  value: MenuAction.logout,
                )
              ];
            },
          ),
        ],
        title: const Text("Main UI"),
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(
          email: userEmail,
        ),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return ListView.builder(
                          itemBuilder: ((context, index) {
                            final note = allNotes[index];
                            return ListTile(
                              title: Text(
                                note.text,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
                          itemCount: allNotes.length,
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return LoadingPage();
                  }
                }),
              );
            default:
              return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("NO"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("YES"),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
