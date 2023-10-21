import 'package:assessment/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";

  Color primary = const Color(0xffeef444c);
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
              "My Attendance",
              style: TextStyle(
                fontFamily: "RobotoBold",
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  DateFormat('MMMM').format(DateTime.now()), // "My Attendance"
                  style: TextStyle(
                    fontFamily: "RobotoBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  "Pick a month",
                  style: TextStyle(
                    fontFamily: "RobotoBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight - screenHeight / 5,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Employee")
                  .doc(User.id)
                  .collection("Record")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final snap = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return Container(
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
                                    //snap[index]['checkIn'],
                                    "Check In",
                                    style: TextStyle(
                                      fontFamily: "RobotoRegular",
                                      fontSize: screenWidth / 20,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    //check in sample
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
                                    snap[index]['checkOut'],

                                    ///"Check Out",
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
                      );
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          )
        ],
      ),
    ));
  }
}
