class Animal {
  void falar() {
    print('Animal falando');
  }
}

class Cachorro extends Animal {
  @override
  void falar() {
    super.falar();
    print('Cachorro latindo');
  }
}
