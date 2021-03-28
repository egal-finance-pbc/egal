import 'dart:developer' as dev;

class Logger {
  final String name;
  Logger({this.name});

  void debug(message) {
    dev.log(message, name: name);
  }

  void info(message) {
    dev.log(message, name: name);
  }

  void warn(message) {
    dev.log(message, name: name);
  }

  void error(message) {
    dev.log(message, name: name);
  }

  void fatal(message) {
    dev.log(message, name: name);
  }
}
