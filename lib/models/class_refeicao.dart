import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qrcode/utils/constants.dart';

class AgendamentoRefeicao {
  final String matricula;
  final String nome;
  final String tipo;
  final String opcao;
  final String periodo;
  final String instituicao;

  AgendamentoRefeicao({
    this.matricula,
    this.nome,
    this.tipo,
    this.opcao,
    this.periodo,
    this.instituicao,
  });
}

class AgendamentosRefeicoes with ChangeNotifier {
  final String _baseUrl = Constants.URL_AGENDAR_REFEICAO;
  List<AgendamentoRefeicao> _items = [];

  List<AgendamentoRefeicao> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<String> cadastrar(AgendamentoRefeicao agendamento) async {
    String retorno = "fail";

    final response = await http.post(
      _baseUrl,
      body: {
        "matricula": agendamento.matricula,
        "nome": agendamento.nome,
        "tipo": agendamento.tipo,
        "opcao": agendamento.opcao,
        "periodo": agendamento.periodo,
        "instituicao": agendamento.instituicao,
      },
    );

    if (response.body.contains('return')) {
      retorno = json.decode(response.body)['return'];
    }

    print(retorno);

    notifyListeners();
    return Future.value(retorno);
  }

  Future<void> loadAgendamentos(String matricula) async {
    final response = await http.get(Constants.URL_AGENDAR_REFEICAO + matricula);

    final data = json.decode(response.body);
    _items.clear();

    if (data != null) {
      data.forEach((dados) {
        _items.add(
          AgendamentoRefeicao(
            matricula: dados['matricula'].toString(),
            nome: dados['nome'].toString(),
            tipo: dados['tipo'].toString(),
            opcao: dados['opcao'].toString(),
            periodo: dados['periodo'].toString(),
            instituicao: dados['instituicao'].toString(),
          ),
        );
      });
    }

    notifyListeners();
    return Future.value();
  }
}
