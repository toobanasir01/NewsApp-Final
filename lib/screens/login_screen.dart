import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:news_app/screens/register_screen.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/controller/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:news_app/widget/custom_button.dart';
import 'package:news_app/widget/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  AuthController _authCtrl = AuthController();

  Future<void> loginUsers() async {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));

      Response<dynamic> res = await _authCtrl.login(
        emailCtrl.text,
        passCtrl.text,
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (res.statusCode == 200) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res.statusCode} - ${res.statusMessage}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   width: 150,
              //   height: 150,
              //   child: const CircleAvatar(
              //
              //       backgroundColor: Colors.indigo,
              //       backgroundImage: AssetImage("assets/news_app_logo1.png",),
              //
              //       ),
              // ),
              Image(image: AssetImage("assets/news_app_logo1.png"),width: 100,height: 100,),
              SizedBox(
                height: 5,
              ),
              const Text(
                "Welcome back",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey,
                ),
              ),
              const Text(
                "Login to your account",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: emailCtrl,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Required*"),
                        EmailValidator(errorText: "Enter a valid email*"),
                      ]),

                      label: "Email",

                      icon: const Icon(
                        Icons.email,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: passCtrl,
                      obscureText: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Required*"),
                        LengthRangeValidator(
                            min: 5,
                            max: 10,
                            errorText: "Password length should be 5-10"),
                      ]),
                      label: "Password",
                      icon: const Icon(
                        Icons.password,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomButton(
                      text: 'Log In',
                      onPressed: loginUsers,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              "Signup",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold
                              ),

                            ))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
