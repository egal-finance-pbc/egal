import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Photos extends StatefulWidget {
  const Photos({Key key}) : super(key: key);

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar: AppBar(
        backgroundColor: Color(0xff3B2F8F),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: size.height * 0.53,
                    //height: 320,
                    decoration: BoxDecoration(
                        color: Color(0xff3B2F8F),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        )),
                  ),
                  Camera(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Camera extends StatefulWidget {
  const Camera({Key key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  CameraController _controller;
  Future<void> _initController;
  var isCamareReady = false;
  XFile ImageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initController = _controller != null ? _controller.initialize() : null;
      if (!mounted) return;
      setState(() {
        isCamareReady = true;
      });
    }
  }

  Widget camaraWidget(context) {
    var camara = _controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camara.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    {
      return Transform.scale(
        scale: scale,
        child: Center(
          child: CameraPreview(_controller),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _initController,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              camaraWidget(context),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.83),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                    color: Color(0xAA333639),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () => capturaImage(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initController = _controller.initialize();
    if (!mounted) {
      return;
    }

    setState(() {
      isCamareReady = true;
    });
  }

  capturaImage(BuildContext context) {
    _controller.takePicture().then((file){
      setState(() {
        ImageFile = file;
      });
      if(mounted){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            DisplayPictures(image:ImageFile)));
      }

    });
  }
}

class DisplayPictures extends StatelessWidget{
  final XFile image;

  DisplayPictures({Key key,this.image}): super(key:key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar: AppBar(
        backgroundColor: Color(0xff3B2F8F),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: size.height * 0.53,
                    //height: 320,
                    decoration: BoxDecoration(
                        color: Color(0xff3B2F8F),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        )),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: size.height*0.30,
                      width: size.height*0.30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: Color(0xffF8991C),
                        ),
                        shape: BoxShape.circle,
                      ),
                        child:ClipOval(
                          child: Image.file(File(image.path),fit: BoxFit.fill,),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
