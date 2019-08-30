part of pocket_church.layout_tradicional;

class DivulgacaoInstitucional extends StatelessWidget {
  const DivulgacaoInstitucional();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Institucional>(
      stream: institucionalBloc.institucional,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: double.infinity,
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: MemoryImage(kTransparentImage),
              image: ArquivoImageProvider(snapshot.data.divulgacao.id),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Icon(Icons.broken_image),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
