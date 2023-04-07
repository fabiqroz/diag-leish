import 'package:diagleishapp/models/info.dart';
import 'package:flutter/material.dart';
import 'package:diagleishapp/widgets/radio_vertical_three.dart';
import 'package:diagleishapp/utils/app_routes.dart';

class AnalyzeWidget extends StatefulWidget {
  const AnalyzeWidget({Key? key}) : super(key: key);

  @override
  State<AnalyzeWidget> createState() => _AnalyzeWidgetState();
}

class _AnalyzeWidgetState extends State<AnalyzeWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  dynamic file;
  int _currentStep = 0;
  final symptomsController = TextEditingController();
  final diagnosisController = TextEditingController();

  final symptoms = List<int>.filled(12, 1);
  final diagnosis = List<int>.filled(2, 1);

  TextStyle titleStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 18,
  );

  void _submit() {
    bool isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      final Info info = Info(
          symptoms: symptoms,
          otherSymptoms: symptomsController.text,
          diagnosis: diagnosis,
          otherDiagnosis: diagnosisController.text);

      Navigator.of(context).pushNamed(AppRoutes.result, arguments: info);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Preencha o questionário corretamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stepper(
        type: StepperType.vertical,
        physics: const ClampingScrollPhysics(),
        steps: _mySteps(context),
        currentStep: _currentStep,
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _currentStep == 9 // this is the last step
                    ? Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Concluir'),
                          onPressed: _submit,
                        ),
                      )
                    : Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.navigate_next),
                          onPressed: details.onStepContinue,
                          label: const Text('Continuar'),
                        ),
                      ),
                Expanded(
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.navigate_before,
                      color: Theme.of(context).primaryColor,
                    ),
                    label: Text(
                      'Voltar',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: _currentStep == 0 ? null : details.onStepCancel,
                  ),
                ),
              ],
            ),
          );
        },
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        onStepContinue: () {
          setState(() {
            if (_currentStep < _mySteps(context).length - 1) {
              _currentStep = _currentStep + 1;
            } else {
              //Logic to check if everything is completed
            }
          });
        },
        onStepCancel: () {
          setState(
            () {
              if (_currentStep > 0) {
                _currentStep = _currentStep - 1;
              } else {
                _currentStep = 0;
              }
            },
          );
        },
      ),
    );
  }

  List<Step> _mySteps(BuildContext context) {
    const ans = ["Sim", "Não", "Ignorado"];
    const ans2 = ["Positivo", "Negativo", "Não realizado"];
    List<Step> steps = [
      Step(
        title: const Text('Sintomas (1-7)'),
        content: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta Febre",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[0] = id;
              },
              description: ans,
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta fraqueza",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[1] = id;
              },
              description: ans,
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Sintomas (2-7)'),
        content: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta edema",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[2] = id;
              },
              description: ans,
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta perda de peso",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[3] = id;
              },
              description: ans,
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Sintomas (3-7)'),
        content: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta tosse ou diarréia",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[4] = id;
              },
              description: ans,
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta palidez",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[5] = id;
              },
              description: ans,
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: const Text('Sintomas (4-7)'),
        content: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta esplenomegalia",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[6] = id;
              },
              description: ans,
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta quadro infeccioso",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[7] = id;
              },
              description: ans,
            ),
          ],
        ),
        isActive: _currentStep >= 4,
      ),
      Step(
        title: const Text('Sintomas (5-7)'),
        content: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta hemorragia",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[8] = id;
              },
              description: ans,
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta hepatomegalia",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[9] = id;
              },
              description: ans,
            ),
          ],
        ),
        isActive: _currentStep >= 5,
      ),
      Step(
        title: const Text('Sintomas (6-7)'),
        content: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta icterícia",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[10] = id;
              },
              description: ans,
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "O paciente apresenta HIV",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                symptoms[11] = id;
              },
              description: ans,
            ),
          ],
        ),
        isActive: _currentStep >= 6,
      ),
      Step(
        title: const Text('Sintomas (7-7)'),
        content: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Especifique outros sitomas",
                style: titleStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              child: TextField(
                controller: symptomsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 7,
      ),
      Step(
        title: const Text('Diagnóstico (1-2)'),
        content: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Diagnóstico Parasitológico",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                diagnosis[0] = id;
              },
              description: ans2,
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Diagnóstico Imunológico (IFI)",
                style: titleStyle,
              ),
            ),
            RadioVerticalThree(
              option: 1,
              radioValue: (int id) {
                diagnosis[1] = id;
              },
              description: ans2,
            ),
          ],
        ),
        isActive: _currentStep >= 8,
      ),
      Step(
        title: const Text('Diagnóstico (2-2)'),
        content: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Especificar outros procedimentos",
                style: titleStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: diagnosisController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 9,
      ),
      Step(
        title: const Text('Fim'),
        content: Text(
          '',
          style: titleStyle,
          textAlign: TextAlign.justify,
        ),
        isActive: _currentStep >= 10,
        state: StepState.complete,
      ),
    ];
    return steps;
  }
}
