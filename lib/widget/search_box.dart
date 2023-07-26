import 'package:flutter/material.dart';

import '../value/app_string.dart';

class SearchBox extends StatelessWidget {

  final IconButton iconButton;

  const SearchBox({super.key,required this.iconButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: TextField(
          cursorColor: Colors.black87,
          decoration: InputDecoration(
              hintText: AppString.search,
              suffixIcon: iconButton,
              border: const OutlineInputBorder(borderSide: BorderSide.none))),
    );
  }
}