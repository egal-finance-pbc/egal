import 'dart:developer' as dev;

class Logger {
  final String name;
  Logger({this.name});

  static const DEBUG = 100;
  static const INFO = 200;
  static const WARN = 300;
  static const ERROR = 400;
  static const FATAL = 500;

  void debug(String message) {
    dev.log(message, level: DEBUG, name: name);
  }

  void info(String message) {
    dev.log(message, level: INFO, name: name);
  }

  void warn(String message) {
    dev.log(message, level: WARN, name: name);
  }

  void error(String message) {
    dev.log(message, level: ERROR, name: name);
  }

  void fatal(String message) {
    dev.log(message, level: FATAL, name: name);
  }
}
