import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

import 'data.dart';
import 'modconfig.dart';
import 'home.dart';

late List<ModConfig> modConfigs;

void main() async {
  var response = await http.get(Uri(path: 'assets/mods.json'));
  if (response.statusCode != 200) {
    return;
  }

  Iterable<dynamic> modList = jsonDecode(response.body);
  modConfigs = List<ModConfig>.from(modList.map((m) => ModConfig.fromJson(m)));

  var home = Home(modConfigs);

  DivElement output = querySelector("#output") as DivElement;
  output.children.add(home.getElement());
}

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
      if (disallowedMod.extraData!.isEmpty) {
        disallowedMod.extraData = null;
      }
    }

    if (mod.status == Status.unknown && disallowedMod.extraData == null) {
      continue;
    }
    disallowedMap.putIfAbsent(mod.name, () => disallowedMod);
  }
  var config = Config(0, 0, disallowedMap);

  var json = jsonEncode(config);

  var blob = Blob([json], 'application/json', 'native');
  var link = querySelector('#link') as AnchorElement;
  link.download = "blc-mod-config.json";
  link.href = Url.createObjectUrlFromBlob(blob).toString();
  link.click();
}
