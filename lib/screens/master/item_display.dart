// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_shopping/widgets/sucess_easy.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:sticky_footer_scrollview/sticky_footer_scrollview.dart';
import 'package:timeline_tile/timeline_tile.dart';

// ignore: must_be_immutable
class ScreenItemDisplay extends StatefulWidget {
  String itemId;
  String bookingId;

  ScreenItemDisplay({Key? key, required this.itemId, required this.bookingId})
      : super(key: key);

  @override
  State<ScreenItemDisplay> createState() => _ScreenItemDisplayState();
}

class _ScreenItemDisplayState extends State<ScreenItemDisplay> {
  String deliveryStatus = '';
  var userId = '';
  String cartQuantity = '';
  String cartId = '';
  final db = FirebaseFirestore.instance;
  String hsn = 'Loading';
  String imageUrl = '';
  String itemName = 'Loading';
  String unitRate = 'Loading';
  final quantityController = TextEditingController();
  String itemStock = '';
  bool orderReceived = true;
  bool itemPacked = false;
  bool itemShipped = false;
  bool itemTransit = false;
  bool outForDelivery = false;
  bool delivered = false;
  bool orderCancelled = false;

  @override
  void initState() {
    getItemDetails(widget.itemId);

    super.initState();
  }

  Future<void> getItemDetails(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    final userDoc = FirebaseFirestore.instance.collection('items').doc(id);
    userDoc.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        final itemData = documentSnapshot.data();

        setState(() {
          hsn = itemData?['hsn'];
          imageUrl = itemData?['imageUrl'];
          itemName = itemData?['item_name'];
          unitRate = itemData?['unit_rate'];
          itemStock = itemData!['quantity'].toString();
        });
      }
    });

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('cart')
        .where('item_id', isEqualTo: id)
        .where('booking_id', isEqualTo: widget.bookingId)
        .get();
    for (var doc in querySnapshot.docs) {
      cartId = doc.id;
      setState(() {
        deliveryStatus = doc['cart_status'];
      });
      print(' in stream builder $deliveryStatus');
      if (deliveryStatus == '7') {
        orderCancelled = true;
        orderReceived = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = false;
        itemPacked = false;
      } else if (deliveryStatus == '6') {
        orderCancelled = false;
        delivered = true;
        outForDelivery = true;
        itemTransit = true;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '5') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = true;
        itemTransit = true;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '4') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = true;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '3') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '2') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = false;
        itemPacked = true;
      } else {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = false;
        itemPacked = false;
        orderReceived = true;
      }
    }
  }

  Future<void> changeStatusDown() async {
    int status = int.parse(deliveryStatus) - 1;
    if (status == 0) {
      status = 7;
    }
    final userDoc = FirebaseFirestore.instance.collection('cart').doc(cartId);
    await userDoc.update({'cart_status': status.toString()});
    setState(() {
      deliveryStatus = status.toString();
      if (deliveryStatus == '7') {
        orderCancelled = true;
        orderReceived = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = false;
        itemPacked = false;
      } else if (deliveryStatus == '6') {
        orderCancelled = false;
        delivered = true;
        outForDelivery = true;
        itemTransit = true;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '5') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = true;
        itemTransit = true;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '4') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = true;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '3') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '2') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = false;
        itemPacked = true;
      } else {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = false;
        itemPacked = false;
        orderReceived = true;
      }
    });
  }

  Future<void> changeStatusUp() async {
    if (deliveryStatus == '7') {
      deliveryStatus = '0';
    }
    int status = int.parse(deliveryStatus) + 1;
    final userDoc = FirebaseFirestore.instance.collection('cart').doc(cartId);
    await userDoc.update({'cart_status': status.toString()});
    setState(() {
      deliveryStatus = status.toString();

      if (deliveryStatus == '7') {
        orderCancelled = true;
        orderReceived = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = false;
        itemPacked = false;
      } else if (deliveryStatus == '6') {
        orderCancelled = false;
        delivered = true;
        outForDelivery = true;
        itemTransit = true;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '5') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = true;
        itemTransit = true;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '4') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = true;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '3') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = true;
        itemPacked = true;
      } else if (deliveryStatus == '2') {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = false;
        itemPacked = true;
      } else {
        orderCancelled = false;
        delivered = false;
        outForDelivery = false;
        itemTransit = false;
        itemShipped = false;
        itemPacked = false;
        orderReceived = true;
      }
    });
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
          'Orders',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
              fontSize: 20,
              color: Colors.white),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: StickyFooterScrollView(
            itemCount: 0,
            itemBuilder: (context, index) {
              return const Text('');
            },
            footer: AppBar(
                toolbarHeight: 80,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.indigo,
                title: Column(
                  children: [
                    const Text(
                      'Change Status',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed:
                                deliveryStatus == '7' ? null : changeStatusDown,
                            child: Text(deliveryStatus == '6'
                                ? 'Change to Out for Delivery'
                                : (deliveryStatus == '5'
                                    ? 'Change to in Transit'
                                    : (deliveryStatus == '4'
                                        ? 'Change to Shipped'
                                        : (deliveryStatus == '3'
                                            ? 'Changed to Packed'
                                            : (deliveryStatus == '2'
                                                ? 'Change to Order Received'
                                                : (deliveryStatus == '1'
                                                    ? 'Cancel Order'
                                                    : 'Cancelled'))))))),
                        ElevatedButton(
                            onPressed:
                                deliveryStatus == '6' ? null : changeStatusUp,
                            child: Text(deliveryStatus == '1'
                                ? 'Change to Packed'
                                : (deliveryStatus == '1'
                                    ? 'Change to Picked'
                                    : (deliveryStatus == '2'
                                        ? 'Change to Shipped'
                                        : (deliveryStatus == '3'
                                            ? 'Change to in Transit'
                                            : (deliveryStatus == '4'
                                                ? 'Change to Out for Delivery'
                                                : (deliveryStatus == '5'
                                                    ? 'Change to Delivered'
                                                    : (deliveryStatus == '6'
                                                        ? 'Delivered'
                                                        : 'Change to Order Received'))))))))
                      ],
                    )
                  ],
                ))),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView(
          children: [
            Container(
              height: 200,
              child: Image(
                image: imageUrl == ''
                    ? const AssetImage(
                        'assets/loading.gif',
                      ) as ImageProvider
                    : NetworkImage(
                        imageUrl,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                itemName,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
            const Divider(),
            const Center(
                child: Text(
              'MRP \u{20B9}55499',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.purple),
            )),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlowText(
                  'Special Price \u{20B9}$unitRate',
                  glowColor: Colors.yellow,
                  blurRadius: 10,
                  style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Colors.indigo),
                ),
              ],
            )),
            const Divider(),
            Visibility(
              visible: orderCancelled,
              child: const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  'This order has been cancelled,',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 25),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: orderReceived,
                    child: TimelineTile(
                      alignment: TimelineAlign.center,
                      isFirst: true,
                      indicatorStyle: const IndicatorStyle(
                        width: 20,
                        color: Colors.indigo,
                      ),
                      beforeLineStyle: const LineStyle(
                        color: Colors.purple,
                        thickness: 6,
                      ),
                      startChild: Container(
                        constraints: const BoxConstraints(
                          minHeight: 10,
                        ),
                      ),
                      endChild: Container(
                        child: Text('Order Received'),
                        constraints: const BoxConstraints(
                          minHeight: 80,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: itemPacked,
                    child: TimelineTile(
                      alignment: TimelineAlign.center,
                      beforeLineStyle: const LineStyle(
                        color: Colors.purple,
                        thickness: 6,
                      ),
                      afterLineStyle: const LineStyle(
                        color: Colors.purple,
                        thickness: 6,
                      ),
                      indicatorStyle: const IndicatorStyle(
                        width: 20,
                        color: Colors.deepOrange,
                      ),
                      endChild: Container(
                        child: Text('Item Packed'),
                        constraints: const BoxConstraints(
                          minHeight: 80,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: itemShipped,
                    child: TimelineTile(
                      alignment: TimelineAlign.center,
                      beforeLineStyle: const LineStyle(
                        color: Colors.purple,
                        thickness: 6,
                      ),
                      afterLineStyle: const LineStyle(
                        color: Colors.purple,
                        thickness: 6,
                      ),
                      indicatorStyle: const IndicatorStyle(
                        width: 20,
                        color: Colors.cyan,
                      ),
                      endChild: Container(
                        child: Text('Item Shipped'),
                        constraints: const BoxConstraints(
                          minHeight: 80,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: itemTransit,
                    child: TimelineTile(
                      alignment: TimelineAlign.center,
                      beforeLineStyle: const LineStyle(
                        color: Colors.purple,
                        thickness: 6,
                      ),
                      afterLineStyle: const LineStyle(
                        color: Colors.purple,
                        thickness: 6,
                      ),
                      indicatorStyle: const IndicatorStyle(
                        width: 20,
                        color: Colors.pink,
                      ),
                      endChild: Container(
                        child: Text('In Transit'),
                        constraints: const BoxConstraints(
                          minHeight: 80,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: outForDelivery,
                    child: TimelineTile(
                      alignment: TimelineAlign.center,
                      beforeLineStyle: const LineStyle(
                        color: Colors.purple,
                        thickness: 6,
                      ),
                      afterLineStyle: const LineStyle(
                        color: Colors.purple,
                        thickness: 6,
                      ),
                      indicatorStyle: const IndicatorStyle(
                        width: 20,
                        color: Colors.amber,
                      ),
                      endChild: Container(
                        child: Text('Out for Delivery'),
                        constraints: const BoxConstraints(
                          minHeight: 80,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: delivered,
                    child: TimelineTile(
                      alignment: TimelineAlign.center,
                      isLast: true,
                      beforeLineStyle: const LineStyle(
                        color: Colors.deepOrange,
                        thickness: 6,
                      ),
                      indicatorStyle: const IndicatorStyle(
                        width: 20,
                        color: Colors.red,
                      ),
                      endChild: Container(
                        child: Text('Delivered'),
                        constraints: const BoxConstraints(
                          minHeight: 80,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
