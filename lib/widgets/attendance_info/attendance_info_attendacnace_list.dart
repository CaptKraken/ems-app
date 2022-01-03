import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'package:ems/screens/attendances_api/attendance_edit.dart';
import 'package:ems/utils/utils.dart';

import '../../constants.dart';

class AttendanceInfoAttendanceList extends StatelessWidget {
  final bool now;
  final bool alltime;
  final bool afternoon;
  final bool multiple;
  final List isTodayNoon;
  final List isToday;
  final List attendanceList;
  List attendanceAll;
  List attendanceListNoon;
  List attendanceAllDisplay;
  final Function fetchAttendanceById;
  final Function deleteData;
  final Function deleteData1;
  final Function fetchAttendanceByIdNoon;
  final Function fetchAllAttendance;

  AttendanceInfoAttendanceList({
    Key? key,
    required this.now,
    required this.alltime,
    required this.afternoon,
    required this.multiple,
    required this.isTodayNoon,
    required this.isToday,
    required this.attendanceList,
    required this.attendanceAll,
    required this.attendanceListNoon,
    required this.attendanceAllDisplay,
    required this.fetchAttendanceById,
    required this.deleteData,
    required this.deleteData1,
    required this.fetchAttendanceByIdNoon,
    required this.fetchAllAttendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return alltime && !multiple && !now
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 8,
                ),
                color: index % 2 == 0 ? kDarkestBlue : kBlue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(attendanceAll[index].date),
                    ),
                    Row(
                      children: [
                        Text(attendanceAll[index].type.toString()),
                        PopupMenuButton(
                          color: Colors.black,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onSelected: (int selectedValue) async {
                            if (selectedValue == 0) {
                              final int userId = attendanceAll[index].userId;
                              final int id = attendanceAll[index].id;
                              final String type = attendanceAll[index].type;
                              final DateTime date = attendanceAll[index].date;
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => AttedancesEdit(
                                    id: id,
                                    userId: userId,
                                    type: type,
                                    date: date,
                                  ),
                                ),
                              );
                              attendanceAll = [];
                              fetchAllAttendance();
                            }
                            if (selectedValue == 1) {
                              print(attendanceList[index].id);
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('${local?.areYouSure}'),
                                  content: Text('${local?.cannotUndone}'),
                                  actions: [
                                    OutlineButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        deleteData(
                                            attendanceAll[index].id as int);
                                      },
                                      child: Text('${local?.yes}'),
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    OutlineButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      borderSide: BorderSide(color: Colors.red),
                                      child: Text('${local?.no}'),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              child: Text(
                                '${local?.edit}',
                                style: kParagraph.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              value: 0,
                            ),
                            PopupMenuItem(
                              child: Text(
                                '${local?.delete}',
                                style: kParagraph.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              value: 1,
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : now
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 8,
                    ),
                    color: index % 2 == 0 ? kDarkestBlue : kBlue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        afternoon
                            ? Text(DateFormat('dd/MM/yyyy HH:mm')
                                .format(isTodayNoon[index].date as DateTime))
                            : Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(isToday[index].date as DateTime),
                              ),
                        Row(
                          children: [
                            afternoon
                                ? Text(isTodayNoon[index].type.toString(),
                                    style: kParagraph)
                                : Text(isToday[index].type.toString(),
                                    style: kParagraph),
                            PopupMenuButton(
                              color: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onSelected: (int selectedValue) async {
                                if (afternoon == false) {
                                  if (selectedValue == 0) {
                                    final int userId = isToday[index].userId;
                                    final int id = isToday[index].id;
                                    final String type = isToday[index].type;
                                    final DateTime date = isToday[index].date;
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => AttedancesEdit(
                                          id: id,
                                          userId: userId,
                                          type: type,
                                          date: date,
                                        ),
                                      ),
                                    );
                                    attendanceAllDisplay = [];
                                    fetchAttendanceById();
                                  }
                                  if (selectedValue == 1) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('${local?.areYouSure}'),
                                        content: Text('${local?.cannotUndone}'),
                                        actions: [
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              deleteData(
                                                  isToday[index].id as int);
                                            },
                                            child: Text('Yes'),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            child: Text('No'),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }
                                if (afternoon == true) {
                                  if (selectedValue == 0) {
                                    final int userId =
                                        isTodayNoon[index].userId;
                                    final int id = isTodayNoon[index].id;
                                    final String type = isTodayNoon[index].type;
                                    final DateTime date =
                                        isTodayNoon[index].date;
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => AttedancesEdit(
                                          id: id,
                                          userId: userId,
                                          type: type,
                                          date: date,
                                        ),
                                      ),
                                    );
                                    attendanceAllDisplay = [];
                                    fetchAttendanceByIdNoon();
                                  }
                                  if (selectedValue == 1) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('${local?.areYouSure}'),
                                        content: Text('${local?.cannotUndone}'),
                                        actions: [
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              deleteData(
                                                  isTodayNoon[index].id as int);
                                            },
                                            child: Text('Yes'),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            child: Text('No'),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  child: Text('Edit',
                                      style: kParagraph.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  value: 0,
                                ),
                                PopupMenuItem(
                                  child: Text('Delete',
                                      style: kParagraph.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  value: 1,
                                ),
                              ],
                              icon: const Icon(Icons.more_vert),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 8,
                    ),
                    color: index % 2 == 0 ? kDarkestBlue : kBlue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        afternoon
                            ? Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(attendanceListNoon[index].date),
                              )
                            : Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(attendanceList[index].date),
                              ),
                        Row(
                          children: [
                            afternoon
                                ? Text(
                                    attendanceListNoon[index].type.toString())
                                : Text(attendanceList[index].type.toString()),
                            PopupMenuButton(
                              color: Colors.black,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onSelected: (int selectedValue) async {
                                if (afternoon == false) {
                                  if (selectedValue == 0) {
                                    final int userId =
                                        attendanceList[index].userId;
                                    final int id = attendanceList[index].id;
                                    final String type =
                                        attendanceList[index].type;
                                    final DateTime date =
                                        attendanceList[index].date;
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => AttedancesEdit(
                                          id: id,
                                          userId: userId,
                                          type: type,
                                          date: date,
                                        ),
                                      ),
                                    );
                                    attendanceAllDisplay = [];
                                    fetchAttendanceById();
                                  }
                                  if (selectedValue == 1) {
                                    print(attendanceList[index].id);
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('${local?.areYouSure}'),
                                        content: Text('${local?.cannotUndone}'),
                                        actions: [
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              deleteData(attendanceList[index]
                                                  .id as int);
                                            },
                                            child: Text('${local?.yes}'),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            child: Text('${local?.no}'),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }
                                if (afternoon == true) {
                                  if (selectedValue == 0) {
                                    final int userId =
                                        attendanceListNoon[index].userId;
                                    final int id = attendanceListNoon[index].id;
                                    final String type =
                                        attendanceListNoon[index].type;
                                    final DateTime date =
                                        attendanceListNoon[index].date;
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => AttedancesEdit(
                                          id: id,
                                          userId: userId,
                                          type: type,
                                          date: date,
                                        ),
                                      ),
                                    );
                                    attendanceAllDisplay = [];
                                    fetchAttendanceByIdNoon();
                                  }
                                  if (selectedValue == 1) {
                                    print(attendanceListNoon[index].id);
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('${local?.areYouSure}'),
                                        content: Text('${local?.cannotUndone}'),
                                        actions: [
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              deleteData1(
                                                  attendanceListNoon[index].id
                                                      as int);
                                            },
                                            child: Text('${local?.yes}'),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            child: Text('${local?.no}'),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  child: Text(
                                    '${local?.edit}',
                                    style: kParagraph.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  value: 0,
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    '${local?.delete}',
                                    style: kParagraph.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  value: 1,
                                ),
                              ],
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
      },
      itemCount: alltime
          ? attendanceAll.length
          : now
              ? afternoon
                  ? isTodayNoon.length
                  : isToday.length
              : afternoon
                  ? attendanceListNoon.length
                  : attendanceList.length,
    );
  }
}
