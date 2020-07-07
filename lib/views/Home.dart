import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/Usuario.dart';
import 'package:olx/views/ImputCustomizado.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerEmail = TextEditingController(text: "valdecir@gmail.com");
  TextEditingController _controllerSenha = TextEditingController(text: "1234567");

  bool _cadastrar = false;
  String _mensagemErro = "";
  String _textoBotao = "Entrar";

  _cadastrarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha)
        .then((firebaseUser) => {
          
    });
  }

  _logarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha)
        .then((firebaseUser) => {});
  }

  _validarCampos(){

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email.isNotEmpty && email.contains("@")){
      if(senha.isNotEmpty && senha.length > 6){

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        if(_cadastrar){
          _cadastrarUsuario(usuario);
        }else{
          _logarUsuario(usuario);
        }
      }else{
        setState(() {
          _mensagemErro = "Preencha a senha! Digite mais de 6 caracteres";
        });
      }
    }else{
      setState(() {
        _mensagemErro = "Preencha o E-mail válido";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                      "images/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                ImputCustomizado(
                  controller: _controllerEmail,
                  hint: "E-mail",
                  autofocus: true,
                  type: TextInputType.emailAddress,
                ),
                ImputCustomizado(
                  controller: _controllerSenha,
                  hint: "Senha",
                  obscure: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Logar"),
                    Switch(
                      value: _cadastrar,
                      onChanged: (bool valor){
                        setState(() {
                          _textoBotao = "Entrar";
                          _cadastrar = valor;
                          if(_cadastrar){
                            _textoBotao = "Cadastrar";
                          }
                        });
                      },
                    ),
                    Text("Cadastrar"),
                  ],
                ),
                RaisedButton(
                  child: Text(
                    _textoBotao,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                  color: Color(0xff9c27b0),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  onPressed: (){
                    _validarCampos();
                  },
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 20),
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}