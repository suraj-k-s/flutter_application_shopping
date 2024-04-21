import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/widgets/sucess_easy.dart';

class ScreenSubCategory extends StatefulWidget {
  const ScreenSubCategory({super.key});

  @override
  State<ScreenSubCategory> createState() => _ScreenSubCategoryState();
}

class _ScreenSubCategoryState extends State<ScreenSubCategory> {
  final _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  DateTime selectedDate = DateTime.now();
  String categoryId = '0';

  int flagSaveUpdate = 0;
  TextEditingController subCategoryController = TextEditingController();
  List<Map<String, dynamic>> userDetails = [];
  String editId = '';
  final companynameController = TextEditingController();
  final addressController = TextEditingController();
  final emController = TextEditingController();

  final mobController = TextEditingController();
  final gstController = TextEditingController();

  List<Map<String, dynamic>> subCategoryList = [];
  Future<void> addCategory() async {
    
    try {
      ScreenLoader().screenLoaderSuccessFailStart();

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('subcategory').add({
        'category_id': categoryId,
        'subcategory': subCategoryController.text,
        'subcategory_lower':subCategoryController.text.toLowerCase(),
      });

      subCategoryController.text = '';

      setState(() {
        editId = '';
        flagSaveUpdate = 0;
      });
      getSubCategory();
      ScreenLoader().screenLoaderDismiss('1', 'Item Added');
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Oops Something went wrong $e');
    }
  }

  Future<void> getSubCategory() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('subcategory').get();
      List<Map<String, dynamic>> subcategory = [];
      for (var doc in querySnapshot.docs) {
        try {
          Map<String, dynamic>? categoryData =
              await getCategory(doc['category_id']);
          if (categoryData != null) {
            subcategory.add({
              'id': doc.id,
              'subcategory': doc['subcategory'].toString(),
              'category': categoryData['category'],
              'category_id': categoryData['collectionId'],
            });
          }
        } catch (e) {
          // ignore: avoid_print
          print(e);
        }
        setState(() {
          subCategoryList = subcategory;
        });
      }
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Oops Something went wrong $e');
    }
  }

  Future<Map<String, dynamic>?> getCategory(String collectionId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('category')
          .doc(collectionId)
          .get();
      if (docSnapshot.exists) {
        final categoryValue = docSnapshot.data()?['category'];
        final collectionId = docSnapshot.id;
        return {'category': categoryValue, 'collectionId': collectionId};
      } else {
        return null;
      }
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Oops Something went wrong $e');
    }
    return null;
  }

  Future<void> editSaveSubCategory() async {
    ScreenLoader().screenLoaderSuccessFailStart();
    Map<String, dynamic> newItem = {
      'category_id': categoryId,
      'subcategory': subCategoryController.text,
       'subcategory_lower':subCategoryController.text.toLowerCase(),
    };
    try {
      db.collection('subcategory').doc(editId).update(newItem).then((_) {
        setState(() {
          editId = '';
          flagSaveUpdate = 0;
        });
        subCategoryController.text = '';
        categoryId = '0';
        getSubCategory();
       ScreenLoader().screenLoaderDismiss('1', 'Item Updated');
      });
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Oops Something went wrong $e');
    }
  }

  Future<void> deleteSubCategory() async {
    bool subcategoryDelete = false;
    try {
      ScreenLoader().screenLoaderSuccessFailStart();
      await FirebaseFirestore.instance
          .collection('items')
          .where('subcategory_id', isEqualTo: editId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          subcategoryDelete = true;
        }
      });
      if (subcategoryDelete) {
        ScreenLoader().screenLoaderDismiss('2', '');
        final snackBar = SnackBar(
          content: const Text(
              'Deletion not permitted due to Foreign Key Constraints. Please delete the child'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        db.collection('subcategory').doc(editId).delete().then((_) {
          setState(() {
            editId = '';
            flagSaveUpdate = 0;
          });
          subCategoryController.text = '';
          getSubCategory();
         ScreenLoader().screenLoaderDismiss('1', 'Item Deleted');
        });
      }
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Oops Something went wrong $e');
    }
  }

  @override
  void initState() {
    getSubCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(
            onPressed: () {
              ScreenLoader().screenLoaderSuccessFailStart();
              Navigator.of(context).pop();
              ScreenLoader().screenLoaderDismiss('2', '');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          'Sub Category Registration',
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
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('category')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<DropdownMenuItem> categoryItems = [];
                    if (!snapshot.hasData) {
                      const CircularProgressIndicator();
                    } else {
                      final categoryAll = snapshot.data?.docs.reversed.toList();
                      categoryItems.add(const DropdownMenuItem(
                          value: '0', child: Text('Select a Category')));
                      for (var c in categoryAll!) {
                        categoryItems.add(DropdownMenuItem(
                            value: c.id, child: Text(c['category'])));
                      }
                    }
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 00, right: 00, top: 15),
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(),
                            ),
                          ),
                          value: categoryId,
                          hint: const Text('Select Category'),
                          items: categoryItems,
                          onChanged: (value) {
                            setState(() {
                              categoryId = value;
                            });
                          }),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                    controller: subCategoryController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Sub Category cannot be empty!';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Sub Category Name",
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            flagSaveUpdate = 0;
                            subCategoryController.text = '';
                          });
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(125, 50),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Text('Cancel')),
                    const SizedBox(
                      width: 30,
                    ),
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (flagSaveUpdate == 0) {
                              addCategory();
                            } else {
                              editSaveSubCategory();
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(125, 50),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: Text(flagSaveUpdate == 0 ? 'Add' : 'Save'))
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: subCategoryList.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> data = subCategoryList[index];
                    return ListTile(
                      title: Text(data['subcategory']),
                      subtitle: Row(
                        children: [
                          Text(data['category']),
                          IconButton(
                              onPressed: () {
                                subCategoryController.text =
                                    data['subcategory'];
                                setState(() {
                                  flagSaveUpdate = 1;
                                  editId = data['id'];
                                  categoryId = data['category_id'];
                                });
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                editId = data['id'];
                                deleteSubCategory();
                              },
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
