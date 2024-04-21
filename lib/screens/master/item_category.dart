import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/widgets/sucess_easy.dart';

class ScreenItemCategory extends StatefulWidget {
  const ScreenItemCategory({super.key});

  @override
  State<ScreenItemCategory> createState() => _ScreenItemCategoryState();
}

class _ScreenItemCategoryState extends State<ScreenItemCategory> {
  final _formKey = GlobalKey<FormState>();
  bool itemVisibility = true;

  List<Map<String, dynamic>> userDetails = [];

  int flagSaveUpdate = 0;
  final db = FirebaseFirestore.instance;
  String editId = '';
  String searchCategory = '';
  final categoryController = TextEditingController();
  final categorySearchController = TextEditingController();
  Future<void> addCategory() async {
    String categoryLowerCase = categoryController.text;
    try {
      ScreenLoader().screenLoaderSuccessFailStart();
      final user = FirebaseAuth.instance.currentUser;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('category').add({
        'category': categoryController.text,
        'category_lower_case': categoryLowerCase.toLowerCase()
      });

      categoryController.text = '';

      setState(() {
        editId = '';
        flagSaveUpdate = 0;
      });
      ScreenLoader().screenLoaderDismiss('1', 'Item Added');
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Oops Some thing went wrong $e');
    }
  }

  Future<void> editSaveCategory() async {
    String categoryLowerCase = categoryController.text;
    Map<String, dynamic> newCategory = {
      'category': categoryController.text,
      'category_lower_case': categoryLowerCase.toLowerCase()
    };
    try {
      ScreenLoader().screenLoaderSuccessFailStart();
      db.collection('category').doc(editId).update(newCategory).then((_) {
        setState(() {
          editId = '';
          flagSaveUpdate = 0;
        });
        categoryController.text = '';
        ScreenLoader().screenLoaderDismiss('1', 'Item Updated');
      });
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Oops Some thing went wrong $e');
    }
  }

  Future<void> deleteCategory() async {
    try {
      ScreenLoader().screenLoaderSuccessFailStart();
      bool deleteCategory = false;
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('subcategory').get();
      for (var doc in querySnapshot.docs) {
        if (doc['category_id'] == editId) {
          deleteCategory = true;
        }
      }
      if (deleteCategory) {
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
        db.collection('category').doc(editId).delete().then((_) {
          setState(() {
            editId = '';
            flagSaveUpdate = 0;
          });
          categoryController.text = '';

          ScreenLoader().screenLoaderDismiss('1', 'Item deleted!');
        });
      }
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Oops Some thing went wrong $e');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchDataStream() {
    if (searchCategory == '') {
      Query<Map<String, dynamic>> collection = FirebaseFirestore.instance
          .collection('category')
          .orderBy('category_lower_case', descending: false);

      return collection.snapshots();
    } else {
      Query<Map<String, dynamic>> collection = FirebaseFirestore.instance
          .collection('category')
          .where('category_lower_case', isGreaterThanOrEqualTo: searchCategory)
          .where('category_lower_case', isLessThan: '${searchCategory}z')
          .orderBy('category_lower_case', descending: false);

      return collection.snapshots();
    }
  }

  @override
  void initState() {
    searchCategory = '';
    itemVisibility = true;
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
          'Item Category',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
              fontSize: 20,
              color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            itemVisibility = false;
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Column(
            children: [
              Visibility(
                visible: itemVisibility,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                          controller: categoryController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Category cannot be empty!';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Category",
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
                                  categoryController.text = '';
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
                                  if (flagSaveUpdate == 0) {
                                    addCategory();
                                  } else {
                                    editSaveCategory();
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
                                  ? 'Add Category'
                                  : 'Save Category'))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !itemVisibility,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              searchCategory = categorySearchController.text;
                            });
                          },
                          controller: categorySearchController,
                          decoration: InputDecoration(
                            labelText: "Search Category",
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
                                  itemVisibility = true;
                                  categorySearchController.text = '';
                                  searchCategory = '';
                                });
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.indigo,
                                  fixedSize: const Size(125, 50),
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              child: const Text('Cancel Search')),
                          const SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: fetchDataStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // return CircularProgressIndicator();
                    }
                    if (snapshot.data != null) {
                      List<QueryDocumentSnapshot> documents =
                          snapshot.data!.docs;

                      return Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          final documentId = snapshot.data!.docs[index].id;
                          var data =
                              documents[index].data() as Map<String, dynamic>;
                          final String categoryNameUpper = data['category'];
                          return ListTile(
                            title: Row(
                              children: [
                                Text(data['category']),
                                const SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                    onPressed: () {
                                      categoryController.text =
                                          data['category'];
                                      setState(() {
                                        flagSaveUpdate = 1;
                                        editId = documentId;
                                      });
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      editId = documentId;
                                      deleteCategory();
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                          );
                        },
                        separatorBuilder: ((context, index) {
                          return const Divider();
                        }),
                        itemCount: documents.length,
                      ));
                    } else {
                      return const Text('');
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
