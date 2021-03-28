import 'dart:developer' as dev;

class Logger {
  void debug(message) {
    dev.log('Debug message', name: message);
  }

  void info(message) {
    dev.log('Info message', name: message);
  }

  void warn(message) {
    dev.log('Warn message', name: message);
  }

  void error(message) {
    dev.log('Error message', name: message);
  }

  void fatal(message) {
    dev.log('Fatal message', name: message);
  }
}
