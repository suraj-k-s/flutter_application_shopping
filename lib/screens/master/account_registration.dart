import 'package:flutter/material.dart';

class ScreenAccountRegistration extends StatefulWidget {
  const ScreenAccountRegistration({super.key});

  @override
  State<ScreenAccountRegistration> createState() => _ScreenAccountRegistrationState();
}

class _ScreenAccountRegistrationState extends State<ScreenAccountRegistration> {
  final _formKey = GlobalKey<FormState>();
  bool itemVisibility = false;
  DateTime selectedDate = DateTime.now();
  late String country = "";
  final String doc = "";
  List<Map<String, dynamic>> userDetails = [];

  final itemnameController = TextEditingController();
  final hsnpercentageController = TextEditingController();
  final emController = TextEditingController();

  final mobController = TextEditingController();
  final gstController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          'Account Registration',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
              fontSize: 20,
              color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Choose a valid Company!';
                      } else {
                        return null;
                      }
                    },
                    hint: const Text('BPM Home Shoppee'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    items: [
                      "BPM Home Shoppee",
                    ]
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        country = value!;
                      });
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Choose a valid Company!';
                      } else {
                        return null;
                      }
                    },
                    hint: const Text('Type'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    items: [
                      "Profit",
                    ]
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        country = value!;
                      });
                    },
                  )),
              
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                    controller: itemnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Head cannot be empty!';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Account Head",
                      fillColor: Colors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                 
                    controller: hsnpercentageController,
                    decoration: InputDecoration(
                      labelText: "Opening",
                      fillColor: Colors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // addUserData();
                          }
                        },
                        style: TextButton.styleFrom(
                          
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(75, 30),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Icon(Icons.add,
                        color: Colors.white,
                        )),
                        TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // addUserData();
                          }
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(75, 30),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Icon(Icons.save,
                        color: Colors.white,
                        )),
                        TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // addUserData();
                          }
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(75, 30),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Icon(Icons.edit_note,
                        color: Colors.white,
                        )),
                        TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // addUserData();
                          }
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(75, 30),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Icon(Icons.delete,
                        color: Colors.white,
                        )),
                  ],
                  
                ),
              ),
              const Divider(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // addUserData();
                          }
                        },
                        style: TextButton.styleFrom(
                          
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(75, 30),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Icon(Icons.arrow_circle_left_outlined,
                        color: Colors.white,
                        )),
                        TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // addUserData();
                          }
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(75, 30),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Icon(Icons.arrow_back_sharp,
                        color: Colors.white,
                        )),
                        TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // addUserData();
                          }
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(75, 30),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Icon(Icons.arrow_forward_outlined,
                        color: Colors.white,
                        )),
                        TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // addUserData();
                          }
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(75, 30),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Icon(Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                        )),
                  ],
                  
                ),
              Visibility(
                visible: itemVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.82,
                      height: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: const [
                            BoxShadow(
                                //offset: Offset(0, 4),
                                color: Colors.grey, //edited
                                spreadRadius: 2,
                                blurRadius: 10 //edited
                                )
                          ]),
                      // ignore: prefer_const_constructors
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.indigo,
                              ),
                              Text(
                                'Account',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              )
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Choose a valid HSN!';
                                  } else {
                                    return null;
                                  }
                                },
                                hint: const Text('Select Account'),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                items: ["Sundry", "Tax", "Cooly"]
                                    .map((label) => DropdownMenuItem(
                                          value: label,
                                          child: Text(label),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    country = value!;
                                  });
                                },
                              )),
                             
                              
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        itemVisibility = false;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.indigo,
                                        fixedSize: const Size(125, 50),
                                        textStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    child: const Text('Close')),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            itemVisibility = true;
          });
        },
        tooltip: 'Search an Item',
        // ignore: sort_child_properties_last
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
