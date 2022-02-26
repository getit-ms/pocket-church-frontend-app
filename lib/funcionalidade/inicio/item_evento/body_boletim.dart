part of pocket_church.inicio;

class BodyBoletim extends StatelessWidget {
  final ItemEvento item;

  const BodyBoletim({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return InkWell(
      onTap: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageBoletim(
            boletim: Boletim(
              id: int.parse(item.id),
              titulo: item.titulo,
              data: item.dataHoraReferencia,
              thumbnail: item.ilustracao,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          right: 10,
          left: 10,
          top: 10,
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width / 2.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    image: item.ilustracao != null
                        ? ArquivoImageProvider(item.ilustracao.id)
                        : tema.homeLogo,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  Text(
                    item.titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tema.primary,
                      fontSize: 25,
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
