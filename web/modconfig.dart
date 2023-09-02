import 'dart:html';
import 'litecheckbox.dart';

var validator = NodeValidatorBuilder.common()
  ..allowElement("ion-icon", attributes: ["name"]);

enum Status {
  unknown(null),
  enabled(false),
  disabled(true);

  final dynamic value;

  const Status(this.value);
}

class ModConfig {
  final String name;
  final String modName;
  final String description;
  final Map<String, Status> fields;
  Status status;
  late final Element element;

  ModConfig(
      this.name, this.modName, this.description, this.status, this.fields) {
    element = _toElement();
  }

  factory ModConfig.fromJson(dynamic json) {
    var listOfFields =
    (json['fields'] as List).map((item) => item as String).toList();

    var fieldMap = {for (var field in listOfFields) field: Status.unknown};
    return ModConfig(
      json['name'],
      json['modName'],
      json['description'],
      Status.unknown,
      fieldMap,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'fields': fields};

  Element _toElement() {
    DivElement parent = DivElement();
    parent.classes.add("mod-config");

    DivElement topPart = DivElement();
    topPart.classes.add("mod-config-header");

    LiteCheckBox checkBox = LiteCheckBox();
    checkBox.add("unchecked");

    click() {
      int index = status.index;
      index += 1;

      if (index > Status.values.length - 1) {
        index = 0;
      }

      status = Status.values[index];

      if (status == Status.unknown) {
        checkBox.remove("force-disabled");
        checkBox.add("unchecked");
      } else if (status == Status.enabled) {
        checkBox.remove("unchecked");
        checkBox.add("force-enabled");
      } else {
        checkBox.remove("force-enabled");
        checkBox.add("force-disabled");
      }
    }

    checkBox.element.onClick.listen((event) => click());

    topPart.children.add(checkBox.element);

    DivElement title = DivElement();
    title.onClick.listen((event) => click());
    title.text = modName;
    title.classes.add("mod-config-header-title");

    topPart.children.add(title);

    if (fields.isNotEmpty) {
      ButtonElement settingModal = ButtonElement();
      settingModal.setInnerHtml("<ion-icon name=\"options\"></ion-icon>",
          validator: validator);
      settingModal.classes.add("mod-config-header-button");
      topPart.children.add(settingModal);
    }

    DivElement desc = DivElement();
    desc.text = description;
    desc.classes.add("mod-config-desc");

    parent.children.addAll([topPart, desc]);

    return parent;
  }
}