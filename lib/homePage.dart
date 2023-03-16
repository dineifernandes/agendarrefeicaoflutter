import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/opcoes_agendamento.dart';
import 'package:qrcode/utils/app_route.dart';
import 'package:connectivity/connectivity.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrCodeResult = "Aguardando...";

  bool resultInternet = false;
  String codeInvalido = "";
  String _connection = "";
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void _updateStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        resultInternet = true;
      });
      updateText("3G/4G");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        resultInternet = true;
      });
      updateText("Conectado via wi-fi");
    } else {
      setState(() {
        resultInternet = false;
      });
      updateText("Atenção, você não tem uma conexão válida!");
    }
  }

  void updateText(String texto) {
    setState(() {
      _connection = texto;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  @override
  void initState() {
    // checkStatus();

    super.initState();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AGENDAR REFEIÇÃO"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'images/logo_sem_texto.png',
              width: MediaQuery.of(context).size.width * .002,
            ),

            resultInternet
                ? flatButton("LER CRACHÁ", OpcoesAgendamento())
                : Center(
                    child: Text(
                      _connection,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ),

            //flatButton("Generate QR CODE", GeneratePage()),
          ],
        ),
      ),
    );
  }

  Widget flatButton(String text, Widget widget) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlatButton(
          padding: EdgeInsets.all(15.0),
          onPressed: () async {
            await BarcodeScanner.scan().then((value) {
              var jsonTEMP = jsonDecode(utf8.decode(base64Url.decode(value)));

              if (jsonTEMP['matricula'] == null ||
                  jsonTEMP['nome'] == null ||
                  jsonTEMP['periodo'] == null ||
                  jsonTEMP['tipo'] == null) {
                setState(() {
                  codeInvalido = "QR Code INVÁLIDO!";
                });
              } else {
                setState(() {
                  codeInvalido = "";
                });
                Navigator.of(context)
                    .pushNamed(AppRoute.OPCOES_AGENDAMENTO, arguments: value);
              }
            });
          },
          child: Text(
            text,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.blue, width: 3.0),
              borderRadius: BorderRadius.circular(20.0)),
        ),
        SizedBox(
          height: 10.0,
        ),
        Center(
          child: Text(
            codeInvalido,
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }
}
