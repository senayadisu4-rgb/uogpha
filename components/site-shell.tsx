'use client';
import Link from 'next/link';
import { useState } from 'react';
const links=[['Home','/'],['About','/about'],['Leadership','/leadership'],['Events','/events'],['Announcements','/announcements'],['Library','/library'],['Research','/research'],['Gallery','/gallery'],['Contact','/contact']];
export function SiteShell({children}:{children:React.ReactNode}) {
 const [menu,setMenu]=useState(false),[dark,setDark]=useState(false),[am,setAm]=useState(false);
 return <div className={dark?'app dark':'app'}><header className="top"><Link className="brand" href="/"><span className="logo">PHA</span><span><b>UoG PUBLIC HEALTH</b><small>ASSOCIATION</small></span></Link><button className="menu" onClick={()=>setMenu(!menu)}>☰</button><nav className={menu?'show':''}>{links.map(([n,h])=><Link key={h} href={h}>{n}</Link>)}</nav><div className="tools"><button onClick={()=>setAm(!am)}>{am?'EN':'አማ'}</button><button onClick={()=>setDark(!dark)}>{dark?'☀':'◐'}</button><Link className="login" href="/login">Login</Link></div></header>{am&&<div className="notice">የአማርኛ ቋንቋ ምርጫ ተመርጧል። ትርጉሞች በደረጃ ይሞላሉ።</div>}<main>{children}</main><footer><div><b>UoG Public Health Association</b><p>Learning · Research · Service · Community</p></div><div>University of Gondar · Ethiopia<br/><a href="https://t.me/uogpublichealth">Association contact</a></div><small>© 2026 UoG PHA. Association identity and official endorsement must be confirmed by the association.</small></footer></div>
}
