import 'dart:async';
import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/shared/bloc/base/bloc.dart';
import 'package:scanner_mobile/src/shared/bloc/token/token_bloc.dart';
import 'package:scanner_mobile/src/shared/models/form_field/form_field_model.dart';
import 'package:scanner_mobile/src/shared/models/http/response.dart';
import 'package:scanner_mobile/src/shared/models/http/token_response.dart';
import 'package:scanner_mobile/src/shared/service/authorization/authorization_service.dart';
import 'package:scanner_mobile/src/shared/service/validation/validation_service.dart';

class AuthorizationBloc extends Bloc {
  final FormFieldModel emailFieldModel = FormFieldModel();
  final FormFieldModel passwordFieldModel = FormFieldModel();
  final FormFieldModel usernameFieldModel = FormFieldModel();

  final StreamController<bool> _screenModeController = StreamController<bool>.broadcast();
  final StreamController<FormFieldModel> _emailFieldModelController = StreamController<FormFieldModel>.broadcast();
  final StreamController<FormFieldModel> _passwordFieldModelController = StreamController<FormFieldModel>.broadcast();
  final StreamController<FormFieldModel> _usernameFieldModelController = StreamController<FormFieldModel>.broadcast();
  final StreamController<bool> _validationFormController = StreamController<bool>.broadcast();

  Stream<bool> get screenModeStream => _screenModeController.stream;
  Stream<FormFieldModel> get emailFieldModelStream => _emailFieldModelController.stream;
  Stream<FormFieldModel> get passwordFieldModelStream => _passwordFieldModelController.stream;
  Stream<FormFieldModel> get usernameFieldModelStream => _usernameFieldModelController.stream;
  Stream<bool> get validationFormStream => _validationFormController.stream;

  final AuthorizationService _authorizationService = AuthorizationService();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode usernameFocus = FocusNode();

  bool _isRegistration = true;

  void onEmailChange(String email) {
    emailFieldModel.value = email;
    emailFieldModel.errorText = ValidationService.validateEmail(emailFieldModel.value);
    emailFieldModel.isValid = emailFieldModel.errorText == null;

    _emailFieldModelController.sink.add(emailFieldModel);
    _setValidForm(_isRegistration);
  }

  void onPasswordChange(String password) {
    passwordFieldModel.value = password;
    passwordFieldModel.errorText = ValidationService.validatePassword(passwordFieldModel.value);
    passwordFieldModel.isValid = passwordFieldModel.errorText == null;

    _passwordFieldModelController.sink.add(passwordFieldModel);
    _setValidForm(_isRegistration);
  }

  void onUsernameChange(String username) {
    usernameFieldModel.value = username;
    usernameFieldModel.errorText = ValidationService.validateUsername(usernameFieldModel.value);
    usernameFieldModel.isValid = usernameFieldModel.errorText == null;

    _usernameFieldModelController.sink.add(usernameFieldModel);
    _setValidForm(_isRegistration);
  }

  void _setValidForm(bool isRegistration) {
    bool validForm;

    if (isRegistration) {
      validForm = emailFieldModel.isValid && passwordFieldModel.isValid && usernameFieldModel.isValid;
    }
    else {
      validForm = emailFieldModel.isValid && passwordFieldModel.isValid;
    }

    _validationFormController.sink.add(validForm);
  }

  void changeScreen() {
    _isRegistration = !_isRegistration;

    _screenModeController.sink.add(_isRegistration);
  }

  void _setToken(TokenBloc tokenBloc, String token) {
    tokenBloc.setToken(token);
  }

  void signIn(TokenBloc tokenBloc) async {
    startLoading();
    ResponseWithError<TokenResponse> tokenResponse = await _authorizationService.signIn(
      emailFieldModel.value,
      passwordFieldModel.value
    );

    if (tokenResponse.errorMessage != null) {
      showError('Sign In', description: tokenResponse.errorMessage);
      stopLoading();

      return;
    }

    _setToken(tokenBloc, tokenResponse.response.token);
    stopLoading();
  }

  void signUp(TokenBloc tokenBloc) async {
    startLoading();
    ResponseWithError<TokenResponse> tokenResponse = await _authorizationService.signUp(
      emailFieldModel.value,
      passwordFieldModel.value,
      usernameFieldModel.value
    );

    if (tokenResponse.errorMessage != null) {
      showError('Sign Up', description: tokenResponse.errorMessage);

      return;
    }

    _setToken(tokenBloc, tokenResponse.response.token);
    stopLoading();
  }

  @override
  void dispose() {
    super.dispose();

    _screenModeController.close();
    _emailFieldModelController.close();
    _passwordFieldModelController.close();
    _usernameFieldModelController.close();
    _validationFormController.close();
  }
}