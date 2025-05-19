import 'package:demoappprovider/FirebaseService/AuthService.dart';
import 'package:demoappprovider/CustomWidget/CustomTextField.dart';
import 'package:demoappprovider/Interface/HomeChatScreen.dart';
import 'package:demoappprovider/Interface/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  String errorMessage = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 100),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Đăng nhập", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                name: "Email",
                prefixIcon: Icons.email_outlined,
                inputType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                errorName: "Email không hợp lệ",
                isValid: false,
                suffixIcon: closeIcon(context, emailController),
              ),
              CustomTextField(
                controller: passwordController,
                name: "Mật khẩu",
                obscureText: _obscureText,
                prefixIcon: Icons.lock_outlined,
                inputType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.none,
                errorName: "Mật khẩu không được để trống",
                isValid: false,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    closeIcon(context, passwordController),
                    hidePassword(context, passwordController, _obscureText,(){
                      setState(() {
                        _obscureText=!_obscureText;
                      });
                    }),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const signUpScreen()),
                    );
                  },
                  child: const Text(
                    "Chưa có tài khoản? Đăng ký",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        try {
                          final userCredential = await AuthService().signIn(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                          if(userCredential!=null){
                          //   Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) => Homechatscreen(
                          //           uid: userCredential.user!.uid,
                          //         ),
                          //   ),
                          // );
                          GoRouter.of(context).go('/login/home/${userCredential.user!.uid}');
                          }
                          
                        } catch (e) {
                          setState(() {
                            errorMessage = e.toString();
                            isLoading = false;
                          });
                        }
                      }
                    },
                    child: const Text("Đăng nhập"),
                  ),
              const SizedBox(height: 12),
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget closeIcon(BuildContext context, TextEditingController controller) {
  return IconButton(
    onPressed: () {
      controller.clear();
    },
    icon: Icon(Icons.close_outlined),
  );
}

Widget hidePassword(
  BuildContext context,
  TextEditingController controller,
  bool _obscureText,
  VoidCallback action,
) {
  return IconButton(
    onPressed: action,
    icon:
        _obscureText
            ? Icon(Icons.remove_red_eye_rounded)
            : Icon(Icons.remove_red_eye_outlined),
  );
}
