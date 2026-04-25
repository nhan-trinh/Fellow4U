const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const { RefreshToken } = require("./refresh-token.model");

function signAccessToken(user, env) {
  return jwt.sign(
    { sub: user._id.toString(), email: user.email, role: user.role },
    env.JWT_ACCESS_SECRET,
    { expiresIn: env.JWT_ACCESS_EXPIRES_IN }
  );
}

function signRefreshToken(user, env) {
  return jwt.sign(
    { sub: user._id.toString(), type: "refresh" },
    env.JWT_REFRESH_SECRET,
    { expiresIn: env.JWT_REFRESH_EXPIRES_IN }
  );
}

async function storeRefreshToken({ token, userId, deviceInfo, expiresAt }) {
  const tokenHash = await bcrypt.hash(token, 10);
  return RefreshToken.create({
    userId,
    tokenHash,
    deviceInfo,
    expiresAt,
  });
}

async function verifyStoredRefreshToken(tokenDoc, rawToken) {
  return bcrypt.compare(rawToken, tokenDoc.tokenHash);
}

module.exports = {
  signAccessToken,
  signRefreshToken,
  storeRefreshToken,
  verifyStoredRefreshToken,
};
