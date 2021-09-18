import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
    required this.submitForm,
    required this.isLoading,
  }) : super(key: key);

  final bool isLoading;

  final void Function(
    String? email,
    String? password,
    String? userName,
    bool isLogin,
    BuildContext ctx,
  ) submitForm;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String? _emailAddress = '';
  String? _userName = '';
  String? _password = '';

  void _trySubmit() {
    final formState = _formKey.currentState;
    bool isValid = formState != null && formState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      formState.save();
      widget.submitForm(_emailAddress?.trim(), _password?.trim(),
          _userName?.trim(), _isLogin, context);
    } else {
      print('invalid');
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please, enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      contentPadding: EdgeInsets.all(4),
                    ),
                    onSaved: (email) {
                      _emailAddress = email;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return 'Username must be at least 4 characters long';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        contentPadding: EdgeInsets.all(5),
                      ),
                      onSaved: (username) {
                        _userName = username;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      contentPadding: EdgeInsets.all(5),
                    ),
                    obscureText: true,
                    onSaved: (password) {
                      _password = password;
                    },
                  ),
                  const SizedBox(height: 12),
                  if (widget.isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Log in' : 'Signup'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Create new account' : 'Log in',
                      ),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
