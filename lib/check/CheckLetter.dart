class Checkletter {
  bool hasLettersAndNumbers(String input) {
    final letterReg = RegExp(r'[A-Za-z]');
    final numberReg = RegExp(r'[0-9]');
    return letterReg.hasMatch(input) && numberReg.hasMatch(input);
  }

  bool checkEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
    ;
  }
}
