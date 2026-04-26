# gabriel_clone

Aplicativo Flutter para iOS e Android da primeira sprint do Gabriel Clone.

## Arquitetura

O projeto usa arquitetura feature-first com Clean Architecture:

```text
lib/
  core/
  features/
    home/
      data/
      domain/
      presentation/
```

## Inversao de dependencia

A camada `domain` define contratos e regras de negocio. Ela nunca importa `data`.

A camada `presentation` consome casos de uso e estados. Ela nunca importa `data` diretamente.

A camada `data` implementa contratos definidos em `domain` e conversa com servicos externos, como Firebase.

Toda dependencia concreta deve ser registrada em `lib/core/di/injection_container.dart` via GetIt. O app acessa dependencias pelo service locator `sl`, e nao por construcao manual espalhada nas telas.

## Firebase

O app inicializa Firebase antes do `runApp` usando `DefaultFirebaseOptions.currentPlatform`.

Instancias compartilhadas como `FirebaseFirestore.instance` e `FirebaseStorage.instance` ficam registradas como singletons no GetIt.