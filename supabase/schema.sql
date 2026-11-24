-- UoG PHA schema baseline. Review and test in a non-production Supabase project first.
create extension if not exists pgcrypto;
create type public.app_role as enum ('super_admin','admin','member');
create type public.membership_status as enum ('pending','approved','rejected','suspended');

create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 full_name text not null,
 student_id text unique,
 email text not null,
 academic_year text,
 avatar_path text,
 membership_status public.membership_status not null default 'pending',
 membership_number text unique,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.user_roles (
 user_id uuid primary key references auth.users(id) on delete cascade,
 role public.app_role not null default 'member',
 created_at timestamptz not null default now()
);
create table if not exists public.events (
 id uuid primary key default gen_random_uuid(),
 title text not null, description text, venue text,
 starts_at timestamptz not null, ends_at timestamptz,
 registration_opens_at timestamptz, registration_closes_at timestamptz,
 capacity integer check (capacity is null or capacity > 0),
 status text not null default 'draft' check(status in ('draft','published','cancelled','completed')),
 created_by uuid references auth.users(id), created_at timestamptz not null default now()
);
create table if not exists public.event_registrations (
 id uuid primary key default gen_random_uuid(),
 event_id uuid not null references public.events(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 status text not null default 'registered' check(status in ('registered','waitlisted','cancelled','attended')),
 created_at timestamptz not null default now(), unique(event_id,user_id)
);
create table if not exists public.announcements (
 id uuid primary key default gen_random_uuid(),
 title text not null, body text not null, published boolean not null default false,
 published_at timestamptz, created_by uuid references auth.users(id), created_at timestamptz not null default now()
);
create table if not exists public.library_files (
 id uuid primary key default gen_random_uuid(),
 title text not null, description text, category text, tags text[] default '{}',
 storage_path text not null, mime_type text not null, size_bytes bigint not null check(size_bytes > 0),
 visibility text not null default 'members' check(visibility in ('public','members','admins')),
 uploaded_by uuid references auth.users(id), approved boolean not null default false,
 created_at timestamptz not null default now()
);
create table if not exists public.notifications (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade,
 title text not null, body text not null, read_at timestamptz, created_at timestamptz not null default now()
);
create table if not exists public.support_requests (
 id uuid primary key default gen_random_uuid(), user_id uuid references auth.users(id),
 subject text not null, message text not null, status text not null default 'open',
 response text, created_at timestamptz not null default now()
);
create table if not exists public.audit_logs (
 id bigint generated always as identity primary key, actor_id uuid references auth.users(id),
 action text not null, entity_type text not null, entity_id text, details jsonb not null default '{}',
 created_at timestamptz not null default now()
);
create table if not exists public.content_items (
 id uuid primary key default gen_random_uuid(), content_type text not null, title text not null,
 body text, metadata jsonb not null default '{}', published boolean not null default false,
 created_by uuid references auth.users(id), created_at timestamptz not null default now()
);
create table if not exists public.suggestions (
 id uuid primary key default gen_random_uuid(), user_id uuid references auth.users(id),
 anonymous boolean not null default false, message text not null, status text not null default 'new',
 created_at timestamptz not null default now()
);
create table if not exists public.newsletter_subscribers (
 id uuid primary key default gen_random_uuid(), email text not null unique,
 confirmed_at timestamptz, unsubscribed_at timestamptz, created_at timestamptz not null default now()
);
create table if not exists public.volunteer_signups (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id),
 activity text not null, availability text, status text not null default 'pending', created_at timestamptz not null default now()
);
create table if not exists public.survey_responses (
 id uuid primary key default gen_random_uuid(), user_id uuid references auth.users(id),
 survey_key text not null, response jsonb not null, created_at timestamptz not null default now()
);
create table if not exists public.quiz_attempts (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id),
 quiz_key text not null, score numeric, answers jsonb not null default '{}', created_at timestamptz not null default now()
);
create table if not exists public.mentorship_requests (
 id uuid primary key default gen_random_uuid(), mentee_id uuid not null references auth.users(id),
 mentor_id uuid references auth.users(id), message text, status text not null default 'pending', created_at timestamptz not null default now()
);
create table if not exists public.certificates (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id),
 event_id uuid references public.events(id), certificate_code text not null unique,
 issued_by uuid references auth.users(id), issued_at timestamptz not null default now()
);
create table if not exists public.brand_settings (
 id boolean primary key default true check(id), logo_path text, favicon_path text,
 brand_primary text default '#102c45', brand_secondary text default '#0c8f89',
 updated_by uuid references auth.users(id), updated_at timestamptz not null default now()
);

create or replace function public.current_app_role()
returns public.app_role language sql stable security definer set search_path=public
as $$ select role from public.user_roles where user_id=auth.uid() $$;
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path=public
as $$ select coalesce(public.current_app_role() in ('admin','super_admin'),false) $$;
create or replace function public.is_super_admin()
returns boolean language sql stable security definer set search_path=public
as $$ select coalesce(public.current_app_role()='super_admin',false) $$;

