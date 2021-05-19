import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FileStorage extends StatefulWidget {
  @override
  _FileStorageState createState() => _FileStorageState();
}

class _FileStorageState extends State<FileStorage> {


  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadFile() async {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/file-to-upload.png')
          .putFile(_image);
  }

  Widget enableUpload(){
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(_image,height: 300,width: 300,),
          RaisedButton(
            elevation: 7.0,
              child: Text('Upload'),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed:()async{
              uploadFile();
              },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('File Storage'),
      ),
      body: Center(
        child: _image == null ? Text('Select an image'): enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add),
      ),
    );
  }
}
