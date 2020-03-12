import 'package:flutter/material.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(id: null, title: '', description: '', price: 0.0 , imageUrl: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImgeUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImgeUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImgeUrl(){
    if(! _imageUrlFocusNode.hasFocus){
      if(!_imageUrlController.text.startsWith('http') || 
        (!_imageUrlController.text.endsWith('.png') || 
        !_imageUrlController.text.endsWith('.jpg') || 
        !_imageUrlController.text.endsWith('.jpeg'))){
            return;
        }
        setState(() {});
    }
  }

  void _saveForm(){
    bool valid = _form.currentState.validate();
    if(!valid){
      return;
    }
    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product'),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.save), onPressed: () => _saveForm()),
      ],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          //autovalidate: true,
          key: _form,
          child: ListView(children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value) {
                  if(value.isEmpty){
                    return "please add value";
                  }
                  return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  id: null, 
                  title: value, 
                  description: _editedProduct.description, 
                  price: _editedProduct.price, 
                  imageUrl: _editedProduct.imageUrl);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              onSaved: (value) {
                _editedProduct = Product(
                  id: null, 
                  title: _editedProduct.title, 
                  description: _editedProduct.description, 
                  price: double.parse(value), 
                  imageUrl: _editedProduct.imageUrl);
              },
              validator: (value) {
                if(value.isEmpty) return 'Please Enter number';
                if(double.tryParse(value) == null ) return 'Please Enter Valid number';
                if(double.parse(value) <= 0) return 'Number must be greater than zero';
                return null;
              }
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
              onSaved: (value) {
                _editedProduct = Product(
                  id: null, 
                  title: _editedProduct.title, 
                  description: value, 
                  price: _editedProduct.price, 
                  imageUrl: _editedProduct.imageUrl);
              },
              validator: (value) {
                if(value.isEmpty) return 'Please Enter Description';
                if(value.length < 10) return 'Descriotion need to longer than 10 digit';
                return null;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 8, right: 10,),
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                child: Container(
                  child: _imageUrlController.text.isEmpty 
                  ? Text('Enter URL') 
                  : FittedBox(child: Image.network(_imageUrlController.text), fit: BoxFit.cover),
                  
                ),
              ),
              Expanded(
                  child: TextFormField(
                  decoration: InputDecoration(labelText:'Image URL'),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  focusNode: _imageUrlFocusNode,
                  onFieldSubmitted: (_) => _saveForm(),
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: null, 
                      title: _editedProduct.title, 
                      description: _editedProduct.description, 
                      price: _editedProduct.price, 
                      imageUrl: value);
                  },
                  validator: (value) {
                    if(value.isEmpty) return 'Please Entry Image URL';
                    if(!value.startsWith('http')) return 'Please Enter valid URL';
                    if(!value.endsWith('.png') || !value.endsWith('.jpg') || !value.endsWith('.jpeg')){
                      return 'Please entry Image URL';
                    }
                    return null;
                  },
                ),
              ),
            ]
            ),
        ],)),
      ),
    );
  }
}