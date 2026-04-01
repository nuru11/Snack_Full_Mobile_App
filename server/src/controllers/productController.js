import * as productModel from "../models/productModel.js";

export async function listProducts(req, res, next) {

  // console.log("listProductaaaaaaaaaaaaaaas");
  try {
    const products = await productModel.findAllProducts();
    res.json({ data: products });
  } catch (err) {
    next(err);
  }
}

export async function getProduct(req, res, next) {
  try {
    const id = Number(req.params.id);
    if (!Number.isInteger(id) || id < 1) {
      res.status(400).json({ error: "Invalid product id" });
      return;
    }
    const product = await productModel.findProductById(id);
    if (!product) {
      res.status(404).json({ error: "Product not found" });
      return;
    }
    res.json({ data: product });
  } catch (err) {
    next(err);
  }
}
