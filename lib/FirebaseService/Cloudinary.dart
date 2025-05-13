import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // Thay vì dart:io cho web
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // để dùng kIsWeb
// import 'dart:io' if (dart.library.html) 'dart:html' as html;

void main(List<String> args) {
  runApp(MaterialApp(home: CloudinaryUploadWidget()));
}

class CloudinaryUploadWidget extends StatefulWidget {
  @override
  _CloudinaryUploadWidgetState createState() => _CloudinaryUploadWidgetState();
}

class _CloudinaryUploadWidgetState extends State<CloudinaryUploadWidget> {
  File? _imageFile; // Dùng cho mobile
  Uint8List? _webImageBytes; // Dùng cho web
  String? _uploadedImageUrl;
  String? _uploadError;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _webImageBytes = result.files.single.bytes!;
          _uploadError = null;
        });
        await _uploadImageWeb(_webImageBytes!, result.files.single.name);
      }
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _uploadError = null;
        });
        await _uploadImageMobile(_imageFile!);
      }
    }
  }

  Future<void> _uploadImageMobile(File image) async {
    final uri = Uri.parse("https://api.cloudinary.com/v1_1/dlimibe4b/image/upload");

    var request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = 'chatApp'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));
    await _sendRequest(request);
  }

  Future<void> _uploadImageWeb(Uint8List imageBytes, String filename) async {
    final uri = Uri.parse("https://api.cloudinary.com/v1_1/dlimibe4b/image/upload");

    var request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = 'chatApp'
      ..files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: filename));

    await _sendRequest(request);
  }


  Future<void> _sendRequest(http.MultipartRequest request) async {
    try {
      print("📤 Bắt đầu gửi request...");
      var response = await request.send();
      print("✅ Đã nhận response...");

      final responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        setState(() {
          _uploadedImageUrl = data['secure_url'];
          _uploadError = null;
        });
        print("✅ Upload thành công: ${data['secure_url']}");
      } else {
        print("❌ Upload thất bại: ${response.statusCode}");
        print("❌ Lỗi chi tiết: ${responseData.body}");
        setState(() {
          _uploadError = "Upload thất bại: ${responseData.body}";
        });
      }
    } catch (e) {
      print("❗ Lỗi ngoại lệ khi upload: $e");
      setState(() {
        _uploadError = "Lỗi ngoại lệ: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload to Cloudinary")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_uploadedImageUrl != null)
                Image.network(_uploadedImageUrl!)
              else
                Text("Chưa có ảnh nào được tải lên."),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Chọn ảnh và tải lên"),
              ),
              if (_uploadError != null) ...[
                SizedBox(height: 20),
                Text(
                  _uploadError!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
