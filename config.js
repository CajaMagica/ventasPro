// ============================================================
// CONFIGURACIÓN MI ARTE BOLIVIA — config.js
// ============================================================
// INSTRUCCIONES:
//  1. Reemplaza supabaseUrl y supabaseAnon con tus datos reales
//  2. Guarda el archivo
//  3. Recarga la página
//
// ¿Dónde encontrar los datos?
//  → supabase.com/dashboard → tu proyecto
//  → Settings → Data API
//  → "Project URL" y "anon / public" key
// ============================================================

window.__MIARTE_CONFIG__ = {

  // ── SUPABASE ─────────────────────────────────────────────
  // Tu Project URL (termina en .supabase.co)
  supabaseUrl: 'https://bvxphmhvpbqblokluxox.supabase.co',

  // Tu Anon Key (empieza con eyJhbGci... y tiene +200 caracteres)
  supabaseAnon: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2eHBobWh2cGJxYmxva2x1eG94Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQwNTM0NDQsImV4cCI6MjA4OTYyOTQ0NH0.mscLfnzFxaVos-TkgJz_QplVlD6uUylljsp3f3pYoe0',

  // ── ADMIN ────────────────────────────────────────────────
  adminUser: 'admin',
  adminPass: 'miarte2025',

  // ── WHATSAPP ─────────────────────────────────────────────
  whatsapp: '59176852054',

};

// ── VALIDACIÓN AUTOMÁTICA ────────────────────────────────
(function(){
  const cfg  = window.__MIARTE_CONFIG__;
  const url  = cfg.supabaseUrl  || '';
  const anon = cfg.supabaseAnon || '';
  const urlOk  = url.includes('.supabase.co') && !url.includes('TU-PROYECTO');
  const anonOk = anon.startsWith('eyJ') && anon.length > 100 && !anon.includes('PEGA_TU');
  if(!urlOk || !anonOk){
    console.warn('%c[Mi Arte Bolivia] config.js incompleto — el sitio no cargará datos de Supabase','color:#c4572a;font-weight:bold');
    if(!urlOk)  console.warn('  ❌ supabaseUrl:', url||'(vacío)');
    if(!anonOk) console.warn('  ❌ supabaseAnon: inválido o placeholder');
    console.warn('  → Edita config.js con tus credenciales reales de Supabase');
  } else {
    console.log('%c[Mi Arte Bolivia] config.js ✅ OK','color:#4a9b8e;font-weight:bold');
    console.log('  Proyecto:', url.replace('https://','').split('.')[0]);
  }
})();