import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appshop1/Home/Homeuse.dart';
import 'package:flutter_appshop1/Home/Map_Screen.dart';
import 'package:flutter_appshop1/model/profilemember.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //กำหนดคลาส
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); //ตัวชี้คำสั่ง
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  String _address = "";
  final TextEditingController _Name = TextEditingController();
  final TextEditingController _Lastname = TextEditingController();
  final TextEditingController _Email = TextEditingController();
  final TextEditingController _Password = TextEditingController();
  final TextEditingController _Number = TextEditingController();
  final TextEditingController _Address = TextEditingController();
  final TextEditingController _Image = TextEditingController();

  void sigUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  Profile profile = Profile(
      //กดหนดเก็บค่า
      Name: '',
      Lastname: '',
      Email: '',
      Password: '',
      Trypassword: '',
      Number: '',
      Address: '',
      Image: '');

  String _password = '';
  String _password2 = '';
  bool _passwordVisible = false;
  bool _isPasswordValid = true;
  bool _passwordVisible2 = false;
  bool _isPasswordValid2 = true;

  void initState() {
    super.initState();
    // Validate password when screen loads
    _validatePassword('');
    _validatePassword2('');
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _password = value;
      _isPasswordValid = value.length >= 6;
    });
  }

  void _togglePasswordVisibility2() {
    setState(() {
      _passwordVisible2 = !_passwordVisible2;
    });
  }

  void _validatePassword2(String value) {
    setState(() {
      _password2 = value;
      _isPasswordValid2 = value.length >= 6;
    });
  }

  // Function สำหรับเช็คเบอร์โทรศัพท์ที่ถูกต้อง
  bool isValidPhoneNumber(String input) {
    final RegExp phoneRegex =
        RegExp(r'^(\+?0?1\d{9})|((\d{3})-?(\d{3})-?(\d{4}))$');
    return phoneRegex.hasMatch(input);
  }

// Function สำหรับเช็คเบอร์บ้านที่ถูกต้อง
  bool isValidHomeNumber(String input) {
    final RegExp homeRegex = RegExp(r'^(\d{3})-?(\d{7})$');
    return homeRegex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 216, 255, 171),
                title: Text("ไม่ได้"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              //ส่งค่ากลับไปยังหน้า Scaffold
              appBar: AppBar(
                //ชื่อมุมขวาบน
                title: Text('สมาชิกใหม่'),
                backgroundColor: const Color.fromARGB(255, 216, 255, 171),
              ),
              body: Form(
                // รูปร่างทั้งหมด
                key: formKey, // คำสั่งFormKey
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/number1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      //องค์ประกอบ
                      children: [
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            controller: _Name,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelText: 'ชื่อ'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอก ชื่อ';
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
                            controller: _Lastname,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelText: 'นามสกุล'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอก นามสกุล';
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
                              controller: _Email,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  labelText: 'อีเมลผู้ใช้งาน'),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "กรุณากรอก อีเมลผู้ใช้งาน"),
                                EmailValidator(
                                    errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                              ])),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            controller: _Password,
                            onChanged: _validatePassword,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelText: 'รหัสผ่าน',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                              errorText: _isPasswordValid
                                  ? null
                                  : 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอก รหัสผ่าน';
                              }
                              return null;
                            },
                          ),
                        ),
                        Visibility(
                          visible: !_isPasswordValid &&
                              _password
                                  .isNotEmpty, // ให้แสดงตัวแจ้งเมื่อรหัสผ่านไม่ถูกต้องและมีความยาวมากกว่า 0
                          child: Text(
                            '',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            onSaved: (String? TryPassword) {
                              profile.Trypassword = TryPassword!;
                            },
                            onChanged: _validatePassword2,
                            obscureText: !_passwordVisible2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelText: 'กรอกรหัสผ่านอีกครั้ง',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible2
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: _togglePasswordVisibility2,
                              ),
                              errorText: _isPasswordValid2
                                  ? null
                                  : 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอก รหัสผ่านอีกครั้ง';
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
                            controller: _Number,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              //prefixText: "+",
                              labelText: 'เบอร์โทรศัพท์',
                            ),
                            validator: (value) {
                              // Validate phone number with regex
                              if (value!.isEmpty) {
                                return 'กรุณากรอก หมายเลขโทรศัพท์';
                              }
                              if (!RegExp(r'^[0-9]{10}$').hasMatch(value!) &&
                                  !RegExp(r'^[0-9]{9}$').hasMatch(value!)) {
                                return 'กรุณากรอกหมายเลขโทรศัพท์หรือหมายเลขบ้านที่ถูกต้อง';
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
                            controller: TextEditingController(text: _address),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelText: 'ที่อยู่',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.location_on),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapScreen(),
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      _address = result;
                                    });
                                  }
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอก ที่อยู่';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.black87, width: 2),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          //ปุ่มกดสมัครสมาชิก
                          onPressed: () async {
                            //คำสั่งสามารถกดได้
                            final String name = _Name.text;
                            final String lastname = _Lastname.text;
                            final String email = _Email.text;
                            final String password = _Password.text;
                            final String number = _Number.text;
                            final String address = _address;
                            final String image = _Image.text;
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (password != profile.Trypassword) {
                                //Navigator.pop(context);

                                displayMessage("รหัสผ่านไม่ตรงกัน");
                                return;
                              }
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: email, password: password);

                                FirebaseFirestore.instance
                                    .collection("members")
                                    .doc(userCredential.user!.email)
                                    .set({
                                  'ชื่อ': name,
                                  'นามสกุล': lastname,
                                  'อีเมล': email,
                                  'รหัสผ่าน': password,
                                  'เบอร์โทรศัพท์': number,
                                  'ที่อยู๋': address,
                                  'รูป': image,
                                });

                                formKey.currentState!.reset(); // กดแล้วค่าจะรี
                                Fluttertoast.showToast(
                                    msg: "สมัครสมาชิกเรียบร้อยแล้ว",
                                    gravity: ToastGravity.BOTTOM);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Home1();
                                })); //สมัครแล้วกลับไปหน้าแรก
                              } on FirebaseAuthException catch (e) {
                                print(e.code);
                                String? message;
                                if (e.code == 'email-already-in-use') {
                                  message =
                                      "มีอีเมลนี้ในระบบแล้ว กรุณากรอกอีเมลอื่น";
                                } else if (e.code == 'weak-password') {
                                  message =
                                      "กรุณากรอกรหัสผ่านให้ถึง 6 ตัวด้วยครับ";
                                } else {
                                  message = e.message;
                                }
                                Fluttertoast.showToast(
                                    msg: message!,
                                    gravity: ToastGravity.BOTTOM);
                                //คำสั่งแสดงข้อความเวลาเขียนผิดรูปแบบ
                              }
                              _Name.text = '';
                              _Lastname.text = '';
                              _Email.text = '';
                              _Password.text = '';
                              _Number.text = '';
                              _Address.text = '';
                              _Image.text = '';
                            }
                          },
                          child: Text('สมัครสมาชิก',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
