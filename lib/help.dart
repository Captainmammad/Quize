import 'package:Quize/responsive/Mobile/helpMobile.dart';
import 'package:Quize/responsive/Tablet/helpTablet.dart';
import 'package:Quize/responsive/responsivedata.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayouts(
        MobileSize: MobileHelp(),
        TabletSize: TabletHelp(),
      ),
    );
  }
}



