import 'dart:developer' as dev;

class Logger {
  void debug(String message) {
    dev.log('This is a error', name: message);
  }

  void info(String message) {
    dev.log('This is a error', name: message);
  }

  void warn(String message) {
    dev.log('This is a error', name: message);
  }

  void error(String message) {
    dev.log('This is a error', name: message);
  }

  void fatal(String message) {
    dev.log('This is a error', name: message);
  }
}
