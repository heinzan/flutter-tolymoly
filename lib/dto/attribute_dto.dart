import 'package:tolymoly/dto/reference_dto.dart';

class AttributeDto {
  int id;
  String name;
  String labelName;
  int attributeType;
  int textboxInputType;
  bool isRequired;
  List<ReferenceDto> referenceDtos;

  AttributeDto.fromMap(Map<String, dynamic> map) {
    var list = map['reference'] as List;
    List<ReferenceDto> referenceList =
        list.map((i) => ReferenceDto.fromMap(i)).toList();

    this.id = map['id'];
    this.name = map['name'];
    this.labelName = map['labelName'];
    this.attributeType = map['attributeType'];
    this.textboxInputType = map['textboxInputType'];
    this.isRequired = map['isRequired'];
    this.referenceDtos = referenceList;
  }
}
