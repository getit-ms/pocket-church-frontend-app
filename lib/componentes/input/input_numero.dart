part of pocket_church.componentes;

class InputNumero extends StatelessWidget {
  const InputNumero({
    Key key,
    this.validator,
    this.onSaved,
    this.inputFormatters,
    this.decoration,
  }) : super(key: key);

  final FormFieldValidator<double> validator;
  final ValueChanged<double> onSaved;
  final List<services.TextInputFormatter> inputFormatters;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return FormField<double>(
      validator: validator,
      onSaved: onSaved,
      builder: (field) {
        return TextField(
          keyboardType: TextInputType.number,
          inputFormatters: inputFormatters,
          onChanged: (value) {
            if (value?.isNotEmpty ?? false) {
              field.didChange(double.parse(value));
            } else {
              field.didChange(null);
            }
          },
          decoration: (decoration ?? InputDecoration()).copyWith(
            errorText: field.errorText,
          ),
        );
      },
    );
  }
}
