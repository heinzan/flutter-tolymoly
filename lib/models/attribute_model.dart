class AttributeModel {
  int id;
  String name;
  String labelName;
  String tableName;
  bool isRequired;
  int attributeType;
  int textboxInputType;

  AttributeModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.labelName = map['label_name'];
    this.tableName = map['table_name'];
    this.isRequired = map['is_required'] == 0 ? false : true;
    this.attributeType = map['attribute_type'];
    this.textboxInputType = map['textbox_input_type'];
  }
}
