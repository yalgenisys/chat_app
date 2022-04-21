import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, this.submitFn, this.isLoading}) : super(key: key);
  final bool? isLoading;
  final void Function(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
    BuildContext context,
  )? submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _key = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile = File('');

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _submitForm() {
    final isValid = _key.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _key.currentState!.save();
      widget.submitFn!(
        _userEmail,
        _userName,
        _userPassword,
        _userImageFile!,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_isLogin) UserImagePicker(imagePickFn: _pickedImage),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white70),
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        key: const ValueKey('email'),
                        // validator: (value) {
                        //   if (value!.isEmpty || !value.contains('@')) {
                        //     return 'Please enter a valid email address.';
                        //   }
                        //   return null;
                        // },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onSaved: (value) {
                          _userEmail = value!;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: const ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'PLease at least 4 characters.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onSaved: (value) {
                            _userName = value!;
                          },
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        key: const ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'PLease must be at least 7 characters long.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        obscureText: true,
                        onSaved: (value) {
                          _userPassword = value!;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      // if (widget.isLoading!) const CircularProgressIndicator(),
                      // if (!widget.isLoading!)
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: _isLogin
                              ? const Text('Login')
                              : const Text('Sign Up'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlueAccent,
                            ),
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: _isLogin
                            ? const Text('Create new account')
                            : const Text('I have an already account'),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightBlueAccent,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
