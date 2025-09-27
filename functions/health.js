// Example Cloudflare Pages Function for health check
// This would handle the /health/pages endpoint mentioned in copilot-instructions.md

export async function onRequest(context) {
  const {
    request, // same as existing Worker API
    env, // same as existing Worker API
    params, // if filename includes [id] or [[path]]
    waitUntil, // same as ctx.waitUntil in existing Worker API
    next, // used for middleware or to fetch assets
    data, // arbitrary space for passing data between middlewares
  } = context;

  // Health check endpoint
  if (new URL(request.url).pathname === "/health/pages") {
    return new Response(
      JSON.stringify({
        ok: true,
        timestamp: new Date().toISOString(),
        service: "semver.org",
        version: "2.0.0",
        hosting: "Cloudflare Pages",
      }),
      {
        headers: {
          "Content-Type": "application/json",
          "Cache-Control": "no-cache",
        },
      }
    );
  }

  // For other requests, continue to static assets
  return next();
}
