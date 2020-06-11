import 'dart:async';

abstract class Bloc {
  final StreamController<bool> _loadingController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;

  void startLoading() {
    _loadingController.sink.add(true);
  }

  void stopLoading() {
    _loadingController.sink.add(false);
  }

  void dispose() {
    _loadingController.close();
  }
}