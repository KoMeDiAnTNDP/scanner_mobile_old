import 'package:flutter/material.dart';

import 'package:scanner_mobile/src/shared/models/form_field/form_field_model.dart';

class AuthorizationField extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isEmail;
  final bool isPassword;
  final FocusNode currentFocus;
  final FocusNode nextFocus;
  final Function(String) onChanged;
  final Stream<FormFieldModel> formFieldStream;
  final FormFieldModel initialData;

  const AuthorizationField({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.currentFocus,
    @required this.onChanged,
    @required this.formFieldStream,
    @required this.initialData,
    this.isEmail = false,
    this.isPassword = false,
    this.nextFocus
  }) : super(key: key);

  void _changeFocus(String value, BuildContext context) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _focusDone(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FormFieldModel>(
      stream: formFieldStream,
      initialData: initialData,
      builder: (context, snapshot) {
        FormFieldModel formFieldModel = snapshot.data;

        return TextFormField(
          decoration: InputDecoration(
            icon: Icon(icon),
            labelText: label,
            errorText: formFieldModel.errorText,
            focusColor: Colors.white30
          ),
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.visiblePassword,
          maxLines: 1,
          onChanged: onChanged,
          focusNode: currentFocus,
          obscureText: isPassword,
          textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: nextFocus != null ? (value) => _changeFocus(value, context) : (value) => _focusDone(context)
        );
      }
    );
  }
}