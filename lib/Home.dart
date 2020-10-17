import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _cepDigitado = '';
  String _resultado = '';
  TextEditingController _controlerCep = TextEditingController();

  _limpaBusca() {

    setState(() {
      _cepDigitado = '';
      _resultado = '';
    });
    _controlerCep.clear();

  }

  _recuperarCep() async{
    if((_controlerCep.value.text.length > 0) && (_controlerCep.value.text.length < 9)) {
      
      String cep = _controlerCep.text;
      String url = 'https://viacep.com.br/ws/${cep}/json/';
      http.Response response;
      response = await http.get(url);
      Map<String, dynamic> retorno = json.decode(response.body);

      setState(() {
        _cepDigitado = 'CEP: ${_controlerCep.text}';
        _resultado = 'Endereço: ${retorno['logradouro']}, ${retorno['bairro']} - ${retorno['localidade']} - ${retorno['uf']}';
      });

    }
    else
    {
      setState(() {
        _resultado = 'Dígite um CEP válido para continuar';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP via API'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Dígite o CEP (somente números)'
              ),
              style: TextStyle(
                fontSize: 20
              ),
              controller: _controlerCep,
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.green,
              disabledTextColor: Colors.green[800],
              disabledColor: Colors.green[800],
              splashColor: Colors.green[800],
              child: Text('CONSULTAR CEP',
                style: TextStyle(fontSize: 25),
              ),
              onPressed: _recuperarCep,
            ),
            Text(_cepDigitado,
                  style: TextStyle(fontSize: 25),
            ),
            Text(_resultado,
                  style: TextStyle(fontSize: 25),
            ),
            RaisedButton(
              textColor: Colors.grey[400],
              color: Colors.grey[100],
              disabledTextColor: Colors.grey[350],
              disabledColor: Colors.grey[350],
              splashColor: Colors.grey[350],
              child: Text('LIMPAR BUSCA',
                style: TextStyle(fontSize: 25),
              ),
              onPressed: _limpaBusca,
            ),
          ],
        ),
      ),
    );
  }
}