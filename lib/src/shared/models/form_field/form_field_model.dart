class FormFieldModel {
  String value;
  String errorText;
  bool isValid;

  FormFieldModel({
    this.value,
    this.errorText,
    this.isValid = false
  });
}