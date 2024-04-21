import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/screens/master/order_details.dart';
import 'package:flutter_application_shopping/widgets/sucess_easy.dart';
import 'package:intl/intl.dart';

class ScreenOrders extends StatefulWidget {
  const ScreenOrders({super.key});

  @override
  State<ScreenOrders> createState() => _ScreenOrdersState();
}

class _ScreenOrdersState extends State<ScreenOrders> {
  List<Map<String, dynamic>> cart = [];
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchDataStream() {
   
    Query<Map<String, dynamic>> collection = FirebaseFirestore.instance
        .collection('bookings')
        .where('status', isEqualTo: '1')
        .orderBy('date', descending: true);

    return collection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
      body: StreamBuilder<QuerySnapshot>(
          stream: fetchDataStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              // return CircularProgressIndicator();
            }
            if (snapshot.data != null) {
              List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

              return ListView.separated(
                  itemBuilder: (ctx, index) {
                    final documentId = snapshot.data!.docs[index].id;
                    var data = documents[index].data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        ScreenLoader().screenLoaderSuccessFailStart();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) =>
                                ScreenOrderDetails(bookingId: documentId)));
                        ScreenLoader().screenLoaderDismiss('2', '');
                      },
                      child: Card(
                        child: ListTile(
                          leading:
                              const Icon(Icons.arrow_circle_right_outlined),
                          title: Text(data['date'].toString()),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const Divider();
                  },
                  itemCount: documents.length);
            } else {
              return const Text('');
            }
          }),
    );
  }
}
