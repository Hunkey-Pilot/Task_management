import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_management/data/serviece/client_network.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/widget/center_circle_indicator.dart';
import 'package:task_management/ui/widget/screen_background.dart';
import 'package:email_validator/email_validator.dart';
import 'package:task_management/ui/widget/snack_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _registrationInProgeress =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen_background(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(
                  "Join With Us",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTEController,
                  decoration: InputDecoration(hintText: "Email"),
                  validator: (String? value) {
                    String email = value?.trim() ?? '';
                    if (EmailValidator.validate(email) == false) {
                      return "Enter valid Mail";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _firstNameTEController,
                  decoration: InputDecoration(hintText: "First Name"),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Enter valid First Name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _lastNameTEController,
                  decoration: InputDecoration(hintText: "Last Name"),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Enter valid Last Name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  controller: _mobileTEController,
                  decoration: InputDecoration(hintText: "Mobile"),
                  validator: (String? value) {
                    String phone = value?.trim() ?? '';
                    RegExp regExp = RegExp(r"^(?:\+?88|0088)?01[15-9]\d{8}$");
                    if (regExp.hasMatch(phone) == false) {
                      return 'Enter your valid phone';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: _passwordEController,
                  decoration: InputDecoration(hintText: "Password"),
                  validator: (String? value) {
                    if ((value?.isEmpty ?? true) || (value!.length < 6)) {
                      return "Enter valid Password";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: _registrationInProgeress == false,
                  replacement:const CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: 32,
                ),
                Center(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Have Account? ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: "Sign In",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _onTapSignIn)
                  ])),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _onTapSignIn() {
    Navigator.pop(context);
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _registerUser();
    }
  }

  Future<void> _registerUser() async {
    _registrationInProgeress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordEController.text
    };

    NetworkResponse response = await ClientNetwork.postRequest(
        url: Urls.registerUrl, body: requestBody);
    _registrationInProgeress = false;
    setState(() {});
    if(response.isSuccess){
          showSnackBarMassage(context, "User Register Successfully");
    } else{
         showSnackBarMassage(context, response.errorMassage ,true);
    }
  }


  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordEController.dispose();
    super.dispose();
  }
}
