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

/** Los idiomas que la invitación sabe mostrar */
const IDIOMAS = ["es", "en"] as const;
export type Idioma = (typeof IDIOMAS)[number];

/**
 * El link personalizado de un invitado:
 *
 *   dominio.com/k7m2p       → español
 *   dominio.com/en/k7m2p    → inglés
 *
 * El código va en la ruta y no como ?i=k7m2p porque se ve mucho mejor al
 * pegarlo en WhatsApp. Que funcione depende de vercel.json, que le dice a
 * Vercel que muestre la invitación cuando la dirección no existe como
 * archivo. Si se despliega en otro lado hay que replicar esa regla.
 *
 * El español no lleva prefijo: es el idioma por defecto y así el link de
 * la mayoría queda lo más corto posible.
 */
export function linkInvitado(codigo: string, idioma: string = "es"): string {
  const prefijo = idioma === "es" ? "" : `/${idioma}`;
  return `${window.location.origin}${prefijo}/${codigo}`;
}

/**
 * Lee el código del invitado desde la dirección.
 *
 * Acepta las tres formas:
 *   /k7m2p        → español
 *   /en/k7m2p     → inglés, hay que saltear el tramo del idioma
 *   ?i=k7m2p      → la forma vieja, para que los links ya repartidos con
 *                   el formato anterior sigan funcionando
 */
export function codigoDeLaUrl(): string | null {
  const query = new URLSearchParams(window.location.search).get("i");
  if (query && query.trim()) return query.trim();

  const tramos = window.location.pathname.split("/").filter(Boolean);

  /*
     Si el primero es un idioma, el código es el siguiente. Sin esto, en
     /en/k7m2p se buscaría un invitado con código "en" y no aparecería
     ningún nombre.
  */
  if (IDIOMAS.includes(tramos[0] as Idioma)) tramos.shift();

  // En la invitación general (dominio.com o dominio.com/en) no queda nada
  return tramos[0] ? decodeURIComponent(tramos[0]) : null;
}
