import 'package:Quize/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MobileHelp extends StatelessWidget {
  const MobileHelp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('myBox');
    String locale = box.get('locale', defaultValue: 'fa');
    String picklang;

    if (locale == "en") {
      picklang = "assets/number/listen.png";
    } else {
      picklang = "assets/number/listfa.png";
    }
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          // مبنای طراحی
          const baseWidth = 360.0;
          const baseHeight = 780.0;

          final widthFactor = width / baseWidth;
          final heightFactor = height / baseHeight;

          // مقیاس با اهمیت بیشتر به height
          double scale = widthFactor * 0.45 + heightFactor * 0.55;

          // محدودیت scale
          if (scale < 0.85) scale = 0.85;
          if (scale > 1.03) scale = 1.03;

          // ابعاد المان‌ها

          final btnFontSize = (26.0 * scale).clamp(14.0, 22.0);
          final smallFontSize = (18.0 * scale).clamp(12.0, 20.0);

          final buttonWidth = double.infinity;
          final buttonHeight = (height * 0.08 * scale).clamp(48.0, 84.0);

          final playIconSize = (height * 0.08 * scale).clamp(28.0, 56.0);

          final imageWidth = height * 0.38 * scale;
          // final imageMaxByHeight = height * 0.4 * scale;

          final adjustedImageWidth = imageWidth > imageWidth
              ? imageWidth
              : imageWidth;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF35DBFF), Color(0xFF04C2FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // 🔹 نوار بالا
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                      vertical: height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, "/home"),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03 * scale,
                              vertical: height * 0.01 * scale,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF009DF1),
                              borderRadius: BorderRadius.circular(8 * scale),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 20 * scale,
                                ),
                                SizedBox(width: width * 0.015 * scale),
                                Text(
                                  AppTranslations.of("home", locale),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: smallFontSize,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "damavand",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, "/quis"),
                          child: Image.asset(
                            "assets/playicon.png",
                            width: playIconSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.05 * scale),

                  // 🔹 عنوان
                  Text(
                    AppTranslations.of("how_to_play", locale),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.08,
                      fontWeight: FontWeight.bold,
                      fontFamily: "damavand",
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: height * 0.0 * scale),

                  // 🔹 تصاویر
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          picklang,
                          width: adjustedImageWidth,
                          fit: BoxFit.contain,
                        ),
                        // SizedBox(height: height * 0.03 * scale),
                        Image.asset(
                          "assets/number/play.png",
                          width: adjustedImageWidth,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(height: height * 0.04 * scale),

                  // 🔹 دکمه
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: Flexible(
                      flex: 0,
                      child: Center(
                        child: SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/quis");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16 * scale),
                              ),
                            ),
                            child: Text(
                              AppTranslations.of("enjoy", locale),
                              style: TextStyle(
                                fontSize: btnFontSize,
                                color: const Color.fromARGB(255, 13, 170, 243),
                                fontWeight: FontWeight.bold,
                                fontFamily: "damavand",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.1 * scale),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
