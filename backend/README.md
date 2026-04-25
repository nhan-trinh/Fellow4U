# Fellow4U Backend MVP

Node.js + Express + MongoDB backend for Fellow4U mobile MVP.

## Stack
- Node.js 20+, Express.js
- MongoDB + Mongoose
- JWT Access/Refresh auth
- Zod validation
- Helmet, CORS, HPP, rate-limit
- Swagger UI at `/docs`

## Implemented APIs (10)
1. `POST /api/v1/auth/register`
2. `POST /api/v1/auth/login`
3. `POST /api/v1/auth/refresh-token`
4. `POST /api/v1/auth/logout`
5. `GET /api/v1/profile/me`
6. `PATCH /api/v1/profile/me`
7. `GET /api/v1/home`
8. `GET /api/v1/home/search`
9. `GET /api/v1/my-trips`
10. `GET /api/v1/my-trips/:tripId`

## Quick start
1. Copy `.env.example` to `.env` and adjust values.
2. Install deps:
   ```bash
   npm install
   ```
3. Run API:
   ```bash
   npm run dev
   ```
4. Open:
   - Health: `http://localhost:8080/health`
   - Docs: `http://localhost:8080/docs`

## Demo account (seeded)
- email: `demo@fellow4u.com`
- password: `123456`

## Docker (optional)
```bash
docker compose up
```

## Postman test auth flow
1. Import collection: `postman/Fellow4U-Auth.postman_collection.json`
2. Import environment: `postman/Fellow4U-Local.postman_environment.json`
3. Select environment `Fellow4U Local`
4. Run requests in order:
   - `01 - Register`
   - `02 - Login`
   - `03 - Get Profile Me (auth check)`
   - `04 - Refresh Token`
   - `05 - Logout`
   - `06 - Refresh After Logout (expect 401)`

Collection includes test scripts and auto-save token variables.
