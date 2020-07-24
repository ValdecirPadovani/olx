import 'package:flutter/material.dart';
import 'package:olx/views/widgets/ItemAnuncio.dart';

class MeusAnuncios extends StatefulWidget {
  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
          itemCount: 4,
          itemBuilder: (_,indice){
            return ItemAnuncio();
          }
      ),
    );
  }
}
