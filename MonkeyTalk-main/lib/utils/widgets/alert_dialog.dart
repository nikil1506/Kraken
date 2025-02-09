import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:kraken/config.dart';
import 'package:kraken/utils/network/network_requester.dart';

import 'image_widget.dart';

Future<String?> showUrlDialog(BuildContext context) async {
  final TextEditingController textController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter URL'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: baseUrl,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(textController.text);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

void showDelightToast(
  BuildContext context,
  String message, {
  Widget? actionButton,
}) {
  DelightToastBar(
    autoDismiss: true,
    snackbarDuration: const Duration(milliseconds: 3000),
    position: DelightSnackbarPosition.top,
    builder: (context) => ToastCard(
      color: context.colorScheme.onPrimary,
      leading: ImageWidget(
        label: "wizard1.png"
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.primary,
                fontSize: 14,
              ),
            ),
          ),
          if (actionButton != null) actionButton,
        ],
      ),
    ),
  ).show(context);
}
