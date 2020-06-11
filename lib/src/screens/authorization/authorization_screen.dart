import 'package:flutter/material.dart';
import 'package:scanner_mobile/src/screens/authorization/forms/login_form.dart';
import 'package:scanner_mobile/src/screens/authorization/forms/regisatration_form.dart';
import 'package:scanner_mobile/src/shared/bloc/authorization/authorization_bloc.dart';
import 'package:scanner_mobile/src/shared/bloc/base/provider_bloc.dart';
import 'package:scanner_mobile/src/shared/bloc/token/token_bloc.dart';

class AuthorizationScreen extends StatelessWidget {
  final TokenBloc tokenBloc;

  const AuthorizationScreen({
    Key key,
    @required this.tokenBloc
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthorizationBloc bloc = AuthorizationBloc();

    return BlocProvider<AuthorizationBloc>(
      bloc: bloc,
      child: StreamBuilder<bool>(
        stream: bloc.screenModeStream,
        initialData: true,
        builder: (context, snapshot) {
          final bool isRegistration = snapshot.data;
          AppBar appBar = AppBar(
            title: Text(isRegistration ? 'Create Account' : 'Sign In'),
            centerTitle: true
          );
          Widget body = isRegistration ?
            RegistrationForm(bloc: bloc, tokenBloc: tokenBloc) :
            LoginForm(bloc: bloc, tokenBloc: tokenBloc);

          return Scaffold(
            appBar: appBar,
            body: body
          );
        }
      )
    );
  }

}