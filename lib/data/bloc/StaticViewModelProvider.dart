import 'dart:async';

import 'package:farmsmart_flutter/data/bloc/ViewModelProvider.dart';

class StaticViewModelProvider<T> implements ViewModelProvider<T> {

  final T _viewModel;
  final StreamController _controller = StreamController<T>();

  StaticViewModelProvider(T viewModel) : _viewModel = viewModel;

  @override
  T initial() {
    return _viewModel;
  }

  @override
  StreamController<T> observe() {
    return _controller;
  }

  @override
  T snapshot() {
    return _viewModel;
  }

  void dispose() {
    _controller.sink.close();
    _controller.close();
  }

}