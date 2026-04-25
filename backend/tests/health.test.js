const request = require("supertest");
const { createApp } = require("../src/app");

describe("Health endpoint", () => {
  it("returns healthy status", async () => {
    const app = createApp({
      NODE_ENV: "test",
      ALLOWED_ORIGINS: "",
      JWT_ACCESS_SECRET: "test_access_secret_12345",
      JWT_REFRESH_SECRET: "test_refresh_secret_12345",
      JWT_ACCESS_EXPIRES_IN: "15m",
      JWT_REFRESH_EXPIRES_IN: "30d",
    });

    const response = await request(app).get("/health");
    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
  });
});
