// src/lib/supabase.ts
// Cliente de Supabase para el navegador.
//
// La clave es pública a propósito: viaja al navegador de cada invitado.
// Lo que impide que alguien se descargue la lista completa son las
// reglas RLS definidas en supabase/schema.sql

import { createClient } from "@supabase/supabase-js";

const url = import.meta.env.PUBLIC_SUPABASE_URL;
const key = import.meta.env.PUBLIC_SUPABASE_KEY;

/**
 * Si faltan las variables de entorno, createClient lanza al cargar el módulo
 * y se lleva por delante todo el script: la página se queda colgada sin decir
 * por qué. Mejor avisar y que quien use el cliente decida qué hacer.
 */
export const configurado = Boolean(url && key);

export const supabase = configurado
  ? createClient(url, key, {
      auth: {
        persistSession: true,
        autoRefreshToken: true,
      },
    })
  : null;

/**
 * Código corto que viaja en el link: ...?i=k7m2p
 * Sin vocales ni caracteres que se confundan (0/O, 1/l/I),
 * para que se pueda dictar por teléfono sin errores.
 */
export function generarCodigo(largo = 5): string {
  const alfabeto = "23456789bcdfghjkmnpqrstvwxyz";
  let codigo = "";
  const valores = new Uint32Array(largo);
  crypto.getRandomValues(valores);
  for (let i = 0; i < largo; i++) {
    codigo += alfabeto[valores[i] % alfabeto.length];
  }
  return codigo;
}

/**
 * El link personalizado de un invitado: dominio.com/k7m2p
 *
 * El código va en la ruta y no como ?i=k7m2p porque se ve mucho mejor al
 * pegarlo en WhatsApp. Que funcione depende de vercel.json, que le dice a
 * Vercel que muestre la invitación cuando la dirección no existe como
 * archivo. Si se despliega en otro lado hay que replicar esa regla.
 */
export function linkInvitado(codigo: string): string {
  return `${window.location.origin}/${codigo}`;
}

/**
 * Lee el código del invitado desde la dirección.
 *
 * Acepta las dos formas: la limpia (/k7m2p) y la vieja (?i=k7m2p), para que
 * los links ya repartidos con el formato anterior sigan funcionando.
 */
export function codigoDeLaUrl(): string | null {
  const query = new URLSearchParams(window.location.search).get("i");
  if (query && query.trim()) return query.trim();

  // El primer tramo de la ruta, sin barras. En la invitación general
  // (dominio.com) queda vacío, y ahí no hay código que buscar.
  const tramo = window.location.pathname.split("/").filter(Boolean)[0];
  return tramo ? decodeURIComponent(tramo) : null;
}
