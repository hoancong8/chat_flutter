
import 'package:demoappprovider/FirebaseService/AuthService.dart';
import 'package:demoappprovider/CustomWidget/CustomTextField.dart';
import 'package:demoappprovider/Interface/HomeChatScreen.dart';
import 'package:demoappprovider/FirebaseService/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // hoặc DefaultFirebaseOptions.currentPlatform
  runApp(MaterialApp(home: LoginScreen(), debugShowCheckedModeBanner: false));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // appBar: AppBar(title: const Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Đăng nhập",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              name: "Email",
              prefixIcon: Icons.email_outlined,
              inputType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.words,
            ),
            CustomTextField(
              controller: passwordController,
              name: "password",
              obscureText: true,
              prefixIcon: Icons.lock_outlined,
              inputType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.words,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: () {
                  print("Bạn đã nhấn vào");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const signUpScreen(),
                    ),
                  );
                },
                child: Text(
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
            ElevatedButton(
              onPressed: () async {
                try {
                  // await AuthService().getAllUsers();
                  UserCredential userCredential = await AuthService().signIn(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  CircularProgressIndicator();
                  String uid = userCredential.user!.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homechatscreen(uid: uid)),
                  );
                  
                  print("Đăng nhập thành công");
                  await AuthService().saveUserData(
                    uid,
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    "https://res.cloudinary.com/dlimibe4b/image/upload/v1746724184/yz6vmpwxrmij5qvi3upw.jpg"
                  );
                  await AuthService().getUserData(uid);

                  // Ví dụ: điều hướng sang trang chính
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                } catch (e) {
                  setState(() {
                    errorMessage = e.toString();
                  });
                }
              },
              child: const Text("Đăng nhập"),
            ),
            const SizedBox(height: 12),
            Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final emailController = TextEditingController();
  bool checkConfirmPW = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, leading: BackButton()),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 100),
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
              inputType: TextInputType.emailAddress,
              name: " nhập Email",
              prefixIcon: Icons.email_outlined,
            ),
            CustomTextField(
              controller: passwordController,
              inputType: TextInputType.emailAddress,
              name: "nhập mật khẩu",
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              isValid: checkConfirmPW,
              errorName: "confirm password invail",
            ),
            CustomTextField(
              controller: rePasswordController,
              inputType: TextInputType.emailAddress,
              name: "nhập lại mật khẩu",
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              isValid: checkConfirmPW,
              errorName: "mật khẩu không giống ở trên!!",
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (passwordController.text.toString().trim().contains(
                    rePasswordController.text.toString().trim(),
                  )) {
                    setState(() {
                      checkConfirmPW = false;
                    });
                    await AuthService().signUp(
                      emailController.text.toString().trim(),
                      passwordController.text.toString().trim(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đăng ký thành công!'),
                        duration: Duration(seconds: 2), // tự mất sau 2 giây
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                    print("huhuhuhu");
                  } else {
                    setState(() {
                      checkConfirmPW = true;
                    });

                    print("huhuhuh11u");
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text("Đăng kí"),
            ),
          ],
        ),
      ),
    );
  }
}
