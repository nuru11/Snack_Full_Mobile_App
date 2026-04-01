import { Router } from "express";
import productRoutes from "./productRoutes.js";
import orderRoutes from "./orderRoutes.js";

const router = Router();

router.use("/products", productRoutes);
router.use("/orders", orderRoutes);

export default router;
