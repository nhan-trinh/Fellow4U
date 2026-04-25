require("dotenv").config();
const { createApp } = require("./app");
const { getEnv } = require("./config/env");
const { connectDB } = require("./config/db");
const { seedMvpData } = require("./seed/seed-mvp");

async function bootstrap() {
  const env = getEnv();
  await connectDB(env.MONGO_URI);
  await seedMvpData();
  const app = createApp(env);
  const port = Number(env.PORT) || 8080;

  app.listen(port, () => {
    // eslint-disable-next-line no-console
    console.log(`Fellow4U backend running at http://localhost:${port}`);
  });
}

bootstrap().catch((err) => {
  // eslint-disable-next-line no-console
  console.error("Failed to bootstrap server:", err);
  process.exit(1);
});
