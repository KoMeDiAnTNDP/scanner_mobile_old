import 'dart:async';

import 'package:scanner_mobile/src/shared/models/Errors.dart';
import 'package:scanner_mobile/src/shared/models/http/error_model.dart';

abstract class Bloc {
  bool _loading = false;
  static String _createTitleError(String methodName) => 'Error on $methodName';

  final StreamController<bool> _loadingController = StreamController<bool>.broadcast();
  final StreamController<ErrorModel> _serverErrorController = StreamController<ErrorModel>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;
  Stream<ErrorModel> get serverErrorStream => _serverErrorController.stream;

  void startLoading() {
    if (!_loading) {
      _loading = true;
      _loadingController.sink.add(_loading);
    }
  }

  void stopLoading() {
    if (_loading) {
      _loading = false;
      _loadingController.sink.add(false);
    }
  }

  void showError(String methodName, {String description = Errors.ERROR_SOMETHING_WENT_WRONG}) {
    stopLoading();
    _serverErrorController.sink.add(
      ErrorModel(
        title: _createTitleError(methodName),
        description: description
      )
    );
  }

  void closeError() {
    _serverErrorController.sink.add(null);
  }

  void dispose() {
    _loadingController.close();
    _serverErrorController.close();
  }
}