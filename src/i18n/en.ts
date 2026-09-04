// src/i18n/en.ts
// Los textos en inglés. Tiene que tener exactamente las mismas claves que
// es.ts: si falta alguna, TypeScript avisa al compilar en vez de dejar un
// hueco en la invitación de un invitado.
//
// Los versículos usan la New International Version, que es la traducción
// más difundida y la que suena natural en una boda. Si los novios prefieren
// otra (King James, por ejemplo), se cambian acá y en ningún lado más.

import type { Textos } from "./index";

export const en: Textos = {
    // ── Cover ────────────────────────────────────────────────
    portada: {
        union: "&",
        para: "For:",
    },

    // ── Lili's letter ────────────────────────────────────────
    dedicatoria: {
        altRetrato: "Lili, the couple’s little dog, surrounded by flowers",
        saludo: "Hello",
        gancho: "I'm Lili, my human mum's spoiled little dog,",
        ganchoDestacado: "and I have something lovely to tell you.",
        textoBoton: "Open my letter",
        bloque1: "I'm Lili, my human mum's spoiled little dog, and today I want to give you a ",
        bloque1Destacado: "warm welcome to a very special day.",
        bloque2:
            "For a long time, my human mum and I were just the two of us. " +
            "We shared our routines, our afternoons, our games and an " +
            "immense love that made us happy.",
        bloque3: "But at a certain moment, someone very special appeared in our lives: ",
        cambio: "And everything changed for the better.",
        subtitulo: "did two very important things:",
        razon1:
            "He accepted my human mum just as she is, with her strong " +
            "character, her good days and the not so good ones. He helped " +
            "her be calmer, happier, and believe that true love does exist.",
        razon2:
            "He loved me too, and that means everything to my human mum. " +
            "With his love and patience, he made me feel part of his life, " +
            "his heart and his family.",
        hoy: "Today, my human mum and I want to tell you that we are no longer alone.",
        somosTres:
            "Now there are three of us, and our home is full of love, " +
            "respect, laughter and many walks together.",
        cierre:
            "We invite you to celebrate with us the beginning of this new " +
            "chapter, where love unites us and happiness walks beside us.",
        firma: "With love,",
        nota: ["Always together,", "forever a family."],
    },

    // ── Framed photo ─────────────────────────────────────────
    foto: {
        alt: "These children are getting married: welcome to Marvin and Carla's wedding",
    },

    // ── We're getting married ────────────────────────────────
    nosCasamos: {
        titulo: "We're getting married!",
        bendicion: [
            "With the blessing of God, of our parents",
            "and in the company of our godparents",
        ],
        invitacion:
            "We have the honour of inviting you to celebrate the " +
            "beginning of our new chapter, where love unites us and " +
            "happiness walks beside us.",
        cierre: "We'll be waiting for you!",
        altFoto:
            "The couple's hands with the engagement ring, and Lili's paw resting on top",
    },

    // ── Bible verses ─────────────────────────────────────────
    versiculo: {
        texto:
            "There is a time for everything, and a season for every " +
            "activity under the heavens.",
        cita: "Ecclesiastes 3:1",
    },
    versiculo2: {
        texto: "Love never fails.",
        cita: "1 Corinthians 13:8",
    },

    // ── Date ─────────────────────────────────────────────────
    fecha: {
        anuncio: "We're Getting Married!",
        hora: "2:00 PM",
        diasSemana: ["S", "M", "T", "W", "T", "F", "S"],
        nombresDia: [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
        ],
        nombresMes: [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December",
        ],
        // "Saturday, January 9" — el orden es distinto al español, por eso
        // la plantilla y no tres pedazos pegados
        formatoFecha: "{dia}, {mes} {numero}",
    },

    // ── Countdown ────────────────────────────────────────────
    contador: {
        titulo: "Not long now",
        dias: "Days",
        horas: "Hrs",
        minutos: "Min",
        segundos: "Sec",
    },

    // ── Message ──────────────────────────────────────────────
    mensaje: ["Sharing these moments with you", "is what makes them unforgettable"],

    // ── Parents ──────────────────────────────────────────────
    padres: {
        bendicion: ["With the blessing of God", "and of our parents"],
        padresNovia: "Parents of the bride",
        padresNovio: "Parents of the groom",
        cierre: [
            "We are delighted to invite you",
            "to share with us",
            "this very special day.",
        ],
    },

    // ── Godparents ───────────────────────────────────────────
    padrinos: {
        titulo: "Our Godparents",
        religion: "Church Godparents",
        civil: "Civil Godparents",
    },

    // ── Religious ceremony ───────────────────────────────────
    ceremonia: {
        titulo: "Religious Ceremony",
        rotulo: "Parish",
        direccion: ["Jamaica Street & Cuba Street", "( Miraflores area )"],
        textoBoton: "View map",
    },

    // ── Reception ────────────────────────────────────────────
    recepcion: {
        titulo: "Reception",
        salon: ["EVENT VENUE", "“ROBLES”"],
        direccion: [
            "Cañada Strongest Street #1822",
            "( Half a block from Plaza del Estudiante )",
        ],
        textoBoton: "View map",
    },

    // ── Dress code ───────────────────────────────────────────
    vestimenta: {
        titulo: "Dress Code",
        etiqueta: "FORMAL",
        damas: "Ladies",
        damasDetalle: "Long dress",
        caballeros: "Gentlemen",
        caballerosDetalle: "Elegant suit",
        nota: [
            "Out of love for the bride,",
            "the colour white is reserved",
            "for her alone",
        ],
    },

    // ── Schedule ─────────────────────────────────────────────
    cronograma: {
        titulo: "Schedule",
        momentos: [
            ["Religious Ceremony"],
            ["Civil Ceremony at", "the Venue"],
            ["Toast"],
            ["First Dance"],
            ["Reception"],
            ["Dinner"],
            ["Cake Cutting", "and Bouquet", "Toss"],
            ["Farewell"],
        ],
    },

    // ── Punctuality ──────────────────────────────────────────
    puntualidad: {
        inicio: "Your punctuality is",
        resalte1: "key",
        medio: "so everything unfolds just as we",
        resalte2: "dreamed",
        final: ".",
    },

    // ── Gift suggestion ──────────────────────────────────────
    regalo: {
        titulo: "Gift Suggestion",
        texto: [
            "Your presence is the greatest gift we could",
            "ask for on this unique day. We already have",
            "our little house, our Ferrari and the yacht —",
            "we just have to pay for them! As a gift",
            "suggestion, we leave you this QR code.",
        ],
        rotuloQr: "QR TRANSFER",
        altQr: "QR code for bank transfer",
        altFoto: "Lu, the couple's little dog, on a yacht at sunset",
    },

    // ── Pass and RSVP ────────────────────────────────────────
    pase: {
        reservado: "We have reserved",
        honor: "in your honour",
        pase: "seat",
        pases: "seats",
        // Se muestra solo si el invitado tiene mesa asignada
        mesaAviso: "A table reserved with much love",
        mesa: "Table",
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

    // ── Good wishes ──────────────────────────────────────────
    deseos: {
        titulo: "Good Wishes",
        textoBoton: "LEAVE A WISH",
        textoBotonEditar: "EDIT MY WISH",
        verTodos: "See all the wishes",
        verMas: "Read more",
        de: "From:",
        modalTitulo: "Leave us your wish",
        campoNombre: "Your name",
        campoMensaje: "Your message",
        enviar: "Send my wish",
        gracias: "Thank you! Your wish is on the wall.",
        actualizado: "Done, we updated your wish.",
        errorNombre: "Please tell us your name, so we know who it's from.",
        errorMensaje: "That message is a little too short.",
        errorEnvio: "We couldn't send it. Please try again in a moment.",
        tarjetaInicial: {
            nombre: "Marvin & Carla",
            mensaje:
                "We would love to hear from you. Leave us a few words and " +
                "they will stay here, with those of everyone celebrating " +
                "with us.",
        },
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

    // ── Farewell ─────────────────────────────────────────────
    despedida: {
        gracias: ["Thank God for granting us this", "day.", "Don't miss it!"],
        anuncio: "OUR WEDDING",
    },
};
