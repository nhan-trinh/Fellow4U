const { ok } = require("../../shared/response");

function toProfile(user) {
  return {
    id: user._id,
    email: user.email,
    name: user.name,
    avatarUrl: user.avatarUrl,
    bio: user.bio,
    phone: user.phone,
    role: user.role,
    preferences: user.preferences,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
  };
}

async function getMe(req, res, next) {
  try {
    return ok(res, "Profile fetched", toProfile(req.user));
  } catch (error) {
    return next(error);
  }
}

async function updateMe(req, res, next) {
  try {
    const payload = req.validated.body;
    Object.assign(req.user, payload);
    await req.user.save();
    return ok(res, "Profile updated", toProfile(req.user));
  } catch (error) {
    return next(error);
  }
}

module.exports = { getMe, updateMe };
