import 'package:ems/models/attendance.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/services/attendance.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';

class CheckStatus extends ConsumerStatefulWidget {
  const CheckStatus({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _CheckStatusState();
}

class _CheckStatusState extends ConsumerState<CheckStatus> {
  bool isFetchingStatus = false;
  bool isMorningCheckIn = false;
  bool isMorningCheckOut = false;
  bool isAfternoonCheckIn = false;
  bool isAfternoonCheckOut = false;

  void getStatus() async {
    bool isOnline = await InternetConnectionChecker().hasConnection;
    if (isOnline == false) {
      // log('offline from check status');
      return;
    }

    if (mounted) {
      setState(() {
        isFetchingStatus = true;
      });
    }

    AttendanceService attService = AttendanceService.instance;
    int userId = ref.read(currentUserProvider).user.id as int;

    List<AttendancesByDate> listOfAttendance =
        await attService.findManyByUserId(
      userId,
      start: DateTime.now(),
      end: DateTime.now(),
    );
    if (!mounted || listOfAttendance.isEmpty) {
      setState(() {
        isFetchingStatus = false;
      });
      return;
    }
    Attendance? att = listOfAttendance.first.attendances?.first;
    if (att?.t1 != null) {
      if (mounted) {
        setState(() {
          isMorningCheckIn = true;
        });
      }
    }
    if (att?.t2 != null) {
      if (mounted) {
        setState(() {
          isMorningCheckOut = true;
        });
      }
    }
    if (att?.t3 != null) {
      if (mounted) {
        setState(() {
          isAfternoonCheckIn = true;
        });
      }
    }
    if (att?.t4 != null) {
      if (mounted) {
        setState(() {
          isAfternoonCheckOut = true;
        });
      }
    }
    if (mounted) {
      setState(() {
        isFetchingStatus = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 113,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Text(
                        "${local?.checkin}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: kBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "${local?.checkout}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: kBlack,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
                Visibility(
                  visible: isEnglish,
                  child: const SizedBox(height: 8),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${local?.morning}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: kBlack,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      isFetchingStatus
                          ? '${local?.loading}...'
                          : isMorningCheckIn
                              ? '✔'
                              : '--',
                      style: const TextStyle(
                        color: kBlack,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      isFetchingStatus
                          ? '${local?.loading}...'
                          : isMorningCheckOut
                              ? '✔'
                              : '--',
                      style: const TextStyle(
                        color: kBlack,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
                Visibility(
                  visible: isEnglish,
                  child: const SizedBox(height: 8),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${local?.afternoon}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: kBlack,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      isFetchingStatus
                          ? '${local?.loading}...'
                          : isAfternoonCheckIn
                              ? '✔'
                              : '--',
                      style: const TextStyle(
                        color: kBlack,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                      child: _buildStatusText(isAfternoonCheckOut),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: isFetchingStatus,
            child: const Positioned(
              bottom: 11,
              right: 11,
              child: SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                  color: kBlue,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isFetchingStatus,
            child: Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: getStatus,
                child: const Icon(
                  MdiIcons.refresh,
                  color: kBlue,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(bool status) {
    AppLocalizations? local = AppLocalizations.of(context);
    return Text(
      isFetchingStatus
          ? '${local?.loading}...'
          : status
              ? '✔'
              : '--',
      style: const TextStyle(
        color: kBlack,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }
}
