import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_listener/services/user_data_service.dart';

import 'state/user_data_state.dart';

final userDataProvider = AsyncNotifierProvider<UserDataNotifier, IUserDataState>(UserDataNotifier.new);

class UserDataNotifier extends AsyncNotifier<IUserDataState> {
  final UserDataService userDataService = UserDataService.shared!;
  @override
  FutureOr<IUserDataState> build() async {
    return _loadUserData();
  }

  Future<IUserDataState> _loadUserData() async {
    final response = await userDataService.reuqestUserData();
    return IUserDataState.success(response);
  }

  Future<void> reloadUserData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadUserData());
  }
}
