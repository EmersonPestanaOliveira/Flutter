// =============================================================
//  gabriel_clone — Firebase Seed Script
//  Pré-requisitos:
//    1. npm install firebase-admin
//    2. Baixar serviceAccountKey.json no Firebase Console:
//       Configurações do projeto → Contas de serviço → Gerar nova chave privada
//    3. Colocar serviceAccountKey.json na mesma pasta deste arquivo
//    4. node seed.js
// =============================================================

const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// ─── Helpers ────────────────────────────────────────────────
const ts = (dateStr) => admin.firestore.Timestamp.fromDate(new Date(dateStr));
const geo = (lat, lng) => new admin.firestore.GeoPoint(lat, lng);
const placeholder_img = (w, h, text) =>
  `https://placehold.co/${w}x${h}/1a1a2e/ffffff?text=${encodeURIComponent(text)}`;
const placeholder_audio = () =>
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
const placeholder_video = () =>
  "https://www.w3schools.com/html/mov_bbb.mp4";

// ─── 1. CÂMERAS (10 entradas — câmeras reais de SP) ─────────
const cameras = [
  { nome: "Câmera Paulista x Consolação",      localizacao: geo(-23.5617, -46.6558), ativo: true  },
  { nome: "Câmera Sé — Praça da Sé",           localizacao: geo(-23.5505, -46.6333), ativo: true  },
  { nome: "Câmera Pinheiros x Faria Lima",     localizacao: geo(-23.5676, -46.6927), ativo: true  },
  { nome: "Câmera Luz — Estação",              localizacao: geo(-23.5362, -46.6336), ativo: true  },
  { nome: "Câmera Ibirapuera — Portão 3",      localizacao: geo(-23.5874, -46.6576), ativo: true  },
  { nome: "Câmera Santana — Av. Cruzeiro do Sul", localizacao: geo(-23.5072, -46.6266), ativo: true },
  { nome: "Câmera Vila Mariana — Domingos de Morais", localizacao: geo(-23.5916, -46.6355), ativo: false },
  { nome: "Câmera Mooca — Av. Paes de Barros", localizacao: geo(-23.5516, -46.5997), ativo: true  },
  { nome: "Câmera Lapa — Av. Pompeia",         localizacao: geo(-23.5266, -46.7063), ativo: true  },
  { nome: "Câmera Santo André — Av. Industrial",localizacao: geo(-23.6563, -46.5322), ativo: false },
];

// ─── 2. ALERTAS (10 entradas) ────────────────────────────────
const tiposAlerta = [
  "Violência",
  "Acidente",
  "Roubo ou Furto de Veículos",
  "Roubo ou Furto",
  "Estelionato",
  "Vandalismo",
  "Invasão",
  "Outros",
];

const alertas = [
  { bairro: "Consolação",     cidade: "São Paulo", data: ts("2025-04-20T14:30:00"), descricao: "Briga entre pedestres na calçada próximo ao metrô.", tipo: "Violência" },
  { bairro: "Sé",             cidade: "São Paulo", data: ts("2025-04-19T09:15:00"), descricao: "Colisão entre dois veículos no cruzamento da Praça da Sé.", tipo: "Acidente" },
  { bairro: "Pinheiros",      cidade: "São Paulo", data: ts("2025-04-18T22:45:00"), descricao: "Veículo roubado na Rua dos Pinheiros, próximo ao bar.", tipo: "Roubo ou Furto de Veículos" },
  { bairro: "Santana",        cidade: "São Paulo", data: ts("2025-04-17T11:00:00"), descricao: "Furto de celular em ponto de ônibus na Av. Cruzeiro do Sul.", tipo: "Roubo ou Furto" },
  { bairro: "Vila Mariana",   cidade: "São Paulo", data: ts("2025-04-16T16:20:00"), descricao: "Golpe do falso entregador aplicado em moradora do bairro.", tipo: "Estelionato" },
  { bairro: "Mooca",          cidade: "São Paulo", data: ts("2025-04-15T08:00:00"), descricao: "Pichação em muro de escola pública na Av. Paes de Barros.", tipo: "Vandalismo" },
  { bairro: "Lapa",           cidade: "São Paulo", data: ts("2025-04-14T03:30:00"), descricao: "Invasão de domicílio registrada na Rua Guaicurus.", tipo: "Invasão" },
  { bairro: "Ibirapuera",     cidade: "São Paulo", data: ts("2025-04-13T19:00:00"), descricao: "Suspeito de porte ilegal de arma detido no parque.", tipo: "Violência" },
  { bairro: "Santo André",    cidade: "Santo André", data: ts("2025-04-12T13:45:00"), descricao: "Acidente com moto na Av. Industrial, vítima socorrida.", tipo: "Acidente" },
  { bairro: "Luz",            cidade: "São Paulo", data: ts("2025-04-11T07:10:00"), descricao: "Ocorrência diversa registrada pela equipe de patrulha.", tipo: "Outros" },
];

