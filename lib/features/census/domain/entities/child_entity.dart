class ChildEntity {
  final int? id;
  final String name;
  final String surname;
  final DateTime birthdate;
  final int age;
  final String hairColor;
  final String uniqueCode;

  ChildEntity({
    this.id,
    required this.name,
    required this.surname,
    required this.birthdate,
    required this.age,
    required this.hairColor,
    required this.uniqueCode,
  });

  ChildEntity copyWith({
    int? id,
    String? name,
    String? surname,
    DateTime? birthdate,
    int? age,
    String? hairColor,
    String? uniqueCode,
  }) {
    return ChildEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthdate: birthdate ?? this.birthdate,
      age: age ?? this.age,
      hairColor: hairColor ?? this.hairColor,
      uniqueCode: uniqueCode ?? this.uniqueCode,
    );
  }
}
