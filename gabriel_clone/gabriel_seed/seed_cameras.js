const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const TOTAL_CAMERAS = Number(process.env.CAMERA_TOTAL ?? 2000);
const BATCH_SIZE = 450;
const DRY_RUN = process.argv.includes("--dry-run");
const RESET = process.argv.includes("--reset");

const geo = (lat, lng) => new admin.firestore.GeoPoint(lat, lng);

function createRandom(seed) {
  let state = seed >>> 0;
  return () => {
    state = (1664525 * state + 1013904223) >>> 0;
    return state / 0x100000000;
  };
}

const random = createRandom(20260427);

const grandeSaoPaulo = [
  { city: "São Paulo", district: "Sé", lat: -23.5505, lng: -46.6333, radiusKm: 4, weight: 8 },
  { city: "São Paulo", district: "Paulista", lat: -23.5617, lng: -46.6558, radiusKm: 5, weight: 8 },
  { city: "São Paulo", district: "Pinheiros", lat: -23.5676, lng: -46.6927, radiusKm: 5, weight: 6 },
  { city: "São Paulo", district: "Vila Mariana", lat: -23.5892, lng: -46.6344, radiusKm: 5, weight: 6 },
  { city: "São Paulo", district: "Santana", lat: -23.5015, lng: -46.6259, radiusKm: 6, weight: 5 },
  { city: "São Paulo", district: "Mooca", lat: -23.5607, lng: -46.5972, radiusKm: 5, weight: 5 },
  { city: "São Paulo", district: "Lapa", lat: -23.5247, lng: -46.7034, radiusKm: 6, weight: 4 },
  { city: "Guarulhos", district: "Centro", lat: -23.4543, lng: -46.5337, radiusKm: 7, weight: 5 },
  { city: "Osasco", district: "Centro", lat: -23.5329, lng: -46.7918, radiusKm: 6, weight: 4 },
  { city: "Barueri", district: "Alphaville", lat: -23.4949, lng: -46.8483, radiusKm: 5, weight: 3 },
  { city: "Carapicuíba", district: "Centro", lat: -23.5226, lng: -46.8350, radiusKm: 5, weight: 3 },
  { city: "Santo André", district: "Centro", lat: -23.6563, lng: -46.5322, radiusKm: 6, weight: 4 },
  { city: "São Bernardo do Campo", district: "Centro", lat: -23.6914, lng: -46.5646, radiusKm: 7, weight: 4 },
  { city: "São Caetano do Sul", district: "Centro", lat: -23.6229, lng: -46.5548, radiusKm: 4, weight: 3 },
  { city: "Diadema", district: "Centro", lat: -23.6865, lng: -46.6234, radiusKm: 5, weight: 3 },
  { city: "Mauá", district: "Centro", lat: -23.6677, lng: -46.4613, radiusKm: 5, weight: 3 },
  { city: "Taboão da Serra", district: "Centro", lat: -23.6261, lng: -46.7917, radiusKm: 4, weight: 2 },
  { city: "Cotia", district: "Granja Viana", lat: -23.6039, lng: -46.9192, radiusKm: 7, weight: 2 },
  { city: "Mogi das Cruzes", district: "Centro", lat: -23.5208, lng: -46.1854, radiusKm: 8, weight: 2 },
  { city: "Suzano", district: "Centro", lat: -23.5428, lng: -46.3108, radiusKm: 6, weight: 2 },
];

const grandeRio = [
  { city: "Rio de Janeiro", district: "Centro", lat: -22.9068, lng: -43.1729, radiusKm: 4, weight: 6 },
  { city: "Rio de Janeiro", district: "Copacabana", lat: -22.9711, lng: -43.1822, radiusKm: 4, weight: 5 },
  { city: "Rio de Janeiro", district: "Botafogo", lat: -22.9519, lng: -43.1840, radiusKm: 4, weight: 5 },
  { city: "Rio de Janeiro", district: "Tijuca", lat: -22.9249, lng: -43.2322, radiusKm: 5, weight: 5 },
  { city: "Rio de Janeiro", district: "Barra da Tijuca", lat: -23.0004, lng: -43.3659, radiusKm: 8, weight: 5 },
  { city: "Rio de Janeiro", district: "Jacarepaguá", lat: -22.9665, lng: -43.3712, radiusKm: 8, weight: 4 },
  { city: "Rio de Janeiro", district: "Campo Grande", lat: -22.9026, lng: -43.5597, radiusKm: 8, weight: 4 },
  { city: "Rio de Janeiro", district: "Madureira", lat: -22.8710, lng: -43.3362, radiusKm: 6, weight: 4 },
  { city: "Niterói", district: "Centro", lat: -22.8832, lng: -43.1034, radiusKm: 6, weight: 4 },
  { city: "São Gonçalo", district: "Centro", lat: -22.8268, lng: -43.0634, radiusKm: 8, weight: 4 },
  { city: "Duque de Caxias", district: "Centro", lat: -22.7856, lng: -43.3117, radiusKm: 7, weight: 4 },
  { city: "Nova Iguaçu", district: "Centro", lat: -22.7592, lng: -43.4511, radiusKm: 8, weight: 4 },
  { city: "Belford Roxo", district: "Centro", lat: -22.7640, lng: -43.3992, radiusKm: 6, weight: 3 },
  { city: "São João de Meriti", district: "Centro", lat: -22.8058, lng: -43.3729, radiusKm: 5, weight: 3 },
  { city: "Nilópolis", district: "Centro", lat: -22.8075, lng: -43.4138, radiusKm: 4, weight: 2 },
  { city: "Mesquita", district: "Centro", lat: -22.7829, lng: -43.4287, radiusKm: 4, weight: 2 },
  { city: "Magé", district: "Centro", lat: -22.6525, lng: -43.0409, radiusKm: 7, weight: 2 },
  { city: "Itaboraí", district: "Centro", lat: -22.7448, lng: -42.8598, radiusKm: 8, weight: 2 },
];

