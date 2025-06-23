// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String displayName = "";
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  List<int> holiday = [];

  List colorCode = [
    Colors.blueGrey[700],
    Colors.deepOrange[800],
    Colors.deepPurple[600],
    Colors.tealAccent[800],
    Colors.redAccent[700],
    const Color.fromARGB(237, 9, 79, 159)
  ];

  randNo() {
    Random random = Random();
    int randomNumber = random.nextInt(6);
    return randomNumber;
  }

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    getCalenderData();
    super.initState();
  }

  getEvents(data) {
    List<dynamic> list = data['msg'] != 'No Data Found' ? data['msg'] : [];
    int i = 0;
    for (var element in list) {
      DateTime calDt =
          DateTime.parse(element['CAL_DT']).add(const Duration(days: 1));
      DateTime date = DateTime.utc(calDt.year, calDt.month, calDt.day, 00);
      if (selectedEvents[date] != null) {
        selectedEvents[date]?.add(
          Event(title: element['CAL_EVENT']),
        );
        holiday.add(int.parse(date.day.toString()));
      } else {
        holiday.add(int.parse(date.day.toString()));
        selectedEvents[date] = [Event(title: element['CAL_EVENT'])];
      }
      setState(() {});
      i++;
    }
    print(holiday);
  }

  var data;
  getCalenderData() async {
    final response = await MasterModel.globalApiCall(0, '/cal_details', null);
    var dt;
    if (response.statusCode == 200) {
      dt = jsonDecode(response.body);
      getEvents(dt);
    }
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height - 160;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: _height,
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: Column(
              children: [
                Container(
                  height: _height * 0.65,
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: TableCalendar(
                    // weekendDays: holiday,
                    // holidayPredicate: (day) => day == holiday![day.day],
                    headerVisible: true,
                    focusedDay: selectedDay,
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                    calendarFormat: format,
                    onFormatChanged: (CalendarFormat _format) {
                      setState(() {
                        format = _format;
                      });
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,

                    //Day Changed
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                      // print(focusedDay);
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },
                    daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                        weekendStyle: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    eventLoader: _getEventsfromDay,

                    //To style the Calendar
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      weekNumberTextStyle: const TextStyle(color: Colors.red),
                      selectedDecoration: BoxDecoration(
                        color: Colors
                            .white, //const Color.fromARGB(237, 9, 79, 159),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      selectedTextStyle: const TextStyle(
                          color: Color.fromARGB(237, 9, 79, 159),
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                      todayDecoration: BoxDecoration(
                        color: Colors
                            .white, //const Color.fromARGB(236, 34, 124, 226),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      todayTextStyle: const TextStyle(
                          color: Color.fromARGB(237, 9, 79, 159),
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      defaultTextStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      // markerMargin: const EdgeInsets.symmetric(vertical: 0.2),
                      markerSize: 6,
                      markerDecoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      weekendTextStyle: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      disabledTextStyle: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        titleTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            letterSpacing: 1),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                        ),
                        headerMargin: EdgeInsets.only(bottom: 10)
                        // formatButtonDecoration: BoxDecoration(
                        //   color: const Color.fromARGB(237, 9, 79, 159),
                        //   borderRadius: BorderRadius.circular(5.0),
                        // ),
                        // formatButtonTextStyle: const TextStyle(
                        //   color: Colors.white,
                        // ),
                        ),
                  ),
                ),
                SizedBox(
                  height: _height * 0.35,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 246, 246, 246),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0))),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 30, right: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 60,
                              child: Center(
                                child: Text(
                                  DateFormat('dd EEE')
                                      .format(selectedDay)
                                      .toString(),
                                  softWrap: true,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 80,
                              child: ListView(
                                children: _getEventsfromDay(selectedDay)
                                    .map((event) => Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              // border: Border.all(width: 0.8),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 2.0,
                                              vertical: 1.0,
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                event.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                              onTap: () {},
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  Event({required this.title});
  @override
  String toString() => title;
}
