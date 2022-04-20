import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key, required this.imagePickFn})
      : super(key: key);
  final void Function(File pickedImage) imagePickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    File tempFile = File(image!.path);
    if (tempFile.path.isEmpty) {
      return;
    }
    setState(() {
      _pickedImage = File(tempFile.path);
    });
    widget.imagePickFn(File(tempFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          _pickedImage != null
              ? CircleAvatar(
                  backgroundImage: FileImage(_pickedImage!),
                  backgroundColor: const Color(0xFF909CB3),
                )
              : const CircleAvatar(
                  backgroundImage: AssetImage('assets/user.png'),
                ),
          Positioned(
            right: -5,
            bottom: 2,
            child: SizedBox(
              height: 32,
              width: 32,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                onPressed: _pickImage,
                child: const Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
