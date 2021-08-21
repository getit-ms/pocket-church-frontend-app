import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pocket_church/api/api.dart';
import 'package:pocket_church/bloc/acesso_bloc.dart';
import 'package:pocket_church/componentes/componentes.dart';
import 'package:pocket_church/model/termo-aceite/model.dart';

class AceiteTermoPage extends StatelessWidget {
  const AceiteTermoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: const IntlText("termo_aceite.termo_aceite")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<TermoAceite>(
          future: termoAceiteApi.buscaAtual(),
          builder: (context, snapshot) {
            return Column(
              children: [
                const IntlText("termo_aceite.instrucao"),
                const SizedBox(height: 20),
                snapshot.data != null
                    ? Html(data: snapshot.data.termo ?? '')
                    : Container(
                        alignment: Alignment.center,
                        height: mediaQueryData.size.height -
                            kToolbarHeight -
                            mediaQueryData.padding.vertical -
                            250,
                        child: const SizedBox(
                          child: CircularProgressIndicator(),
                          width: 50,
                          height: 50,
                        ),
                      ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CommandButton<dynamic>(
                    child: const IntlText("termo_aceite.aceito_termo"),
                    onPressed: snapshot.data == null
                        ? null
                        : (loading) async {
                            await loading(termoAceiteApi.aceitaTermo());
                            await loading(acessoBloc.refresh());
                          },
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const IntlText("termo_aceite.nao_aceito_termos"),
                  onPressed: snapshot.data == null
                      ? null
                      : () {
                          acessoBloc.logout();
                        },
                ),
                SizedBox(height: mediaQueryData.padding.bottom),
              ],
            );
          },
        ),
      ),
    );
  }
}
