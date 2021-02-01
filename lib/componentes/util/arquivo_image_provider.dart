part of pocket_church.componentes;

class ArquivoImageProvider extends ImageProvider<ArquivoImageProvider> {

  final int arquivo;
  final double scale;

  const ArquivoImageProvider(this.arquivo, { this.scale = 1.0 }):
        assert(arquivo != null),
        assert(scale != null);

  @override
  ImageStreamCompleter load(ArquivoImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: key.scale,
        informationCollector: () {
          return [DiagnosticsNode.message('Arquivo: $arquivo')];
        }
    );
  }

  @override
  Future<ArquivoImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ArquivoImageProvider>(this);
  }

  Future<Codec> _loadAsync(ArquivoImageProvider key) async {
    assert(key == this);

    var file = await arquivoService.getFile(arquivo);

    final Uint8List bytes = await file.readAsBytes();
    if (bytes.lengthInBytes == 0)
      return null;

    return await PaintingBinding.instance.instantiateImageCodec(bytes);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType)
      return false;
    final ArquivoImageProvider typedOther = other;
    return arquivo == typedOther.arquivo
        && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(arquivo, scale);

  @override
  String toString() => '$runtimeType("$arquivo", scale: $scale)';
}
