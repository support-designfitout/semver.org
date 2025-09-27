# Security & Deployment Policy

This repository is **Cloudflare Pages + Pages Functions ONLY**.

## ❌ Forbidden
- `.vercel/`, `vercel.json`, `vercel.app`, `VERCEL_*` secrets

## ✅ Allowed
- Cloudflare Pages/Workers/R2, GitHub Actions

## Environment Variables (if needed)
- `MRKETOZ_API_KEY`, `MRKETOZ_ENDPOINT` (example pattern)

No secrets in repo. Incidents → `docs/INCIDENT_LOG.md`.