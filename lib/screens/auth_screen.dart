import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  Future<void> _submitAuthForm(
    String? email,
    String? password,
    String? userName,
    File userImageFile,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email!, password: password!);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email!, password: password!);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(userCredential.user!.uid + '.jpg');
        await ref.putFile(userImageFile);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set(
          {
            'username': userName,
            'email': email,
            'image_url': url,
          },
        );
      }
    } on PlatformException catch (error) {
      var message = 'Something went wrong, please check your credentials';
      if (error.message != null) {
        message = error.message.toString();
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: AuthForm(
        submitForm: _submitAuthForm,
        isLoading: _isLoading,
      ),
    );
  }
}
