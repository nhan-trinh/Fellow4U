function ok(res, message, data = null, meta = null, status = 200) {
  return res.status(status).json({
    success: true,
    message,
    data,
    meta,
  });
}

function fail(res, status, code, message, details = null) {
  return res.status(status).json({
    success: false,
    code,
    message,
    details,
  });
}

module.exports = { ok, fail };
