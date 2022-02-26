part of pocket_church.componentes;

class BottomMenuItem {
  IconData icon;
  Widget label;
  VoidCallback action;

  BottomMenuItem({this.icon, this.label, this.action});
}

class BottomMenu extends StatelessWidget {
  final double height;
  final List<BottomMenuItem> items;

  const BottomMenu({this.height, this.items});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return BottomSheet(
      onClosing: () {
        Navigator.of(context).pop();
      },
      builder: (context) {
        return Container(
          height: height ??
              (mediaQueryData.size.height - 200 + mediaQueryData.padding.top),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var menu in items)
                  _optionSelectFile(context, menu),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _optionSelectFile(BuildContext context, BottomMenuItem menu) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        onPressed: menu.action,
        child: Row(
          children: <Widget>[
            menu.icon != null ? Icon(menu.icon) : Container(),
            menu.icon != null
                ? const SizedBox(
                    width: 10,
                  )
                : Container(),
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                child: menu.label,
              ),
            )
          ],
        ),
      ),
    );
  }
}
