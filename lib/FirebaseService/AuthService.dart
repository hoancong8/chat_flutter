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

  Future<void> saveUserDataLogin(String uid, String email, String name) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'uid': uid,
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  Future<void> saveUserDataUrl(String uid, String url) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'urlavatar': url,
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  
  Future<UserClient> getUserData(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      print("Tên: ${data['name']}");
      print("Email: ${data['email']}");

      return UserClient(
        uid: data['uid'],
        name: data['name'] ?? "không có tên",
        email: data['email'] ?? "không có email",
        urlImage: data['urlavatar']??"",
      );
    } else {
      print("Người dùng không tồn tại");
      throw Exception("Người dùng không tồn tại");
    }
  }


  Future<void> getAllUsers(List<UserClient> users, String IPuid) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (var doc in snapshot.docs) {
        print("🎯 Dữ liệu thô: ${doc.data()}");
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String uid = doc.id;
        String name = data['name'] ?? '';
        String email = data['email'] ?? '';
        String avatar = data['urlavatar'] ?? '';
        if (uid!=IPuid) {
          users.add(
            UserClient(uid: uid, name: name, email: email, urlImage: avatar),
          );
        }
      }
    } catch (e) {
      print("Lỗi khi lấy danh sách người dùng: $e");
    }
  }
}
