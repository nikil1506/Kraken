import 'package:fluttertoast/fluttertoast.dart';
import 'package:kraken/config.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator();
  }
}

void showToast(String message) {
  Fluttertoast.showToast(msg: message);
}
