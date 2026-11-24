# UoG PHA Complete Website Project

This project is structured against the 2026 UoG PHA Website Development Proposal.

## Stack
- Next.js 14, React, TypeScript
- Supabase PostgreSQL, Auth and Storage
- Cloudflare deployment (deployment adapter/configuration must be validated for the chosen Cloudflare product)

## Run locally
1. Install Node.js 20 LTS.
2. Extract this ZIP.
3. Run `npm install`.
4. Copy `.env.example` to `.env.local` and add the Supabase Project URL and anon key.
5. Run `npm run dev` and open http://localhost:3000.

## Important implementation status
This is a complete project scaffold with public pages, responsive UI, SQL schema/RLS baseline, feature routes and implementation notes. It is **not honestly represented as a fully production-verified system** until you configure Supabase, create the first Super Admin securely, finish provider configuration, and execute the acceptance tests in `docs/ACCEPTANCE.md`. No real credentials are included.

## Supabase
Run `supabase/schema.sql` in the Supabase SQL Editor. Create the Storage buckets and policies described in `supabase/README.md`. Never place a service-role key in browser code.

## Proposal coverage
See `docs/PROPOSAL-COVERAGE.md` for all required pages, all 25 additional features, role permissions, technical/security requirements and deliverables.
