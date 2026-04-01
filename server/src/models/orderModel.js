import { pool } from "../config/db.js";
import * as productModel from "./productModel.js";

/**
 * @param {{ customerName: string, phone: string, address: string, items: { productId: number, quantity: number }[] }} input
 */
export async function createOrderWithItems(input) {
  const { customerName, phone, address, items } = input;
  if (!items?.length) {
    throw new Error("ORDER_ITEMS_REQUIRED");
  }

  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    let total = 0;
    const resolvedLines = [];

    for (const line of items) {
      const row = await productModel.getProductPriceForOrder(line.productId);
      if (!row) {
        throw new Error(`INVALID_OR_UNAVAILABLE_PRODUCT:${line.productId}`);
      }
      const qty = Number(line.quantity);
      if (!Number.isInteger(qty) || qty < 1) {
        throw new Error(`INVALID_QUANTITY:${line.productId}`);
      }
      const lineTotal = Number(row.price) * qty;
      total += lineTotal;
      resolvedLines.push({
        productId: row.id,
        quantity: qty,
        unitPrice: Number(row.price),
      });
    }

    const [orderResult] = await connection.query(
      `INSERT INTO orders (customer_name, phone, address, total_amount, status)
       VALUES (?, ?, ?, ?, 'pending')`,
      [customerName, phone, address, total.toFixed(2)]
    );

    const orderId = orderResult.insertId;

    for (const line of resolvedLines) {
      await connection.query(
        `INSERT INTO order_items (order_id, product_id, quantity, unit_price)
         VALUES (?, ?, ?, ?)`,
        [orderId, line.productId, line.quantity, line.unitPrice.toFixed(2)]
      );
    }

    await connection.commit();
    return { orderId, totalAmount: total };
  } catch (e) {
    await connection.rollback();
    throw e;
  } finally {
    connection.release();
  }
}
