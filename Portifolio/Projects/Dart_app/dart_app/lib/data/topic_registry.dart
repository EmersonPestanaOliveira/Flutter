// lib/data/topic_registry.dart

// -- IMPORTAÇÕES DE TÓPICOS INDIVIDUAIS --
// Importe todos os seus arquivos de tópico aqui!
// Exemplo para a categoria 'fundamental':
import 'package:dart_app/data/study_data_model.dart';
import 'package:dart_app/data/topics/advanced/file_io.dart';
import 'package:dart_app/data/topics/advanced/generators.dart';
import 'package:dart_app/data/topics/advanced/isolates_parallelism.dart';
import 'package:dart_app/data/topics/advanced/metadata_annotations.dart';
import 'package:dart_app/data/topics/advanced/operator_overloading.dart';
import 'package:dart_app/data/topics/advanced/reflection_mirrors.dart';
import 'package:dart_app/data/topics/advanced/streams.dart';
import 'package:dart_app/data/topics/fundamental/async_await.dart';
import 'package:dart_app/data/topics/fundamental/conditional_structures.dart';
import 'package:dart_app/data/topics/fundamental/constants.dart';
import 'package:dart_app/data/topics/fundamental/enums.dart';
import 'package:dart_app/data/topics/fundamental/errors.dart';
import 'package:dart_app/data/topics/fundamental/functions.dart';
import 'package:dart_app/data/topics/fundamental/hello_word.dart';
import 'package:dart_app/data/topics/fundamental/loop_structures.dart';
import 'package:dart_app/data/topics/fundamental/null_safety.dart';
import 'package:dart_app/data/topics/fundamental/variables.dart';
import 'package:dart_app/data/topics/fundamental/comments.dart';
import 'package:dart_app/data/topics/fundamental/operators.dart';
import 'package:dart_app/data/topics/oop/abstract_classes.dart';

// Exemplo para a categoria 'oop':
import 'package:dart_app/data/topics/oop/classes_objects_attributes.dart';
import 'package:dart_app/data/topics/oop/constructors.dart';
import 'package:dart_app/data/topics/oop/extension_methods.dart';
import 'package:dart_app/data/topics/oop/getters_setters.dart';
import 'package:dart_app/data/topics/oop/inheritance.dart';
import 'package:dart_app/data/topics/oop/interfaces.dart';
import 'package:dart_app/data/topics/oop/interfaces_another_use.dart';
import 'package:dart_app/data/topics/oop/late_modifier.dart';
import 'package:dart_app/data/topics/oop/method_override.dart';
import 'package:dart_app/data/topics/oop/methods.dart';

// Exemplo para a categoria 'advanced':
import 'package:dart_app/data/topics/advanced/generics.dart';
import 'package:dart_app/data/topics/oop/mixins.dart';
import 'package:dart_app/data/topics/oop/pass_by_reference.dart';
import 'package:dart_app/data/topics/oop/static_modifier.dart';
import 'package:dart_app/data/topics/oop/super_keyword.dart';
import 'package:dart_app/data/topics/oop/type_cast_as_operator.dart';
// -- FIM DAS IMPORTAÇÕES DE TÓPICOS INDIVIDUAIS --

// Mapa que associa uma chave de string (o "ID" do tópico) ao seu TopicContent
final Map<String, TopicContent> _topicRegistry = {
  'hello_world': helloWorldTopic, // helloWorldTopic vem de hello_world.dart
  'variables': variablesTopic,
  'comments': commentsTopic,
  'operators': operatorsTopic,
  'constants': constantsTopic, // <--- NOVO
  'conditional_structures': conditionalStructuresTopic, // <--- NOVO
  'functions': functionsTopic, // <--- NOVO
  'null_safety': nullSafetyTopic, // <--- NOVO
  'errors': errorsTopic, // <--- NOVO
  'enums': enumsTopic,
  'loop_structures':
      loopStructuresTopic, // <-- Garanta que esta linha está aqui
  'async_await': asyncAwaitTopic,

  'classes_objects_attributes': classesObjectsAttributesTopic,
  'methods': methodsTopic,
  'constructors': constructorsTopic, // <--- NOVO
  'getters_setters': gettersSettersTopic, // <--- NOVO
  'static_modifier': staticModifierTopic, // <--- NOVO
  'late_modifier': lateModifierTopic, // <--- NOVO
  'pass_by_reference': passByReferenceTopic, // <--- NOVO
  'inheritance': inheritanceTopic, // <--- NOVO
  'method_override': methodOverrideTopic,
  'super_keyword': superKeywordTopic,
  'type_cast_as_operator': typeCastAsOperatorTopic, // <--- NOVO
  'abstract_classes': abstractClassesTopic, // <--- NOVO
  'interfaces': interfacesTopic, // <--- NOVO
  'interfaces_another_use': interfacesAnotherUseTopic, // <--- NOVO
  'mixins': mixinsTopic, // <--- NOVO
  'extension_methods': extensionMethodsTopic,

// Tópicos Avançados
  'generics': genericsTopic,
  'operator_overloading': operatorOverloadingTopic,
  'file_io': fileIoTopic,
  'reflection_mirrors': reflectionMirrorsTopic,
  'isolates_parallelism': isolatesParallelismTopic,
  'generators': generatorsTopic,
  'futures_error_handling': futuresErrorHandlingTopic,
  'streams': streamsTopic,
};

// Função auxiliar para obter o TopicContent por sua chave
TopicContent? getTopicContentByKey(String topicKey) {
  return _topicRegistry[topicKey];
}
