part of pocket_church.evento;


class ItemEvento extends StatelessWidget {
  final Widget label;
  final Widget value;

  const ItemEvento({
    Key key,
    this.label,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: Border(
        top: BorderSide(
          color: Colors.black54,
          width: .5,
        ),
        bottom: BorderSide(
          color: Colors.black54,
          width: .5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        title: Row(
          children: <Widget>[
            SizedBox(
              width: 120,
              child: label,
            ),
            Expanded(
              child: value,
            ),
          ],
        ),
      ),
    );
  }
}


