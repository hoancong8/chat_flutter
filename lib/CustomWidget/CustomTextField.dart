import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String name, errorName;
  final IconData prefixIcon;
  final bool obscureText;
  final bool isValid;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final Widget? suffixIcon;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.name,
    this.errorName = "",
    required this.prefixIcon,
    this.obscureText = false,
    this.isValid = false,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    required this.inputType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isF = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkText);
    _checkText(); // gọi ban đầu nếu có sẵn text
  }

  void _checkText() {
    setState(() {
      isF = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.inputType,
        textCapitalization: widget.textCapitalization,
        maxLength: 32,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.errorName.isNotEmpty
                ? widget.errorName
                : "Vui lòng nhập $widget.name";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical:0, horizontal: 0),
          prefixIcon: Icon(widget.prefixIcon,size: 18,),
          suffixIcon: isF ? widget.suffixIcon : null,
        
          labelText: widget.name,
          counterText: "",
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
