import 'package:demoappprovider/CustomWidget/CustomTextField.dart';
import 'package:demoappprovider/FirebaseService/AuthService.dart';
import 'package:demoappprovider/Interface/LogIn.dart';
import 'package:demoappprovider/check/CheckLetter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final emailController = TextEditingController();
  bool isLoading = false;
  String mesError = "", mesErrorEmail = "";
  bool checkConfirmPW = false, checkConfirmEmail = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, leading: BackButton()),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 100),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              Text(
                "Đăng kí",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                inputType: TextInputType.name,
                name: "nhập tên",
                prefixIcon: Icons.person_outline,
              ),
              CustomTextField(
                controller: nameController,
                inputType: TextInputType.name,
                name: "nhập họ",
                prefixIcon: Icons.person_outline,
              ),
              CustomTextField(
                controller: emailController,
                inputType: TextInputType.none,
                name: " nhập Email",
                prefixIcon: Icons.email_outlined,
                isValid: checkConfirmEmail,
                errorName: mesErrorEmail,
              ),
              CustomTextField(
                controller: passwordController,
                inputType: TextInputType.none,
                name: "nhập mật khẩu",
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                isValid: checkConfirmPW,
                errorName: mesError,
              ),
              CustomTextField(
                controller: rePasswordController,
                inputType: TextInputType.none,
                name: "nhập lại mật khẩu",
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                isValid: checkConfirmPW,
                errorName: mesError,
              ),
              isLoading
                  ? CircularProgressIndicator()
                  :  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        if (!Checkletter().checkEmail(
                          emailController.text.toString(),
                        )) {
                          setState(() {
                            checkConfirmEmail = true;
                            mesErrorEmail = "email ko đúng định dạng!!";
                          });
                        }

                        if (passwordController.text.toString().trim().contains(
                          rePasswordController.text.toString().trim(),
                        )) {
                          if (!Checkletter().hasLettersAndNumbers(
                            passwordController.text.toString(),
                          )) {
                            setState(() {
                              checkConfirmPW = true;
                              mesError = "mật khẩu phải bao gồm chữ và số!!";
                            });
                          }
                          try {
                            UserCredential userCredential = await AuthService()
                                .signUp(
                                  emailController.text.toString().trim(),
                                  passwordController.text.toString().trim(),
                                );
                            await AuthService().saveUserDataLogin(
                              userCredential.user!.uid,
                              userCredential.user!.email.toString(),
                              nameController.text.toString(),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đăng ký thành công!'),
                                duration: Duration(
                                  seconds: 2,
                                ), // tự mất sau 2 giây
                              ),
                            );
                          } catch (e) {
                            print(e.toString());
                            // setState(() {
                            //   mesError = e.toString();
                            //   checkConfirmPW = true;
                            // });
                          }
                        } else {
                          setState(() {
                            checkConfirmPW = true;
                            mesError = "mật khẩu nhập lại ko giống nhau!!";
                          });
                        }
                      }
                    },
                    child: Text("Đăng kí"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
