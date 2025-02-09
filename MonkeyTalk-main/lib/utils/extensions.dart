import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formattedText => DateFormat('MMM d, yyyy').format(this);
}
