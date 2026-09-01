// src/i18n/es.ts
// Los textos en español. Es el idioma por defecto y el que define qué
// claves tienen que existir: en.ts está obligado a tener las mismas.

export const es = {
    // ── Puntualidad ──────────────────────────────────────────
    puntualidad: {
        inicio: "Tu puntualidad es",
        resalte1: "clave",
        medio: "para que todo salga como lo",
        resalte2: "soñamos",
        final: ".",
    },

    // ── Nuestra historia ─────────────────────────────────────
    historia: {
        titulo: "Nuestra historia",
        primero: [
            "Nos conocimos de niños, crecimos,",
            "tomamos caminos distintos y la vida",
            "volvió a encontrarnos.",
        ],
        segundoInicio: "Hoy, aquellos niños",
        segundoResalte: "se eligen para siempre.",
    },

    // ── Pase y confirmación ──────────────────────────────────
    pase: {
        reservado: "Hemos reservado",
        honor: "en tu honor",
        pase: "pase",
        pases: "pases",
        tituloConfirmar: "Confirmación de Asistencia",
        aviso: [
            "Tu presencia es muy importante, no",
            "olvides confirmar tu asistencia.",
        ],
        textoBoton: "Confirmar Asistencia",
        yaConfirmado: "¡Gracias! Ya confirmaste tu asistencia.",
        errorConfirmar: "No pudimos guardarlo. Probá de nuevo en un rato.",
        confirmando: "Confirmando…",
        modalTitulo: "¿Confirmás tu asistencia?",
        modalTexto: "Vas a confirmar como",
        modalCancelar: "Cancelar",
        modalAceptar: "Sí, confirmo",
        // El mensaje de WhatsApp de la invitación general, donde no hay a
        // quién marcar en la lista
        mensajeWhatsapp:
            "Confirmo la asistencia a la boda de Marvin y Carla. " +
            "Nos vemos el sábado 9 de enero. ¡Será un placer acompañarlos!",
    },
} as const;
