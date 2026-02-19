class CodeGenerator {
  static String generate({
    required String parentName,
    required String parentSurname,
    required String childName,
    required String childSurname,
    required DateTime childBirthdate,
    required List<String> existingCodes,
  }) {
    parentName = parentName.trim().toUpperCase();
    parentSurname = parentSurname.trim().toUpperCase();
    childName = childName.trim().toUpperCase();
    childSurname = childSurname.trim().toUpperCase();

    final String month = childBirthdate.month.toString().padLeft(2, '0');

    //! Generar código base
    String baseCode = _buildCode(
      pName: parentName,
      pSurname: parentSurname,
      cName: childName,
      cSurname: childSurname,
      month: month,
      index: 0,
    );

    if (!existingCodes.contains(baseCode)) {
      return baseCode;
    }

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
        'El código generado ($codeLevel2) ya está en uso. No es posible guardar este registro.');
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
