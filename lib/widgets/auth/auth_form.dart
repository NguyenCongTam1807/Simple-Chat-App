import 'package:chat_app/common/dialogs.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Future<void> Function(
      {required String email,
      required String password,
      required String username,
      required bool isLogin}) submitAuthForm;
  const AuthForm(this.submitAuthForm, {Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

enum AuthMode { signUp, login }

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _passwordController = TextEditingController();

  AuthMode _authMode = AuthMode.login;
  var _username = '';
  var _email = '';
  var _password = '';

  late AnimationController _expandController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    _expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _sizeAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _expandController, curve: Curves.easeInOut));
    super.initState();
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
      _expandController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _expandController.reverse();
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() == false) {
      return;
    }
    _formKey.currentState?.save();
    widget.submitAuthForm(
        username: _username,
        email: _email,
        password: _password,
        isLogin: _authMode == AuthMode.login);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final regExp =
                    RegExp("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$");
                    if (value != null && regExp.hasMatch(value)) {
                      return null;
                    }
                    return "Please enter a correctly formatted email";
                  },
                  onSaved: (value) {
                    _email = value ?? "";
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    final regExp = RegExp("^.{3,32}\$");
                    //final regExp = RegExp("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[*.!@\$%^&(){}[]:;<>,.?/~_+-=|\\]).{6,32}\$");
                    if (value != null && regExp.hasMatch(value)) {
                      return null;
                    }
                    return "Password does not match requirements";
                  },
                  onSaved: (value) {
                    _password = value ?? "";
                  },
                ),
                SizeTransition(
                  sizeFactor: _sizeAnimation,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Re-enter Password'),
                        obscureText: true,
                        validator: (value) {
                          if (_authMode == AuthMode.login || value == _passwordController.text) {
                            return null;
                          }
                          return 'Passwords do not match';
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          final regExp = RegExp("^[a-zA-Z0-9@.]{4,}\$");
                          if (_authMode == AuthMode.login || (value != null && regExp.hasMatch(value))) {
                            return null;
                          }
                          return 'Invalid username';
                        },
                        onSaved: (value) {
                          _username = value ?? "";
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                        _authMode == AuthMode.login ? "Login" : "Sign up")),
                TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(_authMode == AuthMode.login
                        ? "Create an account"
                        : "I have an account")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
