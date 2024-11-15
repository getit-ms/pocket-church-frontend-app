part of pocket_church.componentes;

class ImageView {
  ImageProvider image;
  String heroTag;

  ImageView({@required this.image, this.heroTag});
}

class PhotoViewPage extends StatelessWidget {
  final Widget title;
  final List<ImageView> images;
  final PageController pageController;
  final Function(int) onDownload;
  final Function(int) onShare;

  PhotoViewPage({
    this.title,
    this.onDownload,
    this.onShare,
    this.pageController,
    @required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PhotoViewGallery(
          pageController: pageController,
          pageOptions: images
              .map(
                (img) => PhotoViewGalleryPageOptions(
                  imageProvider: img.image,
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: img.heroTag,
                  ),
                ),
              )
              .toList(),
          gaplessPlayback: true,
          backgroundDecoration: BoxDecoration(color: Colors.black87),
        ),
        Column(
          children: <Widget>[
            AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: title,
              titleTextStyle: const TextStyle(
                color: Colors.white,
              ),
              systemOverlayStyle: services.SystemUiOverlayStyle.dark,
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                onDownload != null
                    ? IconButton(
                        icon: Icon(Icons.cloud_download),
                        onPressed: () =>
                            onDownload(pageController?.page?.round()),
                      )
                    : Container(),
                onShare != null
                    ? IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () => onShare(pageController?.page?.round()),
                      )
                    : Container(),
              ],
            )
          ],
        )
      ],
    );
  }
}
