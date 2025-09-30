class AppTranslations {
  static final Map<String, Map<String, String>> _values = {
    "fa": {
      "start": "شروع",
      "skip": "رد کردن سوال",
      "ready": "اگه آماده‌ای\nدکمه شروع رو بزن 😉",
      "sub_ready": "آماده‌ای خودت رو محک بزنی؟",
      "volume": "تنظیمات",
      "save": "ذخیره",
      // 🔹 کلیدهای جدید برای صفحه نتیجه
      "you_win": "آفرین! بردی 🎉",
      "you_lose": "باختی 😢",
      "correct": "درست",
      "wrong": "غلط",
      "play_again": "بازی دوباره",
      "home": "خانه",

      // 🔹 کلیدهای جدید برای صفحه Home
      "title": "در چالش روزانه ما شرکت کنید و برنده شوید",
      "subtitle": "یک هدیه ویژه برای تو",
      "play": "شروع بازی",
      "how_to_play": "چطور بازی کنیم",
      "enjoy": "از بازی لذت ببر",
    },
    "en": {
      "start": "Start",
      "skip": "Skip Question",
      "ready": "If you are ready,\npress the Start button",
      "sub_ready": "Get ready to test your knowledge!",
      "volume": "Settings",
      "save": "Save",
      // 🔹 کلیدهای جدید برای صفحه نتیجه
      "you_win": "You won 🎉",
      "you_lose": "You lost 😢 ",
      "correct": "Correct",
      "wrong": "Wrong",
      "play_again": "Play again",
      "home": "Home",

      // 🔹 کلیدهای جدید برای صفحه Home
      "title": "Join our daily challenge and win",
      "subtitle": "Special gift just for you",
      "play": "Play",
      "how_to_play": "How to play",
      "enjoy": "Enjoy the game",
    },
  };

  static String of(String key, String locale) {
    return _values[locale]?[key] ?? key;
  }
}