alter table public.profiles enable row level security;
alter table public.user_roles enable row level security;
alter table public.events enable row level security;
alter table public.event_registrations enable row level security;
alter table public.announcements enable row level security;
alter table public.library_files enable row level security;
alter table public.notifications enable row level security;
alter table public.support_requests enable row level security;
alter table public.audit_logs enable row level security;
alter table public.content_items enable row level security;
alter table public.suggestions enable row level security;
alter table public.newsletter_subscribers enable row level security;
alter table public.volunteer_signups enable row level security;
alter table public.survey_responses enable row level security;
alter table public.quiz_attempts enable row level security;
alter table public.mentorship_requests enable row level security;
alter table public.certificates enable row level security;
alter table public.brand_settings enable row level security;

create policy "profiles read self or admins" on public.profiles for select to authenticated using (id=auth.uid() or public.is_admin());
create policy "profiles update self" on public.profiles for update to authenticated using(id=auth.uid()) with check(id=auth.uid());
create policy "admins manage profiles" on public.profiles for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "users read own role; super admin reads all" on public.user_roles for select to authenticated using(user_id=auth.uid() or public.is_super_admin());
create policy "super admins manage roles" on public.user_roles for all to authenticated using(public.is_super_admin()) with check(public.is_super_admin());
create policy "published events public read" on public.events for select using(status='published' or public.is_admin());
create policy "admins manage events" on public.events for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "users manage own event registration" on public.event_registrations for select to authenticated using(user_id=auth.uid() or public.is_admin());
create policy "users register self" on public.event_registrations for insert to authenticated with check(user_id=auth.uid());
create policy "users cancel own registration or admins" on public.event_registrations for update to authenticated using(user_id=auth.uid() or public.is_admin()) with check(user_id=auth.uid() or public.is_admin());
create policy "published announcements read" on public.announcements for select using(published or public.is_admin());
create policy "admins manage announcements" on public.announcements for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "approved visible library read" on public.library_files for select to authenticated using((approved and visibility in ('public','members')) or public.is_admin() or uploaded_by=auth.uid());
create policy "authenticated upload own library metadata" on public.library_files for insert to authenticated with check(uploaded_by=auth.uid());
create policy "admins manage library" on public.library_files for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "notifications own read" on public.notifications for select to authenticated using(user_id=auth.uid() or public.is_admin());
create policy "notifications own update" on public.notifications for update to authenticated using(user_id=auth.uid()) with check(user_id=auth.uid());
create policy "support own read and create" on public.support_requests for select to authenticated using(user_id=auth.uid() or public.is_admin());
create policy "support create own" on public.support_requests for insert to authenticated with check(user_id=auth.uid());
create policy "admins respond support" on public.support_requests for update to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "audit super admin read" on public.audit_logs for select to authenticated using(public.is_super_admin());
create policy "audit admins insert" on public.audit_logs for insert to authenticated with check(public.is_admin());
create policy "published content read" on public.content_items for select using(published or public.is_admin());
create policy "admins manage content" on public.content_items for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "suggestions create" on public.suggestions for insert to anon,authenticated with check(user_id is null or user_id=auth.uid());
create policy "admins manage suggestions" on public.suggestions for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "newsletter public subscribe" on public.newsletter_subscribers for insert to anon,authenticated with check(true);
create policy "admins manage newsletter" on public.newsletter_subscribers for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "volunteers own records" on public.volunteer_signups for select to authenticated using(user_id=auth.uid() or public.is_admin());
create policy "volunteers apply" on public.volunteer_signups for insert to authenticated with check(user_id=auth.uid());
create policy "admins manage volunteers" on public.volunteer_signups for update to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "survey own responses" on public.survey_responses for select to authenticated using(user_id=auth.uid() or public.is_admin());
create policy "survey submit" on public.survey_responses for insert to authenticated with check(user_id=auth.uid());
create policy "quiz own attempts" on public.quiz_attempts for select to authenticated using(user_id=auth.uid() or public.is_admin());
create policy "quiz submit" on public.quiz_attempts for insert to authenticated with check(user_id=auth.uid());
create policy "mentorship participants read" on public.mentorship_requests for select to authenticated using(mentee_id=auth.uid() or mentor_id=auth.uid() or public.is_admin());
create policy "mentee create request" on public.mentorship_requests for insert to authenticated with check(mentee_id=auth.uid());
create policy "admins manage mentorship" on public.mentorship_requests for update to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "certificate owner or admins read" on public.certificates for select to authenticated using(user_id=auth.uid() or public.is_admin());
create policy "admins issue certificates" on public.certificates for insert to authenticated with check(public.is_admin());
create policy "brand settings read" on public.brand_settings for select using(true);
create policy "super admin manages brand" on public.brand_settings for all to authenticated using(public.is_super_admin()) with check(public.is_super_admin());

-- NOTE: For production, review policy overlaps, add stricter field-level/server-side authorization,
-- create Storage policies per bucket, rate limiting, audit triggers, and transaction-safe event capacity.