// ─── 3. USUÁRIOS (2 entradas de exemplo) ─────────────────────
const usuarios = [
  {
    nomeCompleto: "Carlos Silva Santos",
    dataNascimento: ts("1990-03-15T00:00:00"),
    cpf: "123.456.789-00",
    email: "carlos.silva@email.com",
    criadoEm: ts("2025-01-10T10:00:00"),
  },
  {
    nomeCompleto: "Ana Paula Rodrigues",
    dataNascimento: ts("1995-07-22T00:00:00"),
    cpf: "987.654.321-00",
    email: "ana.rodrigues@email.com",
    criadoEm: ts("2025-02-14T09:30:00"),
  },
];

// ─── 4. CASOS SOLUCIONADOS (3 entradas) ──────────────────────
const casosSolucionados = [
  {
    imagem: placeholder_img(600, 400, "Caso+Solucionado+1"),
    descricao: "Suspeito de série de roubos na zona norte identificado e preso após análise de imagens de câmeras de monitoramento.",
    cidade: "São Paulo",
    data: ts("2025-03-10T00:00:00"),
  },
  {
    imagem: placeholder_img(600, 400, "Caso+Solucionado+2"),
    descricao: "Veículo roubado recuperado em menos de 24 horas graças ao rastreamento via câmeras inteligentes da cidade.",
    cidade: "Santo André",
    data: ts("2025-02-28T00:00:00"),
  },
  {
    imagem: placeholder_img(600, 400, "Caso+Solucionado+3"),
    descricao: "Golpista que aplicou estelionato em idosos identificado por reconhecimento facial e encaminhado à delegacia.",
    cidade: "São Paulo",
    data: ts("2025-01-15T00:00:00"),
  },
];

// ─── 5. NOVIDADES (3 entradas) ───────────────────────────────
const novidades = [
  {
    imagem: placeholder_img(600, 300, "Novidade+1"),
    titulo: "Gabriel Clone expande cobertura para o ABC Paulista",
    data: ts("2025-04-15T00:00:00"),
  },
  {
    imagem: placeholder_img(600, 300, "Novidade+2"),
    titulo: "Nova funcionalidade: alerta em tempo real por bairro",
    data: ts("2025-03-20T00:00:00"),
  },
  {
    imagem: placeholder_img(600, 300, "Novidade+3"),
    titulo: "Parceria com a Secretaria de Segurança Pública de SP",
    data: ts("2025-02-10T00:00:00"),
  },
];

