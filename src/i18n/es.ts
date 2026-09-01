// src/i18n/es.ts
// Los textos en español. Es el idioma por defecto y el que define qué
// claves tienen que existir: en.ts está obligado a tener las mismas.
//
// Lo que NO va acá porque no se traduce: nombres de personas, la parroquia,
// las direcciones, el número de cuenta y los enlaces a los mapas. Eso vive
// en cada componente y es igual en los dos idiomas.

export const es = {
    // ── Portada ──────────────────────────────────────────────
    portada: {
        union: "y",
        para: "Para:",
    },

    // ── Carta de Lili ────────────────────────────────────────
    dedicatoria: {
        altRetrato: "Lili, la perrita de los novios, rodeada de flores",
        saludo: "Hola",
        gancho: "Soy Lili, la perrita consentida de mi mamá humana,",
        ganchoDestacado: "y tengo algo lindo que contarte.",
        textoBoton: "Ábreme mi carta",
        bloque1: "Soy Lili, la perrita consentida de mi mamá humana, y hoy quiero darte la ",
        bloque1Destacado: "bienvenida a un día muy especial.",
        bloque2:
            "Hace mucho tiempo, mamá humana y yo éramos solo dos. " +
            "Compartíamos nuestras rutinas, nuestras tardes, " +
            "nuestros juegos y un amor inmenso que nos hacía felices.",
        bloque3: "Pero en un momento determinado, apareció alguien muy especial en nuestras vidas: ",
        cambio: "Y todo cambió para mejor.",
        subtitulo: "hizo dos cosas muy importantes:",
        razon1:
            "Aceptar a mi mamá humana tal como es, con su carácter fuerte, " +
            "sus días buenos y los no tan buenos. La ayudó a ser más tranquila, " +
            "más feliz y a creer que el amor verdadero sí existe.",
        razon2:
            "Quererme a mí, y eso es lo más importante para mí, mamá humana. " +
            "Con su amor y paciencia, me hizo sentir parte de su vida, " +
            "de su corazón y de su familia.",
        hoy: "Hoy, mamá humana y yo queremos decirte que ya no estamos solas.",
        somosTres:
            "Ahora somos tres, y nuestro hogar está lleno de amor, respeto, " +
            "risas y muchos paseos juntos.",
        cierre:
            "Te invitamos a celebrar con nosotros el inicio de esta nueva etapa, " +
            "donde el amor nos une y la felicidad nos acompaña.",
        firma: "Con amor,",
        nota: ["Siempre juntos,", "por siempre familia."],
    },

    // ── Foto enmarcada ───────────────────────────────────────
    foto: {
        alt: "Estos niños se casan: bienvenidos a la boda de Marvin y Carla",
    },

    // ── ¡Nos casamos! ────────────────────────────────────────
    nosCasamos: {
        titulo: "¡Nos casamos!",
        bendicion: [
            "Con la bendición de Dios, de nuestros padres",
            "y en compañía de nuestros padrinos",
        ],
        invitacion:
            "Tenemos el honor de invitarte a celebrar " +
            "el inicio de nuestra nueva etapa, " +
            "donde el amor nos une y la felicidad nos acompaña.",
        cierre: "¡Te esperamos!",
        altFoto:
            "Las manos de los novios con el anillo de compromiso, y la patita de Lili encima",
    },

    // ── Versículos ───────────────────────────────────────────
    versiculo: {
        texto:
            "Así que no son ya más dos, sino una sola carne; por tanto, " +
            "lo que Dios ha unido, no lo separe el hombre.",
        cita: "Mateo 19:6",
    },
    versiculo2: {
        texto: "El amor no pasará jamás.",
        cita: "1 Corintios 13:8",
    },

    // ── Fecha ────────────────────────────────────────────────
    fecha: {
        anuncio: "¡Nos Casamos!",
        hora: "14:00 hrs",
        diasSemana: ["D", "L", "M", "M", "J", "V", "S"],
        nombresDia: [
            "Domingo",
            "Lunes",
            "Martes",
            "Miércoles",
            "Jueves",
            "Viernes",
            "Sábado",
        ],
        nombresMes: [
            "Enero",
            "Febrero",
            "Marzo",
            "Abril",
            "Mayo",
            "Junio",
            "Julio",
            "Agosto",
            "Septiembre",
            "Octubre",
            "Noviembre",
            "Diciembre",
        ],
        // "Sábado 9 de Enero". En inglés el orden cambia, por eso es una
        // plantilla y no tres pedazos pegados.
        formatoFecha: "{dia} {numero} de {mes}",
    },

    // ── Cuenta regresiva ─────────────────────────────────────
    contador: {
        titulo: "Falta poco",
        dias: "Días",
        horas: "Hrs.",
        minutos: "Min.",
        segundos: "Seg.",
    },

    // ── Mensaje ──────────────────────────────────────────────
    mensaje: ["Compartir esos momentos con", "ustedes los hace inolvidables"],

    // ── Padres ───────────────────────────────────────────────
    padres: {
        bendicion: ["Con la bendición de Dios", "y de nuestros padres"],
        padresNovia: "Padres de la novia",
        padresNovio: "Padres del novio",
        cierre: [
            "Nos complace invitarles a",
            "compartir con nosotros",
            "este día tan especial.",
        ],
    },

    // ── Padrinos ─────────────────────────────────────────────
    padrinos: {
        titulo: "Nuestros Padrinos",
        religion: "Padrinos de Religión",
        civil: "Padrinos de Civil",
    },

    // ── Ceremonia religiosa ──────────────────────────────────
    ceremonia: {
        titulo: "Ceremonia Religiosa",
        rotulo: "Parroquia",
        direccion: ["Calle Jamaica esquina calle Cuba", "( Zona Miraflores )"],
        textoBoton: "Ver mapa",
    },

    // ── Recepción ────────────────────────────────────────────
    recepcion: {
        titulo: "Recepción Social",
        salon: ["SALÓN DE EVENTOS", "“ROBLES”"],
        direccion: [
            "Calle Cañada Strongest #1822",
            "( A media cuadra de la Plaza del Estudiante )",
        ],
        textoBoton: "Ver mapa",
    },

    // ── Código de vestimenta ─────────────────────────────────
    vestimenta: {
        titulo: "Código de Vestimenta",
        etiqueta: "FORMAL",
        damas: "Damas",
        damasDetalle: "Vestido largo",
        caballeros: "Caballeros",
        caballerosDetalle: "Traje elegante",
        nota: [
            "Por cariño a la novia el vestido",
            "de color blanco está reservado",
            "para la novia",
        ],
    },

    // ── Cronograma ───────────────────────────────────────────
    cronograma: {
        titulo: "Cronograma",
        momentos: [
            ["Ceremonia Religiosa"],
            ["Ceremonia Civil en", "el Salón"],
            ["Brindis"],
            ["Vals de Novios"],
            ["Recepción Social"],
            ["Cena"],
            ["Corte de Torta", "y Lanzamiento", "de Bouquet"],
            ["Despedida"],
        ],
    },

    // ── Puntualidad ──────────────────────────────────────────
    puntualidad: {
        inicio: "Tu puntualidad es",
        resalte1: "clave",
        medio: "para que todo salga como lo",
        resalte2: "soñamos",
        final: ".",
    },

    // ── Sugerencia de regalo ─────────────────────────────────
    regalo: {
        titulo: "Sugerencia de Regalo",
        texto: [
            "Tu presencia es el mejor regalo para compartir",
            "este momento único. Ya tenemos nuestra casita",
            "completa, nuestro ferrari y el yate, ¡solo nos",
            "falta pagarlo! Como sugerencia de regalo te",
            "dejamos el siguiente QR.",
        ],
        rotuloQr: "TRANSFERENCIA QR",
        altQr: "Código QR para transferencia",
        altFoto: "Lu, la perrita de los novios, en un yate al atardecer",
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
        mensajeWhatsapp:
            "Confirmo la asistencia a la boda de Marvin y Carla. " +
            "Nos vemos el sábado 9 de enero. ¡Será un placer acompañarlos!",
    },

    // ── Buenos deseos ────────────────────────────────────────
    deseos: {
        titulo: "Buenos Deseos",
        textoBoton: "ESCRIBE UN DESEO",
        textoBotonEditar: "EDITAR MI DESEO",
        verTodos: "Ver todos los deseos",
        verMas: "Ver más",
        de: "De:",
        modalTitulo: "Dejanos tu deseo",
        campoNombre: "Tu nombre",
        campoMensaje: "Tu mensaje",
        enviar: "Enviar mi deseo",
        gracias: "¡Gracias! Tu deseo ya está en el muro.",
        actualizado: "Listo, actualizamos tu deseo.",
        errorNombre: "Escribinos tu nombre, así sabemos de quién es.",
        errorMensaje: "El mensaje quedó muy cortito.",
        errorEnvio: "No pudimos enviarlo. Probá de nuevo en un rato.",
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

    // ── Despedida ────────────────────────────────────────────
    despedida: {
        gracias: ["Gracias a Dios por permitirnos este", "día.", "¡No falten!"],
        anuncio: "NUESTRA BODA",
    },
};
