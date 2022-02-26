part of pocket_church.inicio;

class BodyEventoInscricao extends StatelessWidget {
  final ItemEvento item;

  const BodyEventoInscricao({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return InkWell(
      onTap: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => evento.PageEvento(
            evento: Evento(
              id: int.parse(item.id),
              nome: item.titulo,
              tipo: "EVENTO",
              banner: item.ilustracao,
              dataHoraInicio: item.dataHoraReferencia,
              dataInicioInscricao: item.dataHoraPublicacao,
            ),
          ),
        );
      },
      child: Container(
        height: 250,
        child: Stack(
          children: [
            if (item.ilustracao != null)
              FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: ArquivoImageProvider(item.ilustracao.id),
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    item.ilustracao != null
                        ? Colors.transparent
                        : tema.secondary,
                    item.ilustracao != null ? Colors.black : tema.primary,
                  ],
                  begin: item.ilustracao != null
                      ? Alignment.topCenter
                      : Alignment.topLeft,
                  end: item.ilustracao != null
                      ? Alignment.bottomCenter
                      : Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              top: 10,
              bottom: 10,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 150,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            StringUtil.formatData(item.dataHoraReferencia,
                                pattern: "dd"),
                            style: TextStyle(
                              color: tema.primary,
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            StringUtil.formatData(item.dataHoraReferencia,
                                    pattern: "MMM")
                                .toUpperCase(),
                            style: TextStyle(
                              color: tema.primary,
                              fontSize: 22,
                            ),
                          ),
                          Divider(
                            color: tema.primary,
                          ),
                          Text(
                            StringUtil.formatData(item.dataHoraReferencia,
                                pattern: "HH:mm"),
                            style: TextStyle(
                              color: tema.primary,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.titulo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
