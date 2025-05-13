
class UserClient {
  String urlImage;
  final String uid,email;
  final String name;
  String ho;
  UserClient({
    required this.uid,
    required this.name,
    this.urlImage = "",
    required this.email,
    this.ho = "",
  });
  // @override
  // String toString() {
  //   return 'UserClient(name: $name, email: $email)'; // Hoặc bạn có thể tùy chỉnh cách hiển thị
  // }
}