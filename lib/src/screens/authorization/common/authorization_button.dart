import 'package:flutter/material.dart';

class AuthorizationButton extends StatelessWidget {
  final String title;
  final Stream<bool> validationFormStream;
  final VoidCallback onPressed;

  const AuthorizationButton({
    Key key,
    @required this.title,
    @required this.validationFormStream,
    @required this.onPressed
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: validationFormStream,
      initialData: false,
      builder: (context, snapshot) {
        bool isFormValid = snapshot.data;

        return Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)
            ),
            color: Colors.lightBlueAccent,
            disabledColor: Colors.grey.withOpacity(.5),
            child: Text(title, style: TextStyle(color: Colors.white)),
            onPressed: isFormValid ? () {
              FocusScope.of(context).requestFocus(FocusNode());
              onPressed();
            }: null
          )
        );
      }
    );
  }

}