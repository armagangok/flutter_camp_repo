import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_listener/providers/user_data_provider.dart';

import '../../providers/internet_connection_provider.dart';
import '../../providers/state/user_data_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Internet Connection Listener"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(internetConnectionProvider);

          switch (state) {
            case ConnectionStatus.connected:
              final userDataState = ref.watch(userDataProvider);

              return userDataState.when(
                data: (state) {
                  switch (state.runtimeType) {
                    case UserDataSuccessState:
                      state as UserDataSuccessState;

                      return ListView.builder(
                        itemCount: state.value.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(state.value[index].username),
                            subtitle: Text(state.value[index].description),
                          );
                        },
                      );

                    default:
                      return const SizedBox.shrink();
                  }
                },
                error: (object, stacktrace) {
                  return Center(
                    child: CupertinoButton(
                      color: Theme.of(context).colorScheme.primary,
                      child: const Text("Try Again"),
                      onPressed: () {
                        ref.read(userDataProvider.notifier).reloadUserData();
                      },
                    ),
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
              );

            case ConnectionStatus.disconnected:
              return const Text("Please check your internet connection.");
            default:
              return const Center();
          }
        },
      ),
    );
  }
}
