part of pocket_church.componentes;

class IntlText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final Map<String, dynamic> args;

  const IntlText(
    this.text, {
    this.textAlign,
    this.style,
    this.args,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Bundle>(
      stream: configuracaoBloc.bundle,
      builder: (context, bundle) {
        return Text(
          bundle.hasData
              ? bundle.data.get(
                  text,
                  args: args,
                )
              : "",
          textAlign: textAlign ?? DefaultTextStyle.of(context)?.textAlign ?? TextAlign.left,
          style: style,
        );
      },
    );
  }
}
