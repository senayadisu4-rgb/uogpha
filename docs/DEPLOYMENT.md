# Deployment guide

## Cloudflare
The proposal specifies Cloudflare deployment. Select the Cloudflare product and Next.js adapter compatible with the current Next.js version, follow Cloudflare's current official deployment guide, set environment variables in the Cloudflare dashboard, and verify server rendering, route handlers, authentication cookies and file uploads. Do not assume a generic static export can run this full application.

## Secrets
Only `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` belong in browser-visible configuration. Keep service-role keys and email-provider secrets server-side only.
