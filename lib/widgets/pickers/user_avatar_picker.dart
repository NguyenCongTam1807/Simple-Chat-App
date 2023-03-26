import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserAvatarPicker extends StatefulWidget {
  final Function(File image) pickImageFn;

  const UserAvatarPicker(this.pickImageFn, {Key? key}) : super(key: key);

  @override
  State<UserAvatarPicker> createState() => _UserAvatarPickerState();
}

class _UserAvatarPickerState extends State<UserAvatarPicker> {
  File? avatar;

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 120,
      maxHeight: 120
    );
    if (image != null) {
      setState(() {
        avatar = File(image.path);
      });
      widget.pickImageFn(avatar!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.withOpacity(0.5),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _pickImage,
        splashColor: Theme.of(context).primaryColor,
        child: avatar == null
            ? const Icon(Icons.image)
            : CircleAvatar(
                backgroundImage: FileImage(avatar!),
              ),
      ),
    );
  }
}
