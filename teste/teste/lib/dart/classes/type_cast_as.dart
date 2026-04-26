class Animal {
  void fazerSom() {
    print("Som genérico de animal");
  }
}

class Cachorro extends Animal {
  void latir() {
    print("Au Au!");
  }
}

void main() {
  Animal animal = Cachorro();

  Cachorro dog = animal as Cachorro;
  dog.latir();
}
