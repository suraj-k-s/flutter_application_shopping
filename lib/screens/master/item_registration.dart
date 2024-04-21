import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/widgets/sucess_easy.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:flutter_glow/flutter_glow.dart';

class ScreenItemRegistration extends StatefulWidget {
  const ScreenItemRegistration({super.key});

  @override
  State<ScreenItemRegistration> createState() => _ScreenItemRegistrationState();
}

class _ScreenItemRegistrationState extends State<ScreenItemRegistration> {
  final _formKey = GlobalKey<FormState>();
  bool itemVisibility = false;
  DateTime selectedDate = DateTime.now();
  late String country = "";
  final String doc = "";
  List<Map<String, dynamic>> userDetails = [];
  final hsnController = TextEditingController();
  final itemnameController = TextEditingController();
  final qtyController = TextEditingController();
  final stockController = TextEditingController();
  final urateController = TextEditingController();
  int flagSaveUpdate = 0;
  final db = FirebaseFirestore.instance;
  String editId = '';
  String updateImage = '';
  XFile? _selectedImage;
  String categoryId = '0';
  String subcategoryId = '0';
  List<DropdownMenuItem> subCategoryItems = [];

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (PickedFile != null) {
      setState(() {
        ScreenLoader().screenLoaderSuccessFailStart();
        _selectedImage = XFile(pickedFile!.path);
        ScreenLoader().screenLoaderDismiss('2', '');
      });
    }
  }

  Future<void> addItem() async {
    String itemLower=itemnameController.text;
    try {
      ScreenLoader().screenLoaderSuccessFailStart();
      final user = FirebaseAuth.instance.currentUser;
      final userID = user?.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference itemRef = await firestore.collection('items').add({
        'hsn': hsnController.text,
        'item_name': itemnameController.text,
        'item_lower_case': itemLower.toLowerCase(),
        'quantity': '0',
        'unit_rate': urateController.text,
        'category_id': categoryId,
        'subcategory_id': subcategoryId
        // Add more fields as needed
      });

      String docId = itemRef.id;

      await uploadUserImage(docId);
      ScreenLoader().screenLoaderDismiss('1', 'Item Added Sucessfully');
      hsnController.text = '';
      itemnameController.text = '';
      qtyController.text = '';
      urateController.text = '';

      setState(() {
        editId = '';
        flagSaveUpdate = 0;
        _selectedImage = null;
        updateImage = '';
        categoryId = '0';
      });
      
      
    }
    // ignore: empty_catches
    catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Something went wrong $e');
    }
  }

  Future<void> uploadUserImage(String userId) async {
    try {
      if (_selectedImage != null) {
        Reference ref =
            FirebaseStorage.instance.ref().child('user_images/$userId.jpg');
        UploadTask uploadTask = ref.putFile(File(_selectedImage!.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('items')
            .doc(userId)
            .update({
          'imageUrl': imageUrl,
        });
      }
    } catch (e) {
       ScreenLoader().screenLoaderDismiss('0', 'Something went wrong $e');
    }
  }

  Future<void> editSaveItem() async {
     String itemLower=itemnameController.text;
    ScreenLoader().screenLoaderSuccessFailStart();
    Map<String, dynamic> newItem = {
      'hsn': hsnController.text,
      'item_name': itemnameController.text,
       'item_lower_case': itemLower.toLowerCase(),
      'unit_rate': urateController.text,
      'category_id': categoryId,
      'subcategory_id': subcategoryId
    };
    try {
      await db.collection('items').doc(editId).update(newItem).then((_) {
        if (_selectedImage != null) {
          uploadUserImage(editId);
        }
        setState(() {
          editId = '';
          flagSaveUpdate = 0;
          _selectedImage = null;
          updateImage = '';
          categoryId = '0';
          subcategoryId = '0';
        });
        hsnController.text = '';
        itemnameController.text = '';
        qtyController.text = '';
        urateController.text = '';
        ScreenLoader().screenLoaderDismiss('1', 'Item updated');
      });
    } catch (e) {ScreenLoader().screenLoaderDismiss('0', 'Something went wrong $e');}
  }

  Future<void> deleteItem() async {
    try{
      ScreenLoader().screenLoaderSuccessFailStart();
      db.collection('items').doc(editId).delete().then((_) {
      setState(() {
        editId = '';
        flagSaveUpdate = 0;
        _selectedImage = null;
        updateImage = '';
      });
      hsnController.text = '';
      itemnameController.text = '';
      qtyController.text = '';
      urateController.text = '';
      ScreenLoader().screenLoaderDismiss('1', 'Item Deleted');
    });
    }
    catch(e)
    {
ScreenLoader().screenLoaderDismiss('0', 'Something went wrong $e');
    }
  }

  Future<void> getSubCategoryID(String id) async {
    subcategoryId = '0';
    String newID = '';
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('subcategory').get();
      for (var doc in querySnapshot.docs) {
        try {
          if (doc.id == id) {
            newID = doc.id;
          }
        } catch (e) {
          ScreenLoader().screenLoaderDismiss('0', 'Something went wrong $e');
        }
      }

      setState(() {
        subcategoryId = newID;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> stockUpdate() async {
    int existingStock = 0, updatedStock = 0;
    
    try {
      ScreenLoader().screenLoaderSuccessFailStart();
      final itemData =
          await FirebaseFirestore.instance.collection('items').doc(editId);
      final documentSnapshot = await itemData.get();
      if (documentSnapshot.exists) {
        final item = documentSnapshot.data();
        existingStock = int.parse(item?['quantity']);
        updatedStock = existingStock + int.parse(stockController.text);
        Map<String, dynamic> newItem = {'quantity': updatedStock.toString()};
        try {
          db.collection('items').doc(editId).update(newItem).then((_) {
           
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => const ScreenItemRegistration()));
                ScreenLoader().screenLoaderDismiss('1', 'Stock Updated');
          });
         setState(() {
            stockController.text='0';
         });
        } catch (e) {ScreenLoader().screenLoaderDismiss('0', 'Something went wrong $e');}
      }
    } catch (e) {ScreenLoader().screenLoaderDismiss('0', 'Something went wrong $e');}
  }

  Future<void> getsubCategory(String id) async {
    subcategoryId = '0';
    try {
      List<DropdownMenuItem> sub_CategoryItems = [];
      subCategoryItems = [];
      FirebaseFirestore.instance
          .collection('subcategory')
          .where('category_id', isEqualTo: id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        sub_CategoryItems.add(const DropdownMenuItem(
            value: '0', child: Text('Select a Sub Category')));
        for (var doc in querySnapshot.docs) {
          //print(doc['subcategory']);
          sub_CategoryItems.add(
              DropdownMenuItem(value: doc.id, child: Text(doc['subcategory'])));
        }

        setState(() {
          subCategoryItems = sub_CategoryItems;
        });
      });
      // ignore: empty_catches
    } catch (e) {}
  }
@override
  void initState() {
   
  setState(() {
     stockController.text='0';
  });
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
            'Item Registration',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                fontSize: 20,
                color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: Center(
                          child: GlowContainer(
                            glowColor: Colors.purple,
                            shape: BoxShape.circle,
                            child: CircleAvatar(
                              backgroundImage: _selectedImage != null
                                  ? FileImage(File(_selectedImage!.path))
                                  : flagSaveUpdate == 1
                                      ? NetworkImage(updateImage)
                                      : const AssetImage('assets/add-item.png')
                                          as ImageProvider,
                              radius: 60,
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('category')
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<DropdownMenuItem> categoryItems = [];
                            if (!snapshot.hasData) {
                              const CircularProgressIndicator();
                            } else {
                              final categoryAll =
                                  snapshot.data?.docs.reversed.toList();
                              categoryItems.add(const DropdownMenuItem(
                                  value: '0',
                                  child: Text('Select a Category')));
                              for (var c in categoryAll!) {
                                categoryItems.add(DropdownMenuItem(
                                    value: c.id, child: Text(c['category'])));
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 15),
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
                                      ScreenLoader().screenLoaderSuccessFailStart();
                                      getsubCategory(categoryId);
                                      ScreenLoader().screenLoaderDismiss('2', '');
                                    });
                                  }),
                            );
                          }),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 15),
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(),
                              ),
                            ),
                            value: subcategoryId,
                            hint: const Text('Select Sub Category'),
                            items: subCategoryItems,
                            onChanged: (newvalue) {
                              setState(() {
                                subcategoryId = newvalue;
                              });
                            }),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 15),
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: hsnController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'HSN cannot be empty!';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "HSN Code",
                              fillColor: Colors.blue,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(),
                              ),
                            )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 15),
                        child: TextFormField(
                            controller: itemnameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Item Name cannot be empty!';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Item Name",
                              fillColor: Colors.blue,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(),
                              ),
                            )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 15),
                        child: TextFormField(
                            controller: urateController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Unit Rate cannot be empty!';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Unit Rate",
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
                                  ScreenLoader().screenLoaderSuccessFailStart();
                                  ScreenLoader().screenLoaderDismiss('3', '');
                                  setState(() {
                                    flagSaveUpdate = 0;
                                    hsnController.text = '';
                                    itemnameController.text = '';
                                    qtyController.text = '';
                                    urateController.text = '';
                                    categoryId = '0';
                                    subcategoryId = '0';
                                  });
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.indigo,
                                    fixedSize: const Size(125, 50),
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                child: const Text('Cancel')),
                            const SizedBox(
                              width: 30,
                            ),
                            TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (categoryId == '0') {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            'Please select product category.'),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    if (subcategoryId == '0') {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            'Please select product sub category.'),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    if (_selectedImage == null &&
                                        editId == '') {
                                      final snackBar = SnackBar(
                                        content: const Text(
                                            'Please select product image.'),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      if (flagSaveUpdate == 0) {
                                        addItem();
                                      } else {
                                        editSaveItem();
                                      }
                                    }
                                  }
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.indigo,
                                    fixedSize: const Size(125, 50),
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                child: Text(flagSaveUpdate == 0
                                    ? 'Add Item'
                                    : 'Save Item'))
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                    ],
                  )),
              StreamBuilder(
                  stream: db.collection('items').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> data =
                                snapshot.data!.docs[index].data();

                            final documentId = snapshot.data!.docs[index].id;
                            // test();
                            return ListTile(
                              leading: Image(
                                image: data['imageUrl'] == null
                                    ? const AssetImage('assets/loading.gif')
                                        as ImageProvider
                                    : NetworkImage(data['imageUrl']),
                              ),
                              title: Row(
                                children: [
                                  Text(data['item_name']),
                                  Text(
                                    '  \u{20B9}${data['unit_rate']}',
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 18),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    'HSN ${data['hsn']}',
                                    style: const TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        hsnController.text = data['hsn'];
                                        itemnameController.text =
                                            data['item_name'];
                                        //qtyController.text = data['quantity'];
                                        urateController.text =
                                            data['unit_rate'];
                                        setState(() {
                                          flagSaveUpdate = 1;
                                          editId = documentId;
                                          updateImage = data['imageUrl'];
                                          categoryId = data['category_id'];
                                        });
                                        getsubCategory(categoryId);
                                        getSubCategoryID(
                                            data['subcategory_id']);
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        editId = documentId;
                                        deleteItem();
                                      },
                                      icon: const Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: () {
                                        
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Enter new Stock Value'),
                                              content: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30,
                                                    right: 30,
                                                    top: 15),
                                                child: TextFormField(
                                                    controller: stockController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Stock cannot be empty!';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: "Stock Value",
                                                      fillColor: Colors.blue,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25.0),
                                                        borderSide:
                                                            const BorderSide(),
                                                      ),
                                                    )),
                                              ),
                                              actions: [
                                                 TextButton(
                                                  onPressed: () {
                                                   print('hi');
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    editId = documentId;
                                                    
                                                    stockUpdate();
                                                   
                                                  },
                                                  child: const Text('Update'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.update)),
                                ],
                              ),
                            );
                          });
                    }
                  })
            ],
          ),
        ));
  }

  void test() {
    print('Test hello');
  }
}
