import 'package:intl/intl.dart';

extension IntDateExtension on int {
  String formatedDate(String format) {
    return DateFormat(format).format(
      DateTime.fromMillisecondsSinceEpoch(this * 1000),
    );
  }
}
