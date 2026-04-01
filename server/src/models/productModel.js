import { pool } from "../config/db.js";

export async function findAllProducts() {
  const [rows] = await pool.query(
    `SELECT id, name, category, description, price, image_url, is_available, created_at
     FROM products
     WHERE is_available = 1
     ORDER BY id ASC`
  );
  return rows;
}

export async function findProductById(id) {
  const [rows] = await pool.query(
    `SELECT id, name, category, description, price, image_url, is_available, created_at
     FROM products
     WHERE id = ?
     LIMIT 1`,
    [id]
  );
  return rows[0] ?? null;
}

/** Returns current price for a product or null if missing / unavailable */
export async function getProductPriceForOrder(productId) {
  const [rows] = await pool.query(
    `SELECT id, price FROM products WHERE id = ? AND is_available = 1 LIMIT 1`,
    [productId]
  );
  return rows[0] ?? null;
}
