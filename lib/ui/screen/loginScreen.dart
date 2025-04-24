import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:task_management/ui/screen/bottom_nav_bar.dart';
import 'package:task_management/ui/screen/register_screen.dart';
import 'package:task_management/ui/widget/center_circle_indicator.dart';
import 'package:task_management/ui/widget/screen_background.dart';

import '../../data/serviece/client_network.dart';
import '../../data/utils/urls.dart';
import '../widget/snack_bar.dart';
import 'forget_Password_email_verify.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loginInProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body: screen_background(child:
         Padding(
           padding: const EdgeInsets.all(30.0),
           child: Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 120,),
                Text("Get Started With",
                  style: Theme.of(context).textTheme.titleLarge
                ),
                const SizedBox(height: 24,),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailTEController,
                  decoration: InputDecoration(
                    hintText: "Email"
                  ),
                  validator: (String? value) {
                    String email = value?.trim() ?? '';
                    if (EmailValidator.validate(email) == false) {
                      return "Enter valid Mail";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14,),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  controller: _passwordTEController,
                  decoration: InputDecoration(
                    hintText: "Password"
                  ),
                  validator: (String? value){
                    if(value?.isEmpty ?? true){
                      return "Enter valid Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),
                Visibility(
                  visible: _loginInProcess == false,
                  replacement:const CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: Icon(Icons.arrow_circle_right_outlined,
                        color: Colors.white,)
                  ),
                ),
                const SizedBox(height: 32,),
                Center(
                  child: Column(
                    children: [
                      TextButton(onPressed: () => _onTapForgetPassword(),
                          child: Text("Forget Password ?"),
                      ),
                      RichText(text:
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                        ),
                        children: [
                          TextSpan(text: "Don't have an account?"),
                           TextSpan(text: " Sign up",
                             style: TextStyle(
                               fontWeight: FontWeight.bold,
                               color: Colors.green
                             ),
                            recognizer: TapGestureRecognizer()..onTap = _onTapSignUp
                           ),
                        ]
                      )
                      ),
                    ],
                  ),
                ),



              ],
             ),
           ),
         )
         ),
    );
  }
  void _onTapForgetPassword(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ForgotPasswordVerifyEmailScreen()
    )
    );
  }
  void _onTapSignUp(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => RegisterScreen()
        )
    );
  }

  Future<void> _loginUser() async {
    _loginInProcess = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text
    };

    NetworkResponse response = await ClientNetwork.postRequest(
        url: Urls.loginUrl, body: requestBody);
    _loginInProcess = false;
    setState(() {});
    if(response.isSuccess){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context)=>MainBottomNavBar()),
              (predicate) => false
      );
    } else{
      showSnackBarMassage(context, response.errorMassage ,true);
    }
  }

  void _onTapSubmitButton(){
    if (_formKey.currentState!.validate()) {
      _loginUser();
    }

  }

  @override
  void dispose(){
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
  }
}
