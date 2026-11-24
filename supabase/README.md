# Supabase setup

1. Create a Supabase project.
2. Run `schema.sql` in SQL Editor.
3. Create private bucket `member-files` and public bucket `public-assets` only for content approved for public access.
4. Configure bucket limits and MIME types to match the proposal.
5. Add project URL and anon key to `.env.local`.
6. Configure Auth email confirmation and password recovery URLs.
7. Bootstrap the first Super Admin through a trusted, one-time server-side administrative process. Never allow public signup to self-assign admin roles.
8. Test RLS and Storage policies using separate member, admin and super-admin accounts.

The SQL is a security baseline and must be reviewed in the target Supabase project before production.
