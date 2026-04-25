const jwt = require("jsonwebtoken");
const { User } = require("../modules/users/user.model");

function authGuard(env) {
  return async (req, res, next) => {
    try {
      const authHeader = req.headers.authorization || "";
      const token = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : null;
      if (!token) {
        const err = new Error("Missing access token");
        err.status = 401;
        err.code = "UNAUTHORIZED";
        throw err;
      }
      const payload = jwt.verify(token, env.JWT_ACCESS_SECRET);
      const user = await User.findById(payload.sub);
      if (!user) {
        const err = new Error("User not found");
        err.status = 401;
        err.code = "UNAUTHORIZED";
        throw err;
      }
      req.user = user;
      next();
    } catch (error) {
      const err = new Error("Invalid or expired token");
      err.status = 401;
      err.code = "UNAUTHORIZED";
      next(err);
    }
  };
}

module.exports = { authGuard };
