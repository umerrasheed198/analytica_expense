import 'dart:io';

import 'package:analytica_expense/theme/Style.dart';
import 'package:analytica_expense/widget/Buttons.dart';
import 'package:analytica_expense/widget/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:analytica_expense/json/create_budget_json.dart';
import 'package:analytica_expense/theme/colors.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class CreatBudgetPage extends StatefulWidget {
  @override
  _CreatBudgetPageState createState() => _CreatBudgetPageState();
}

class _CreatBudgetPageState extends State<CreatBudgetPage> {
  int activeCategory = 0;

  TextEditingController _budgetName =  TextEditingController(text: "");
  TextEditingController _budgetPrice = TextEditingController(text: "");
  var date;
  File _pickedImage;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String image_path;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Create Expense",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      Row(
                        children: [Icon(AntDesign.search1)],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Text(
              "Choose category",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: black.withOpacity(0.5)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(categories.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeCategory = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    width: 150,
                    height: 170,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(
                            width: 2,
                            color: activeCategory == index
                                ? primary
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: grey.withOpacity(0.01),
                            spreadRadius: 10,
                            blurRadius: 3,
                            // changes position of shadow
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: grey.withOpacity(0.15)),
                              child: Center(
                                child: Image.asset(
                                  categories[index]['icon'],
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                ),
                              )),
                          Text(
                            categories[index]['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xff67727d)),
                ),
                TextField(
                  controller: _budgetName,
                  cursorColor: black,
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold, color: black),
                  decoration: InputDecoration(
                      hintText: "Enter Description", border: InputBorder.none),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Amount",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xff67727d)),
                ),
                TextField(
                  controller: _budgetPrice,
                  cursorColor: black,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: black),
                  decoration: InputDecoration(
                      hintText: "Enter Amount",
                      border: InputBorder.none),
                ),
                SizedBox(
                  height: 20,
                ),
                DateTimePicker(
                    maxLines: 1,
                    type: DateTimePickerType.date,
                    dateMask: 'd MMM, yyyy',
                    readOnly: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            right: subMargin,
                            left: subMargin,
                            bottom: mainMargin - 1,
                            top: mainMargin + 2),
                        errorStyle: TextStyle(color: errorColor, height: 0),
                        labelStyle:
                            TextStyle(color: primary, fontSize: subMargin + 2),
                        hintText: "Select Date",
                        labelText: "Select Date",
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
                      });
                    },
                    validator: (val) {
                      setState(() => date = val);
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        date = val;
                      });
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Attachment",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xff67727d)),
                ),
                Center(
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
                  ),
                SizedBox(
                  height: 20,
                ),
                PrimaryButton(
                  isloading: isloading,
                  onPressed: () {
                    if (_budgetName.text == '') {
                      print("description null");
                      setState(() {
                        CustomSnackBar(
                            actionTile: "close",
                            haserror: true,
                            isfloating: false,
                            scaffoldKey: scaffoldKey,
                            onPressed: () {},
                            title: "Please enter description")
                            .show();
                      });
                    } else if (_budgetPrice.text.isEmpty) {
                      setState(() {
                        CustomSnackBar(
                            actionTile: "close",
                            haserror: true,
                            isfloating: false,
                            scaffoldKey: scaffoldKey,
                            onPressed: () {},
                            title: "Please enter amount")
                            .show();
                      });
                    } else if (date == null) {
                      setState(() {
                        CustomSnackBar(
                            actionTile: "close",
                            haserror: true,
                            isfloating: false,
                            scaffoldKey: scaffoldKey,
                            onPressed: () {},
                            title: "Please enter date")
                            .show();

                      });
                    } else {
                      setState(() {
                        isloading = true;
                      });

                      print("calling submit");
                      uploadProfileanddata(context, FirebaseAuth.instance.currentUser);
                    }
                  },
                  title: "Submit",
                  backgroundColor: primary,
                  foregroundColor: white,
                  height: 55,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Pick from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _loadPicker(ImageSource.gallery);
              },
            ),
            ListTile(
              title: Text("Take a Picture"),
              onTap: () {
                Navigator.pop(context);
                _loadPicker(ImageSource.camera);
              },
            )
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(mainMargin))),
      ),
    );
  }

  _loadPicker(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _pickedImage = File(pickedFile.path);
        //_cropImage(_image);
      } else {
        print('No image selected.');
      }
    });
  }

/*  _cropImage(File picked) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: picked.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        maxWidth: 400,
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      setState(() {
        _pickedImage = croppedFile;
      });
    }
  }*/

  void uploadProfileanddata(BuildContext context, User userCredential) async {
    if(_pickedImage != null){
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('attachements')
          .child('/' + date.toString() + '.jpg');

      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': _pickedImage.path});
      ref.putFile(File(_pickedImage.path), metadata).then((value) async {
        print("file uploaded");
        image_path = await ref.getDownloadURL();
        print(image_path);
        final CollectionReference postsRef =
        FirebaseFirestore.instance.collection('users_expense');
        var data = {
          "description": _budgetName.text,
          "amount": _budgetPrice.text,
          "date": date.toString(),
          "category": categories[activeCategory]['name'],
          "attachment": image_path ,
        };
        await postsRef.doc(userCredential.uid).collection('users_expense').doc(date).set(data);
        Navigator.pop(context);
      });
    }
    else{
      final CollectionReference postsRef =
      FirebaseFirestore.instance.collection('users_expense');
      var data = {
        "description": _budgetName.text,
        "amount": _budgetPrice.text,
        "date": date.toString(),
        "category": categories[activeCategory]['name'],
        "attachment": image_path ,
      };
      await postsRef.doc(userCredential.uid).collection('users_expense').doc(date).set(data);
      Navigator.pop(context);
    }
  }
}
