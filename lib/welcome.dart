import 'package:Quize/responsive/Mobile/homeMobile.dart';
import 'package:Quize/responsive/Tablet/homeTablet.dart';
import 'package:Quize/responsive/responsivedata.dart';
import 'package:flutter/material.dart';

class WelcomPage extends StatefulWidget {
  const WelcomPage({super.key});

  @override
  State<WelcomPage> createState() => _WelcomPageState();
}

class _WelcomPageState extends State<WelcomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayouts(
        MobileSize: MobileHome(),
        TabletSize: TabletHome(),
      ),
    );
  }
}
