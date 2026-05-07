const admin = require('firebase-admin');
const serviceAccount = require('../service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const { GeoPoint } = admin.firestore;

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

function normalize(value) {
  return String(value || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase();
}

function fallbackLocation(bairro, cidade) {
  const normalized = normalize(`${bairro} ${cidade}`);
  if (normalized.includes('consolacao')) return [-23.5579, -46.6608];
  if (normalized.includes('se sao paulo')) return [-23.5505, -46.6333];
  if (normalized.includes('pinheiros')) return [-23.5676, -46.6927];
  if (normalized.includes('santana')) return [-23.5015, -46.6259];
  if (normalized.includes('vila mariana')) return [-23.5892, -46.6344];
  if (normalized.includes('mooca')) return [-23.5607, -46.5972];
  if (normalized.includes('lapa')) return [-23.5247, -46.7034];
  if (normalized.includes('ibirapuera')) return [-23.5874, -46.6576];
  if (normalized.includes('santo andre')) return [-23.6563, -46.5322];
  if (normalized.includes('luz')) return [-23.5362, -46.6336];
  if (normalized.includes('copacabana')) return [-22.9711, -43.1822];
  if (normalized.includes('centro rio')) return [-22.9068, -43.1729];
  return null;
}

function readNumber(value) {
  if (typeof value === 'number') return value;
  if (typeof value === 'string') return Number(value.replace(',', '.'));
  return Number.NaN;
}

function readLocation(data) {
  const localizacao = data.localizacao || data.geo;
  if (
    localizacao &&
    typeof localizacao.latitude === 'number' &&
    typeof localizacao.longitude === 'number'
  ) {
    return [localizacao.latitude, localizacao.longitude];
  }

  const latitude = readNumber(data.latitude ?? data.lat);
  const longitude = readNumber(data.longitude ?? data.lng);
  if (Number.isFinite(latitude) && Number.isFinite(longitude)) {
    return [latitude, longitude];
  }

  return fallbackLocation(data.bairro, data.cidade);
}

async function main() {
  const dryRun = process.argv.includes('--dry-run');
  const force = process.argv.includes('--force');
  const limitArg = process.argv.find((arg) => arg.startsWith('--limit='));
  const limit = limitArg ? Number(limitArg.split('=')[1]) : Infinity;

  const snapshot = await db.collection('alertas').get();
  let scanned = 0;
  let updated = 0;
  let skippedHasGeohash = 0;
  let skippedNoLocation = 0;
  let batch = db.batch();
  let batchCount = 0;

  for (const doc of snapshot.docs) {
    if (scanned >= limit) break;
    scanned++;

    const data = doc.data();
    if (data.geohash && !force) {
      skippedHasGeohash++;
      continue;
    }

    const location = readLocation(data);
    if (!location) {
      skippedNoLocation++;
      continue;
    }

    const [latitude, longitude] = location;
    const next = {
      geohash: geohash(latitude, longitude),
      latitude,
      longitude,
    };
    if (!data.localizacao) {
      next.localizacao = new GeoPoint(latitude, longitude);
    }

    if (dryRun) {
      console.log(`[dry-run] ${doc.id}`, next);
    } else {
      batch.update(doc.ref, next);
      batchCount++;
      updated++;
      if (batchCount === 450) {
        await batch.commit();
        console.log(`Committed ${updated} updates...`);
        batch = db.batch();
        batchCount = 0;
      }
    }
  }

  if (!dryRun && batchCount > 0) {
    await batch.commit();
  }

  console.log(
    JSON.stringify(
      {
        dryRun,
        force,
        scanned,
        updated: dryRun ? scanned - skippedHasGeohash - skippedNoLocation : updated,
        skippedHasGeohash,
        skippedNoLocation,
      },
      null,
      2,
    ),
  );
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(() => admin.app().delete());
