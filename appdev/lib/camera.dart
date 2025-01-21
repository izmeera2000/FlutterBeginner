import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get available cameras
  final cameras = await availableCameras();

  runApp(MyApp(camera: cameras.first)); // Use the first available camera
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(camera: camera),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? _imageFile;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  // Request camera permission
  Future<void> _requestPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _initCamera();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission is required!")),
      );
    }
  }

  // Initialize camera
  void _initCamera() {
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();

    setState(() {
      _hasPermission = true;
    });
  }

  // Capture & save image
  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();
      final directory = await getExternalStorageDirectory();
      final imagePath = path.join(directory!.path, "${DateTime.now()}.jpg");

      File savedImage = await File(image.path).copy(imagePath);

      setState(() {
        _imageFile = savedImage;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image saved: ${savedImage.path}")),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera App")),
      body: _hasPermission
          ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Get the aspect ratio of the camera preview
                  double aspectRatio = _controller.value.aspectRatio;
                  double targetAspectRatio = 3 / 4; // Force 4:3 ratio

                  return Center(
                    child: AspectRatio(
                      aspectRatio: targetAspectRatio,
                      child: Transform.rotate(
                        angle: 1.5708, // Rotate 90 degrees for back camera
                        child: CameraPreview(_controller),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          : Center(child: Text("Waiting for permissions...")),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera),
      ),
      bottomNavigationBar: _imageFile != null
          ? Container(
              height: 100,
              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: Image.file(_imageFile!),
            )
          : SizedBox.shrink(),
    );
  }
}
