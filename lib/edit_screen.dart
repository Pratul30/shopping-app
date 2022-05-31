import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/product.dart';
import './provider/products.dart';
class EditScreen extends StatefulWidget {

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var pricefocusnode = FocusNode();
  var descfocusnode = FocusNode();
  var imageurlfocus = FocusNode();
  var imagecontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();
  var product = Product(
    id: null,
    title: '',
    price: 0.0,
    desc: '',
    imageUrl: ''
    );
  var editvalues = {
    'title': '',
    'price': '',
    'desc': '',
    'imageUrl': ''
  };
  bool temp = true;
  bool loading = false;

 @override
   void initState() {
     imageurlfocus.addListener(imagelistener);
     super.initState();
   }

   @override
     void didChangeDependencies() {
       if(temp){
       final editproductid = ModalRoute.of(context).settings.arguments as String;
       if(editproductid != null){
        product = Provider.of<Products>(context, listen: false).findbyid(editproductid);
        editvalues = {
          'title': product.title,
          'price': product.price.toString(),
          'desc': product.desc,
          'imageUrl': ''
        };
        imagecontroller.text = product.imageUrl; 
       } 
       }   
       temp = false;
       super.didChangeDependencies();
     }

void imagelistener(){
  if(!imageurlfocus.hasFocus){
    setState(() {
          
        });
  }
} 

Future<void> form() async {
  final isValid = formkey.currentState.validate();
  if(!isValid){
    return ;
  }
  formkey.currentState.save();
  setState(() {
    loading = true;
  });
  if(product.id==null){
  try{
  await Provider.of<Products>(context, listen:false).addProduct(product);
  }catch(error){
    return showDialog<Null>(context: context, builder: (ctx)=> AlertDialog(
      title: Text('An error occured'), 
      content: Text('Some error occured, please reenter your data.'),
      actions: [
        ElevatedButton(child: Text('Ok'), onPressed: (){
          Navigator.of(context).pop();
        })
      ],
    ));
  }
  }
  else{
  await Provider.of<Products>(context, listen: false).updateProduct(product);
  }
  setState(() {
    loading = false;
  });
  Navigator.of(context).pop();
}

  @override
    void dispose() {
      imageurlfocus.removeListener(imagelistener);
      imageurlfocus.dispose();
      imagecontroller.dispose();
      pricefocusnode.dispose();
      descfocusnode.dispose();
      super.dispose();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: loading ? 
      Center(child: CircularProgressIndicator()) :
      Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: editvalues['title'],
                  decoration: InputDecoration(
                    labelText: 'Title'
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(pricefocusnode);
                  },
                  validator: (value){
                    if(value.isEmpty){
                      return 'Enter title'; 
                    }
                    return null;
                  },
                  onSaved: (value){
                    product = Product(
                      title: value,
                      price: product.price,
                      desc: product.desc,
                      imageUrl: product.imageUrl,
                      id: product.id,
                      isFavorite: product.isFavorite
                    );
                  }
                ),
                TextFormField(
                  initialValue: editvalues['price'],
                  decoration: InputDecoration(
                    labelText: 'Price'
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: pricefocusnode,
                  onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(descfocusnode);
                  },
                  validator: (value){
                    if(value.isEmpty){
                      return 'Please enter price.';
                    }
                    else if(double.tryParse(value)==null){
                      return 'Enter a valid price';
                    }
                    else if(double.parse(value)<0){
                      return 'Please enter price above than 0';
                    }
                    return null;
                  },
                  onSaved: (value){
                    product = Product(
                      title : product.title,
                      price: double.parse(value),
                      desc : product.desc,
                      imageUrl: product.imageUrl,
                      id: product.id,
                      isFavorite: product.isFavorite
                    );
                  } 
                ),
                TextFormField(
                  focusNode: descfocusnode,
                  initialValue: editvalues['desc'],
                  decoration: InputDecoration(
                    labelText: 'Decription'
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Please enter description.';
                    }
                    return null;
                  },
                  onSaved: (value){
                    product = Product(
                      title: product.title,
                      price: product.price,
                      desc: value,
                      imageUrl: product.imageUrl,
                      id: product.id,
                      isFavorite: product.isFavorite
                    );
                  }
                ),
                Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children :[ 
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(top: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2)
                  ),
                  child: imagecontroller.text.isEmpty ? Text('Enter URL') : Image.network(imagecontroller.text) 
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText : 'Image URL'
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    onEditingComplete: (){
                      setState(() {

                      });
                    },
                    controller: imagecontroller,
                    focusNode: imageurlfocus,
                    onFieldSubmitted: (_){
                      form();
                    },
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter url';
                      }
                      else if(!value.startsWith('http') && !value.startsWith('https')){
                        return 'Enter a valid url';
                      }
                     
                      return null;
                    },
                    onSaved: (value){
                      product = Product(
                        title: product.title,
                        price: product.price,
                        desc: product.desc,
                        imageUrl: value,
                        id: product.id,
                        isFavorite: product.isFavorite
                      );
                    } 
                  ),
                )
               ]
               ),
               SizedBox(
                 height: 20
               ),
               ElevatedButton(
                 child: Text('Add'),
                 onPressed: form,
               )
              ]
            )
          ),
        ),
      )
    );
  }
}