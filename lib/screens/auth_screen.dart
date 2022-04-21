import 'dart:convert';
import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_http_client.dart';
import '../widgets/custom_shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String userName,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        // userCredential = await _auth.signInWithEmailAndPassword(
        //     email: email, password: password);
        CustomHttpClient http = CustomHttpClient();
        final token = await FirebaseMessaging.instance.getToken();
        print("FCM TOKEN:- $token");
        var body = jsonEncode({'username': userName, 'password': password});
        var response = await http.post(
          Uri.parse('http://192.168.100.187:8081/auth'),
          body: body,
        );
        print("ResponseCode:- ${response.statusCode}");
        final dynamic loginResponse = jsonDecode(response.body);
        // if (loginResponse['error'] != null) {
        //   // return CustomError.fromJson(loginResponse);
        // }
        print("User Token:- $loginResponse");
        await CustomSharedPreferences.setString('token', token!);
        // final u.User user = u.User.fromJson(loginResponse['user']);
        // await CustomSharedPreferences.setString('user', user.toString());

        // return user;
      } else {
        // userCredential = await _auth.createUserWithEmailAndPassword(
        //   email: email,
        //   password: password,
        // );

        //   final ref = FirebaseStorage.instance
        //       .ref()
        //       .child('user_image')
        //       .child(userCredential.user!.uid + '.jpg');
        //   await ref.putFile(image);
        //   final url = await ref.getDownloadURL();
        //   await FirebaseFirestore.instance
        //       .collection('users')
        //       .doc(userCredential.user!.uid)
        //       .set({
        //     'userName': username,
        //     'email': email,
        //     'imageUrl': url,
        //   });

        print("in sign up");
        final token = await FirebaseMessaging.instance.getToken();
        print("TOKEN FCM:- $token");
        CustomHttpClient http = CustomHttpClient();
        var body = jsonEncode(
            {'name': email, 'username': userName, 'password': password});
        print('Body: $body');
        final url = Uri.parse('http://192.168.100.187:8081/user');
        var response = await http.post(
          url,
          body: body,
        );
        print("Response code:- ${response.statusCode}");
        final dynamic registerResponse = jsonDecode(response.body);
        print(registerResponse);
        await CustomSharedPreferences.setString('token', token!);
        //final String? token = await CustomSharedPreferences.get('token');
        //print(token);
        print("UserResponse:- $registerResponse");
      }
    } on PlatformException catch (error) {
      print(error);
      String message = 'An error occurred, please check your credentials';
      print(message);
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
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

  Future<dynamic> getUsers() async {
    try {
      CustomHttpClient http = CustomHttpClient();
      final url = Uri.parse('http://192.168.100.187:8081/user');
      var response = await http.get(url);
      var usersResponse = jsonDecode(response.body)['users'] as Map;
      usersResponse.forEach((key, value) {
        print("Key:- $key");
        print("value:- $value");
      });
      // final List users =
      // usersResponse.map((user) => u.User.fromJson(user)).toList();
      // return users;
    } catch (err) {
      print("Error:-$err");
      // return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.red,
            ],
          )),
          child: AuthForm(submitFn: _submitAuthForm, isLoading: _isLoading),
        ),
      ),
    );
  }
}
