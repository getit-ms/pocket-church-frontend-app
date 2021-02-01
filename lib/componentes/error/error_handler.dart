part of pocket_church.componentes;

class ErrorHandler {
  handle(ScaffoldState scaffoldState, dynamic ex) {
    if (ex is ApiException) {
      switch (ex.response.statusCode) {
        case 401:
        case 403:
          acessoBloc.logout();
          break;
        case 400:
          handleBadRequest(scaffoldState, ex.data);
          break;
        case 500:
        default:
          handleGenericError(scaffoldState, ex.data);
          break;
      }
    } else {
      handleGenericError(scaffoldState, null);
    }
  }

  IconData resolveIcon(dynamic ex) {
    if (ex is ApiException) {
      switch (ex.response.statusCode) {
        case 302:
          return Icons.signal_wifi_off;
        case 404:
          return Icons.cloud_off;
      }
    }

    return Icons.error;
  }

  Widget resolveMessage(dynamic ex) {
    if (ex is ApiException) {
      switch (ex.response.statusCode) {
        case 400:
          if (ex.data['message'] != null) {
            return IntlText(
              ex.data['message'],
            );
          }
          break;
        case 500:
        default:
          return IntlText(
            'mensagens.MSG-500',
            args: {
              'mensagem': ex.data != null && ex.data['message'] != null
                  ? ex.data['message']
                  : "Erro Interno"
            },
          );
      }
    } else if (ex is SocketException) {
      return IntlText('mensagens.MSG-404');
    }

    return IntlText(
      'mensagens.MSG-500',
      args: {'mensagem': "Erro Interno"},
    );
  }

  handleBadRequest(ScaffoldState scaffoldState, dynamic erro) {
    if (erro['message'] != null) {
      MessageHandler.error(
        scaffoldState,
        IntlText(
          erro['message'],
        ),
        duration: Duration(seconds: 8),
      );
    } else {
      handleGenericError(scaffoldState, erro);
    }
  }

  handleGenericError(ScaffoldState scaffoldState, dynamic erro) {
    MessageHandler.error(
      scaffoldState,
      IntlText(
        'mensagens.MSG-500',
        args: {
          'mensagem': erro != null && erro['message'] != null
              ? erro['message']
              : "Erro Interno"
        },
      ),
      duration: Duration(seconds: 8),
    );
  }
}

ErrorHandler error = new ErrorHandler();
