import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/screens/authorization/authorization_screen.dart';
import 'package:scanner_mobile/src/screens/home/home_screen.dart';
import 'package:scanner_mobile/src/shared/bloc/base/provider_bloc.dart';
import 'package:scanner_mobile/src/shared/bloc/token/token_bloc.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TokenBloc bloc = TokenBloc();
    return BlocProvider<TokenBloc>(
      bloc: bloc,
      child: StreamBuilder<String>(
        stream: bloc.tokenStream,
        builder: (context, snapshot) {
          String token = snapshot.data;

          if (token == null) {
            return AuthorizationScreen(tokenBloc: bloc);
          }

          return HomeScreen(token: token, tokenBloc: bloc);
        }
      )
    );
  }
}