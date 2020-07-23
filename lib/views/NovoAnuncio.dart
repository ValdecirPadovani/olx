import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/views/widgets/BotaoCustomizado.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {

  List<File> _listImagens = List();
  List<DropdownMenuItem<String>> _listItensDorpEstados = List();
  List<DropdownMenuItem<String>> _listItensDorpCategorias = List();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _piker = ImagePicker();
  File _image;

  String _itemSelecionadoEstado;
  String _itemSelecionadoCategoria;

  Future _selecionarImagemGaleria() async {
    final imagemSelecionada = await _piker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(imagemSelecionada.path);
    });

    if(_image != null){
      setState(() {
        _listImagens.add(_image);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarItensDropdown();
  }

  _carregarItensDropdown(){

    _listItensDorpCategorias.add(
        DropdownMenuItem(child: Text("Automóvel"), value: "auto",)
    );

    _listItensDorpCategorias.add(
        DropdownMenuItem(child: Text("Imóvel"), value: "imovel",)
    );

    _listItensDorpCategorias.add(
        DropdownMenuItem(child: Text("Eletrônicos"), value: "eletro",)
    );

    _listItensDorpCategorias.add(
        DropdownMenuItem(child: Text("Moda"), value: "moda",)
    );

    _listItensDorpCategorias.add(
        DropdownMenuItem(child: Text("Esportes"), value: "esportes",)
    );


   for(var estados in Estados.listaEstadosAbrv){
    _listItensDorpEstados.add(
        DropdownMenuItem(child: Text(estados), value: estados,)
    );
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Anúncios"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormField<List>(
                  initialValue: _listImagens,
                  validator: (imagens ){
                    if(imagens.length == 0){
                      return "Necessário selecionar uma imagem";
                    }
                    return null;
                  },
                  builder: (state){
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listImagens.length +1,
                              itemBuilder: (context, indice){
                                if(indice == _listImagens.length){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: (){
                                        _selecionarImagemGaleria();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[400],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey[100],
                                            ),
                                            Text(
                                              "Adicionar",
                                              style: TextStyle(
                                                color: Colors.grey[100]
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if(_listImagens.length > 0){
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: GestureDetector(
                                        onTap: (){
                                          showDialog(
                                              context: context,
                                            builder: (context) => Dialog(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Image.file(_listImagens[indice]),
                                                  FlatButton(
                                                    child: Text("Excluir"),
                                                    textColor: Colors.red,
                                                    onPressed: (){
                                                      setState(() {
                                                        _listImagens.removeAt(indice);
                                                        Navigator.of(context).pop();
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                            )
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: FileImage(_listImagens[indice]),
                                          child: Container(
                                            color: Color.fromRGBO(255, 255, 255, 0.4),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                }
                                return Container();
                              }
                          ),
                        ),
                        if(state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: TextStyle(
                                color: Colors.red, fontSize: 14
                              ),
                            )
                            ,
                          )
                      ],
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoEstado,
                          hint: Text("Estados"),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),
                          items: _listItensDorpEstados,
                          validator: (valor){
                            return Validador().add(Validar.OBRIGATORIO, msg: "Campo obrigatório").valido(valor);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoEstado = valor;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoCategoria,
                          hint: Text("Categorias"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          ),
                          items: _listItensDorpCategorias,
                          validator: (valor){
                            return Validador().add(Validar.OBRIGATORIO, msg: "Campo obrigatório").valido(valor);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoCategoria = valor;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Text("Caixa de textos"),
                BotaoCustomizado(
                  texto: "Cadastrar anúncio",
                  onPressed: (){
                    if(_formKey.currentState.validate()){

                    }
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
