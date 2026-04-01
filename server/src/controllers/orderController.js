import * as orderModel from "../models/orderModel.js";

export async function createOrder(req, res, next) {
  try {
    const body = req.body ?? {};
    const customerName = String(body.customerName ?? body.customer_name ?? "").trim();
    const phone = String(body.phone ?? "").trim();
    const address = String(body.address ?? "").trim();
    const items = Array.isArray(body.items) ? body.items : [];

    if (!customerName || !phone || !address) {
      res.status(400).json({
        error: "Missing required fields: customerName, phone, address",
      });
      return;
    }

    const normalizedItems = items.map((item) => ({
      productId: Number(item.productId ?? item.product_id),
      quantity: Number(item.quantity),
    }));

    const result = await orderModel.createOrderWithItems({
      customerName,
      phone,
      address,
      items: normalizedItems,
    });

    res.status(201).json({
      data: {
        orderId: result.orderId,
        totalAmount: result.totalAmount,
      },
    });
  } catch (err) {
    if (typeof err?.message === "string" && err.message.startsWith("INVALID_OR_UNAVAILABLE_PRODUCT")) {
      res.status(400).json({ error: "One or more products are invalid or unavailable" });
      return;
    }
    if (typeof err?.message === "string" && err.message.startsWith("INVALID_QUANTITY")) {
      res.status(400).json({ error: "Invalid quantity for a product" });
      return;
    }
    if (err?.message === "ORDER_ITEMS_REQUIRED") {
      res.status(400).json({ error: "Order must include at least one item" });
      return;
    }
    next(err);
  }
}
