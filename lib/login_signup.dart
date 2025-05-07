import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoappprovider/CustomTextField.dart';
import 'package:demoappprovider/firebase_options.dart';
import 'package:demoappprovider/firebasetest.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  ); // hoặc DefaultFirebaseOptions.currentPlatform
  runApp(MaterialApp(home: LoginScreen(),debugShowCheckedModeBanner: false,));
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng ký tài khoản mới
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Đăng nhập
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Lấy người dùng hiện tại
  User? get currentUser => _auth.currentUser;

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> saveUserData(String uid, String email, String name) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> getUserData(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      print("Tên: ${data['name']}");
      print("Email: ${data['email']}");
    } else {
      print("Người dùng không tồn tại");
    }
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  String errorMessage = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      nameController.addListener(() {
        print(nameController.text.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Đăng nhập", textAlign: TextAlign.center,style: TextStyle(fontSize: 18,),),
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
                    MaterialPageRoute(builder: (context) => const signUpScreen()),
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

            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await AuthService().signIn(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  String uid = userCredential.user!.uid;
                  print("Đăng nhập thành công");
                  await AuthService().saveUserData(
                    uid,
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  await AuthService().getUserData(uid);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
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
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final emailController = TextEditingController();
  bool eyebt = true;
  bool clearE = true;
  bool clearPW = true;
  bool clearRPW = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.addListener(
      () => {
        setState(() {
          print(emailController.text.toString());
          //hoan số 1
        }),
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Đăng kí"),
          TextField(
            controller: emailController,

            decoration: InputDecoration(
              labelText: "nhập email",
              suffixIcon: SizedBox(
                child: Visibility(
                  visible: true,
                  child: IconButton(
                    onPressed: () => {emailController.clear()},
                    icon: Icon(Icons.clear),
                  ),
                ),
              ),
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "nhập mật khẩu",
              suffixIcon: SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed:
                          () => {
                            setState(() {
                              if (eyebt) {
                                eyebt = false;
                              } else {
                                eyebt = true;
                              }
                            }),
                          },
                      icon:
                          eyebt
                              ? Icon(Icons.remove_red_eye_rounded)
                              : Icon(Icons.remove_red_eye_outlined),
                    ),
                  ],
                ),
              ),
            ),
            obscureText: eyebt,
          ),
          TextField(
            controller: rePasswordController,
            decoration: InputDecoration(
              labelText: "nhập lại mật khẩu",
              suffixIcon: SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed:
                          () => {
                            setState(() {
                              if (eyebt) {
                                eyebt = false;
                              } else {
                                eyebt = true;
                              }
                            }),
                          },
                      icon:
                          eyebt
                              ? Icon(Icons.remove_red_eye_rounded)
                              : Icon(Icons.remove_red_eye_outlined),
                    ),
                    // IconButton(onPressed: ()=>{}), icon: )
                  ],
                ),
              ),
            ),
            obscureText: eyebt,
          ),
          ElevatedButton(onPressed: () => {}, child: Text("Đăng kí")),
        ],
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
