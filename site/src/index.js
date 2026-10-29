// auth.tanookistudios.com: the page itself is a static asset; /download/<file> streams from R2,
// because the installers are bigger than the 25 MiB a static asset may be.
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (!url.pathname.startsWith('/download/')) return env.ASSETS.fetch(request);
    if (request.method !== 'GET' && request.method !== 'HEAD') return new Response('Method not allowed', { status: 405 });
    const key = decodeURIComponent(url.pathname.slice('/download/'.length));
    const obj = await env.DOWNLOADS.get(key, { range: request.headers, onlyIf: request.headers });
    if (!obj) return new Response('That download does not exist.', { status: 404 });
    const headers = new Headers();
    obj.writeHttpMetadata(headers);
    headers.set('etag', obj.httpEtag);
    headers.set('content-disposition', `attachment; filename="${key}"`);
    headers.set('cache-control', 'public, max-age=3600');
    if (!('body' in obj)) return new Response(null, { status: 304, headers });
    // R2 reports a range even for whole-file reads, so only a request that asked for one gets a 206.
    const partial = request.headers.has('range') && obj.range;
    if (partial) {
      const { offset = 0, length = obj.size - offset } = obj.range;
      headers.set('content-range', `bytes ${offset}-${offset + length - 1}/${obj.size}`);
    }
    return new Response(request.method === 'HEAD' ? null : obj.body, { status: partial ? 206 : 200, headers });
  },
};
