import 'dart:io';

import 'package:analytica_expense/pages/budget_page.dart';
import 'package:analytica_expense/pages/daily_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:analytica_expense/pages/Dashboard.dart';
import 'package:analytica_expense/providers/UserProvider.dart';
import 'package:analytica_expense/theme/Style.dart';
import 'package:analytica_expense/theme/colors.dart';
import 'package:analytica_expense/widget/Buttons.dart';
import 'package:analytica_expense/widget/inputbox.dart';
import 'package:analytica_expense/widget/snackbar.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController email, pass, name;
  //var date;

  bool isloading = false;
  bool email_error = false, pass_error = false;
  bool fname_erorr = false;
  String general_error = '';
  String email_text = '';
  String pass_text = '';
  String fname_text = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  //File _pickedImage;

  //String image_path;

  void uploadProfileanddata(BuildContext context, UserCredential userCredential) async {
    final CollectionReference postsRef =
    FirebaseFirestore.instance.collection('users');
    var data = {
      "email": email.text,
      "name": name.text,
    };
    postsRef.doc(userCredential.user.uid).set(data);
    Provider.of<UserProvider>(context, listen: false).fetchLogedUser();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (contex) => DailyPage()),
            (route) => false);
    /*firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile photo')
        .child('/' + email.text + '.jpg');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': _pickedImage.path});
    ref.putFile(File(_pickedImage.path), metadata).then((value) async {
      print("file uploaded");
      image_path = await ref.getDownloadURL();
      print(image_path);
    });*/
  }

  void signup(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: pass.text);

      try {
        print("user credentials | ${userCredential.user.toString()}");
        uploadProfileanddata(context, userCredential);
      } catch (e) {
        print("something wrong,please try again latter");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        setState(() {
          pass_text = 'The password provided is too weak';
          pass_error = true;

          isloading = false;
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: "The password provided is too weak!")
              .show();
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          email_text = 'The account already exists for this email';
          email_error = true;
          isloading = false;
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: "The account already exists for this email!")
              .show();
        });
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    email = TextEditingController();
    pass = TextEditingController();
    name = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: white,
        elevation: 0,
        title: Text(
          "Create an Account",
          style: TextStyle(
              color: primary, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: black,
            size: mainMargin + 6,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(mainMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                if (overscroll.leading) {
                  // loadmore();
                  overscroll.disallowGlow();
                } else {
                  overscroll.disallowGlow();
                }
              },
              child: ListView(
                children: [
                  /*Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Container(
                        width: 145,
                        height: 145,
                        //color: primary,
                        child: Center(
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: _pickedImage == null
                                    ? Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: primary.withOpacity(0.85)),
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: white,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          _pickedImage,
                                          width: 120,
                                          height: 120,
                                        ),
                                      ),
                              ),
                              Positioned(
                                right: 5,
                                top: 5,
                                child: InkWell(
                                  onTap: () {
                                    _showPickOptionsDialog(context);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.circular(
                                            buttonRadius)),
                                    child: Icon(
                                      _pickedImage == null
                                          ? Icons.camera_alt
                                          : Icons.sync,
                                      color: white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),*/
                  SizedBox(
                    height: 2 * mainMargin,
                  ),
                  inputBox(
                    controller: name,
                    error: fname_erorr,
                    errorText: "",
                    readonly: isloading,
                    inuptformat: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      FilteringTextInputFormatter.deny(RegExp('[\\ ]')),
                      /*WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
                      BlacklistingTextInputFormatter(new RegExp('[\\ ]')),*/
                    ],
                    labelText: "Full Name",
                    obscureText: false,
                    ispassword: false,
                    istextarea: false,
                    onchanged: (value) {
                      setState(() {
                        fname_erorr = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: email,
                    error: email_error,
                    readonly: isloading,
                    errorText: "",
                    inuptformat: [
                      FilteringTextInputFormatter.deny(RegExp('[\\ ]')),
                      //BlacklistingTextInputFormatter(new RegExp('[\\ ]')),
                    ],
                    labelText: "Email Address",
                    obscureText: false,
                    ispassword: false,
                    istextarea: false,
                    onchanged: (value) {
                      setState(() {
                        email_error = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: pass,
                    error: pass_error,
                    readonly: isloading,
                    errorText: "",
                    inuptformat: [],
                    labelText: "Password",
                    obscureText: true,
                    ispassword: true,
                    istextarea: false,
                    onchanged: (value) {
                      setState(() {
                        pass_error = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  /*DateTimePicker(
                    maxLines: 1,
                    type: DateTimePickerType.date,
                    dateMask: 'd MMM, yyyy',
                    readOnly: isloading,
                    decoration: InputDecoration(
                        errorText: date_error ? "" : null,
                        contentPadding: EdgeInsets.only(
                            right: subMargin,
                            left: subMargin,
                            bottom: mainMargin - 1,
                            top: mainMargin + 2),
                        errorStyle: TextStyle(color: errorColor, height: 0),
                        labelStyle:
                            TextStyle(color: primary, fontSize: subMargin + 2),
                        hintText: "Select Birthday",
                        labelText: "Select Birthday",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(buttonRadius),
                          borderSide: BorderSide(width: 2, color: primary),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(buttonRadius),
                          borderSide: BorderSide(width: 1, color: grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(buttonRadius),
                          borderSide: BorderSide(width: 1, color: primary),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(buttonRadius),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(buttonRadius),
                            borderSide:
                                BorderSide(width: 1.5, color: errorColor)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(buttonRadius),
                            borderSide:
                                BorderSide(width: 2, color: errorColor)),
                        suffixIcon: Icon(
                          Icons.event_outlined,
                          color: primary.withOpacity(0.4),
                          size: 30,
                        )),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    selectableDayPredicate: (date) {
                      if (date.weekday == 6 || date.weekday == 7) {
                        return true;
                      }
                      return true;
                    },
                    onChanged: (val) {
                      setState(() {
                        date = val;
                        date_error = false;
                        isloading = false;
                      });
                    },
                    validator: (val) {
                      setState(() => date = val);
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        date = val;
                        date_error = false;
                      });
                    },
                  ),*/
                  /*SizedBox(
                    height: mainMargin,
                  ),*/
                  /*inputBox(
                    controller: description,
                    error: bio_error,
                    minLine: 3,
                    errorText: "",
                    readonly: isloading,
                    inuptformat: [],
                    labelText: "Tell us a bit about yourself",
                    obscureText: false,
                    ispassword: false,
                    istextarea: true,
                    onchanged: (value) {
                      setState(() {
                        bio_error = false;
                      });
                    },
                  ),*/
                ],
              ),
            )),
            SizedBox(
              height: mainMarginHalf,
            ),
            /*Container(
              height: 50,
              child: Stack(
                children: [
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Checkbox(
                            value: tnc,
                            onChanged: (value) {
                              setState(() {
                                tnc = !tnc;
                              });
                            },
                            activeColor: primary,
                          ),
                        ),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree to the ',
                                style: TextStyle(
                                    color: primary.withOpacity(0.6),
                                    fontSize: 16),
                              ),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                    color: primary,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // single tapped
                                  },
                              ),
                              TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                    color: primary.withOpacity(0.6),
                                    fontSize: 16),
                              ),
                              TextSpan(
                                text: 'Privacy Policy ',
                                style: TextStyle(
                                    color: primary,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // long pressed
                                  },
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                    left: -15,
                    width: MediaQuery.of(context).size.width - 3 * mainMargin,
                  ),
                ],
              ),
            ),*/
            /*SizedBox(
              height: mainMarginHalf,
            ),*/
            PrimaryButton(
              isloading: isloading,
              onPressed: () {
                fname_erorr = name.text == "" ? true : false;
                email_error = email.text == "" ? true : false;
                pass_error = pass.text == "" ? true : false;

                try {


                  //isloading = false;
                  /*if (_pickedImage != null) {
                    setState(() {
                      fname_erorr = name.text == "" ? true : false;

                      email_error = email.text == "" ? true : false;

                      pass_error = pass.text == "" ? true : false;

                      isloading = false;
                    });
                  } else {
                    setState(() {
                      CustomSnackBar(
                              actionTile: "Close",
                              haserror: true,
                              isfloating: false,
                              scaffoldKey: scaffoldKey,
                              onPressed: () {},
                              title: "Please choose profile picture!")
                          .show();
                      isloading = false;
                    });
                  }*/
                } finally {
                  if (fname_erorr ||
                      email_error ||
                      pass_error) {
                    if(fname_erorr && name.text.isEmpty){
                      CustomSnackBar(
                          actionTile: "close",
                          haserror: true,
                          isfloating: false,
                          scaffoldKey: scaffoldKey,
                          onPressed: () {},
                          title: "Please enter full name")
                          .show();
                    }
                    else if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email.text)) {
                      print("not  email");
                      setState(() {
                        CustomSnackBar(
                            actionTile: "close",
                            haserror: true,
                            isfloating: false,
                            scaffoldKey: scaffoldKey,
                            onPressed: () {},
                            title: "Please enter valid email!")
                            .show();
                        email_error = true;
                        isloading = false;
                      });
                    }
                    else if(pass_error && pass.text.isEmpty){
                      CustomSnackBar(
                          actionTile: "close",
                          haserror: true,
                          isfloating: false,
                          scaffoldKey: scaffoldKey,
                          onPressed: () {},
                          title: "Please enter password")
                          .show();
                    }

                    /*if (_pickedImage != null) {
                      CustomSnackBar(
                              actionTile: "Close",
                              haserror: true,
                              isfloating: false,
                              scaffoldKey: scaffoldKey,
                              title: "Please fillup all details!")
                          .show();
                    }*/
                  } else {
                    if(!isloading){
                      setState(() {
                        isloading = true;
                      });
                      signup(context);
                    }

                  }
                }
              },
              title: "Continue",
              backgroundColor: primary,
              foregroundColor: white,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}
