part of pocket_church.enquete;

class PageRespostaEnquete extends StatelessWidget {
  final Enquete enquete;

  const PageRespostaEnquete({this.enquete});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: Text(enquete.nome),
      body: RespostaForm(
        enquete: enquete,
      ),
    );
  }
}

class RespostaForm extends StatefulWidget {
  Enquete enquete;

  RespostaForm({this.enquete});

  @override
  State<StatefulWidget> createState() => RespostaFormState();
}

class RespostaFormState extends State<RespostaForm> {
  Enquete enquete;
  RespostaEnquete resposta;
  int index = 0;

  var _keyStepper = GlobalKey();

  @override
  void initState() {
    super.initState();

    enqueteApi.detalha(widget.enquete.id).then((enquete) {
      setState(() {
        this.enquete = enquete;
        this.resposta = RespostaEnquete(votacao: Enquete(id: enquete.id), respostas: []);
        this.resposta.respostas = enquete.questoes
            .map((q) => RespostaQuestao(questao: Questao(id: q.id), opcoes: []))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (resposta == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return _content();
  }

  _actionArea() {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[_anteriorAction(), _proximaAction()],
      ),
    );
  }

  _anteriorAction() {
    return MaterialButton(
      child: Row(
        children: <Widget>[
          const Icon(Icons.chevron_left),
          const SizedBox(
            width: 5,
          ),
          const IntlText("global.voltar")
        ],
      ),
      onPressed: index > 0
          ? () {
              setState(() {
                index--;
              });
            }
          : null,
    );
  }

  _proximaAction() {
    if (index + 1 == enquete.questoes.length) {
      return SizedBox(
        width: 120,
        child: CommandButton(
          child: Row(
            children: <Widget>[
              const Icon(Icons.check, color: Colors.white),
              const SizedBox(
                width: 5,
              ),
              const IntlText(
                "global.concluir",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
          onPressed:
              resposta.respostas[index].opcoes.isEmpty ? null : submeteResposta,
        ),
      );
    }

    return MaterialButton(
      child: Row(
        children: <Widget>[
          const IntlText("global.continuar"),
          const SizedBox(
            width: 5,
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onPressed: resposta.respostas[index].opcoes.isEmpty
          ? null
          : () {
              setState(() {
                index++;
              });
            },
    );
  }

  void submeteResposta(loading) {
    loading(enqueteApi
        .responde(resposta))
        .then((resp) {
      Navigator.of(context).pop(resp);
    });
  }


  Widget _content() {
    if (resposta == null) {
      return Container();
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Stepper(
              key: _keyStepper,
              currentStep: index,
              controlsBuilder: (context, details) => Container(),
              onStepTapped: (idx) {
                if (idx == 0 || resposta.respostas[idx - 1].opcoes.isNotEmpty) {
                  setState(() {
                    index = idx;
                  });
                }
              },
              type: enquete.questoes.length > 1
                  ? StepperType.vertical
                  : StepperType.horizontal,
              steps: enquete.questoes
                  .map((q) => Step(
                      title: Container(
                        constraints: new BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 84),
                        child: Text(q.questao),
                      ),
                      content: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: q.opcoes.map((o) {
                              var rq = resposta.respostas
                                  .firstWhere((rq) => rq.questao.id == q.id);

                              return InkWell(
                                  child: Row(
                                    children: <Widget>[
                                      Radio(
                                        groupValue: rq.opcoes.isEmpty
                                            ? null
                                            : rq.opcoes[0].opcao,
                                        value: o,
                                        activeColor: ConfiguracaoApp.of(context)
                                            .tema
                                            .primary,
                                        onChanged: (selected) {
                                          setState(() {
                                            if (selected != null) {
                                              rq.opcoes = [
                                                new RespostaOpcao(
                                                    opcao: selected)
                                              ];
                                            } else {
                                              rq.opcoes = [];
                                            }
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: Text(o.opcao),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      rq.opcoes = [new RespostaOpcao(opcao: o)];
                                    });
                                  });
                            }).toList(),
                          ),
                        ),
                      )))
                  .toList(),
            ),
          ),
        ),
        _actionArea()
      ],
    );
  }
}
