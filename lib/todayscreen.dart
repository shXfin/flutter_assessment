import 'dart:async';

import 'package:assessment/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";

  Color primary = const Color(0xffeef444c);
  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: User.employeeId)
          .get();

      print(snap.docs[0].id);

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc('20 Octtober')
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = "10:11";
        checkOut = "12:11";
      });
    }
    print(checkIn);
    print(checkOut);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "WELCOME,",
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "RobotoBold",
                fontSize: screenWidth / 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Employee${User.employeeId}",
              style: TextStyle(
                fontFamily: "RobotoBold",
                fontSize: screenWidth / 26,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Today's Status☀︎",
              style: TextStyle(
                fontFamily: "RobotoBold",
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 32),
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(28)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Check In",
                        style: TextStyle(
                          fontFamily: "RobotoRegular",
                          fontSize: screenWidth / 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        //check in samole
                        checkIn, //"--/--"
                        style: TextStyle(
                          fontFamily: "RobotoBold",
                          fontSize: screenWidth / 10,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Check Out",
                        style: TextStyle(
                          fontFamily: "RobotoRegular",
                          fontSize: screenWidth / 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        //check outt sample
                        checkOut, //"09:30"
                        style: TextStyle(
                          fontFamily: "RobotoBold",
                          fontSize: screenWidth / 10,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: TextStyle(
                        color: primary,
                        fontSize: screenWidth / 18,
                        fontFamily: "RobotoBold"),
                    children: [
                      TextSpan(
                        text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth / 20,
                            fontFamily: "RobotoBold"),
                      )
                    ]),
              )),
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    //current time
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(
                      fontFamily: "RobotoRegular",
                      fontSize: screenWidth / 20,
                      color: Colors.black54,
                    ),
                  ),
                );
              }),
          checkOut == "--/--"
              ? Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: Builder(
                    builder: (context) {
                      final GlobalKey<SlideActionState> key = GlobalKey();

                      return SlideAction(
                          text: checkIn == "--/--"
                              ? "Slide to Check In"
                              : "Slide to Check Out",
                          textStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: screenWidth / 20,
                            fontFamily: "RobotoRegular",
                          ),
                          outerColor: Colors.white,
                          innerColor: primary,
                          key: key,
                          onSubmit: () async {
                            Timer(const Duration(seconds: 1), () {
                              key.currentState!.reset();
                            });
                            print(DateFormat('hh:mm').format(DateTime.now()));

                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection("Employee")
                                .where('id', isEqualTo: User.employeeId)
                                .get();

                            if (snap.docs.isNotEmpty) {
                              print(snap.docs[0].id);
                            } else {
                              print(
                                  "No matching documents found for the query.");
                            }
                            DocumentSnapshot snap2 = await FirebaseFirestore
                                .instance
                                .collection("Employee")
                                //im so done with this doc id
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy')
                                    .format(DateTime.now()))
                                .get();

                            try {
                              String checkIn = snap2['checkIn'];
                              //for updating ui when checked iout but doesnt work for docid
                              setState(() {
                                checkIn =
                                    DateFormat('hh:mm').format(DateTime.now());
                              });
                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now()))
                                  .update({
                                'checkIn': checkIn,
                                'checkOut':
                                    DateFormat('hh:mm').format(DateTime.now()),
                              });
                            } catch (e) {
                              //for updating ui when checked in but doesnt work for docid
                              setState(() {
                                checkIn =
                                    DateFormat('hh:mm').format(DateTime.now());
                              });

                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMMM yyyy')
                                      .format(DateTime.now()))
                                  .set({
                                'checkIn':
                                    DateFormat('hh:mm').format(DateTime.now()),
                              });
                            }
                          });
                    },
                  ),
                )
              : Container(
                  //doesnt work
                  margin: const EdgeInsets.only(top: 32),
                  child: Text(
                    "You have completed this day!",
                    style: TextStyle(
                      fontFamily: "RobotoRegular",
                      fontSize: screenWidth / 20,
                      color: Colors.black54,
                    ),
                  ),
                )
        ],
      ),
    ));
  }
}
