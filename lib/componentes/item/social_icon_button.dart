part of pocket_church.componentes;

class SocialIconButton extends StatelessWidget {

  final IconData icon;
  final VoidCallback onPressed;
  final Color foregroundColor;
  final Color backgroundColor;

  const SocialIconButton({
    Key key,
    this.icon,
    this.onPressed,
    this.foregroundColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(minWidth: 26),
      fillColor: backgroundColor,
      child: Icon(icon,
        size: 22,
        color: foregroundColor,
      ),
      onPressed: onPressed,
    );
  }
}