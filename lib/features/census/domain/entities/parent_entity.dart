import 'child_entity.dart';

class ParentEntity {
  final int? id;
  final String name;
  final String surname;
  final String email;
  final String phone;
  final DateTime birthdate;
  final String documentId;
  final String civilStatus;
  final String gender;
  final bool hasHealthInsurance;
  final bool isEmployed;
  final String cityOfResidence;
  final String notes;
  final List<ChildEntity> children;

  ParentEntity({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.documentId,
    required this.civilStatus,
    required this.gender,
    required this.hasHealthInsurance,
    required this.isEmployed,
    required this.cityOfResidence,
    required this.notes,
    this.children = const [],
  });

  ParentEntity copyWith({
    int? id,
    String? name,
    String? surname,
    String? email,
    String? phone,
    DateTime? birthdate,
    String? documentId,
    String? civilStatus,
    String? gender,
    bool? hasHealthInsurance,
    bool? isEmployed,
    String? cityOfResidence,
    String? notes,
    List<ChildEntity>? children,
  }) {
    return ParentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthdate: birthdate ?? this.birthdate,
      documentId: documentId ?? this.documentId,
      civilStatus: civilStatus ?? this.civilStatus,
      gender: gender ?? this.gender,
      hasHealthInsurance: hasHealthInsurance ?? this.hasHealthInsurance,
      isEmployed: isEmployed ?? this.isEmployed,
      cityOfResidence: cityOfResidence ?? this.cityOfResidence,
      notes: notes ?? this.notes,
      children: children ?? this.children,
    );
  }
}