// ─── 6. OCORRÊNCIAS (3 entradas) ─────────────────────────────
const ocorrencias = [
  {
    informacoes: "Roubo a pedestre com uso de motocicleta.",
    quando: ts("2025-04-20T00:00:00"),
    horario: "22:15",
    audio: placeholder_audio(),
    descricao: "Vítima relatou que dois indivíduos em moto abordaram e levaram celular e carteira na Av. Paulista.",
    boletimOcorrencia: "BO-2025-0042381",
    multimidia: [placeholder_video(), placeholder_video(), placeholder_audio()],
  },
  {
    informacoes: "Colisão de trânsito com feridos.",
    quando: ts("2025-04-18T00:00:00"),
    horario: "07:40",
    audio: placeholder_audio(),
    descricao: "Dois veículos colidiram no cruzamento. SAMU acionado. Condutor de um dos veículos apresentava sinais de embriaguez.",
    boletimOcorrencia: "BO-2025-0039102",
    multimidia: [placeholder_video(), placeholder_audio(), placeholder_video()],
  },
  {
    informacoes: "Invasão de propriedade durante madrugada.",
    quando: ts("2025-04-14T00:00:00"),
    horario: "03:20",
    audio: placeholder_audio(),
    descricao: "Moradores acionaram o sistema ao detectar movimentação suspeita. Câmera registrou entrada não autorizada.",
    boletimOcorrencia: "BO-2025-0035876",
    multimidia: [placeholder_video(), placeholder_video(), placeholder_video()],
  },
];

// ─── 7. BUSCA VEÍCULOS (3 entradas) ──────────────────────────
const buscaVeiculos = [
  {
    informacoes: "Veículo Honda Civic prata, placa ABC-1234, roubado.",
    nome: "João",
    sobrenome: "Ferreira",
    email: "joao.ferreira@email.com",
    telefone: "(11) 99999-1111",
    perfilContato: placeholder_img(200, 200, "João+F"),
    cep: "01310-100",
    endereco: "Av. Paulista",
    numeroEndereco: "1000",
    gabriel: true,
    horarioContato: "08:00 - 18:00",
  },
  {
    informacoes: "Moto Yamaha Factor 150 azul, placa XYZ-5678, furtada.",
    nome: "Mariana",
    sobrenome: "Costa",
    email: "mariana.costa@email.com",
    telefone: "(11) 98888-2222",
    perfilContato: placeholder_img(200, 200, "Mariana+C"),
    cep: "04101-300",
    endereco: "Rua Domingos de Morais",
    numeroEndereco: "500",
    gabriel: false,
    horarioContato: "10:00 - 20:00",
  },
  {
    informacoes: "Caminhonete Ford Ranger branca, placa DEF-9012, roubada.",
    nome: "Roberto",
    sobrenome: "Almeida",
    email: "roberto.almeida@email.com",
    telefone: "(11) 97777-3333",
    perfilContato: placeholder_img(200, 200, "Roberto+A"),
    cep: "02311-000",
    endereco: "Av. Cruzeiro do Sul",
    numeroEndereco: "1500",
    gabriel: true,
    horarioContato: "Qualquer horário",
  },
];

// ─── 8. LOCALIDADE (3 entradas) ──────────────────────────────
const localidades = [
  { cep: "01310-100", numero: "1000", perfil: placeholder_img(400, 300, "Paulista") },
  { cep: "04101-300", numero: "500",  perfil: placeholder_img(400, 300, "Vila+Mariana") },
  { cep: "02311-000", numero: "1500", perfil: placeholder_img(400, 300, "Santana") },
];

// ─── 9. VÍDEOS (3 por câmera = 30 total) ─────────────────────
function gerarVideosDaCamera(cameraId, cameraGeo, cameraNome) {
  const videos = [];
  for (let i = 1; i <= 3; i++) {
    const hora = String(8 + i).padStart(2, "0");
    videos.push({
      cameraId,
      cameraNome,
      url: placeholder_video(),
      localizacao: cameraGeo,
      gravadoEm: ts(`2025-04-20T${hora}:00:00`),
      duracaoSegundos: 5,
    });
  }
  return videos;
}

