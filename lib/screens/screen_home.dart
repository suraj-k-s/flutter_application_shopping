//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/screens/master/account_registration.dart';
import 'package:flutter_application_shopping/screens/master/asset_registration.dart';
import 'package:flutter_application_shopping/screens/master/orders.dart';
import 'package:flutter_application_shopping/screens/master/stock_update.dart';
import 'package:flutter_application_shopping/screens/master/item_category.dart';
import 'package:flutter_application_shopping/screens/master/item_registration.dart';
import 'package:flutter_application_shopping/screens/master/personal_registration.dart';
import 'package:flutter_application_shopping/screens/master/subcategory_registration.dart';
import 'package:flutter_application_shopping/screens/master/test.dart';
import 'package:flutter_application_shopping/screens/screen_login.dart';
import 'package:flutter_application_shopping/widgets/sucess_easy.dart';

class ScreenHome extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
 
   const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.indigo,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             
              const Text('EasyBuy Home',
              style:TextStyle(
                color: Colors.purple
              )),
              const SizedBox(
                width: 40,
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.doorbell_outlined,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: () {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.indigo,
                      content: const Text(
                        'Are you sure?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      action: SnackBarAction(
                        label: 'Yes. Exit the app',
                        onPressed: () {
                          ScreenLoader().screenLoaderSuccessFailStart();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const ScreenLogin()),
                              (Route<dynamic> route) => false);
                              ScreenLoader().screenLoaderDismiss('2', '');
                        },
                      ),
                    );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.blue,
                  ))
            ],
          ),
        ),
        body: ListView(
          children: [            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.82,
                  height: 220,
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
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.admin_panel_settings_outlined,
                            color: Colors.indigo,
                          ),
                          Text(
                            'Master Settings',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {
                                      ScreenLoader().screenLoaderSuccessFailStart();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const ScreenItemCategory()));
                                      ScreenLoader().screenLoaderDismiss('2', '');
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.shopping_bag), // <-- Icon
                                        Text("Category",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {
                                      ScreenLoader().screenLoaderSuccessFailStart();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const ScreenSubCategory()));
                                       ScreenLoader().screenLoaderDismiss('2', '');
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.category_outlined), // <-- Icon
                                        Text("S Category",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {
                                      ScreenLoader().screenLoaderSuccessFailStart();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ScreenItemRegistration()));
                                      ScreenLoader().screenLoaderDismiss('2', '');
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.shopping_cart_checkout), // <-- Icon
                                        Text("Items",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const ScreenOrders()));
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.add_card), // <-- Icon
                                        Text("Orders",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const ScreenPersonalRegistration()));
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.account_balance), // <-- Icon
                                        Text("Person",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const ScreenAccountRegistration()));
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.account_tree), // <-- Icon
                                        Text("Account",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const ScreenAssetRegistration()));
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.assignment_add), // <-- Icon
                                        Text("Asset",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          

                        ],
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.82,
                  height: 330,
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
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.indigo,
                          ),
                          Text(
                            'Transactions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.shop_two_sharp), // <-- Icon
                                        Text("GST",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.undo_sharp), // <-- Icon
                                        Text("Sales",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.backup_table_sharp), // <-- Icon
                                        Text("Purchase",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.redo), // <-- Icon
                                        Text("Purchase",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.account_balance), // <-- Icon
                                        Text("Expense",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.account_tree), // <-- Icon
                                        Text("Income",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.note_add), // <-- Icon
                                        Text("CD Notes",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.note_alt_outlined), // <-- Icon
                                        Text("Journals",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          

                        ],
                        
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.check_box), // <-- Icon
                                        Text("Cheques",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.query_stats_rounded), // <-- Icon
                                        Text("Status",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          

                        ],
                        
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.82,
                  height: 220,
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
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.toc_outlined,
                            color: Colors.indigo,
                          ),
                          Text(
                            'Tools',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.supervised_user_circle), // <-- Icon
                                        Text("User",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.settings_accessibility_outlined), // <-- Icon
                                        Text("Access",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.price_change), // <-- Icon
                                        Text("Price",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.barcode_reader), // <-- Icon
                                        Text("Barcode",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox.fromSize(
                              size: const Size(56, 56),
                              child: ClipOval(
                                child: Material(
                                  //color: Colors.grey,
                                  child: InkWell(
                                    splashColor: Colors.grey,
                                    onTap: () {},
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.add_shopping_cart_outlined), // <-- Icon
                                        Text("Orders",
                                        style: TextStyle(
                                          fontSize: 10
                                        ),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          

                        ],
                      )
                    ],
                  )),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){},
        tooltip: 'Reports',
        // ignore: sort_child_properties_last
        child: const Icon(Icons.note_alt_sharp,
        color: Colors.white,
        ),
        backgroundColor: Colors.indigo,
        ),
        );
  }
}