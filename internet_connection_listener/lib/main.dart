import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'page/home/home_page.dart';
import 'providers/internet_connection_provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print(context);
    return Consumer(
      builder: (context, ref, child) {
        ref.listen(
          internetConnectionProvider,
          (previous, next) {
            switch (next) {
              case ConnectionStatus.disconnected:
                ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                  const SnackBar(
                    content: Text("Please check your internet connection!"),
                  ),
                );
              case ConnectionStatus.connected:
                ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                  const SnackBar(
                    content: Text("Connected to the internet successfuly!"),
                  ),
                );

                break;
              default:
            }
          },
        );
        return MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData.dark(
            useMaterial3: true,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
