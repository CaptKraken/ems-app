import 'package:ems/models/attendance.dart';
import 'package:ems/models/individual_attendance.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import './models/employee.dart';

const indiEmployee = const [
  Employee(
      name: 'Manut',
      id: '1',
      date: '1-2-2001',
      skill: 'mobile app developer',
      salary: 123,
      workRate: 'normal',
      contact: 011265895,
      background: '3 months experience'),
  Employee(
      name: 'Song',
      id: '2',
      date: '1-2-2001',
      skill: 'mobile app developer',
      salary: 321,
      workRate: 'normal',
      contact: 012345678,
      background: '3 months experience'),
  Employee(
      name: 'Sunny',
      id: '3',
      date: '1-2-2001',
      skill: 'mobile app developer',
      salary: 123,
      workRate: 'normal',
      contact: 011265895,
      background: '3 months experience'),
  Employee(
      name: 'Song',
      id: '4',
      date: '1-2-2001',
      skill: 'mobile app developer',
      salary: 321,
      workRate: 'normal',
      contact: 012345678,
      background: '3 months experience'),
  Employee(
      name: 'Manut',
      id: '5',
      date: '1-2-2001',
      skill: 'mobile app developer',
      salary: 123,
      workRate: 'normal',
      contact: 011265895,
      background: '3 months experience'),
  Employee(
      name: 'Song',
      id: '6',
      date: '1-2-2001',
      skill: 'mobile app developer',
      salary: 321,
      workRate: 'normal',
      contact: 012345678,
      background: '3 months experience'),
  Employee(
      name: 'Manut',
      id: '7',
      date: '1-2-2001',
      skill: 'mobile app developer',
      salary: 123,
      workRate: 'normal',
      contact: 011265895,
      background: '3 months experience'),
  Employee(
      name: 'Song',
      id: '8',
      date: '1-2-2001',
      skill: 'mobile app developer',
      salary: 321,
      workRate: 'normal',
      contact: 012345678,
      background: '3 months experience'),
];

const attendanceHistory = const [
  Attendance(
      name: 'Manut',
      id: '1',
      status: 'Presnet',
      textColor: Color(0xff334732),
      bgColor: Color(0xff9CE29B)),
  Attendance(
      name: 'Song',
      id: '2',
      status: 'Presnet',
      textColor: Color(0xff334732),
      bgColor: Color(0xff9CE29B)),
  Attendance(
      name: 'Sunny',
      id: '3',
      status: 'Absent',
      textColor: Color(0xffA03E3E),
      bgColor: Color(0xffFFCBCE)),
  Attendance(
      name: 'Elijah',
      id: '4',
      status: 'Late',
      textColor: Color(0xff5A5E45),
      bgColor: Color(0xffF3FDB6)),
  Attendance(
      name: 'Nikluas',
      id: '5',
      status: 'Absent',
      textColor: Color(0xffA03E3E),
      bgColor: Color(0xffFFCBCE)),
  Attendance(
      name: 'Rebekah',
      id: '6',
      status: 'Presnet',
      textColor: Color(0xff334732),
      bgColor: Color(0xff9CE29B)),
  Attendance(
      name: 'Vincent',
      id: '7',
      status: 'Permission',
      textColor: Color(0xff313B3F),
      bgColor: Color(0xff77B1C9)),
];

final individualAttendance = [
  IndividualAttendance(
    name: 'Kira Manut',
    id: '1',
    totalPresent: '10',
    totalAbsent: '5',
    totalPermission: '2',
    totalLate: '2',
    isAbsent: DateTime(2021, 10, 23),
    isPermission: DateTime(2021, 10, 25),
  ),
  IndividualAttendance(
    name: 'Kim Song',
    id: '2',
    totalPresent: '15',
    totalAbsent: '6',
    totalPermission: '3',
    totalLate: '3',
    isAbsent: DateTime(2021, 10, 24),
    isPermission: DateTime(2021, 10, 25),
  ),
  IndividualAttendance(
    name: 'Kheav Sunny',
    id: '3',
    totalPresent: '20',
    totalAbsent: '5',
    totalPermission: '3',
    totalLate: '3',
    isAbsent: DateTime(2021, 10, 24),
    isPermission: DateTime(2021, 10, 25),
  ),
];
