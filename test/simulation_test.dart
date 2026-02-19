import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niu_guardian/core/utils/code_generator.dart';

void main() {
  test('Simulate Form Submission Loop with Exact User Data', () {
    final parentName = "Julio Alfredo";
    final parentSurname = "Ajpacaja Cano";

    final child1Name = "Julio Enrique";
    final child1Surname = "Ajpacaja Estrada";
    final child1Birthdate = DateTime(2015, 1, 1);

    final child2Name = "Julio Alfonso";
    final child2Surname = "Ajpacaja Estrada";
    final child2Birthdate = DateTime(2015, 1, 2);

    final List<String> existingCodes = [];

    debugPrint("--- Child 1 ---");
    final code1 = CodeGenerator.generate(
      parentName: parentName,
      parentSurname: parentSurname,
      childName: child1Name,
      childSurname: child1Surname,
      childBirthdate: child1Birthdate,
      existingCodes: existingCodes,
    );
    debugPrint("Generated Code 1: $code1");

    existingCodes.add(code1);
    debugPrint("Existing Codes after 1: $existingCodes");

    debugPrint("--- Child 2 ---");
    final code2 = CodeGenerator.generate(
      parentName: parentName,
      parentSurname: parentSurname,
      childName: child2Name,
      childSurname: child2Surname,
      childBirthdate: child2Birthdate,
      existingCodes: existingCodes,
    );
    debugPrint("Generated Code 2: $code2");
    existingCodes.add(code2);

    debugPrint("--- Child 3 (Duplicate trigger) ---");
    try {
      CodeGenerator.generate(
        parentName: parentName,
        parentSurname: parentSurname,
        childName: child2Name,
        childSurname: child2Surname,
        childBirthdate: child2Birthdate,
        existingCodes: existingCodes,
      );
      fail("Se esperaba una excepción");
    } catch (e) {
      debugPrint("SUCCESS:  $e");
      expect(e.toString(), contains("No es posible guardar"));
    }
  });
}
