import 'package:flutter/material.dart';

class TabletHome extends StatelessWidget {
  const TabletHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          // مبنای طراحی (برای بدست آوردن نسبت)
          const baseWidth = 360.0;
          const baseHeight = 780.0;

          final widthFactor = width / baseWidth;
          final heightFactor = height / baseHeight;

          // میانگین وزنی از عرض و ارتفاع (وزن ارتفاع کمی بیشتر تا از overflow عمودی جلوگیری کند)
          double scale = widthFactor * 0.45 + heightFactor * 0.55;

          // محدودیت مقیاس: نه خیلی کوچک، نه خیلی بزرگ
          if (scale < 0.85) scale = 0.85;
          if (scale > 1.03) scale = 1.03;

          // محاسبه ابعاد منطقی و با کات برای جلوگیری از بزرگ شدن بیش از حد
          double logoWidth = width * 0.90 * scale;
          double logoMaxByHeight = height * 0.40 * scale;
          if (logoWidth > logoMaxByHeight) logoWidth = logoMaxByHeight;

          double bannerWidth = width * 0.90 * scale;
          double bannerMaxByHeight = height * 0.40 * scale;
          if (bannerWidth > bannerMaxByHeight) bannerWidth = bannerMaxByHeight;

          double buttonWidth = width * 0.82;
          double buttonHeight = (height * 0.08 * scale).clamp(48.0, 84.0);

          final titleFontSize = (26.0 * scale).clamp(16.0, 30.0);
          final subtitleFontSize = (20.0 * scale).clamp(12.0, 22.0);
          final btnFontSize = (22.0 * scale).clamp(14.0, 24.0);

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
                  SizedBox(height: height * 0.03 * scale),
                  Flexible(
                    flex: 2,
                    child: Center(
                      child: Image.asset(
                        "assets/logo.png",
                        width: logoWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01 * scale),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: Column(
                      children: [
                        Text(
                          "Join our daily challenge and win",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleFontSize,
                            fontFamily: "damavand",
                          ),
                        ),
                        SizedBox(height: height * 0.003 * scale),
                        Text(
                          "special gift just for you",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: subtitleFontSize,
                            fontFamily: "damavand",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Center(
                      child: Image.asset(
                        "assets/banner.png",
                        width: bannerWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02 * scale),
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: buttonWidth,
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD601), Color(0xFFFF9103)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/quis");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Play",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: btnFontSize,
                                fontWeight: FontWeight.bold,
                                fontFamily: "damavand",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.015 * scale),
                        SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/help");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "How to play",
                              style: TextStyle(
                                fontSize: btnFontSize,
                                color: const Color.fromARGB(255, 13, 170, 243),
                                fontWeight: FontWeight.bold,
                                fontFamily: "damavand",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02 * scale),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
