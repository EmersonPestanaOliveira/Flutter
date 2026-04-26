class Vetor {
  final int x;
  final int y;

  Vetor(this.x, this.y);

  Vetor operator +(Vetor outro) {
    return Vetor(x + outro.x, y + outro.y);
  }
}
