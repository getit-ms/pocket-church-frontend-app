part of pocket_church.infra;

final icones = {
  'fa fa-plus-square': FontAwesomeIcons.solidPlusSquare,
  'fa fa-book': FontAwesomeIcons.book,
  'fa fa-users': FontAwesomeIcons.users,
  'fa fa-ellipsis-h': FontAwesomeIcons.ellipsisH,
  'fa fa-cog': FontAwesomeIcons.cog,
  'fa fa-home': FontAwesomeIcons.home
};

class IconUtil {
  static IconData fromString(String iconName) {
    return icones[iconName];
  }
}