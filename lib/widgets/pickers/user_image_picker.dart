import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource imageSource) async {
    final pickedImageFile = await _picker.getImage(source: imageSource,maxWidth: 150,imageQuality: 50);
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagePickFn(_pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: Icon(Icons.photo_camera_outlined),
                label: Text(
                  "Add Image\nfrom Camera",
                  textAlign: TextAlign.center,
                )),
            TextButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.image_outlined),
                label: Text(
                  "Add Image\nfrom Gallery",
                  textAlign: TextAlign.center,
                )),
          ],
        )
      ],
    );
  }
}
