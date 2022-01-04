import 'dart:developer';
import 'dart:io';

import 'package:ems/constants.dart';
import 'package:ems/models/attendance.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/overtime/widgets/blank_panel.dart';
import 'package:ems/screens/take_attendance/widgets/confirmation.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/widgets/statuses/info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScanner extends ConsumerStatefulWidget {
  final String type;
  const QRCodeScanner({Key? key, required this.type}) : super(key: key);

  @override
  ConsumerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends ConsumerState<QRCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool noPermission = false;
  bool isAddingAttendance = false;
  final AttendanceService _attService = AttendanceService.instance;
  Attendance? attendance;

  /// helps with hotreload
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _closePanel() {
    // if (!isLoading) {
    Navigator.of(context).pop();
    // }
  }

  addAttendance(Barcode _result) async {
    // TODO:
    // maybe check password from qr code?
    // _result.code;

    User _currentUser = ref.read(currentUserProvider).user;

    setState(() {
      attendance = Attendance(
        userId: _currentUser.id,
        type: widget.type,
        date: DateTime.now(),
      );
    });

    bool confirmed = await confirmScan();

    if (!confirmed) {
      return;
    }

    setState(() {
      isAddingAttendance = true;
    });
    try {
      print('hello from scanner');
      await _attService.createOne(
        attendance: attendance as Attendance,
      );
      setState(() {
        isAddingAttendance = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar(
          textColor: kGreenText,
          backgroundColor: kGreenBackground,
          type: widget.type,
          message: '${widget.type} successfully!',
        ),
      );
      _closePanel();
    } catch (err) {
      print(" ERROR $err");
      setState(() {
        isAddingAttendance = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar(
          textColor: kRedText,
          backgroundColor: kRedBackground,
          type: widget.type,
          message: '${widget.type} failed!',
        ),
      );
    }
  }

  /// Full screen snackbar widget
  SnackBar _buildSnackBar(
      {required backgroundColor,
      required Color textColor,
      required String type,
      required String message}) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: backgroundColor,
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: 80,
              color: textColor,
            ),
            Text(
              message,
              style: kParagraph.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> confirmScan() async {
    bool confirmation = false;
    void ok(String str) {
      if (str.isNotEmpty) {
        setState(() {
          attendance = attendance?.copyWith(note: str);
        });
      }
      print("what ${attendance?.toCleanJson()}");
      confirmation = true;
    }

    await modalBottomSheetBuilder(
      isDismissible: false,
      isScrollControlled: false,
      context: context,
      maxHeight: MediaQuery.of(context).size.height * 0.6,
      minHeight: MediaQuery.of(context).size.height * 0.4,
      child: ScanConfirmation(attendance: attendance as Attendance, ok: ok),
    );

    return confirmation;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now());
    return Scaffold(
        body: isAddingAttendance ? _loading(context) : _buildScanner(context));
  }

  Widget _buildScanner(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);

    return Container(
      color: kDarkestBlue,
      child: Stack(
        children: <Widget>[
          _buildQrView(context),
          Positioned(
            bottom: 80,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                    },
                    child: Text(
                      '${local?.flash}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 80,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width * 0.9,
              child: StatusInfo(text: "${local?.scanInstruction}"),
            ),
          ),
        ],
      ),
    );
  }

  /// qr scanner
  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: kBlue,
        borderRadius: 10,
        borderLength: 25,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  /// set controller and listen to events
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code.toString().isNotEmpty) {
        // set scanning result
        setState(() {
          result = scanData;
        });

        // stop the camera to let user know that the app got the data
        if (Platform.isAndroid) {
          await this.controller!.stopCamera();
        }
        if (Platform.isIOS) {
          await this.controller!.pauseCamera();
        }
        // add attendance
        await addAttendance(scanData);
        await this.controller!.resumeCamera();
      }
    });
  }

  /// check permission
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    AppLocalizations? local = AppLocalizations.of(context);

    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      setState(() {
        noPermission = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: kRedBackground,
            content: Text(
              '${local?.allowCamera}',
              style: kParagraph.copyWith(color: kRedText),
            )),
      );
    }
  }

  /// dispose the controller to avoid memory leak
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  /// loading widget
  Widget _loading(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    AppLocalizations? local = AppLocalizations.of(context);

    return Container(
      width: _size.width,
      height: _size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: kWhite,
              strokeWidth: 4,
            ),
            const SizedBox(
              height: 15,
            ),
            Text("${local?.savingAttendance}")
          ],
        ),
      ),
      color: kDarkestBlue,
    );
  }
}
