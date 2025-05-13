import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String name, errorName;
  final IconData prefixIcon;
  bool obscureText, isValid;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.name,
    this.errorName = "",
    required this.prefixIcon,
    this.obscureText = false,
    this.isValid = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    // Lắng nghe khi text thay đổi
    widget.controller.addListener(() {
      setState(() {
        _hasText = widget.controller.text.isNotEmpty;
        widget.isValid = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: widget.controller,

        obscureText: widget.obscureText,
        keyboardType: widget.inputType,
        textCapitalization: widget.textCapitalization,
        maxLength: 32,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIcon),
          suffixIcon:
              (_hasText)
                  ? IconButton(
                    onPressed: () {
                      widget.controller.clear();
                      FocusScope.of(
                        context,
                      ).requestFocus(_focusNode); // giữ focus
                    },
                    icon: const Icon(Icons.close_outlined),
                  )
                  : null,
          isDense: true,
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
          errorText: widget.isValid ? widget.errorName : null,
        ),
      ),
    );
  }
}
