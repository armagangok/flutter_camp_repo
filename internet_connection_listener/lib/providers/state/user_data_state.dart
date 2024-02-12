import 'package:internet_connection_listener/models/user_data_model.dart';

abstract class IUserDataState {
  const IUserDataState._();
  factory IUserDataState.success(List<UserDataModel> value) = UserDataSuccessState;
  factory IUserDataState.error(String message) = UserDataErrorState;
  factory IUserDataState.initial(String message) = UserDataInitialState;
  factory IUserDataState.loadig(bool message) = UserDataLoadingState;
}

class UserDataInitialState extends IUserDataState {
  const UserDataInitialState(this.message) : super._();
  final String message;
}

class UserDataErrorState extends IUserDataState {
  const UserDataErrorState(this.msg) : super._();
  final String msg;
}

class UserDataSuccessState extends IUserDataState {
  const UserDataSuccessState(this.value) : super._();
  final List<UserDataModel> value;
}

class UserDataLoadingState extends IUserDataState {
  UserDataLoadingState(this.isLoading) : super._();
  bool isLoading;
}
