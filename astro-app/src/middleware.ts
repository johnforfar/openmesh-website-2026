import type { MiddlewareHandler } from 'astro';

// Permissive headers — Framer-compiled bundles do dynamic imports + many
// cross-origin fetches. Will tighten once we refactor to clean Astro components.
export const onRequest: MiddlewareHandler = async (_ctx, next) => {
  const res = await next();
  res.headers.set('X-Content-Type-Options', 'nosniff');
  res.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');
  return res;
};
