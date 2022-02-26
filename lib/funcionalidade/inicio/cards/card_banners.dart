part of pocket_church.inicio;

class CardBanners extends StatelessWidget {
  const CardBanners({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<banner.Banner>>(
      stream: institucionalBloc.banners,
      initialData: institucionalBloc.currentBanners,
      builder: (context, snapshot) {
        return TimelineCard(
          height: MediaQuery.of(context).size.width / 2,
          builder: _buildBanner,
          items: snapshot.data ?? [null, null, null],
        );
      },
    );
  }

  Widget _buildBanner(BuildContext context, banner.Banner banner) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        image: DecorationImage(
          image: banner != null
              ? ArquivoImageProvider(banner.banner.id)
              : MemoryImage(kTransparentImage),
          fit: BoxFit.cover,
          scale: 2,
        ),
      ),
      child: BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 7.7, sigmaY: 7.5),
        child: banner == null
            ? Container()
            : FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: ArquivoImageProvider(banner.banner.id),
                width: double.infinity,
                fit: BoxFit.fitHeight,
              ),
      ),
    );
  }
}
