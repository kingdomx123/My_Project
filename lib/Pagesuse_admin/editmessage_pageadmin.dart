import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appshop1/Pagesuse_admin/edit_pageadmin/Promotion_history_admin.dart';
import 'package:flutter_appshop1/Pagesuse_admin/edit_pageadmin/edit_img_Promotion.dart';
import 'package:flutter_appshop1/Widgets/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class Editmessage_admin extends StatefulWidget {
  const Editmessage_admin({Key? key}) : super(key: key);

  @override
  State<Editmessage_admin> createState() => _Editmessage_adminState();
}

class _Editmessage_adminState extends State<Editmessage_admin> {
  AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      //'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('A bg message just showed up :  ${message.messageId}');
  }

  late TextEditingController _textTitle;
  late TextEditingController _textBody;

  @override
  void dispose() {
    _textTitle.dispose();
    _textBody.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _textTitle = TextEditingController();
    _textBody = TextEditingController();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification!.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, //channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/number1.jpg'), // Replace this with your image asset
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(35),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black, // เปลี่ยนสีของเส้นกรอบเป็นสีแดง
                      width: 2.0, // กำหนดความหนาของเส้นกรอบ
                    ),
                    color: Colors.white,
                  ),
                  child: const Text(
                    'เพิ่มโปรโมชั่น',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _textTitle,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'หัวเรื่อง'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอก หัวเรื่อง';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _textBody,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'ข้อมูลโปรโมชั่น'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอก ข้อมูลโปรโมชั่น';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        if (check()) {
                          pushNotificationsAllUsers(
                            title: _textTitle.text,
                            body: _textBody.text,
                          );
                        }
                        final String title = _textTitle.text;
                        final String body = _textBody.text;
                        if (body != null) {
                          try {
                            FirebaseFirestore.instance
                                .collection("message")
                                .doc()
                                .set({
                              'หัวเรื่อง': title,
                              'ข้อมูลโปรโมชั่น': body,
                              'เวลาสร้าง': FieldValue.serverTimestamp(),
                            });
                          } on FirebaseAuthException catch (e) {
                            print(e.code);
                            //คำสั่งแสดงข้อความเวลาเขียนผิดรูปแบบ
                          }
                          _textTitle.text = '';
                          _textBody.text = '';
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // สีกรอบเส้นที่คุณต้องการ
                            width: 2.0, // ความหนาของเส้น
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.5),
                            )
                          ],
                        ),
                        child: Center(
                            child: Text(
                          "ยืนยันการแจ้งเตือน",
                          style: TextStyle(fontSize: 18),
                        )),
                      ),
                    ),
                    TextButton(
                      child: Text('แก้ไขข้อมูลโปรโมชั่น',
                          style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Promotion_history_admin();
                        }));
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Edit_Promotion_admin();
                        }));
                      },
                      child: Text('แก้ไขภาพโปรโมชั่น',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,
  }) async {
    FirebaseMessaging.instance.subscribeToTopic("myTopic1");

    String dataNotifications = '{ '
        ' "to" : "/topics/myTopic1" , '
        ' "notification" : {'
        ' "title":"$title" , '
        ' "body":"$body" '
        ' } '
        ' } ';

    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    print(response.body.toString());
    return true;
  }

  bool check() {
    if (_textTitle.text.isNotEmpty && _textBody.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}
