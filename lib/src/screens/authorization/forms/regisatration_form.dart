import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/screens/authorization/common/authorization_button.dart';
import 'package:scanner_mobile/src/screens/authorization/common/form_field.dart';
import 'package:scanner_mobile/src/shared/bloc/authorization/authorization_bloc.dart';
import 'package:scanner_mobile/src/shared/bloc/token/token_bloc.dart';

class RegistrationForm extends StatelessWidget {
  final AuthorizationBloc bloc;
  final TokenBloc tokenBloc;

  const RegistrationForm({
    Key key,
    @required this.bloc,
    @required this.tokenBloc
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: Form(
        child: ListView(
          children: <Widget>[
            AuthorizationField(
              icon: Icons.email,
              label: 'Email',
              currentFocus: bloc.emailFocus,
              onChanged: bloc.onEmailChange,
              formFieldStream: bloc.emailFieldModelStream,
              initialData: bloc.emailFieldModel,
              nextFocus: bloc.passwordFocus,
              isEmail: true,
            ),
            AuthorizationField(
              icon: Icons.lock,
              label: 'Password',
              isPassword: true,
              currentFocus: bloc.passwordFocus,
              onChanged: bloc.onPasswordChange,
              formFieldStream: bloc.passwordFieldModelStream,
              initialData: bloc.passwordFieldModel,
              nextFocus: bloc.usernameFocus
            ),
            AuthorizationField(
              icon: Icons.people,
              label: 'Username',
              currentFocus: bloc.usernameFocus,
              onChanged: bloc.onUsernameChange,
              formFieldStream: bloc.usernameFieldModelStream,
              initialData: bloc.usernameFieldModel
            ),
            AuthorizationButton(
              title: 'Create Account',
              validationFormStream: bloc.validationFormStream,
              onPressed: () => bloc.signUp(tokenBloc)
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: FlatButton(
                child: Text('Have an account! Sign in'),
                onPressed: bloc.changeScreen,
              )
            )
          ]
        )
      )
    );
  }
}