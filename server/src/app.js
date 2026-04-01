import express from "express";
import cors from "cors";
import apiRoutes from "./routes/index.js";
import { pingDb } from "./config/db.js";

const app = express();

const corsOrigins = process.env.CORS_ORIGINS?.split(",").map((s) => s.trim()).filter(Boolean);
app.use(
  cors(
    corsOrigins?.length
      ? { origin: corsOrigins }
      : { origin: true }
  )
);
app.use(express.json({ limit: "1mb" }));

app.get("/health", async (req, res, next) => {
  try {
    await pingDb();
    res.json({ ok: true, db: "up" });
  } catch (err) {
    res.status(503).json({ ok: false, db: "down" });
  }
});

app.use("/api", apiRoutes);

app.use((req, res) => {
  res.status(404).json({ error: "Not found" });
});

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: "Internal server error" });
});

export default app;
