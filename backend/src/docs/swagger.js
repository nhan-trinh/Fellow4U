const swaggerJsDoc = require("swagger-jsdoc");
const swaggerUi = require("swagger-ui-express");

function setupSwagger(app) {
  const specs = swaggerJsDoc({
    definition: {
      openapi: "3.0.0",
      info: {
        title: "Fellow4U Backend API",
        version: "1.0.0",
      },
      servers: [{ url: "/api/v1" }],
    },
    apis: [],
  });

  app.use("/docs", swaggerUi.serve, swaggerUi.setup(specs));
}

module.exports = { setupSwagger };
