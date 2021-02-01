part of pocket_church.componentes;


class IntlBuilder extends StatelessWidget {

  final String text;
  final AsyncWidgetBuilder<String> builder;

  const IntlBuilder({this.text, this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Bundle>(
      stream: configuracaoBloc.bundle,
      builder: (context, bundle) {

        return builder(context,
            bundle.hasData ?
            new AsyncSnapshot.withData(bundle.connectionState, bundle.data[text]) :
            bundle.hasData ?
            new AsyncSnapshot.withError(bundle.connectionState, bundle.error) :
            new AsyncSnapshot.nothing()
        );
      },
    );
  }

}

