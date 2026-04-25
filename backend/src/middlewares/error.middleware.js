const { fail } = require("../shared/response");

function errorMiddleware(err, req, res, next) {
  if (err && err.name === "ZodError") {
    return fail(res, 422, "VALIDATION_ERROR", "Validation failed", err.issues);
  }

  const status = err.status || 500;
  const code = err.code || "INTERNAL_SERVER_ERROR";
  const message = err.message || "Unexpected server error";
  return fail(res, status, code, message, err.details || null);
}

module.exports = { errorMiddleware };
