import 'package:flutter_lorem/flutter_lorem.dart';

import '../models/user_data_model.dart';

class UserDataService {
  static UserDataService? _shared;
  UserDataService._();

  static UserDataService? get shared {
    _shared ??= UserDataService._();
    _shared = UserDataService._();
    return _shared;
  }

  Future<List<UserDataModel>> reuqestUserData() async {
    await Future.delayed(const Duration(seconds: 2));

    return List.generate(
      5,
      (index) => UserDataModel(
        userId: DateTime.now().millisecond.toString(),
        username: lorem(
          paragraphs: 1,
          words: 1,
        ),
        description: lorem(
          paragraphs: 1,
          words: 25,
        ),
      ),
    );
  }
}

