import 'dart:core';

import 'package:flutter/material.dart';

class Events {
  final String id;
  final String name;
  final String desc;
  final String date;
  final String sem;
  final String batch;
  final Map<String, bool> students;

  Events({
    @required this.id,
    @required this.name,
    @required this.desc,
    @required this.batch,
    @required this.date,
    @required this.sem,
    this.students,
  });
}
