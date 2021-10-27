import 'package:ems/constants.dart';
import 'package:ems/screens/slide_menu.dart';
import 'package:ems/widgets/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => _scaffoldKey.currentState!.openDrawer(),
          child: Container(
            padding: kPaddingAll,
            child: SvgPicture.asset(
              'assets/images/menuburger.svg',
              semanticsLabel: "menu",
            ),
          ),
        ),
        title: Text('Internal EMS'),
      ),
      drawer: const MenuDrawer(),
      body: SafeArea(
        bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: SvgPicture.asset(
                      'assets/images/graph.svg',
                      semanticsLabel: "menu",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello, [username].",
                              style: kHeadingFour,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "It's ${DateFormat('jm').format(DateTime.now())} on ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                              style: kSubtitleTwo,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: kPaddingAll.copyWith(top: 30, bottom: 30),
                        margin: kPaddingAll,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: kLightBlue,
                          borderRadius: BorderRadius.all(kBorderRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75,
                              child: Image.asset(
                                "assets/images/profile-icon-png-910.png",
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '26',
                                  style: kHeadingOne.copyWith(
                                      color: kBlack, fontSize: 32),
                                ),
                                Text(
                                  'employees',
                                  style: kSubtitle.copyWith(color: kBlack),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: kPaddingAll,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .57,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      kDarkestBlue,
                      kDarkestBlue,
                      kBlue,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: MenuItem(
                            onTap: () {
                              print('check in tapped');
                              //
                            },
                            illustration:
                                SvgPicture.asset("assets/images/tick.svg"),
                            label: "Check In",
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          flex: 1,
                          child: MenuItem(
                            onTap: () {
                              print('check out tapped');
                              //
                            },
                            illustration:
                                SvgPicture.asset("assets/images/close.svg"),
                            label: "Check out",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        print("attendance history tapped");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 175,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: kLightBlue,
                                borderRadius: BorderRadius.all(kBorderRadius)),
                            padding: kPaddingAll,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/chart.svg',
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Attendance History",
                                  style: kSubtitle.copyWith(
                                      color: kBlack,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
