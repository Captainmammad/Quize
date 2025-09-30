// ignore_for_file: deprecated_member_use, unnecessary_cast

import 'package:Quize/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart'; // ✅ اضافه شد برای Hive

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ARGUMENTS — امن‌سازی: ممکن است null باشد یا نوع دیگری داشته باشد
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Map) {
      // اگر داده‌ها ارسال نشده بودند، یک صفحه ساده نشان بده تا کرَش نکند
      return Scaffold(
        body: Center(
          child: Text(
            'No result data',
            style: TextStyle(fontFamily: "damavand", fontSize: 18),
          ),
        ),
      );
    }

    final Map data = args as Map;

    // helper محلی برای تبدیل ایمن به int
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    int right = parseInt(data["right"]);
    int fall = parseInt(data["fall"]);
    int total = parseInt(data["total"]);

    // جلوگیری از تقسیم بر صفر
    double percent = total > 0 ? (right / total) * 100 : 0.0;

    // 🔹 دریافت locale از Hive (اسم box خودت را بگذار به جای "myBox")
    final box = Hive.box('myBox');
    String locale = box.get('locale', defaultValue: 'fa');

    // پیام برد یا باخت از AppTranslations
    String hapoo = right > fall
        ? AppTranslations.of("you_win", locale)
        : AppTranslations.of("you_lose", locale);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, "/quis", (route) => false);
        return false;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF35DBFF), Color(0xFF04C2FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              // 🎉 Title
              Text(
                hapoo,
                style: TextStyle(
                  fontFamily: "damavand",
                  fontSize: MediaQuery.of(context).size.height * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // 🔵 Gradient circle percent
              GradientCircleBorder(
                size: MediaQuery.of(context).size.height * 0.2,
                borderWidth: 12,
                percent: percent,
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // ✅ ❌ Score box
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 3),
                            Text(
                              AppTranslations.of("correct", locale),
                              style: const TextStyle(
                                fontFamily: "damavand",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$right",
                          style: const TextStyle(
                            fontFamily: "damavand",
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.cancel, color: Colors.red),
                            const SizedBox(width: 3),
                            Text(
                              AppTranslations.of("wrong", locale),
                              style: const TextStyle(
                                fontFamily: "damavand",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$fall",
                          style: const TextStyle(
                            fontFamily: "damavand",
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              // 🔘 Play again Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
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
                    AppTranslations.of("play_again", locale),
                    style: const TextStyle(
                      fontFamily: "damavand",
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // 🔘 Home Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/home");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppTranslations.of("home", locale),
                    style: const TextStyle(
                      fontFamily: "damavand",
                      color: Color.fromARGB(255, 13, 170, 243),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔆 دایره با بوردر گرادینت (بدون پکیج)
class GradientCircleBorder extends StatelessWidget {
  final double size;
  final double borderWidth;
  final double percent;

  const GradientCircleBorder({
    super.key,
    required this.size,
    required this.borderWidth,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GradientCirclePainter(borderWidth),
        child: Center(
          child: Text(
            "${percent.toStringAsFixed(0)}%",
            style: const TextStyle(
              fontFamily: "damavand",
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientCirclePainter extends CustomPainter {
  final double borderWidth;

  _GradientCirclePainter(this.borderWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final gradient = const SweepGradient(
      colors: [Color(0xFFFFC300), Color(0xFFFF9500)],
      startAngle: 0.0,
      endAngle: 3.14 * 2,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect.deflate(borderWidth / 2), 0, 3.14 * 2, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
