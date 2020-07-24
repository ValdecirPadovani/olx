import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/Anuncio.dart';
import 'package:olx/views/widgets/ItemAnuncio.dart';

class MeusAnuncios extends StatefulWidget {
  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuarioLogado;

  _recuperarUsuarioLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async{

    await _recuperarUsuarioLogado();

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .document(_idUsuarioLogado)
        .collection("anuncios")
        .snapshots();
    
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _removerAnuncio(String idAnuncio){
    Firestore db = Firestore.instance;
    db.collection("meus_anuncios").document(_idUsuarioLogado).collection("anuncios").document(idAnuncio).delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando anúncios"),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Anúncios"),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, "/novo-anuncio");
        },
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot){

          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:

              if(snapshot.hasError)
                return Text("Erro ao carregar os dados!");

              QuerySnapshot querySnapshot = snapshot.data;

              return ListView.builder(
                  itemCount: querySnapshot.documents.length,
                  itemBuilder: (_,indice){

                    List<DocumentSnapshot> anuncios = querySnapshot.documents.toList();
                    DocumentSnapshot documentSnapshot = anuncios[indice];
                    Anuncio anuncio = Anuncio.fromDocumentSnapshot(documentSnapshot);

                    return ItemAnuncio(
                      anuncio: anuncio,
                      onTapRemover: (){
                        showDialog(
                            context: context,
                            builder: (context){
                                return AlertDialog(
                                  title: Text("Confimar"),
                                  content: Text("Deseja realmente excluir o anúncio?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                          "Cancelar",
                                        style: TextStyle(
                                          color: Colors.grey
                                        ),
                                      ),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "Remover",
                                        style: TextStyle(
                                            color: Colors.red
                                        ),
                                      ),
                                      onPressed: (){
                                        _removerAnuncio(anuncio.id);
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                            }
                        );
                      },
                    );
                  }
              );
          }
          return Container();
        },
      )
    );
  }
}