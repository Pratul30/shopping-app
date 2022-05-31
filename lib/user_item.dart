import 'package:flutter/material.dart';
class UserItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function delete;

  UserItem(this.delete,this.id,this.title,this.imageUrl);
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl)
        ),
        title: Text(title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
                  Navigator.of(context).pushNamed('/edit_screen',arguments: id);
                },
                color: Colors.green
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  delete(id);
                },
                color: Colors.red,
              )
            ]
          ),
        )
      )
    );
  }
}