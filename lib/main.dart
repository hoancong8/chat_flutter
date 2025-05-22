import 'package:demoappprovider/FirebaseService/firebase_options.dart';
import 'package:demoappprovider/Interface/HomeChatScreen.dart';
import 'package:demoappprovider/Interface/LogIn.dart';
import 'package:demoappprovider/Interface/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   ); // hoặc DefaultFirebaseOptions.currentPlatform
//   runApp(
//     MaterialApp(
//       theme: ThemeData(
//         useMaterial3: false, // Tắt Material3 nếu bạn không cần
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.white,

//           iconTheme: IconThemeData(color: Colors.black),
//           titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//       ),
//       home: LoginScreen(),
//       debugShowCheckedModeBanner: false,
//     ),
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // hoặc DefaultFirebaseOptions.currentPlatform
  // shared_preferences 
  runApp(
    MyApp(isLoggedIn: true)
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key,required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/login',
      redirect: (BuildContext context,GoRouterState state) {
        final goingToLogin = state.uri.toString() == '/login';
        // if(isLoggedIn&&goingToLogin){
        //   return '/login/home/:uid';
        // }
        // else {
        //   return '/login';
        // }
        return null;
        
      },
      routes: [
        GoRoute(path: '/login',builder: (context, state) => LoginScreen(),),
        GoRoute(path: '/signup',builder: (context, state) => signUpScreen(),),
        GoRoute(path: '/login/home/:uid',builder:(context,state){
          final uid = state.pathParameters['uid'];
          return Homechatscreen(uid: uid!);
        }),

      ],
    );
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: false, // Tắt Material3 nếu bạn không cần
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        ),
        
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


// // nhà cung cấp
// class CounterHome extends ChangeNotifier {
//   int counter = 100;
//   int get _counter => counter;
//   void add() {
//     counter++;
//     notifyListeners();
//   }
// }


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(), // home là màn hình đầu tiên
//     );
//   }
// }


// //screen 1
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(context.watch<CounterHome>()._counter.toString()),
//             SizedBox(width: 20),
//             FloatingActionButton(
//               backgroundColor: Colors.amber,
//               child: Icon(Icons.add, size: 20),
//               onPressed: () {
//                 context.read<CounterHome>().add();
//               },
//             ),
//             SizedBox(width: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => SecondScreen()),
//                 );
//               },
//               child: Text("Chuyển"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// //screen 2
// class SecondScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Màn hình 2")),
//       body: Center(
//         child: Text("Counter: ${context.watch<CounterHome>()._counter}"),
//       ),
//     );
//   }
// }
