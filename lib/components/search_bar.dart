import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const MySearchBar({Key? key, required this.onChanged, required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: 60,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              const Icon(Icons.search),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(fontSize: 12),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
