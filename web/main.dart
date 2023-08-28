import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

import 'data.dart';

var validator = NodeValidatorBuilder.common()
  ..allowElement("ion-icon", attributes: ["name"]);

var modConfigs = List<ModConfig>.empty(growable: true);

void main() async {
  var response = await http.get(Uri(path: 'assets/mods.json'));
  if (response.statusCode != 200) {
    return;
  }

  Iterable<dynamic> modList = jsonDecode(response.body);

  modConfigs = List<ModConfig>.from(modList.map((m) => ModConfig.fromJson(m)));

  generateToggleKey();

  DivElement output = querySelector("#output") as DivElement;
  InputElement search = querySelector("#search") as InputElement;
  output.children.addAll(modConfigs.map((e) => e.element));

  querySelector("#save")?.onClick.listen((event) => save());

  search.onKeyUp.listen((event) {
    if (search.value == null) {
      return;
    }

    if (!search.value!.toLowerCase().contains(RegExp("[a-z]")) &&
        search.value!.isNotEmpty) {
      return;
    }

    output.children.clear();
    for (var value in modConfigs) {
      if (value.modName.toLowerCase().contains(search.value!.toLowerCase())) {
        output.children.add(value.element);
      }
    }
  });
}

void generateToggleKey() {
  DivElement key = querySelector("#key") as DivElement;
  var unchecked = LiteCheckBox();
  unchecked.add("unchecked");
  var enabled = LiteCheckBox();
  enabled.add("force-enabled");
  var disabled = LiteCheckBox();
  disabled.add("force-disabled");
  var userSet = DivElement();
  userSet.text = "User Set";
  var forceEnabled = DivElement();
  forceEnabled.text = "Force Enabled";
  var forceDisabled = DivElement();
  forceDisabled.text = "Force Disabled";
  
  key.children
      .addAll([unchecked.element, userSet, enabled.element, forceEnabled, disabled.element, forceDisabled]);
}

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
    topPart.onClick.listen((event) {
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
    });

    topPart.children.add(checkBox.element);

    DivElement title = DivElement();
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

class LiteCheckBox {
  final Element element = DivElement();

  LiteCheckBox() {
    element.classes.add("lite-checkbox-outer");

    DivElement inner = DivElement();
    inner.classes.add("lite-checkbox-inner");
    element.children.add(inner);
  }

  Element add(clazz) {
    element.classes.add(clazz);
    element.children[0].classes.add(clazz);
    return element;
  }

  Element remove(clazz) {
    element.classes.remove(clazz);
    element.children[0].classes.remove(clazz);
    return element;
  }
}

// TODO Modal to remove fields

void save() {
  var disallowedMap = <String, DisallowedMod>{};
  for (var mod in modConfigs) {
    var disallowedMod = DisallowedMod(mod.status.value);
    if (mod.fields.isNotEmpty) {
      disallowedMod.extraData = [];
      mod.fields.forEach((key, value) {
        if (value.value != null) {
          disallowedMod.extraData!.add(JsonBoolean(value.value));
        }
      });
    }

    if (mod.fields.isNotEmpty || mod.status != Status.unknown) {
      disallowedMap.putIfAbsent(mod.name, () => disallowedMod);
    }
  }
  var config = Config(0, 0, disallowedMap);

  var json = jsonEncode(config);

  var blob = Blob([json], 'application/json', 'native');
  var link = querySelector('#link') as AnchorElement;
  link.download = "blc-mod-config.json";
  link.href = Url.createObjectUrlFromBlob(blob).toString();
  link.click();
}
