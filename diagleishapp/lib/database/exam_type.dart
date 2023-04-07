import 'package:flutter/material.dart';
import 'package:diagleishapp/models/exam.dart';

const typeExam = [
  Exam(
    id: "2136d2d2-cec9-4b44-8c7f-3e97f876b737",
    name: "Latifah Limbani",
    result: ResultType.positivo,
    specificity: 40.3,
    sensitivity: 12.0,
    image: AssetImage('assets/images/result_exam.png'),
  ),
  Exam(
    id: "81fcd93d-0f67-4d8d-8061-d0154ff3b690",
    name: "Quirin Kamila",
    result: ResultType.positivo,
    specificity: 40.3,
    sensitivity: 12.0,
    image: AssetImage('assets/images/result_exam.png'),
  ),
  Exam(
    id: "927a8f7b-3460-4699-9f28-d400876bf4d8",
    name: "Phaidros Elpis",
    result: ResultType.positivo,
    specificity: 40.3,
    sensitivity: 12.0,
    image: AssetImage('assets/images/result_exam.png'),
  ),
  Exam(
    id: "e0289f4d-4304-4338-91d1-b76d0d30a804",
    name: "Valeriu Tovah",
    result: ResultType.positivo,
    specificity: 40.3,
    sensitivity: 12.0,
    image: AssetImage('assets/images/result_exam.png'),
  ),
  Exam(
    id: "30724eb1-91b3-4cff-91ec-aa20882fe73a",
    name: "Nona Kunal",
    result: ResultType.positivo,
    specificity: 40.3,
    sensitivity: 12.0,
    image: AssetImage('assets/images/result_exam.png'),
  ),
];

class ExamType {
  const ExamType();

  List getList() {
    List newList = [];

    for (Exam type in typeExam) {
      newList.add(type);
    }

    return newList;
  }
}
