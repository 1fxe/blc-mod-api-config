import 'dart:html';

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