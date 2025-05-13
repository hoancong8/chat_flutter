
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoappprovider/model/person.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> saveUserData(
    String uid,
    String email,
    String name,
    String url,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'uid': uid,
      'urlavatar': url,
      'createdAt': Timestamp.now(),
    });
  }

  Future<UserClient> getUserData(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      print("Tên: ${data['name']}");
      print("Email: ${data['email']}");
    } else {
      print("Người dùng không tồn tại");
    }
    return UserClient(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      urlImage: data['urlavatar']
    );
  }

  Future<void> getAllUsers(List<UserClient> users) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print("ID: ${doc.id}");
      print("Tên: ${data['name']}");
      print("Email: ${data['email']}");
      users.add(
        UserClient(uid: doc.id, name: data['name'], email: data['email'],urlImage: data['urlavatar']),
      );
      print("------");
    }
  }
  //   Future<void> getAllUsers(List<UserClient> users) async {
  //   QuerySnapshot snapshot =
  //       await FirebaseFirestore.instance.collection('users').get();

  //   users.clear(); // Xóa danh sách cũ nếu cần

  //   for (var doc in snapshot.docs) {
  //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //     users.add(UserClient(
  //       uid: doc.id,
  //       name: data['name'] ?? '',
  //       email: data['email'] ?? '',
  //     ));
  //   }
  // }
}
