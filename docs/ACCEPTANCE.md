# Acceptance and test checklist

Run these tests before calling the system production-ready.

- [ ] Registration, email confirmation, login, logout and password recovery.
- [ ] New applications default to pending; member cannot self-approve.
- [ ] Admin can approve/reject only within granted permissions.
- [ ] Super Admin can create/deactivate admins and change roles.
- [ ] Admin cannot grant themselves Super Admin.
- [ ] Member can read/update only permitted own profile fields.
- [ ] Private files cannot be downloaded by unauthorized accounts.
- [ ] MIME type and file size validation works on client and server/storage.
- [ ] Logo replacement failure preserves current valid logo.
- [ ] Event capacity and registration window are enforced transactionally.
- [ ] Notifications appear for membership decisions and event/announcement changes.
- [ ] Search respects row-level permissions.
- [ ] CSV exports exclude unauthorized/private fields.
- [ ] Audit records are protected from member modification.
- [ ] Mobile, tablet, desktop, keyboard and screen-reader checks.
- [ ] Backup restore is tested, not merely documented.
- [ ] Cloudflare build and runtime are verified on the selected product.
