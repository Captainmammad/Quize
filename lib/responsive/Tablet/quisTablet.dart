import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/../music_service.dart';

class TabletQuis extends StatefulWidget {
  const TabletQuis({super.key});

  @override
  State<TabletQuis> createState() => _TabletQuisState();
}

class _TabletQuisState extends State<TabletQuis>
    with SingleTickerProviderStateMixin {
  int index = 0;
  int rightAnswerCount = 0;
  int fallAnswerCount = 0;
  final int questionTime = 10;
  int? selectedOption;
  bool isAnswered = false;
  int streak = 0;
  bool isStarted = false;
  Color? buttonColor0;
  Color? textColor0;
  Color? buttonColor1;
  Color? textColor1;
  Color? buttonColor2;
  Color? textColor2;
  Color? buttonColor3;
  Color? textColor3;

  List<dynamic>? questionsCache;

  late AnimationController _shakeController;
  // ignore: unused_field
  late Animation<double> _offsetAnimation;

  late Box _myBox;
  double volume = 100;

  @override
  void initState() {
    super.initState();
    _myBox = Hive.box("myBox");
    volume = (_myBox.get("volume") ?? 100).toDouble();
    MusicService().setVolume(volume / 100);

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<double>(
      begin: 0.0,
      end: 16.0,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
  }

  Future<List<dynamic>> fetchData() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    List<dynamic> all = jsonDecode(jsonString)["result"];
    final random = Random();
    final selected = <dynamic>[];

    while (selected.length < 10 && selected.length < all.length) {
      int idx = random.nextInt(all.length);
      if (!selected.contains(all[idx])) {
        selected.add(all[idx]);
      }
    }
    return selected;
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void validate(int i, List<dynamic> questions) {
    if (isAnswered) return;
    setState(() {
      selectedOption = i;
      isAnswered = true;
    });

    final correctIndex = questions[index]['answerIndex'];
    if (correctIndex is int && correctIndex == i) {
      rightAnswerCount++;
      streak++;
    } else {
      fallAnswerCount++;
      streak = 0;
      _shakeController.forward(from: 0).whenComplete(() {
        _shakeController.reset();
      });
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      nextQuestion(questions);
    });
  }

  void nextQuestion(List<dynamic> questions) {
    if (index < questions.length - 1) {
      setState(() {
        index++;
        selectedOption = null;
        isAnswered = false;
      });
    } else {
      Navigator.pushNamed(
        context,
        "/result",
        arguments: {
          "right": rightAnswerCount,
          "fall": fallAnswerCount,
          "total": questions.length,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF35DBFF), Color(0xFF04C2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isStarted ? buildQuiz(questionsCache!) : buildStartScreen(),
      ),
    );
  }

  // ---------------- Header ----------------
  Widget buildHeader({List<dynamic>? questions}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/home"),
            child: Icon(
              Icons.home,
              color: Colors.white,
              size:
                  MediaQuery.of(context).size.width * 0 <
                      MediaQuery.of(context).size.height * 0
                  ? MediaQuery.of(context).size.width * 0.1
                  : MediaQuery.of(context).size.width * 0.1,
            ),
          ),
          if (isStarted && questions != null)
            TweenAnimationBuilder<double>(
              key: ValueKey(index),
              tween: Tween(begin: 1.0, end: 0.0),
              duration: Duration(seconds: questionTime),
              onEnd: () {
                if (!isAnswered && isStarted) {
                  setState(() {
                    fallAnswerCount++;
                    streak = 0;
                  });
                  nextQuestion(questions);
                }
              },
              builder: (context, value, child) {
                int secondsLeft = (value * questionTime).ceil();
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0 <
                              MediaQuery.of(context).size.height * 0
                          ? MediaQuery.of(context).size.width * 0.12
                          : MediaQuery.of(context).size.width * 0.12,
                      height:
                          MediaQuery.of(context).size.width * 0 <
                              MediaQuery.of(context).size.height * 0
                          ? MediaQuery.of(context).size.width * 0.12
                          : MediaQuery.of(context).size.width * 0.12,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 6,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                        backgroundColor: Colors.white24,
                      ),
                    ),
                    Text(
                      "$secondsLeft",
                      style: const TextStyle(
                        fontSize: 27,
                        fontFamily: "damavand",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            )
          else
            const SizedBox(width: 50, height: 50),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  double tempVolume = volume;
                  return StatefulBuilder(
                    builder: (context, setDialogState) {
                      return Dialog(
                        backgroundColor: const Color(0xFF04C2FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Volume",
                                    style: TextStyle(
                                      fontFamily: "damavand",
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      MusicService().setVolume(volume / 100);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      value: tempVolume,
                                      min: 0,
                                      max: 100,
                                      divisions: 100,
                                      activeColor: Colors.orange,
                                      inactiveColor: Colors.white24,
                                      onChanged: (value) {
                                        setDialogState(() {
                                          tempVolume = value;
                                        });
                                        MusicService().setVolume(
                                          tempVolume / 100,
                                        );
                                      },
                                    ),
                                  ),
                                  Text(
                                    "${tempVolume.toInt()}%",
                                    style: const TextStyle(
                                      fontFamily: "damavand",
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 24,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    volume = tempVolume;
                                  });
                                  _myBox.put("volume", tempVolume);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    fontFamily: "damavand",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Image.asset(
              "assets/number/setting.png",
              width:
                  MediaQuery.of(context).size.width * 0 <
                      MediaQuery.of(context).size.height * 0
                  ? MediaQuery.of(context).size.width * 0.1
                  : MediaQuery.of(context).size.width * 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Start Screen ----------------
  Widget buildStartScreen() {
    return Column(
      children: [
        buildHeader(),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width > 700
                    ? MediaQuery.of(context).size.height * 0
                    : MediaQuery.of(context).size.height * 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz,
                    size:
                        MediaQuery.of(context).size.width * 0 <
                            MediaQuery.of(context).size.height * 0
                        ? MediaQuery.of(context).size.width * 0.2
                        : MediaQuery.of(context).size.width * 0.2,
                    color: Colors.white,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                  Text(
                    "If you are ready,\npress the Start button",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width * 0 <
                              MediaQuery.of(context).size.height * 0
                          ? MediaQuery.of(context).size.width * 0.07
                          : MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                  Text(
                    "Get ready to test your knowledge!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width * 0 <
                              MediaQuery.of(context).size.height * 0
                          ? MediaQuery.of(context).size.width * 0.035
                          : MediaQuery.of(context).size.width * 0.035,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.04),

                  GestureDetector(
                    onTap: () async {
                      final data = await fetchData();
                      setState(() {
                        questionsCache = data;
                        isStarted = true;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30.0),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      // height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFC300), Color(0xFFFF9500)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Start",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- Quiz Screen ----------------
  Widget buildQuiz(List<dynamic> questions) {
    final height = MediaQuery.of(context).size.height;
    const scale = 1.0;
    return SafeArea(
      child: Column(
        children: [
          buildHeader(questions: questions),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Progress bar
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            final progress = (index + 1) / questions.length;
                            // double buttonWidth = width * 0.82;
                            // double buttonHeight = (height * 0.08 * scale).clamp(
                            //   48.0,
                            //   84.0,
                            // );

                            // final titleFontSize = (26.0 * scale).clamp(
                            //   16.0,
                            //   30.0,
                            // );
                            // final subtitleFontSize = (20.0 * scale).clamp(
                            //   12.0,
                            //   22.0,
                            // );
                            // final btnFontSize = (22.0 * scale).clamp(
                            //   14.0,
                            //   24.0,
                            // );
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: width * progress,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFC300),
                                    Color(0xFFFF9500),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          },
                        ),
                        Center(
                          child: Text(
                            "${index + 1} / ${questions.length}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0 <
                                      MediaQuery.of(context).size.height * 0
                                  ? MediaQuery.of(context).size.width * 0.01
                                  : MediaQuery.of(context).size.width * 0.01,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Score
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size:
                              MediaQuery.of(context).size.width * 0 <
                                  MediaQuery.of(context).size.height * 0
                              ? MediaQuery.of(context).size.width * 0.07
                              : MediaQuery.of(context).size.width * 0.07,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "$rightAnswerCount",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0 <
                                    MediaQuery.of(context).size.height * 0
                                ? MediaQuery.of(context).size.width * 0.06
                                : MediaQuery.of(context).size.width * 0.06,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 90),
                    Row(
                      children: [
                        Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size:
                              MediaQuery.of(context).size.width * 0 <
                                  MediaQuery.of(context).size.height * 0
                              ? MediaQuery.of(context).size.width * 0.07
                              : MediaQuery.of(context).size.width * 0.07,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "$fallAnswerCount",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0 <
                                    MediaQuery.of(context).size.height * 0
                                ? MediaQuery.of(context).size.width * 0.06
                                : MediaQuery.of(context).size.width * 0.06,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.05 * scale),
          // Question
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height:
                MediaQuery.of(context).size.width * 0 <
                    MediaQuery.of(context).size.height * 0
                ? MediaQuery.of(context).size.height * 0.15
                : MediaQuery.of(context).size.height * 0.15,
            child: Text(
              questions[index]['question'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize:
                    MediaQuery.of(context).size.width * 0 <
                        MediaQuery.of(context).size.height * 0
                    ? MediaQuery.of(context).size.width * 0.06
                    : MediaQuery.of(context).size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // SizedBox(height: height * 0.07 * scale),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // دکمه اول
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        int correctIndex = questions[index]['answerIndex'];

                        setState(() {
                          buttonColor0 = (correctIndex == 0)
                              ? Colors.green
                              : Colors.red;
                          textColor0 = Colors.white;
                        });

                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() {
                            buttonColor0 = Colors.white;
                            textColor0 = const Color.fromARGB(
                              255,
                              13,
                              170,
                              243,
                            );
                          });
                          if (correctIndex == 0) {
                            rightAnswerCount++;
                          } else {
                            fallAnswerCount++;
                          }
                          nextQuestion(questions);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor0 ?? Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        questions[index]['options'][0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width *
                              0.05, // سایز متن ریسپانسیو بر اساس عرض
                          color:
                              textColor0 ??
                              const Color.fromARGB(255, 13, 170, 243),
                          fontWeight: FontWeight.bold,
                          fontFamily: "damavand",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // دکمه دوم
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        int correctIndex = questions[index]['answerIndex'];

                        setState(() {
                          buttonColor1 = (correctIndex == 1)
                              ? Colors.green
                              : Colors.red;
                          textColor1 = Colors.white;
                        });

                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() {
                            buttonColor1 = Colors.white;
                            textColor1 = const Color.fromARGB(
                              255,
                              13,
                              170,
                              243,
                            );
                          });
                          if (correctIndex == 1) {
                            rightAnswerCount++;
                          } else {
                            fallAnswerCount++;
                          }
                          nextQuestion(questions);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor1 ?? Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        questions[index]['options'][1],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width *
                              0.05, // سایز متن ریسپانسیو بر اساس عرض
                          color:
                              textColor1 ??
                              const Color.fromARGB(255, 13, 170, 243),
                          fontWeight: FontWeight.bold,
                          fontFamily: "damavand",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01 * scale),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //دکمه سوم
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        int correctIndex = questions[index]['answerIndex'];

                        setState(() {
                          buttonColor2 = (correctIndex == 0)
                              ? Colors.green
                              : Colors.red;
                          textColor2 = Colors.white;
                        });

                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() {
                            buttonColor2 = Colors.white;
                            textColor2 = const Color.fromARGB(
                              255,
                              13,
                              170,
                              243,
                            );
                          });
                          if (correctIndex == 0) {
                            rightAnswerCount++;
                          } else {
                            fallAnswerCount++;
                          }
                          nextQuestion(questions);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor2 ?? Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        questions[index]['options'][2],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width *
                              0.05, // سایز متن ریسپانسیو بر اساس عرض
                          color:
                              textColor2 ??
                              const Color.fromARGB(255, 13, 170, 243),
                          fontWeight: FontWeight.bold,
                          fontFamily: "damavand",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // دکمه چهارم
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        int correctIndex = questions[index]['answerIndex'];

                        setState(() {
                          buttonColor3 = (correctIndex == 1)
                              ? Colors.green
                              : Colors.red;
                          textColor3 = Colors.white;
                        });

                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() {
                            buttonColor3 = Colors.white;
                            textColor3 = const Color.fromARGB(
                              255,
                              13,
                              170,
                              243,
                            );
                          });
                          if (correctIndex == 1) {
                            rightAnswerCount++;
                          } else {
                            fallAnswerCount++;
                          }
                          nextQuestion(questions);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor3 ?? Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        questions[index]['options'][3],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width *
                              0.05, // سایز متن ریسپانسیو بر اساس عرض
                          color:
                              textColor3 ??
                              const Color.fromARGB(255, 13, 170, 243),
                          fontWeight: FontWeight.bold,
                          fontFamily: "damavand",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: height * 0.08 * scale),
          // Skip button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  fallAnswerCount++;
                  streak = 0;
                });
                nextQuestion(questions);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFC300), Color(0xFFFF9500)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Skip Question",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
