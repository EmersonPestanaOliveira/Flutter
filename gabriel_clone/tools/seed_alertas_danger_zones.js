const admin = require('firebase-admin');
const serviceAccount = require('../service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const { FieldValue, GeoPoint, Timestamp } = admin.firestore;

const BASE32 = '0123456789bcdefghjkmnpqrstuvwxyz';

function geohash(latitude, longitude, precision = 7) {
  let latRange = [-90, 90];
  let lonRange = [-180, 180];
  let isEven = true;
  let bit = 0;
  let ch = 0;
  let hash = '';

  while (hash.length < precision) {
    if (isEven) {
      const mid = (lonRange[0] + lonRange[1]) / 2;
      if (longitude >= mid) {
        ch |= 1 << (4 - bit);
        lonRange[0] = mid;
      } else {
        lonRange[1] = mid;
      }
    } else {
      const mid = (latRange[0] + latRange[1]) / 2;
      if (latitude >= mid) {
        ch |= 1 << (4 - bit);
        latRange[0] = mid;
      } else {
        latRange[1] = mid;
      }
    }

    isEven = !isEven;
    if (bit < 4) {
      bit++;
    } else {
      hash += BASE32[ch];
      bit = 0;
      ch = 0;
    }
  }

  return hash;
}

const EVENT_TYPES = [
  'Violência',
  'Acidente',
  'Roubo ou Furto de Veículos',
  'Roubo ou Furto',
  'Estelionato',
  'Vandalismo',
  'Invasão',
  'Outros',
];

const CLUSTERS = [
  {
    bairro: 'Sé',
    cidade: 'São Paulo',
    latitude: -23.5505,
    longitude: -46.6333,
    tipo: 'Roubo ou Furto',
    count: 48,
  },
  {
    bairro: 'Pinheiros',
    cidade: 'São Paulo',
    latitude: -23.5676,
    longitude: -46.6927,
    tipo: 'Roubo ou Furto de Veículos',
    count: 44,
  },
  {
    bairro: 'Consolação',
    cidade: 'São Paulo',
    latitude: -23.5579,
    longitude: -46.6608,
    tipo: 'Violência',
    count: 42,
  },
  {
    bairro: 'Vila Mariana',
    cidade: 'São Paulo',
    latitude: -23.5892,
    longitude: -46.6344,
    tipo: 'Estelionato',
    count: 38,
  },
  {
    bairro: 'Santana',
    cidade: 'São Paulo',
    latitude: -23.5015,
    longitude: -46.6259,
    tipo: 'Vandalismo',
    count: 36,
  },
  {
    bairro: 'Lapa',
    cidade: 'São Paulo',
    latitude: -23.5247,
    longitude: -46.7034,
    tipo: 'Invasão',
    count: 34,
  },
  {
    bairro: 'Mooca',
    cidade: 'São Paulo',
    latitude: -23.5607,
    longitude: -46.5972,
    tipo: 'Acidente',
    count: 34,
  },
  {
    bairro: 'Copacabana',
    cidade: 'Rio de Janeiro',
    latitude: -22.9711,
    longitude: -43.1822,
    tipo: 'Roubo ou Furto',
    count: 32,
  },
  {
    bairro: 'Centro',
    cidade: 'Rio de Janeiro',
    latitude: -22.9068,
    longitude: -43.1729,
    tipo: 'Violência',
    count: 32,
  },
];

const SCATTER_AREAS = [
  ['Ibirapuera', 'São Paulo', -23.5874, -46.6576],
  ['Liberdade', 'São Paulo', -23.5558, -46.6350],
  ['Bela Vista', 'São Paulo', -23.5614, -46.6562],
  ['Tatuapé', 'São Paulo', -23.5409, -46.5763],
  ['Santo Amaro', 'São Paulo', -23.6528, -46.7090],
  ['Barra da Tijuca', 'Rio de Janeiro', -23.0004, -43.3659],
  ['Tijuca', 'Rio de Janeiro', -22.9249, -43.2322],
  ['Botafogo', 'Rio de Janeiro', -22.9519, -43.1809],
  ['Centro', 'Santo André', -23.6563, -46.5322],
  ['Centro', 'São Bernardo do Campo', -23.6914, -46.5646],
];

const DESCRIPTIONS = {
  'Violência': [
    'Discussão com agressão registrada por moradores.',
    'Briga em via pública com acionamento de autoridades.',
    'Ocorrência de violência reportada na região.',
  ],
  Acidente: [
    'Acidente de trânsito com lentidão no entorno.',
    'Colisão entre veículos registrada por câmeras próximas.',
    'Ocorrência de acidente em cruzamento movimentado.',
  ],
  'Roubo ou Furto de Veículos': [
    'Tentativa de furto de veículo estacionado.',
    'Roubo de veículo reportado por morador.',
    'Veículo subtraído nas proximidades.',
  ],
  'Roubo ou Furto': [
    'Furto de celular em ponto de ônibus.',
    'Roubo a pedestre reportado na via.',
    'Furto de pertences em área de grande circulação.',
  ],
  Estelionato: [
    'Golpe reportado por morador da localidade.',
    'Suspeita de fraude comunicada à central.',
    'Estelionato envolvendo abordagem na região.',
  ],
  Vandalismo: [
    'Dano ao patrimônio identificado na via.',
    'Vandalismo em equipamento urbano.',
    'Pichação e dano material reportados.',
  ],
  Invasão: [
    'Tentativa de invasão em imóvel monitorado.',
    'Movimentação suspeita em acesso privado.',
    'Invasão reportada por morador.',
  ],
  Outros: [
    'Ocorrência de segurança em acompanhamento.',
    'Evento atípico reportado na região.',
    'Situação suspeita encaminhada para verificação.',
  ],
};

function randomFactory(seed) {
  let state = seed >>> 0;
  return () => {
    state = (state * 1664525 + 1013904223) >>> 0;
    return state / 0xffffffff;
  };
}

const random = randomFactory(20260430);

function randomBetween(min, max) {
  return min + (max - min) * random();
}

function randomOffsetMeters(maxMeters) {
  const angle = randomBetween(0, Math.PI * 2);
  const distance = Math.sqrt(random()) * maxMeters;
  return {
    northMeters: Math.cos(angle) * distance,
    eastMeters: Math.sin(angle) * distance,
  };
}

function movePoint(latitude, longitude, maxMeters) {
  const offset = randomOffsetMeters(maxMeters);
  const lat = latitude + offset.northMeters / 111320;
  const lng =
    longitude + offset.eastMeters / (111320 * Math.cos((latitude * Math.PI) / 180));
  return { latitude: lat, longitude: lng };
}

function recentDate(maxHoursAgo = 70) {
  const now = Date.now();
  const hoursAgo = randomBetween(1, maxHoursAgo);
  return new Date(now - hoursAgo * 60 * 60 * 1000);
}

function descriptionFor(tipo) {
  const options = DESCRIPTIONS[tipo] || DESCRIPTIONS.Outros;
  return options[Math.floor(random() * options.length)];
}

function buildClusterDocs(seedRun) {
  const docs = [];
  for (const cluster of CLUSTERS) {
    for (let i = 0; i < cluster.count; i++) {
      const point = movePoint(cluster.latitude, cluster.longitude, 180);
      docs.push({
        bairro: cluster.bairro,
        cidade: cluster.cidade,
        data: Timestamp.fromDate(recentDate(48)),
        descricao: descriptionFor(cluster.tipo),
        tipo: cluster.tipo,
        localizacao: new GeoPoint(point.latitude, point.longitude),
        latitude: point.latitude,
        longitude: point.longitude,
        geohash: geohash(point.latitude, point.longitude),
        origem: 'seed_areas_de_atencao',
        seedRun,
        createdAt: FieldValue.serverTimestamp(),
      });
    }
  }
  return docs;
}

function buildScatterDocs(seedRun, count) {
  const docs = [];
  for (let i = 0; i < count; i++) {
    const area = SCATTER_AREAS[Math.floor(random() * SCATTER_AREAS.length)];
    const tipo = EVENT_TYPES[i % EVENT_TYPES.length];
    const point = movePoint(area[2], area[3], 1600);
    docs.push({
      bairro: area[0],
      cidade: area[1],
      data: Timestamp.fromDate(recentDate(72)),
      descricao: descriptionFor(tipo),
      tipo,
      localizacao: new GeoPoint(point.latitude, point.longitude),
      latitude: point.latitude,
      longitude: point.longitude,
      geohash: geohash(point.latitude, point.longitude),
      origem: 'seed_areas_de_atencao',
      seedRun,
      createdAt: FieldValue.serverTimestamp(),
    });
  }
  return docs;
}

async function commitInBatches(docs) {
  let committed = 0;
  for (let i = 0; i < docs.length; i += 450) {
    const batch = db.batch();
    const chunk = docs.slice(i, i + 450);
    for (const doc of chunk) {
      const ref = db.collection('alertas').doc();
      batch.set(ref, doc);
    }
    await batch.commit();
    committed += chunk.length;
    console.log(`Committed ${committed}/${docs.length} alertas...`);
  }
}

async function main() {
  const dryRun = process.argv.includes('--dry-run');
  const seedRun = `areas_de_atencao_${new Date()
    .toISOString()
    .replace(/[:.]/g, '-')}`;
  const clusterDocs = buildClusterDocs(seedRun);
  const scatterDocs = buildScatterDocs(seedRun, 500 - clusterDocs.length);
  const docs = [...clusterDocs, ...scatterDocs];

  if (docs.length !== 500) {
    throw new Error(`Expected 500 docs, got ${docs.length}`);
  }

  if (dryRun) {
    console.log(JSON.stringify({ seedRun, count: docs.length, docs }, null, 2));
    return;
  }

  await commitInBatches(docs);
  console.log(`Seed complete. seedRun=${seedRun}`);
  console.log('Danger-zone clusters:');
  for (const cluster of CLUSTERS) {
    console.log(
      `- ${cluster.tipo} | ${cluster.bairro}/${cluster.cidade} | ${cluster.count} eventos`,
    );
  }
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(() => admin.app().delete());
