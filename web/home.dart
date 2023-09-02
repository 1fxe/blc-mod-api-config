import 'dart:html';
import 'modconfig.dart';
import 'litecheckbox.dart';

class Home {
  late final Element _element;

  Home(List<ModConfig> modConfigs) {
    _element = _generateElement(modConfigs);
  }

  Element getElement() {
    return _element;
  }

  Element _generateElement(List<ModConfig> modConfigs) {
    DivElement body = DivElement();

    DivElement searchBody = DivElement();
    InputElement search = InputElement();
    DivElement modBody = DivElement();
    modBody.classes.add("mod-body");

    searchBody.classes.add("search");
    search.id = "search";
    search.classes.add("search-input");
    search.maxLength = 20;
    search.placeholder = "Search..";
    search.type = "text";
    
    searchBody.children.add(search);

    body.children.addAll([searchBody, _generateToggleKey(), modBody]);
    modBody.children.addAll(modConfigs.map((e) => e.element));



    search.onKeyUp.listen((event) {
      if (search.value == null) {
        return;
      }

      if (!search.value!.toLowerCase().contains(RegExp("[a-z]")) &&
          search.value!.isNotEmpty) {
        return;
      }

      modBody.children.clear();
      for (var value in modConfigs) {
        if (value.modName.toLowerCase().contains(search.value!.toLowerCase())) {
          modBody.children.add(value.element);
        }
      }
    });
    return body;
  }

  DivElement _generateToggleKey() {
    DivElement key = DivElement();
    key.id = "key";
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

    key.children.addAll([
      unchecked.element,
      userSet,
      enabled.element,
      forceEnabled,
      disabled.element,
      forceDisabled
    ]);

    return key;
  }
}
