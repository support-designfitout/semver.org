export const onRequestGet = async () => {
  return new Response(JSON.stringify({
    ok: true,
    service: "pages",
    repo: "semver.org",
    ts: Date.now()
  }), { headers: { "content-type": "application/json" }});
};