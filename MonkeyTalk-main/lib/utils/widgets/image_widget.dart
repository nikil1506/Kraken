import 'package:kraken/config.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.label,
    this.size,
  });

  final String label;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/$label",
      width: size,
      height: size,
    );
  }
}
