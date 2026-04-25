function validate(schema) {
  return (req, res, next) => {
    const parsed = schema.safeParse({
      body: req.body,
      query: req.query,
      params: req.params,
    });
    if (!parsed.success) {
      const err = new Error("Validation failed");
      err.name = "ZodError";
      err.issues = parsed.error.issues;
      return next(err);
    }
    req.validated = parsed.data;
    return next();
  };
}

module.exports = { validate };
