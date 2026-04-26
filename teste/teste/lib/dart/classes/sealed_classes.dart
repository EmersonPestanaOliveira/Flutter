sealed class Resultado {}

class Sucesso extends Resultado {
  final String valor;
  Sucesso(this.valor);
}

class Erro extends Resultado {
  final String mensagem;
  Erro(this.mensagem);
}
