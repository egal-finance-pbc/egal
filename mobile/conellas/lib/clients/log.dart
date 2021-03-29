import 'dart:developer' as dev;

class Logger {
  final String name;
  Logger({this.name});

  static const DebugLevel  = 100;
  static const InfoLevel = 200;
  static const WarnLevel = 300;
  static const ErrorLevel = 400;
  static const FatalLevel = 500;

  void debug(String message) {
    dev.log(message, level: DebugLevel , name: name);
  }

  void info(String message) {
    dev.log(message, level: InfoLevel, name: name);
  }

  void warn(String message) {
    dev.log(message, level: WarnLevel, name: name);
  }

  void error(String message) {
    dev.log(message, level: ErrorLevel, name: name);
  }

  void fatal(String message) {
    dev.log(message, level: FatalLevel, name: name);
  }
}
