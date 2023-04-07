import 'package:flutter/material.dart';

enum ResultType {
  positivo,
  negativo,
  inconclusivo,
}

class Exam {
  final String id;
  final String name;
  final ResultType result;
  final double specificity;
  final double sensitivity;
  final AssetImage image;

  const Exam({
    required this.id,
    required this.name,
    required this.result,
    required this.specificity,
    required this.sensitivity,
    required this.image,
  });
}