// ─── 10. CONFIGURAÇÕES (política, termos, FAQ) ────────────────
const configuracoes = {
  politica_privacidade: {
    versao: "1.0.0",
    atualizadoEm: ts("2025-01-01T00:00:00"),
    conteudo: `POLÍTICA DE PRIVACIDADE — Gabriel Clone\n\nEsta Política descreve como coletamos, usamos e protegemos suas informações pessoais ao utilizar o aplicativo Gabriel Clone.\n\n1. DADOS COLETADOS\nColetamos nome completo, data de nascimento, CPF, e-mail e localização aproximada durante o uso do aplicativo.\n\n2. USO DOS DADOS\nOs dados são utilizados exclusivamente para prestação dos serviços de monitoramento e segurança, envio de alertas e personalização da experiência.\n\n3. COMPARTILHAMENTO\nNão compartilhamos seus dados com terceiros sem seu consentimento, exceto quando exigido por lei ou autoridade competente.\n\n4. SEGURANÇA\nUtilizamos criptografia e práticas de segurança de acordo com as melhores práticas do mercado para proteger seus dados.\n\n5. SEUS DIREITOS\nVocê pode solicitar acesso, correção ou exclusão dos seus dados a qualquer momento pelo e-mail privacidade@gabrielclone.com.br.\n\n6. CONTATO\nDúvidas: privacidade@gabrielclone.com.br`,
  },
  termos_uso: {
    versao: "1.0.0",
    atualizadoEm: ts("2025-01-01T00:00:00"),
    conteudo: `TERMOS DE USO — Gabriel Clone\n\nAo utilizar o aplicativo Gabriel Clone você concorda com os presentes Termos de Uso.\n\n1. ACEITAÇÃO\nO uso do aplicativo implica aceitação integral destes termos.\n\n2. CADASTRO\nO usuário deve fornecer informações verdadeiras e mantê-las atualizadas. É proibido criar contas falsas.\n\n3. USO ADEQUADO\nÉ vedado utilizar o aplicativo para fins ilícitos, difamatórios ou que violem direitos de terceiros.\n\n4. PROPRIEDADE INTELECTUAL\nTodo o conteúdo do aplicativo é de propriedade exclusiva da Gabriel Clone. É proibida a reprodução sem autorização.\n\n5. LIMITAÇÃO DE RESPONSABILIDADE\nO serviço é fornecido "como está". Não nos responsabilizamos por danos indiretos decorrentes do uso.\n\n6. ALTERAÇÕES\nPodemos atualizar estes termos a qualquer momento. Você será notificado pelo aplicativo.\n\n7. CONTATO\ncontato@gabrielclone.com.br`,
  },
  faq: {
    atualizadoEm: ts("2025-01-01T00:00:00"),
    perguntas: [
      { pergunta: "O que é o Gabriel Clone?", resposta: "É um aplicativo de monitoramento e segurança que permite acompanhar câmeras, alertas e ocorrências em tempo real na sua cidade." },
      { pergunta: "Como faço para registrar uma ocorrência?", resposta: "Acesse a aba Ocorrências, toque em Nova Ocorrência e preencha os campos com as informações do evento, incluindo descrição, horário e mídias." },
      { pergunta: "Meus dados estão seguros?", resposta: "Sim. Utilizamos criptografia e seguimos as diretrizes da LGPD para proteger todas as suas informações pessoais." },
      { pergunta: "O app funciona offline?", resposta: "Algumas funcionalidades básicas ficam disponíveis offline, mas para alertas e câmeras em tempo real é necessária conexão com a internet." },
      { pergunta: "Como funciona o botão Pedir Ajuda?", resposta: "O botão Pedir Ajuda aciona imediatamente a central de monitoramento mais próxima de você, compartilhando sua localização atual." },
      { pergunta: "Como atualizo meu cadastro?", resposta: "Acesse Meu Perfil no menu e toque em Editar para atualizar seus dados pessoais a qualquer momento." },
      { pergunta: "Como busco um veículo furtado?", resposta: "Na aba Placas você pode cadastrar as informações do veículo e ele será incluído na nossa base de busca ativa." },
    ],
  },
};

