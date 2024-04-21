import 'package:flutter/material.dart';

class TestAddItem extends StatefulWidget {
  const TestAddItem({super.key});

  @override
  State<TestAddItem> createState() => _TestAddItemState();
}

class _TestAddItemState extends State<TestAddItem> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Form(
            
            child: Column(
              
            ) 
            )

        ],
      ),
    );
  }
}