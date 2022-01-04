import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/attendance/attendacne_all_time_list.dart';
import 'package:ems/widgets/attendance_info/attendance_info_attendacnace_list.dart';
import 'package:ems/widgets/attendance_info/attendance_info_name_id.dart';
import 'package:ems/widgets/attendance_info/attendance_info_no_attendance.dart';
import 'package:ems/widgets/attendance_info/attendance_info_no_data.dart';
import 'package:ems/widgets/attendance_info/attendance_info_present.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';
import '../../models/attendance.dart';
import '../../utils/services/attendance_service.dart';

class AttendancesInfoScreen extends StatefulWidget {
  static const routeName = '/attendances-info';
  final int id;

  AttendancesInfoScreen(this.id);
  @override
  _AttendancesInfoScreenState createState() => _AttendancesInfoScreenState();
}

class _AttendancesInfoScreenState extends State<AttendancesInfoScreen> {
  AttendanceService _attendanceService = AttendanceService.instance;
  AttendanceService _attendanceNoDateService = AttendanceService.instance;
  List<Attendance> attendanceDisplay = [];
  List<Attendance> attendanceAllDisplay = [];
  List<AttendanceWithDate> _attendanceDisplay = [];
  List<AttendanceWithDate> _attendanceNoDateDisplay = [];
  List<AttendanceWithDate> _attendanceAll = [];

  String dropDownValue = '';
  bool afternoon = false;
  dynamic countPresent,
      countPresentNoon,
      countLate,
      countLateNoon,
      countAbsent,
      countAbsentNoon,
      countPermission,
      countPermissionNoon,
      lateMorning,
      lateAfternoon,
      absentMorning,
      absentAfternoon,
      permissionMorning,
      permissionAfternoon,
      presentMorning,
      presentAfternoon,
      presentAll,
      lateAll,
      permissionAll,
      absentAll;
  bool multipleDay = false;
  bool alltime = false;
  bool isOneDay = false;
  bool _isLoading = true;
  bool _isLoadingNoDate = true;
  bool order = false;
  bool isFilterExpanded = false;
  List<Appointment>? _appointment;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  List isToday = [];
  List isTodayNoon = [];
  List oneDayMorning = [];
  List oneDayNoon = [];
  bool now = true;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List attendanceList = [];
  List attendanceListNoon = [];
  List attendanceListAll = [];

  String sortByValue = '';
  List<String> dropdownItems = [];
  fetchNoDate() async {
    try {
      List<AttendanceWithDate> attendanceNoDateDisplay =
          await _attendanceNoDateService.findManyByUserId(userId: widget.id);
      setState(() {
        _attendanceNoDateDisplay = attendanceNoDateDisplay;
        _isLoadingNoDate = false;
      });
    } catch (e) {}
  }

  fetchAllAttendance() async {
    try {
      List<AttendanceWithDate> attendanceDisplay =
          await _attendanceService.findManyByUserId(userId: widget.id);
      setState(() {
        _attendanceAll = attendanceDisplay;
      });
      List flat = _attendanceAll.expand((element) => element.list).toList();
      attendanceListAll = flat.toList();
    } catch (e) {
      print(e);
    }
  }

  fetchAttendanceById() async {
    try {
      List<AttendanceWithDate> attendanceDisplay =
          await _attendanceService.findManyByUserId(
        userId: widget.id,
        start: startDate,
        end: endDate,
      );
      setState(() {
        _attendanceDisplay = attendanceDisplay;

        _isLoading = false;
        var now = DateTime.now();
        var today = attendanceDisplay.where((element) =>
            element.date.day == now.day &&
            element.date.month == now.month &&
            element.date.year == now.year);
        List todayFlat = today.expand((element) => element.list).toList();
        isToday = todayFlat
            .where((element) =>
                element.code != 'cin2' &&
                element.code != 'cout2' &&
                element.code != 'cout3' &&
                element.code != 'cin3')
            .toList();
        var oneDay = attendanceDisplay.where((element) =>
            element.date.day == startDate.day &&
            element.date.month == startDate.month &&
            element.date.year == startDate.year);
        List oneDayFlat = oneDay.expand((element) => element.list).toList();
        oneDayMorning = oneDayFlat
            .where((element) =>
                element.code != 'cin2' &&
                element.code != 'cout2' &&
                element.code != 'cin3' &&
                element.code != 'cout3')
            .toList();
      });
      List flat = _attendanceDisplay.expand((element) => element.list).toList();
      attendanceList = flat
          .where((element) =>
              element.code != 'cin2' &&
              element.code != 'cout2' &&
              element.code != 'cout3' &&
              element.code != 'cin3')
          .toList();
    } catch (e) {}
  }

