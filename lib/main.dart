import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/homePage.dart';
import 'package:qrcode/opcoes_agendamento.dart';
import 'package:qrcode/utils/app_route.dart';

import 'models/class_refeicao.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new AgendamentosRefeicoes(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projeto Crescer',
        routes: {
          AppRoute.INDEX: (ctx) => HomePage(),
          AppRoute.OPCOES_AGENDAMENTO: (ctx) => OpcoesAgendamento(),
        },
      ),
    );
  }
}