function pickWeighted(points) {
  const totalWeight = points.reduce((sum, point) => sum + point.weight, 0);
  let value = random() * totalWeight;

  for (const point of points) {
    value -= point.weight;
    if (value <= 0) return point;
  }

  return points[points.length - 1];
}

function pointNear(center) {
  const angle = random() * Math.PI * 2;
  const distanceKm = Math.sqrt(random()) * center.radiusKm;
  const latDelta = (distanceKm * Math.cos(angle)) / 111.32;
  const lngDelta =
    (distanceKm * Math.sin(angle)) /
    (111.32 * Math.cos((center.lat * Math.PI) / 180));

  return {
    lat: Number((center.lat + latDelta).toFixed(6)),
    lng: Number((center.lng + lngDelta).toFixed(6)),
  };
}

function buildCamera(index, regionName, center) {
  const point = pointNear(center);
  const paddedIndex = String(index + 1).padStart(5, "0");

  return {
    nome: `Câmera ${regionName} ${paddedIndex} - ${center.city} / ${center.district}`,
    localizacao: geo(point.lat, point.lng),
    ativo: random() > 0.06,
    cidade: center.city,
    bairro: center.district,
    regiao: regionName,
    seedId: `camera_${regionName.toLowerCase().replaceAll(" ", "_")}_${paddedIndex}`,
    criadoEm: admin.firestore.FieldValue.serverTimestamp(),
  };
}

function* generateCameras(total) {
  const saoPauloTotal = Number(
    process.env.CAMERA_SAO_PAULO_TOTAL ?? Math.round(total / 2),
  );

  for (let index = 0; index < total; index++) {
    const isSaoPaulo = index < saoPauloTotal;
    const regionName = isSaoPaulo ? "Grande São Paulo" : "Grande Rio";
    const centers = isSaoPaulo ? grandeSaoPaulo : grandeRio;

    yield buildCamera(index, regionName, pickWeighted(centers));
  }
}

async function commitBatch(batch, count) {
  if (DRY_RUN) return;
  await batch.commit();
  console.log(`   ${count} câmeras gravadas...`);
}

async function deleteSeededCameras() {
  console.log("Limpando câmeras geradas pelo seed...");

  let totalDeleted = 0;

  while (true) {
    const snapshot = await db
      .collection("cameras")
      .where("seedId", ">=", "camera_")
      .where("seedId", "<", "camera`")
      .limit(BATCH_SIZE)
      .get();

    if (snapshot.empty) {
      break;
    }

    if (!DRY_RUN) {
      const batch = db.batch();
      snapshot.docs.forEach((doc) => batch.delete(doc.ref));
      await batch.commit();
    }

    totalDeleted += snapshot.size;
    console.log(`   ${totalDeleted} câmeras removidas...`);

    if (DRY_RUN) {
      break;
    }
  }

  console.log(`Limpeza concluída: ${totalDeleted} câmeras removidas.`);
}

async function main() {
  if (!Number.isInteger(TOTAL_CAMERAS) || TOTAL_CAMERAS <= 0) {
    throw new Error("CAMERA_TOTAL precisa ser um inteiro positivo.");
  }

  if (RESET) {
    await deleteSeededCameras();
  }

  console.log(`Populando [cameras] com ${TOTAL_CAMERAS} câmeras.`);
  console.log("Distribuição padrão: 1000 Grande São Paulo, 1000 Grande Rio.");

  if (DRY_RUN) {
    console.log("Modo dry-run: nenhuma escrita será feita no Firestore.");
  }

  let batch = db.batch();
  let batchCount = 0;
  let totalCount = 0;

  for (const camera of generateCameras(TOTAL_CAMERAS)) {
    const ref = db.collection("cameras").doc(camera.seedId);
    batch.set(ref, camera, { merge: true });
    batchCount++;
    totalCount++;

    if (batchCount === BATCH_SIZE) {
      await commitBatch(batch, totalCount);
      batch = db.batch();
      batchCount = 0;
    }
  }

  if (batchCount > 0) {
    await commitBatch(batch, totalCount);
  }

  console.log(`Concluído: ${totalCount} câmeras ${DRY_RUN ? "geradas" : "gravadas"}.`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Erro ao popular câmeras:", error);
    process.exit(1);
  });
