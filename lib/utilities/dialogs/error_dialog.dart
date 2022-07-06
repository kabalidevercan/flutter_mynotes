import 'package:flutter/cupertino.dart';
import 'package:flutter_yeniden_ogreniyorum/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: "An Error occurred",
    content: text,
    optionsBuilder: () => {
      'OK' : null,
    },
  );
}