  fetchAttendanceByIdNoon() async {
    try {
      List<AttendanceWithDate> attendanceDisplay =
          await _attendanceService.findManyByUserId(
        userId: widget.id,
        start: startDate,
        end: endDate,
      );
      setState(() {
        _attendanceDisplay = attendanceDisplay;
        _isLoading = false;
        var now = DateTime.now();
        var today = attendanceDisplay.where((element) =>
            element.date.day == now.day &&
            element.date.month == now.month &&
            element.date.year == now.year);
        List todayFlat = today.expand((element) => element.list).toList();
        isTodayNoon = todayFlat
            .where((element) =>
                element.code != 'cin1' &&
                element.code != 'cout1' &&
                element.code != 'cout3' &&
                element.code != 'cin3')
            .toList();
        var oneDay = attendanceDisplay.where((element) =>
            element.date.day == startDate.day &&
            element.date.month == startDate.month &&
            element.date.year == startDate.year);
        List oneDayFlat = oneDay.expand((element) => element.list).toList();
        oneDayNoon = oneDayFlat
            .where((element) =>
                element.code != 'cin1' &&
                element.code != 'cout1' &&
                element.code != 'cin3' &&
                element.code != 'cout3')
            .toList();
      });
      List flat = _attendanceDisplay.expand((element) => element.list).toList();
      attendanceListNoon = flat
          .where((element) =>
              element.code != 'cin1' &&
              element.code != 'cout1' &&
              element.code != 'cout3' &&
              element.code != 'cin3')
          .toList();
    } catch (e) {}
  }

  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/attendances";

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    if (response.statusCode == 200) {
      attendanceAllDisplay = [];
      fetchAttendanceById();
    } else {
      return false;
    }
  }

  Future deleteData1(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    if (response.statusCode == 200) {
      attendanceAllDisplay = [];
      fetchAttendanceByIdNoon();
    } else {
      return false;
    }
  }

  fetchLate() async {
    var pc = await _attendanceService.countLateByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        lateMorning = pc;
      });
    }
  }

  fetchLateNoon() async {
    var pc = await _attendanceService.countLateNoonByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        lateAfternoon = pc;
      });
    }
  }

  fetchAbsent() async {
    var pc = await _attendanceService.countAbsentByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        absentMorning = pc;
      });
    }
  }

  fetchAbsentNoon() async {
    var pc = await _attendanceService.countAbsentNoonByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        absentAfternoon = pc;
      });
    }
  }

  fetchPermission() async {
    var pc = await _attendanceService.countPermissionByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        permissionMorning = pc;
      });
    }
  }

  fetchPermissionNoon() async {
    var pc = await _attendanceService.countPermissionNoonByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        permissionAfternoon = pc;
      });
    }
  }

  fetchPresent() async {
    var pc = await _attendanceService.countPresentByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        presentMorning = pc;
        print(presentMorning);
      });
    }
  }

  fetchPresentNoon() async {
    var pc = await _attendanceService.countPresentNoonByUserId(
      userId: widget.id,
      start: startDate,
      end: endDate,
    );
    if (mounted) {
      setState(() {
        presentAfternoon = pc;
      });
    }
  }

  getPresent() async {
    var pc = await _attendanceService.countPresent(widget.id);
    if (mounted) {
      setState(() {
        countPresent = pc;
      });
    }
  }

  getPresentNoon() async {
    var pc = await _attendanceService.countPresentNoon(widget.id);
    if (mounted) {
      setState(() {
        countPresentNoon = pc;
      });
    }
  }

  getLate() async {
    var pc = await _attendanceService.countLate(widget.id);
    if (mounted) {
      setState(() {
        countLate = pc;
      });
    }
  }

  getLateNoon() async {
    var pc = await _attendanceService.countLateNoon(widget.id);
    if (mounted) {
      setState(() {
        countLateNoon = pc;
      });
    }
  }

  getAbsent() async {
    var pc = await _attendanceService.countAbsent(widget.id);
    if (mounted) {
      setState(() {
        countAbsent = pc;
      });
    }
  }

  getAbsentNoon() async {
    var pc = await _attendanceService.countAbsentNoon(widget.id);
    if (mounted) {
      setState(() {
        countAbsentNoon = pc;
      });
    }
  }

  getPermission() async {
    var pc = await _attendanceService.countPermission(widget.id);
    if (mounted) {
      setState(() {
        countPermission = pc;
      });
    }
  }

  getPermissionNoon() async {
    var pc = await _attendanceService.countPermissionNoon(widget.id);
    if (mounted) {
      setState(() {
        countPermissionNoon = pc;
      });
    }
  }

  getPresentAll() async {
    var pc = await _attendanceService.countPresentAll(widget.id);
    if (mounted) {
      setState(() {
        presentAll = pc;
      });
    }
  }

  getAbsentAll() async {
    var pc = await _attendanceService.countAbsentAll(widget.id);
    if (mounted) {
      setState(() {
        absentAll = pc;
      });
    }
  }

  getLateAll() async {
    var pc = await _attendanceService.countLateAll(widget.id);
    if (mounted) {
      setState(() {
        lateAll = pc;
      });
    }
  }

  getPermissionAll() async {
    var pc = await _attendanceService.countPermissionAll(widget.id);
    if (mounted) {
      setState(() {
        permissionAll = pc;
      });
    }
  }

  void toggleFilter() {
    setState(() {
      isFilterExpanded = !isFilterExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      getAbsentAll();
      getPermissionAll();
      getPresentAll();
      getLateAll();
      getPresent();
      getPresentNoon();
      getLate();
      getLateNoon();
      getAbsent();
      getAbsentNoon();
      getPermission();
      getPermissionNoon();
      fetchAttendanceById();
      fetchAttendanceByIdNoon();
      fetchNoDate();
      fetchLate();
      fetchLateNoon();
      fetchAbsent();
      fetchAbsentNoon();
      fetchPermission();
      fetchPermissionNoon();
      fetchPresent();
      fetchPresentNoon();
      fetchAllAttendance();
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    setState(() {
      if (dropDownValue.isEmpty) {
        dropDownValue = local!.morning;
      }
      if (dropdownItems.isEmpty) {
        dropdownItems = [
          '${local?.optionDay}',
          '${local?.optionMultiDay}',
          '${local?.optionAllTime}',
        ];
      }
      if (sortByValue.isEmpty) {
        sortByValue = local!.optionAllTime;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: _isLoading && _isLoadingNoDate
          ? Container(
              padding: const EdgeInsets.only(top: 320),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${local?.fetchData}'),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(
                      color: kWhite,
                    ),
                  ],
                ),
              ),
            )
          : _isLoadingNoDate
              ? Container(
                  padding: const EdgeInsets.only(top: 320),
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${local?.fetchData}'),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator(
                          color: kWhite,
                        ),
                      ],
                    ),
                  ),
                )
              : _attendanceNoDateDisplay.isEmpty
                  ? AttendanceInfoNoAttenance()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              !alltime
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 0),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: kDarkestBlue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButton(
                                        underline: Container(),
                                        style: kParagraph.copyWith(
                                            fontWeight: FontWeight.bold),
                                        isDense: true,
                                        borderRadius: const BorderRadius.all(
                                            kBorderRadius),
                                        dropdownColor: kDarkestBlue,
                                        icon: const Icon(Icons.expand_more),
                                        value: dropDownValue,
                                        onChanged: (String? newValue) {
                                          if (newValue ==
                                              '${local?.afternoon}') {
                                            setState(() {
                                              afternoon = true;
                                              dropDownValue = newValue!;
                                            });
                                          }
                                          if (newValue == '${local?.morning}') {
                                            setState(() {
                                              afternoon = false;
                                              dropDownValue = newValue!;
                                            });
                                          }
                                        },
                                        items: <String>[
                                          '${local?.morning}',
                                          '${local?.afternoon}',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: toggleFilter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${local?.filter}',
                                          style: kParagraph.copyWith(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Icon(
                                          isFilterExpanded
                                              ? MdiIcons.chevronUp
                                              : MdiIcons.chevronDown,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: isFilterExpanded,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),

                                        /// SORT FILTER
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: kDarkestBlue,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: DropdownButton(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        kBorderRadius),
                                                dropdownColor: kDarkestBlue,
                                                underline: Container(),
                                                style: kParagraph.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                isDense: true,
                                                value: sortByValue,
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: dropdownItems
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  if (sortByValue == newValue)
                                                    return;
                                                  setState(() {
                                                    sortByValue =
                                                        newValue as String;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),

                                        /// FROM FILTER
                                        Visibility(
                                          visible: sortByValue !=
                                              '${local?.optionAllTime}',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                sortByValue ==
                                                        '${local?.optionDay}'
                                                    ? "Date"
                                                    : '${local?.from}',
                                                style: kParagraph,
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.white,
                                                  textStyle: kParagraph,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                                  backgroundColor: kDarkestBlue,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            kBorderRadius),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final DateTime? picked =
                                                      await buildDateTimePicker(
                                                    context: context,
                                                    date: startDate,
                                                  );
                                                  if (picked != null &&
                                                      picked != startDate) {
                                                    setState(() {
                                                      startDate = picked;
                                                    });
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getDateStringFromDateTime(
                                                          startDate),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Icon(
                                                        MdiIcons.calendar),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        /// TO FILTER
                                        Visibility(
                                          visible: sortByValue ==
                                              '${local?.optionMultiDay}',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${local?.to}',
                                                  style: kParagraph),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.white,
                                                  textStyle: kParagraph,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                                  backgroundColor: kDarkestBlue,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            kBorderRadius),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final DateTime? picked =
                                                      await buildDateTimePicker(
                                                    context: context,
                                                    date: endDate,
                                                  );
                                                  if (picked != null &&
                                                      picked != endDate) {
                                                    setState(() {
                                                      endDate = picked;
                                                    });
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getDateStringFromDateTime(
                                                          endDate),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Icon(
                                                        MdiIcons.calendar),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        /// GO BUTTON
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 16),
                                                primary: Colors.white,
                                                textStyle: kParagraph,
                                                backgroundColor: Colors.black38,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          kBorderRadius),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (sortByValue ==
                                                    '${local?.optionMultiDay}') {
                                                  setState(() {
                                                    alltime = false;
                                                    multipleDay = true;
                                                    now = false;
                                                    isFilterExpanded = false;
                                                    isOneDay = false;
                                                  });
                                                  fetchLate();
                                                  fetchLateNoon();
                                                  fetchAbsent();
                                                  fetchAbsentNoon();
                                                  fetchPermission();
                                                  fetchPermissionNoon();
                                                  fetchPresent();
                                                  fetchPresentNoon();
                                                  fetchAttendanceById();
                                                  fetchAttendanceByIdNoon();
                                                }
                                                if (sortByValue ==
                                                    '${local?.optionAllTime}') {
                                                  setState(() {
                                                    multipleDay = false;
                                                    now = false;
                                                    alltime = true;
                                                    isFilterExpanded = false;
                                                    isOneDay = false;
                                                  });
                                                  fetchAllAttendance();
                                                  getAbsentAll();
                                                  getPermissionAll();
                                                  getPresentAll();
                                                  getLateAll();
                                                }
                                                if (sortByValue ==
                                                    '${local?.optionDay}') {
                                                  setState(() {
                                                    multipleDay = false;
                                                    now = false;
                                                    alltime = false;
                                                    isFilterExpanded = false;
                                                    isOneDay = true;
                                                  });
                                                  fetchLate();
                                                  fetchLateNoon();
                                                  fetchAbsent();
                                                  fetchAbsentNoon();
                                                  fetchPermission();
                                                  fetchPermissionNoon();
                                                  fetchPresent();
                                                  fetchPresentNoon();
                                                  fetchAttendanceById();
                                                  fetchAttendanceByIdNoon();
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Go',
                                                    style: kParagraph.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const Icon(
                                                      MdiIcons.chevronRight)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AttendanceInfoNameId(
                            name: _attendanceNoDateDisplay[0]
                                .list[0]
                                .users!
                                .name
                                .toString(),
                            id: _attendanceNoDateDisplay[0]
                                .list[0]
                                .users!
                                .id
                                .toString(),
                            image: _attendanceNoDateDisplay[0]
                                .list[0]
                                .users!
                                .image
                                .toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(
                            //   width: 50,
                            // ),
                            Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: AttendanceInfoPresent(
                                        isOneday: isOneDay,
                                        onedayMorning:
                                            presentMorning.toString(),
                                        onedayAfternoon:
                                            presentAfternoon.toString(),
                                        presentAll: presentAll.toString(),
                                        alltime: alltime,
                                        text: '${local?.present}: ',
                                        afternoon: afternoon,
                                        multipleDay: multipleDay,
                                        presentAfternoon:
                                            presentAfternoon == null
                                                ? '♽'
                                                : presentAfternoon.toString(),
                                        countPresentNoon:
                                            countPresentNoon == null
                                                ? '♽'
                                                : countPresentNoon.toString(),
                                        presentMorning: presentMorning == null
                                            ? '♽'
                                            : presentMorning.toString(),
                                        countPresent: countPresent == null
                                            ? '♽'
                                            : countPresent.toString()),
                                  ),
                                  AttendanceInfoPresent(
                                      isOneday: isOneDay,
                                      onedayMorning:
                                          permissionMorning.toString(),
                                      onedayAfternoon:
                                          permissionAfternoon.toString(),
                                      presentAll: permissionAll.toString(),
                                      alltime: alltime,
                                      text: '${local?.permission}: ',
                                      afternoon: afternoon,
                                      multipleDay: multipleDay,
                                      presentAfternoon:
                                          permissionAfternoon == null
                                              ? '♽'
                                              : permissionAfternoon.toString(),
                                      countPresentNoon:
                                          countPermissionNoon == null
                                              ? '♽'
                                              : countPermissionNoon.toString(),
                                      presentMorning: permissionMorning == null
                                          ? '♽'
                                          : permissionMorning.toString(),
                                      countPresent: countPermission == null
                                          ? '♽'
                                          : countPermission.toString()),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 60,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: AttendanceInfoPresent(
                                          isOneday: isOneDay,
                                          onedayMorning: lateMorning.toString(),
                                          onedayAfternoon:
                                              lateAfternoon.toString(),
                                          presentAll: lateAll.toString(),
                                          alltime: alltime,
                                          text: '${local?.late}: ',
                                          afternoon: afternoon,
                                          multipleDay: multipleDay,
                                          presentAfternoon:
                                              lateAfternoon == null
                                                  ? '♽'
                                                  : lateAfternoon.toString(),
                                          countPresentNoon:
                                              countLateNoon == null
                                                  ? '♽'
                                                  : countLateNoon.toString(),
                                          presentMorning: lateMorning == null
                                              ? '♽'
                                              : lateMorning.toString(),
                                          countPresent: countLate == null
                                              ? '♽'
                                              : countLate.toString())),
                                  AttendanceInfoPresent(
                                      isOneday: isOneDay,
                                      onedayMorning: absentMorning.toString(),
                                      onedayAfternoon:
                                          absentAfternoon.toString(),
                                      presentAll: absentAll.toString(),
                                      alltime: alltime,
                                      text: '${local?.absent}: ',
                                      afternoon: afternoon,
                                      multipleDay: multipleDay,
                                      presentAfternoon: absentAfternoon == null
                                          ? '♽'
                                          : absentAfternoon.toString(),
                                      countPresentNoon: countAbsentNoon == null
                                          ? '♽'
                                          : countAbsentNoon.toString(),
                                      presentMorning: absentMorning == null
                                          ? '♽'
                                          : absentMorning.toString(),
                                      countPresent: countAbsent == null
                                          ? '♽'
                                          : countAbsent.toString())
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: isEnglish ? 10 : 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Text(
                                      isEnglish
                                          ? '${local?.attendance} '
                                          : '${local?.list} ',
                                      style: kHeadingThree,
                                    ),
                                    Text(
                                      isEnglish
                                          ? '${local?.list} '
                                          : '${local?.attendance} ',
                                      style: kHeadingThree,
                                    ),
                                  ],
                                ),
                              ),
                              isToday.isEmpty && now && isTodayNoon.isEmpty
                                  ? AttendanceInfoNoData()
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: AttendanceInfoAttendanceList(
                                            oneDayMorning: oneDayMorning,
                                            oneDayNoon: oneDayNoon,
                                            isOneDay: isOneDay,
                                            multiple: multipleDay,
                                            fetchAllAttendance:
                                                fetchAllAttendance,
                                            alltime: alltime,
                                            attendanceAll: attendanceListAll,
                                            now: now,
                                            afternoon: afternoon,
                                            isTodayNoon: isTodayNoon,
                                            isToday: isToday,
                                            attendanceList: attendanceList,
                                            attendanceListNoon:
                                                attendanceListNoon,
                                            attendanceAllDisplay:
                                                attendanceAllDisplay,
                                            fetchAttendanceById:
                                                fetchAttendanceById,
                                            deleteData: deleteData,
                                            deleteData1: deleteData1,
                                            fetchAttendanceByIdNoon:
                                                fetchAttendanceByIdNoon),
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

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
