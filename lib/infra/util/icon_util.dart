part of pocket_church.infra;

final icones = {
  'fa fa-plus-square': FontAwesomeIcons.solidPlusSquare,
  'fa fa-book': FontAwesomeIcons.book,
  'fa fa-users': FontAwesomeIcons.users,
  'fa fa-ellipsis-h': FontAwesomeIcons.ellipsisH,
  'fa fa-cog': FontAwesomeIcons.cog,
  'fa fa-home': FontAwesomeIcons.home,
  'fa fa-bullhorn': FontAwesomeIcons.bullhorn,
  'fa fa-check-square': FontAwesomeIcons.solidCheckSquare,
  'fa fa-calendar-o': FontAwesomeIcons.calendar,
  'fa fa-envelope': FontAwesomeIcons.envelope,
  'fa fa-bell': FontAwesomeIcons.bell,
  'fa fa-cube': FontAwesomeIcons.cube,
  'fa fa-cog': FontAwesomeIcons.cog,
  'fa fa-newspaper-o': FontAwesomeIcons.newspaper,
  'fa fa-image': FontAwesomeIcons.image,
  'fa fa-user': FontAwesomeIcons.user,
  'fa fa-birthday-cake': FontAwesomeIcons.birthdayCake,
  'fa fa-headphones': FontAwesomeIcons.headphones,
  'fa fa-youtube-play': FontAwesomeIcons.youtubeSquare,
  'fa fa-images': FontAwesomeIcons.images,
  'fa fa-calendar': FontAwesomeIcons.calendarAlt,
  'fa fa-calendar-day': FontAwesomeIcons.calendarDay,
};

class IconUtil {
  static IconData fromString(String iconName) {
    return icones[iconName];
  }
}
