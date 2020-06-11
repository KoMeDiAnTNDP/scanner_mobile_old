import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/shared/bloc/base/bloc.dart';

class BlocProvider<TBloc extends Bloc> extends StatefulWidget {
  final TBloc bloc;
  final Widget child;

  const BlocProvider({
    Key key,
    @required this.bloc,
    @required this.child
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocProvider();
}

class _BlocProvider extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.bloc.loadingStream,
      initialData: false,
      builder: (context, snapshot) {
        bool isLoading = snapshot.data;
        Widget loadingContainer = isLoading ? _showLoadingOverlay() : Container(width: 0, height: 0);

        return Stack(
          children: <Widget>[
            widget.child,
            loadingContainer
          ],
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

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}