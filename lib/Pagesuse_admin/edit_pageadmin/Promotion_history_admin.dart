import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Promotion_history_admin extends StatefulWidget {
  @override
  _Promotion_history_adminState createState() =>
      _Promotion_history_adminState();
}

class _Promotion_history_adminState extends State<Promotion_history_admin> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _Title = TextEditingController();
  final TextEditingController _Body = TextEditingController();

  final usersCollection = FirebaseFirestore.instance.collection('message');

  final CollectionReference _Promotion =
      FirebaseFirestore.instance.collection('message');

  Future<void> _updata([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _Title.text = documentSnapshot['หัวเรื่อง'];
      _Body.text = documentSnapshot['ข้อมูลโปรโมชั่น'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "แก้ไขข้อมูลผัก",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _Title,
                  decoration: const InputDecoration(
                      labelText: 'หัวเรื่อง', hintText: ''),
                ),
                TextField(
                  //keyboardType: TextInputType.number,
                  controller: _Body,
                  decoration: const InputDecoration(
                      labelText: 'ข้อมูลโปรโมชั่น', hintText: ''),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          final String title = _Title.text;
                          final String body = _Body.text;
                          if (title != null) {
                            FirebaseFirestore.instance
                                .collection('message')
                                .doc(documentSnapshot?.id)
                                .update({
                              'หัวเรื่อง': title,
                              'ข้อมูลโปรโมชั่น': body,
                            });
                            _Title.text = '';
                            _Body.text = '';

                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('แก้ไข')),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('ยกเลิก')),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> _delete(String ProductID) async {
    FirebaseFirestore.instance.collection("message").doc(ProductID).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //ชื่อมุมขวาบน
        title: Text('แก้ไขข้อมูลโปรโมชั่น'),
        backgroundColor: const Color.fromARGB(255, 216, 255, 171),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/number1.jpg'), // Replace this with your image asset
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: _Promotion.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  //shrinkWrap: true,
                  key: formKey,
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          documentSnapshot['หัวเรื่อง'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(
                          documentSnapshot['ข้อมูลโปรโมชั่น'].toString(),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => _updata(documentSnapshot),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () => _delete(documentSnapshot.id),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
