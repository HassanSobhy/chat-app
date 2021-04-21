import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool _isLoading;
  final Function(
    BuildContext context,
    String email,
    String password,
    String username,
    bool isLogin,
  ) _submitFnc;

  AuthForm(this._submitFnc, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _username = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildEmailField(),
                if (!_isLogin) buildUserNameField(),
                buildPasswordField(),
                SizedBox(height: 16),
                widget._isLoading ? buildLoading() : buildSubmitButton(),
                buildCreateOrHaveAccButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

///////////Helper Widget//////////////
  Widget buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  TextButton buildCreateOrHaveAccButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
      child:
          Text(_isLogin ? "Create a new account" : "I already have an account"),
    );
  }

  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
      child: Text(_isLogin ? "Login" : "Sign Up"),
      onPressed: _submit,
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      key: ValueKey("password"),
      validator: validatePassword,
      onSaved: (val) => _password = val.trim(),
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(labelText: "Password"),
      obscureText: true,
    );
  }

  TextFormField buildUserNameField() {
    return TextFormField(
      key: ValueKey("username"),
      validator: validateUserName,
      onSaved: (val) => _username = val.trim(),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: "Username"),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      key: ValueKey("email"),
      validator: validateEmail,
      onSaved: (val) => _email = val.trim(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: "Email Address"),
    );
  }

///////////Helper Widget//////////////

///////////Helper Method//////////////

  void _submit() {
    bool _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      _formKey.currentState.save();
      widget._submitFnc(context, _email, _password, _username, _isLogin);
    }
  }

  String validatePassword(val) {
    if (val.isEmpty || val.length < 7) {
      return "Please enter at least 7 characters";
    }
    return null;
  }

  String validateUserName(val) {
    if (val.isEmpty || val.length < 4) {
      return "Please enter at least 4 characters";
    }
    return null;
  }

  String validateEmail(val) {
    if (val.isEmpty || !val.contains("@")) {
      return "Please enter a valid email";
    }
    return null;
  }

///////////Helper Method//////////////

}
