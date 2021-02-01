part of pocket_church.componentes;

class ListaPaginasPDF extends StatelessWidget {
  final String titulo;
  final Arquivo arquivo;

  const ListaPaginasPDF({@required this.titulo, @required this.arquivo});

  @override
  Widget build(BuildContext context) {
    return PDFViewerBuilder(
      arquivo: arquivo,
      builder: (context, snapshot) {
        if (snapshot.status == PDFRenderingStatus.waiting) {
          return _waiting();
        } else if (snapshot.status == PDFRenderingStatus.downloading) {
          return _downloading(snapshot.statusProgress);
        } else if (snapshot.status == PDFRenderingStatus.error) {
          return _error(context, snapshot.error);
        } else {
          return _rendering(snapshot.pdf);
        }
      },
    );
  }

  Widget _rendering(ArquivoPDF arquivoPDF) {
    return GridView.builder(
        itemCount: arquivoPDF.paginas.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio:
                arquivoPDF.paginas[0].width / arquivoPDF.paginas[0].height),
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.black54,
                  )
                ],
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  child: _pagina(index, arquivoPDF),
                  onTap: () {
                    NavigatorUtil.navigate(context,
                        builder: (context) => GaleriaPDF(
                              titulo: titulo,
                              arquivo: arquivo,
                              initialPage: index + 1,
                            ));
                  },
                ),
              ));
        });
  }

  Widget _pagina(int index, ArquivoPDF arquivoPDF) {
    var file = arquivoPDF.paginas[index].file;

    if (file == null) {
      return Container(
        child: Center(
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.black38),
          ),
        ),
      );
    }

    return Hero(
        tag: 'pagina_' + (index + 1).toString(),
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: FileImage(file, scale: .5),
          fit: BoxFit.contain,
        ));
  }

  Widget _error(BuildContext context, dynamic ex) {
    return Container(
      padding: const EdgeInsets.all(50),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            error.resolveIcon(ex),
            color: Colors.black38,
            size: 66,
          ),
          const SizedBox(
            height: 10,
          ),
          DefaultTextStyle(
            child: error.resolveMessage(ex),
            style: const TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget _downloading(double progress) {
    return DownloadProgress(progress: progress);
  }

  Widget _waiting() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
