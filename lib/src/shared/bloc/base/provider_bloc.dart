import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/shared/bloc/base/bloc.dart';
import 'package:scanner_mobile/src/shared/models/http/error_model.dart';

class BlocProvider<TBloc extends Bloc> extends StatefulWidget {
  final TBloc bloc;
  final Widget child;

  const BlocProvider({
    Key key,
    @required this.bloc,
    @required this.child
  }) : super(key: key);

  static T of<T extends Bloc>(BuildContext context) {
    final BlocProvider<T> provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();

    return provider.bloc;
  }

  static Widget createLoadingContainer() {
    return Container(
      child: Center(
        child: CircularProgressIndicator()
      )
    );
  }

  @override
  State<StatefulWidget> createState() => _BlocProvider();
}

class _BlocProvider extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.bloc.loadingStream,
      initialData: false,
      builder: (context, snapshotLoading) {
        bool isLoading = snapshotLoading.data;
        Widget loadingContainer = isLoading ? _showLoadingOverlay() : Container(width: 0, height: 0);

        return StreamBuilder<ErrorModel>(
          stream: widget.bloc.serverErrorStream,
          builder: (context, snapshotError) {
            ErrorModel errorModel = snapshotError.data;

            if (errorModel != null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _createAlertDialog(errorModel);
                  }
                );
              });
            }

            return Stack(
              children: [
                widget.child,
                loadingContainer
              ]
            );
          }
        );
      }
    );
  }

  Widget _showLoadingOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(.5),
      child: Center(
        child: CircularProgressIndicator()
      )
    );
  }

  Widget _createAlertDialog(ErrorModel errorModel) => AlertDialog(
    title: Text(errorModel.title),
    content: Text(errorModel.description),
    actions: _createActions(),
  );

  List<Widget> _createActions() => [
    FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.pop(context);
        widget.bloc.closeError();
      }
    )
  ];

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}