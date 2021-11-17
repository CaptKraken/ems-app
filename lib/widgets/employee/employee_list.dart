import 'dart:async';

import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/employee/employee_edit_screen.dart';
import 'package:ems/screens/employee/employee_info_screen.dart';
import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeeList extends StatefulWidget {
  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  final UserService _userService = UserService.instance;

  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => EmployeeListScreen()));
    } else {
      return false;
    }
  }

  // Future fetchData(String text) async {
  //   final response = await http.get(Uri.parse(
  //       "http://rest-api-laravel-flutter.herokuapp.com/api/search?search=${text}"));
  //   if (response.statusCode == 200) {
  //     print('okey');
  //   } else {
  //     print('not okey');
  //   }
  // }
  List<User> userDisplay = [];
  List<User> user = [];

  bool _isLoading = true;
  bool order = false;
  // bool sort = false;

  @override
  void initState() {
    try {
      _userService.findMany().then((usersFromServer) {
        setState(() {
          _isLoading = false;
          user.addAll(usersFromServer);
          userDisplay = user;

          userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
        });
      });
      super.initState();
    } catch (err) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
            colors: [
              color1,
              color,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: _isLoading
          ? Container(
              padding: EdgeInsets.only(top: 320),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Fetching Data'),
                    SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(
                      color: kWhite,
                    ),
                  ],
                ),
              ),
            )
          : userDisplay.isEmpty
              ? Column(
                  children: [
                    _searchBar(),
                    Container(
                      padding: EdgeInsets.only(top: 200),
                      child: Column(
                        children: [
                          Text(
                            'NO EMPLOYEE ADDED YET!!',
                            style: kHeadingThree.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                            'assets/images/no-data.jpeg',
                            width: 220,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _searchBar(),
                    Expanded(
                      child: ListView.builder(
                          itemCount: userDisplay.length,
                          itemBuilder: (context, index) {
                            return _listItem(index);
                          }),
                    ),
                  ],
                ),
    );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: 'Search...',
                errorStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                // if (text.isEmpty) {
                //   userDisplay;
                // }
                setState(() {
                  userDisplay = user.where((user) {
                    var userName = user.name!.toLowerCase();
                    return userName.contains(text);
                  }).toList();
                });
              },
            ),
          ),
          PopupMenuButton(
            color: kDarkestBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            onSelected: (int selectedValue) {
              if (selectedValue == 0) {
                setState(() {
                  userDisplay.sort((a, b) =>
                      a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
                });
              }
              if (selectedValue == 1) {
                setState(() {
                  userDisplay.sort((b, a) =>
                      a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
                });
              }
              if (selectedValue == 2) {
                setState(() {
                  userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
                });
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('From A-Z'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('From Z-A'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('by ID'),
                value: 2,
              ),
            ],
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }

  _listItem(index) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      child: Container(
        width: double.infinity,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Image.asset(
                'assets/images/profile-icon-png-910.png',
                width: 75,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 240,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Name: '),
                          Text(
                            userDisplay[index].name.toString(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('ID: '),
                          Text(userDisplay[index].id.toString()),
                        ],
                      )
                    ],
                  ),
                  // SizedBox(
                  //   width: 50,
                  // ),
                  PopupMenuButton(
                    color: kDarkestBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onSelected: (int selectedValue) {
                      if (selectedValue == 1) {
                        int id = userDisplay[index].id as int;
                        String name = userDisplay[index].name.toString();
                        String phone = userDisplay[index].phone.toString();
                        String email = userDisplay[index].email.toString();
                        String address = userDisplay[index].address.toString();
                        String position =
                            userDisplay[index].position.toString();
                        String skill = userDisplay[index].skill.toString();
                        String salary = userDisplay[index].salary.toString();
                        String role = userDisplay[index].role.toString();
                        String status = userDisplay[index].status.toString();
                        String rate = userDisplay[index].rate.toString();
                        String background =
                            userDisplay[index].background.toString();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => EmployeeEditScreen(
                                id,
                                name,
                                phone,
                                email,
                                address,
                                position,
                                skill,
                                salary,
                                role,
                                status,
                                rate,
                                background)));
                      }
                      if (selectedValue == 0) {
                        Navigator.of(context).pushNamed(
                          EmployeeInfoScreen.routeName,
                          arguments: userDisplay[index].id,
                        );
                      }
                      if (selectedValue == 2) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text('This action cannot be undone!'),
                            actions: [
                              OutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteData(userDisplay[index].id as int);
                                },
                                child: Text('Yes'),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              OutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                borderSide: BorderSide(color: Colors.red),
                                child: Text('No'),
                              )
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text('Info'),
                        value: 0,
                      ),
                      PopupMenuItem(
                        child: Text('Edit'),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 2,
                      ),
                    ],
                    icon: Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
