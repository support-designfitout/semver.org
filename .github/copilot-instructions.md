# Copilot Coding Agent — Onboarding (Cloudflare Pages only)

- **Hosting:** Cloudflare Pages (+ optional Pages Functions). No Vercel.
- **Static root:** `public/`
- **Functions:** `functions/` (export `onRequest*` handlers)
- **Config:** `wrangler.toml`
- **Tests:** Playwright (BASE_URL driven)

## Run / Test
wrangler pages dev public --functions=functions          # http://127.0.0.1:8788
BASE_URL=http://127.0.0.1:8788 npx playwright test       # local
BASE_URL=https://<your-domain> npx playwright test       # production

## Redirects & Sitemap
- Add 301s to `public/_redirects`
- Add/maintain `public/sitemap.xml`

## Guardrails
- ❌ No Vercel artifacts (blocked by hooks & CI)
- ❌ No secrets in repo (use Cloudflare project vars)
- ✅ Keep PRs small; touch only listed files

## Validate before PR
- `/` loads; `/health/pages` returns `{"ok":true}` (if present)
- Redirects respond 301 as specified
- Playwright passes with chosen `BASE_URL`