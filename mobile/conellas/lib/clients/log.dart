import 'dart:developer' as dev;

class Logger {
  void debug(message) {
    dev.log('This is a error', name: '$debug');
  }

  void info(message) {
    dev.log('This is a error', name: '$info');
  }

  void warn(message) {
    dev.log('This is a error', name: '$warn');
  }

  void error(message) {
    dev.log('This is a error', name: '$error');
  }

  void fatal(message) {
    dev.log('This is a error', name: '$fatal');
  }
}
