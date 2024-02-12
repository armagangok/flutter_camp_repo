import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final internetConnectionProvider = NotifierProvider<InternetConnectionNotifier, ConnectionStatus>(() => InternetConnectionNotifier.shared);

enum ConnectionStatus { notDetermined, connected, disconnected }

class InternetConnectionNotifier extends Notifier<ConnectionStatus> {
  InternetConnectionNotifier._();
  static final shared = InternetConnectionNotifier._();

  late final InternetConnectionChecker _internetConnectionChecker;
  InternetConnectionChecker get internetConnectionChecker => _internetConnectionChecker;

  late final StreamSubscription<InternetConnectionStatus> _listener;

  ConnectionStatus currentStatus = ConnectionStatus.notDetermined;

  @override
  ConnectionStatus build() {
    _initialize();

    Future(() async {
      final hasConnection = await _internetConnectionChecker.hasConnection;

      if (hasConnection) {
        currentStatus = ConnectionStatus.connected;
      }
    });

    _listenConnectivity();
    return currentStatus;
  }

  void _initialize() {
    _internetConnectionChecker = InternetConnectionChecker.createInstance(
      // The timeout period before a check request is dropped and an address is considered unreachable.
      // Defaults to [DEFAULT_TIMEOUT] (10 seconds).
      checkTimeout: const Duration(seconds: 1),

      // The interval between periodic checks. Periodic checks are only made if there's an attached listener to [onStatusChange].
      // If that's the case [onStatusChange] emits an update only if there's change from the previous status.
      // Defaults to [DEFAULT_INTERVAL] (10 seconds).
      checkInterval: const Duration(seconds: 1),
    );
  }

  void _listenConnectivity() {
    _listener = internetConnectionChecker.onStatusChange.listen((status) {
      log("Connection is being listened: $status");
      switch (status) {
        case InternetConnectionStatus.connected:
          state = ConnectionStatus.connected;

          break;
        case InternetConnectionStatus.disconnected:
          state = ConnectionStatus.disconnected;

          break;
        default:
          state = ConnectionStatus.notDetermined;
      }
    });
  }

  void pauseListener() {
    log("Pausing Connection Listener");
    _listener.pause();
  }

  void onErrorWhileListening() {
    _listener.onError((error) {
      log("Error While Listening: $error");
    });
  }

  void resumeListener() {
    log("Resuming Connection Listener");
    _listener.resume();
  }

  static Future<bool> checkConnection() async {
    InternetConnectionChecker customInstance = InternetConnectionChecker.createInstance(checkTimeout: const Duration(seconds: 3), checkInterval: const Duration(seconds: 3));
    bool res = await customInstance.hasConnection;
    return res;
  }
}
