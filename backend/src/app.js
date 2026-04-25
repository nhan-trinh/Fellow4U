const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const hpp = require("hpp");
const rateLimit = require("express-rate-limit");
const morgan = require("morgan");
const pinoHttp = require("pino-http");
const pino = require("pino");
const { authRouter } = require("./modules/auth/auth.routes");
const { createProfileRouter } = require("./modules/users/profile.routes");
const { homeRouter } = require("./modules/home/home.routes");
const { createTripsRouter } = require("./modules/trips/trips.routes");
const { fail } = require("./shared/response");
const { errorMiddleware } = require("./middlewares/error.middleware");
const { setupSwagger } = require("./docs/swagger");

function createApp(env) {
  const app = express();
  app.locals.env = env;

  app.use(
    cors({
      origin: env.ALLOWED_ORIGINS ? env.ALLOWED_ORIGINS.split(",") : true,
      credentials: true,
    })
  );
  app.use(helmet());
  app.use(hpp());
  app.use(
    rateLimit({
      windowMs: 15 * 60 * 1000,
      max: 200,
    })
  );
  app.use(express.json());
  app.use(pinoHttp({ logger: pino() }));

  if (env.NODE_ENV !== "production") {
    app.use(morgan("dev"));
  }

  app.get("/health", (req, res) =>
    res.json({ success: true, message: "Backend is healthy" })
  );

  app.use("/api/v1/auth", authRouter);
  app.use("/api/v1/profile", createProfileRouter(env));
  app.use("/api/v1/home", homeRouter);
  app.use("/api/v1/my-trips", createTripsRouter(env));

  setupSwagger(app);

  app.use((req, res) => fail(res, 404, "NOT_FOUND", "Route not found"));
  app.use(errorMiddleware);

  return app;
}

module.exports = { createApp };
