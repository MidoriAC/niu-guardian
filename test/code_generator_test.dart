import 'package:flutter/material.dart';
import 'package:niu_guardian/core/utils/code_generator.dart';

void main() {
  final existingCodes = <String>[];

  // Child 1
  final code1 = CodeGenerator.generate(
    parentName: "Julio Alfredo",
    parentSurname: "Ajpacaja Cano",
    childName: "Julio Pedro",
    childSurname: "Cano Estrada",
    childBirthdate: DateTime(2015, 1, 10),
    existingCodes: existingCodes,
  );

  debugPrint("Code 1: $code1");
  existingCodes.add(code1);
  final code2 = CodeGenerator.generate(
    parentName: "Julio Alfredo",
    parentSurname: "Ajpacaja Cano",
    childName: "Julio Elias",
    childSurname: "Cano Estrada",
    childBirthdate: DateTime(2015, 1, 11),
    existingCodes: existingCodes,
  );
  debugPrint("Code 2: $code2");
  final code3 = CodeGenerator.generate(
    parentName: "Julio Alfredo",
    parentSurname: "Ajpacaja Cano",
    childName: "Julio Hernan",
    childSurname: "Cano Estrada",
    childBirthdate: DateTime(2015, 1, 11),
    existingCodes: existingCodes,
  );
  debugPrint("Code 2: $code3");

  if (code1 == code2) {
    debugPrint("FAIL: Codes are identical!");
  } else {
    debugPrint("SUCCESS: Codes are unique.");
  }
}