// ─── FUNÇÕES DE SEED ─────────────────────────────────────────
async function seedColecao(nomeColecao, dados, labelFn) {
  console.log(`\n→ Populando [${nomeColecao}]...`);
  const batch = db.batch();
  dados.forEach((doc, i) => {
    const ref = db.collection(nomeColecao).doc();
    batch.set(ref, doc);
    console.log(`   ${i + 1}. ${labelFn(doc, i)}`);
  });
  await batch.commit();
  console.log(`   ✓ ${dados.length} documentos criados.`);
}

async function seedDoc(colecao, docId, dados) {
  console.log(`\n→ Criando documento [${colecao}/${docId}]...`);
  await db.collection(colecao).doc(docId).set(dados);
  console.log(`   ✓ Documento criado.`);
}

async function main() {
  console.log("╔══════════════════════════════════════════╗");
  console.log("║   gabriel_clone — Firebase Seed Script   ║");
  console.log("╚══════════════════════════════════════════╝");

  // 1. Câmeras
  const cameraRefs = [];
  console.log("\n→ Populando [cameras]...");
  for (let i = 0; i < cameras.length; i++) {
    const ref = db.collection("cameras").doc();
    await ref.set(cameras[i]);
    cameraRefs.push({ id: ref.id, geo: cameras[i].localizacao, nome: cameras[i].nome });
    console.log(`   ${i + 1}. ${cameras[i].nome}`);
  }
  console.log(`   ✓ ${cameras.length} câmeras criadas.`);

  // 2. Alertas
  await seedColecao("alertas", alertas, (d) => `${d.bairro} — ${d.tipo}`);

  // 3. Usuários
  await seedColecao("usuarios", usuarios, (d) => d.nomeCompleto);

  // 4. Casos Solucionados
  await seedColecao("casos_solucionados", casosSolucionados, (d, i) => `Caso ${i + 1} — ${d.cidade}`);

  // 5. Novidades
  await seedColecao("novidades", novidades, (d) => d.titulo);

  // 6. Ocorrências
  await seedColecao("ocorrencias", ocorrencias, (d) => d.boletimOcorrencia);

  // 7. Busca Veículos
  await seedColecao("busca_veiculos", buscaVeiculos, (d) => `${d.nome} ${d.sobrenome}`);

  // 8. Localidades
  await seedColecao("localidade", localidades, (d) => `CEP ${d.cep}`);

  // 9. Vídeos (3 por câmera)
  console.log("\n→ Populando [videos] (3 por câmera)...");
  const videoBatch = db.batch();
  let videoCount = 0;
  cameraRefs.forEach(({ id, geo, nome }) => {
    const vids = gerarVideosDaCamera(id, geo, nome);
    vids.forEach((v) => {
      videoBatch.set(db.collection("videos").doc(), v);
      videoCount++;
    });
  });
  await videoBatch.commit();
  console.log(`   ✓ ${videoCount} vídeos criados.`);

  // 10. Configurações (política, termos, FAQ)
  await seedDoc("configuracoes", "politica_privacidade", configuracoes.politica_privacidade);
  await seedDoc("configuracoes", "termos_uso", configuracoes.termos_uso);
  await seedDoc("configuracoes", "faq", configuracoes.faq);

  console.log("\n╔══════════════════════════════════════════╗");
  console.log("║   Seed concluído com sucesso!            ║");
  console.log("╚══════════════════════════════════════════╝");
  console.log("\nColeções criadas:");
  console.log("  cameras             → 10 docs");
  console.log("  alertas             → 10 docs");
  console.log("  usuarios            →  2 docs");
  console.log("  casos_solucionados  →  3 docs");
  console.log("  novidades           →  3 docs");
  console.log("  ocorrencias         →  3 docs");
  console.log("  busca_veiculos      →  3 docs");
  console.log("  localidade          →  3 docs");
  console.log("  videos              → 30 docs");
  console.log("  configuracoes       →  3 docs (politica, termos, faq)");

  process.exit(0);
}

main().catch((err) => {
  console.error("\n✗ Erro durante o seed:", err);
  process.exit(1);
});
