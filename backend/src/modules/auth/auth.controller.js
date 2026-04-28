const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { User } = require("../users/user.model");
const { RefreshToken } = require("./refresh-token.model");
const { ok } = require("../../shared/response");
const { seedTripsForUser } = require("../trips/trip-seed.service");
const {
  signAccessToken,
  signRefreshToken,
  storeRefreshToken,
  verifyStoredRefreshToken,
} = require("./token.service");

async function register(req, res, next) {
  try {
    const { email, password, name } = req.validated.body;
    const exists = await User.findOne({ email: email.toLowerCase() });
    if (exists) {
      const err = new Error("Email already registered");
      err.status = 409;
      err.code = "EMAIL_EXISTS";
      throw err;
    }
    const passwordHash = await bcrypt.hash(password, 10);
    const user = await User.create({ email, passwordHash, name });
    await seedTripsForUser(user._id);

    return ok(
      res,
      "Register success",
      {
        id: user._id,
        email: user.email,
        name: user.name,
      },
      null,
      201
    );
  } catch (error) {
    return next(error);
  }
}

async function login(req, res, next) {
  try {
    const { email, password, deviceInfo = "unknown" } = req.validated.body;
    const user = await User.findOne({ email: email.toLowerCase() });
    if (!user) {
      const err = new Error("Invalid credentials");
      err.status = 401;
      err.code = "INVALID_CREDENTIALS";
      throw err;
    }
    const isValid = await bcrypt.compare(password, user.passwordHash);
    if (!isValid) {
      const err = new Error("Invalid credentials");
      err.status = 401;
      err.code = "INVALID_CREDENTIALS";
      throw err;
    }
    await seedTripsForUser(user._id);

    const env = req.app.locals.env;
    const accessToken = signAccessToken(user, env);
    const refreshToken = signRefreshToken(user, env);
    const refreshDecoded = jwt.decode(refreshToken);
    await storeRefreshToken({
      token: refreshToken,
      userId: user._id,
      deviceInfo,
      expiresAt: new Date(refreshDecoded.exp * 1000),
    });

    return ok(res, "Login success", {
      accessToken,
      refreshToken,
      user: {
        id: user._id,
        email: user.email,
        name: user.name,
        role: user.role,
      },
    });
  } catch (error) {
    return next(error);
  }
}

async function refreshToken(req, res, next) {
  try {
    const { refreshToken: rawToken } = req.validated.body;
    const env = req.app.locals.env;
    const payload = jwt.verify(rawToken, env.JWT_REFRESH_SECRET);
    if (payload.type !== "refresh") {
      const err = new Error("Invalid refresh token type");
      err.status = 401;
      err.code = "UNAUTHORIZED";
      throw err;
    }

    const tokenDocs = await RefreshToken.find({
      userId: payload.sub,
      revokedAt: null,
      expiresAt: { $gt: new Date() },
    }).sort({ createdAt: -1 });

    let matchedDoc = null;
    for (const tokenDoc of tokenDocs) {
      // Compare raw token with each hash until found.
      const isMatch = await verifyStoredRefreshToken(tokenDoc, rawToken);
      if (isMatch) {
        matchedDoc = tokenDoc;
        break;
      }
    }

    if (!matchedDoc) {
      const err = new Error("Refresh token not found or revoked");
      err.status = 401;
      err.code = "UNAUTHORIZED";
      throw err;
    }

    const user = await User.findById(payload.sub);
    if (!user) {
      const err = new Error("User not found");
      err.status = 401;
      err.code = "UNAUTHORIZED";
      throw err;
    }

    const accessToken = signAccessToken(user, env);
    return ok(res, "Access token refreshed", { accessToken });
  } catch (error) {
    const err = new Error("Invalid or expired refresh token");
    err.status = 401;
    err.code = "UNAUTHORIZED";
    return next(err);
  }
}

async function logout(req, res, next) {
  try {
    const { refreshToken: rawToken } = req.body || {};
    if (!rawToken) {
      const err = new Error("refreshToken is required");
      err.status = 400;
      err.code = "BAD_REQUEST";
      throw err;
    }
    const activeTokens = await RefreshToken.find({
      revokedAt: null,
      expiresAt: { $gt: new Date() },
    });
    for (const tokenDoc of activeTokens) {
      const isMatch = await verifyStoredRefreshToken(tokenDoc, rawToken);
      if (isMatch) {
        tokenDoc.revokedAt = new Date();
        await tokenDoc.save();
        return ok(res, "Logout success", null);
      }
    }
    return ok(res, "Logout success", null);
  } catch (error) {
    return next(error);
  }
}

module.exports = { register, login, refreshToken, logout };
