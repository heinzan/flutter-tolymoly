import 'package:tolymoly/dto/reference_dto.dart';

class AttributeDto2 {
  int id;
  String name;
  String label;
  int type;
  int inputType;
  bool isRequired;
  List<ReferenceDto> referenceDtos;
  String value;

  AttributeDto2.fromMap(Map<String, dynamic> map) {
    var list = map['reference'] as List;
    List<ReferenceDto> referenceList =
        list.map((i) => ReferenceDto.fromMap(i)).toList();

    this.id = map['id'];
    this.name = map['name'];
    this.label = map['label'];
    this.type = map['type'];
    this.inputType = map['inputType'];
    this.isRequired = map['isRequired'];
    this.referenceDtos = referenceList;
    this.value = map['value'];
  }
}
