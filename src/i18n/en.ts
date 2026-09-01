// src/i18n/en.ts
// Los textos en inglés. Tiene que tener exactamente las mismas claves que
// es.ts: si falta alguna, TypeScript avisa al compilar en vez de dejar un
// hueco en la invitación de un invitado.

import type { Textos } from "./index";

export const en: Textos = {
    // ── Punctuality ──────────────────────────────────────────
    puntualidad: {
        inicio: "Your punctuality is",
        resalte1: "key",
        medio: "so everything unfolds just as we",
        resalte2: "dreamed",
        final: ".",
    },

    // ── Our story ────────────────────────────────────────────
    historia: {
        titulo: "Our story",
        primero: [
            "We met as children, we grew up,",
            "took different paths, and life",
            "brought us back together.",
        ],
        segundoInicio: "Today, those children",
        segundoResalte: "choose each other forever.",
    },

    // ── Pass and RSVP ────────────────────────────────────────
    pase: {
        reservado: "We have reserved",
        honor: "in your honour",
        pase: "seat",
        pases: "seats",
        tituloConfirmar: "Please RSVP",
        aviso: [
            "Your presence means the world to us,",
            "please remember to confirm.",
        ],
        textoBoton: "Confirm Attendance",
        yaConfirmado: "Thank you! Your attendance is confirmed.",
        errorConfirmar: "We couldn't save it. Please try again in a moment.",
        confirmando: "Confirming…",
        modalTitulo: "Confirm your attendance?",
        modalTexto: "You are confirming as",
        modalCancelar: "Cancel",
        modalAceptar: "Yes, I'll be there",
        mensajeWhatsapp:
            "I'm confirming my attendance to Marvin and Carla's wedding. " +
            "See you on Saturday, January 9th. It will be a pleasure to " +
            "celebrate with you!",
    },
};
