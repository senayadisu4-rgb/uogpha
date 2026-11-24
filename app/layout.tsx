import type { Metadata } from 'next';
import './globals.css';
import { SiteShell } from '@/components/site-shell';
export const metadata: Metadata = { title: 'UoG Public Health Association', description: 'University of Gondar Public Health Association digital platform' };
export default function RootLayout({children}:{children:React.ReactNode}) { return <html lang="en"><body><SiteShell>{children}</SiteShell></body></html>; }
