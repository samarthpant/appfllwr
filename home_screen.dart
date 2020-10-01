import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  bool _loading = false;
  List _output;

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value){
      setState(() {
        _loading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title:Text("Flower Name Predictor",
        ),
        backgroundColor: Colors.lightGreen
        ),
      body:_loading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) : Container(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Container(
              child: Text("Please press the buton below to add photo of the flower")
            )
             : Image.file(_image),
            SizedBox(height:20),
            _output != null ? Text("${_output[0]["label"]}",
            style: TextStyle(
              color:Colors.black,
              fontSize:20.0,
              background: Paint()..color = Colors.white,
            ),
            ) : Container()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: chooseImage,
        child: Icon(Icons.add_a_photo)
        ),
    );
  }

  chooseImage() async {
    var picker = ImagePicker();
    var image  = await picker.getImage(source: ImageSource.camera); 
    if(image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path) ;
    });
    runModelOnImage(_image);
}

runModelOnImage(File image) async{
  var output = await Tflite.runModelOnImage(
    path: image.path,
    numResults: 2,
    imageMean: 130.5,
    imageStd: 130.5,
    threshold: 0.5,
  );
  setState(() {
    _loading = false;
    _output = output;
  });
}

loadModel() async {
  await Tflite.loadModel(
    model: "assets/model_unquant.tflite",
    labels: "assets/labels.txt"
    );
  }


}