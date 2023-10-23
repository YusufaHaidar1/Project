import 'package:flutter/material.dart';
import 'package:uts/screens/Home.dart';
import 'package:uts/screens/Detail.dart';
import 'package:uts/screens/detail_complain.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/' : (_) => const Home(),
      "/detail": (_) => Detail(),
      "/detail-complain": (_) => const DetailComplain(),
    },
  ));
}

