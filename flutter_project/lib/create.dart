import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP package
import 'dart:convert'; // For handling JSON
import 'package:provider/provider.dart'; // State management
import 'authprovider.dart'; // Import AuthProvider for token
import 'dart:io'; // For handling file I/O
import 'package:image_picker/image_picker.dart'; // Image picker for mobile
import 'dart:html' as html; // For web file upload
import 'sidebar.dart'; // Custom sidebar widget

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _twitterTextController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  File? _selectedImage; // For mobile platforms
  html.File? _webSelectedImage; // For web platforms
  String _selectedMediaType = 'IMAGE';

  // Platform check
  bool get isWeb => identical(0, 0.0);

  // Image picker for mobile
  Future<void> _pickImageMobile() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // File picker for web
  Future<void> _pickImageWeb() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          _webSelectedImage = files.first;
        });
      }
    });
  }

  // Save Instagram draft
  Future<void> _saveInstagramDraft() async {
    final caption = _captionController.text;
    final mediaType = _selectedMediaType;

    if ((isWeb && _webSelectedImage == null) ||
        (!isWeb && _selectedImage == null) ||
        caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please provide a caption and select an image!')),
      );
      return;
    }

    final url =
        Uri.parse('http://13.60.226.247:8080/api/posts/instagram/drafts');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    try {
      if (isWeb) {
        final formData = html.FormData();
        formData.append('caption', caption);
        formData.append('mediaType', mediaType);
        formData.appendBlob('imageFile', _webSelectedImage!);

        final response = await html.HttpRequest.request(
          url.toString(),
          method: 'POST',
          sendData: formData,
          requestHeaders: {'Authorization': 'Bearer $token'},
        );

        if (response.status == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Instagram draft saved successfully!')),
          );
        } else {
          throw Exception('Failed with status: ${response.status}');
        }
      } else {
        final request = http.MultipartRequest('POST', url)
          ..headers.addAll({'Authorization': 'Bearer $token'})
          ..fields['caption'] = caption
          ..fields['mediaType'] = mediaType
          ..files.add(await http.MultipartFile.fromPath(
              'imageFile', _selectedImage!.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Instagram draft saved successfully!')),
          );
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred! Please try again.')),
      );
    }
  }

  // Save Twitter draft
  Future<void> _saveTwitterDraft() async {
    final tweetText = _twitterTextController.text;
    if (tweetText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a tweet!')),
      );
      return;
    }

    final url = Uri.parse('http://13.60.226.247:8080/api/posts/twitter/drafts');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'tweetText': tweetText}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tweet draft saved successfully!')),
        );
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred! Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(selectedMenu: 'Create'),
          Expanded(
            child: Container(
              color: const Color(0xFFF4EEE2),
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Post',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            labelColor: Colors.black,
                            indicatorColor: Color(0xFFBBA87C),
                            tabs: [
                              Tab(text: 'Instagram'),
                              Tab(text: 'Twitter')
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Instagram Tab
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Caption',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: _captionController,
                                      decoration: const InputDecoration(
                                        hintText: 'Write your caption...',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: isWeb
                                          ? _pickImageWeb
                                          : _pickImageMobile,
                                      child: Container(
                                        height: 300,
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Text(
                                            isWeb && _webSelectedImage != null
                                                ? 'File Selected'
                                                : _selectedImage != null
                                                    ? 'Image Selected'
                                                    : 'Tap to select an image',
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    DropdownButton<String>(
                                      value: _selectedMediaType,
                                      items: ['IMAGE', 'STORIES']
                                          .map(
                                            (type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(type),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedMediaType = value!;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: _saveInstagramDraft,
                                      child: const Text('Save Instagram Draft'),
                                    ),
                                  ],
                                ),
                                // Twitter Tab
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Tweet'),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: _twitterTextController,
                                      decoration: const InputDecoration(
                                        hintText: "What's happening?",
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: _saveTwitterDraft,
                                      child: const Text('Save Twitter Draft'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
