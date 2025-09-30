import 'package:Quize/responsive/Mobile/quizMobile.dart';
import 'package:Quize/responsive/Tablet/quisTablet.dart';
import 'package:Quize/responsive/responsivedata.dart';
import 'package:flutter/material.dart';
class QuisPage extends StatefulWidget {
  const QuisPage({super.key});

  @override
  State<QuisPage> createState() => _QuisPageState();
}

class _QuisPageState extends State<QuisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayouts(
        MobileSize: MobileQuis(),
        TabletSize: TabletQuis(),
      ),
    );
  }
}