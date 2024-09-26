import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name = 'John Doe';
  String? _description = 'Welcome to your profile!';
  String? _email = 'johndoe123@gmail.com';
  XFile? _image;

  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'John Doe';
      _description = prefs.getString('description') ?? 'Welcome to your profile!';
      _email = prefs.getString('email') ?? 'johndoe123@gmail.com';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      setState(() {
        _image = croppedFile != null ? XFile(croppedFile.path) : null;
      });
    }
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _name!);
    await prefs.setString('description', _description!);
    await prefs.setString('email', _email!);

    String uid = _auth.currentUser!.uid;
    String imageUrl = '';

    if (_image != null) {
      imageUrl = await uploadProfilePicture(File(_image!.path));
    }

    await saveUserProfile(uid, _name!, _description!, imageUrl);
  }

  Future<void> changePassword(String newPassword) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        await _auth.signOut();
        // User will have to sign in again with new password
        print("Password changed successfully!");
      } catch (error) {
        print("Password can't be changed: $error");
      }
    }
  }

  Future<void> changeEmail(String newEmail) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await user.updateEmail(newEmail);
        print("Email changed successfully!");
      } catch (error) {
        print("Email can't be changed: $error");
      }
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent!");
    } catch (error) {
      print("Failed to send password reset email: $error");
    }
  }

  Future<void> saveUserProfile(String uid, String name, String bio, String imageUrl) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'bio': bio,
      'imageUrl': imageUrl,
    });
  }

  Future<String> uploadProfilePicture(File image) async {
    String userId = _auth.currentUser!.uid;
    Reference storageRef = FirebaseStorage.instance.ref().child('profile_pictures/$userId');

    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _image != null
                  ? FileImage(File(_image!.path))
                  : AssetImage('assets/images/profile.jpg') as ImageProvider,
            ),
            IconButton(icon: Icon(Icons.edit), onPressed: _pickImage),
            TextField(
              onChanged: (value) => _name = value,
              decoration: InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: _name),
            ),
            TextField(
              onChanged: (value) => _description = value,
              decoration: InputDecoration(labelText: 'Description'),
              controller: TextEditingController(text: _description),
            ),
            TextField(
              enabled: false, // Lock email field
              decoration: InputDecoration(labelText: 'Email'),
              controller: TextEditingController(text: _email),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                changePassword(_passwordController.text);
              },
              child: Text('Change Password'),
            ),
            ElevatedButton(
              onPressed: () {
                changeEmail(_emailController.text);
              },
              child: Text('Change Email'),
            ),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                sendPasswordResetEmail(_email!);
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
