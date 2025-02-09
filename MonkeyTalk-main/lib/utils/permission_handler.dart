import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<bool> requestMicrophone() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isPermanentlyDenied) openAppSettings();
    return status.isGranted;
  }
}
