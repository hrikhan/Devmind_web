import 'package:flutter/widgets.dart';

enum DeviceSize { mobile, tablet, desktop }

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, DeviceSize size) builder;

  static DeviceSize sizeOf(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return DeviceSize.mobile;
    if (width < 1000) return DeviceSize.tablet;
    return DeviceSize.desktop;
  }

  static bool isMobile(BuildContext context) => sizeOf(context) == DeviceSize.mobile;
  static bool isTablet(BuildContext context) => sizeOf(context) == DeviceSize.tablet;
  static bool isDesktop(BuildContext context) => sizeOf(context) == DeviceSize.desktop;

  @override
  Widget build(BuildContext context) {
    return builder(context, sizeOf(context));
  }
}
