part of pocket_church.componentes;

class DownloadProgress extends StatelessWidget {

  final double progress;

  const DownloadProgress({this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.file_download,
              size: 50,
              color: Colors.black54,
            ),
            SizedBox(width: 10,),
            Column(
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    value: progress,
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Baixando: "),
                      Text(((progress * 100).toInt()).toString() + "%"),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }

}