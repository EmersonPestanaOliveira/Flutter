class Animal {
  void som() {
    print('Som genérico');
  }
}

class Gato extends Animal {
  @override
  void som() {
    print('Miau');
  }
}
