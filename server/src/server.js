import app from "./app.js";
import { assertDbEnv, pingDb } from "./config/db.js";

assertDbEnv();

const port = Number(process.env.PORT || 3000);

app.listen(port, async () => {
  console.log(`Restaurant API listening on http://localhost:${port}`);
  console.log(`Health: GET http://localhost:${port}/health`);
  console.log(`Products: GET http://localhost:${port}/api/products`);
  try {
    await pingDb();
    console.log("[db] Connection OK");
  } catch (e) {
    if (e?.code === "ER_ACCESS_DENIED_ERROR") {
      console.error(
        "[db] MySQL rejected the login. Fix: (1) correct DB_PASSWORD in .env — if the password has # or spaces, wrap it in double quotes; (2) in hosting, allow remote access from your IP for this user (MySQL user must match 'user'@'your-ip' or 'user'@'%')."
      );
      if (e.sqlMessage) console.error("[db]", e.sqlMessage);
    } else if (e?.code === "ECONNREFUSED") {
      console.error(
        "[db] Cannot reach MySQL (connection refused). Check DB_HOST/DB_PORT, that mysqld is listening, and firewall allows your IP on 3306."
      );
    } else {
      console.error("[db] MySQL connection error:", e?.message || e);
    }
    if (e?.code) console.error("[db] Error code:", e.code);
  }
});
