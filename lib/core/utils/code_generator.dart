class CodeGenerator {
  static String generate({
    required String parentName,
    required String parentSurname,
    required String childName,
    required String childSurname,
    required DateTime childBirthdate,
    required List<String> existingCodes,
  }) {
    final String month = childBirthdate.month.toString().padLeft(2, '0');

    //? Primero intento para la creación de códigos
    final codeLevel1 = _buildCode(
      pName: parentName,
      pSurname: parentSurname,
      cName: childName,
      cSurname: childSurname,
      month: month,
      index: 0,
    );

    if (!existingCodes.contains(codeLevel1)) {
      return codeLevel1;
    }

    //? Segundo intento para cuando se tiene un código igual entonces usar la segunda letra
    final codeLevel2 = _buildCode(
      pName: parentName,
      pSurname: parentSurname,
      cName: childName,
      cSurname: childSurname,
      month: month,
      index: 1,
    );

    if (!existingCodes.contains(codeLevel2)) {
      return codeLevel2;
    }

    throw Exception(
        "Lo sentimos, el código $codeLevel2 ya esta en uso, intente con otro");
  }

  static String _buildCode({
    required String pName,
    required String pSurname,
    required String cName,
    required String cSurname,
    required String month,
    required int index,
  }) {
    final String pN = _getCharSafe(pName, index);
    final String pS = _getCharSafe(pSurname, index);
    final String cN = _getCharSafe(cName, index);
    final String cS = _getCharSafe(cSurname, index);

    return "$pN$pS-$cN$cS-$month".toUpperCase();
  }

  //* Obtiene el caracter en el [index] deseado.
  //* Si el string es muy corto, devuelve el primer caracter (fallback).
  static String _getCharSafe(String text, int index) {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return 'X';

    if (cleanText.length > index) {
      return cleanText[index];
    }
    return cleanText[0];
  }
}
