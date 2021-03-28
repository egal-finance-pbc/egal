import 'dart:developer' as dev;

class Logger {
  final String name;
  Logger({this.name});

  void debug(String message) {
    dev.log(message, level: 100, name: name);
  }

  void info(String message) {
    dev.log(message, level: 200, name: name);
  }

  void warn(String message) {
    dev.log(message, level: 300, name: name);
  }

  void error(String message) {
    dev.log(message, level: 400, name: name);
  }

  void fatal(String message) {
    dev.log(message, level: 500, name: name);
  }
}
