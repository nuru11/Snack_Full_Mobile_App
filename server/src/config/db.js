import path from "node:path";
import { fileURLToPath } from "node:url";
import mysql from "mysql2/promise";
import dotenv from "dotenv";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.join(__dirname, "..", "..", ".env") });

const port = Number(process.env.DB_PORT || 3306);

const host = process.env.DB_HOST;
const user = process.env.DB_USER;
const database = process.env.DB_NAME;

/** Call once at startup to surface misconfiguration early. */
export function assertDbEnv() {
  const missing = [];
  if (!host) missing.push("DB_HOST");
  if (!user) missing.push("DB_USER");
  if (!database) missing.push("DB_NAME");
  if (process.env.DB_PASSWORD === undefined) missing.push("DB_PASSWORD");
  if (missing.length) {
    console.error(
      `[db] Missing env: ${missing.join(", ")}. Copy server/.env.example to server/.env and set MySQL credentials.`
    );
  } else {
    console.log(`[db] Will connect to MySQL at ${host}:${port} (database: ${database}, user: ${user})`);
  }
}

export const pool = mysql.createPool({
  host,
  port,
  user,
  password: process.env.DB_PASSWORD,
  database,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  enableKeepAlive: true,
  connectTimeout: 10000,
});

export async function pingDb() {
  const conn = await pool.getConnection();
  try {
    await conn.ping();
    return true;
  } finally {
    conn.release();
  }
}
