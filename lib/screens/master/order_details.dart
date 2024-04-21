import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/screens/master/item_display.dart';
import 'package:flutter_application_shopping/widgets/sucess_easy.dart';

class ScreenOrderDetails extends StatefulWidget {
  final bookingId;
  const ScreenOrderDetails({super.key,required this.bookingId});

  @override
  State<ScreenOrderDetails> createState() => _ScreenOrderDetailsState();
}

class _ScreenOrderDetailsState extends State<ScreenOrderDetails> {
  String cartQuantity = '';
  final db = FirebaseFirestore.instance;
  String? customerId = '';
  String bookingId = '';
  String userId = '';
  int cartTotal = 0;
  final quantityController = TextEditingController();
  List<Map<String, dynamic>> cartItems = [];
  @override
  void initState() {
    getCartItems();
   
    super.initState();
  }

  

  Future<void> getCartItems() async {
    
    int cartTotalValue = 0;
    bookingId = '';
    try {
      List<Map<String, dynamic>> cart = [];
      final user = FirebaseAuth.instance.currentUser;
      customerId = user?.uid.toString();

        
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
            .collection('cart')
            .where('booking_id', isEqualTo: widget.bookingId)
            .where('cart_status', isGreaterThanOrEqualTo: '1')
            .where('cart_status', isLessThanOrEqualTo: '7')
            .get();

        for (var doc in querySnapshot.docs) {
          try {
           
            Map<String, dynamic>? itemData =
                await getItemDetails(doc['item_id']);
            if (itemData != null) {
              cart.add({
                'id': doc.id,
                'booking_id': doc['booking_id'],
                'cart_status': doc['cart_status'],
                'date': doc['date'],
                'item_id': doc['item_id'],
                'quantity': doc['quantity'],
                'item_name': itemData['item_name'],
                'unit_rate': itemData['unit_rate'],
                'imageUrl': itemData['imageUrl']
              });
            }
            cartTotalValue +=
                int.parse(doc['quantity']) * int.parse(itemData?['unit_rate']);
          } catch (e)
          // ignore: empty_catches
          {}
        
          setState(() {
            cartItems = cart;
          
          });
        
      }
      setState(() {
         cartTotal = cartTotalValue;
      });
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Oops.Something went wrong $e');
    }
  }

  Future<Map<String, dynamic>?> getItemDetails(String itemId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('items')
          .doc(itemId)
          .get();
      if (docSnapshot.exists) {
        final itemName = docSnapshot.data()?['item_name'];
        final unitRate = docSnapshot.data()?['unit_rate'];
        final imageUrl = docSnapshot.data()?['imageUrl'];
        return {
          'item_name': itemName,
          'unit_rate': unitRate,
          'imageUrl': imageUrl
        };
      } else {
        return null;
      }
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Oops Something went wrong $e');
    }
    return null;
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
          'Order Details',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
              fontSize: 20,
              color: Colors.white),
        ),
      ),
        
        body: ListView(
          children: [
            Column(
              children: [
                cartTotal==0? const CircularProgressIndicator():
                SizedBox(
                  height: 900,
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        final Map<String, dynamic> data = cartItems[index];
                        return GestureDetector(
                          onTap:(){
                              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ScreenItemDisplay(itemId: data['item_id'], bookingId: widget.bookingId)));
                          } ,
                          child: ListTile(
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
                                //Text(data['quantity']),
                                Text(data['quantity'])
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () {},
                                tooltip: 'Slide for actions',
                                icon: const Icon(
                                    Icons.double_arrow_outlined)),
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const Divider();
                      },
                      itemCount: cartItems.length),
                ),
              ],
            ),
           
          ],
        ));
  }
}
