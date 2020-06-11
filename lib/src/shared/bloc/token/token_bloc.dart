import 'dart:async';

import 'package:scanner_mobile/src/shared/bloc/base/bloc.dart';

class TokenBloc extends Bloc {
  final StreamController<String> _tokenController = StreamController<String>();

  Stream<String> get tokenStream => _tokenController.stream;

  void setToken(String token) {
    _tokenController.sink.add(token);
  }

  @override
  void dispose() {
    super.dispose();

    _tokenController.close();
  }
}