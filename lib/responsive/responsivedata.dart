import "package:flutter/material.dart";

class ResponsiveLayouts extends StatelessWidget {
  final Widget MobileSize;
  final Widget TabletSize;
  ResponsiveLayouts({required this.MobileSize, required this.TabletSize});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, Constraints) {
        if (Constraints.maxWidth < 10000) {
          return MobileSize;
        } else {
          return TabletSize;
        }
      },
    );
  }
}
