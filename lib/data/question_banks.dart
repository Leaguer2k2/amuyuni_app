import '../models/models.dart';

final List<List<QuestionModel>> allQuestionBanks = [
  node1Questions,
  node2Questions,
  node3Questions,
  node4Questions,
];

final List<QuestionModel> node1Questions = [
  QuestionModel(
    id: 'n1q1',
    type: QuestionType.multipleChoice,
    question:
        'Estás en el mercado y la casera te muestra un QR para pagar con Tigo Money. Antes de escanear, notas que el sticker del QR está pegado encima de otro más viejo. ¿Qué haces?',
    options: [
      'Escaneo rápido, total ya estoy con prisa',
      'Verifico el nombre del destinatario en la app y pregunto si ese es su nombre real',
      'Pago en efectivo para evitar problemas técnicos',
      'Confío plenamente porque la casera es conocida',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Bien hecho! Tiwula dice: Los QR falsos pegados sobre los originales redirigen el pago a otra cuenta. Siempre verifica que el nombre del destinatario sea el de la persona que te está cobrando.',
    feedbackWrong:
        '¡Cuidado! Es una técnica común en mercados: pegan un QR falso sobre el original. Tu pago iría al estafador. Siempre revisa el nombre del destinatario.',
    lupaHint:
        'Observa si el sticker del QR está intacto o parece tener capas pegadas. Revisa el nombre en la app antes de confirmar.',
    audioPrompt: 'Revisa siempre el nombre del destinatario antes de pagar con QR',
  ),
  QuestionModel(
    id: 'n1q2',
    type: QuestionType.multipleChoice,
    question:
        'Recibes un SMS: "Banco Unión: Su cuenta fue BLOQUEADA por actividad sospechosa. Desbloquéela inmediatamente en: www.banco-union-seguro.com". ¿Qué haces?',
    options: [
      'Entro al enlace y pongo mis datos para desbloquear mi cuenta',
      'Llamo al número oficial del Banco Unión que aparece en mi tarjeta para verificar',
      'Respondo el SMS pidiendo más información',
      'Reenvío el mensaje a mis familiares por si acaso',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Excelente! Tiwula te aplaude. Los bancos NUNCA envían enlaces por SMS para "desbloquear cuentas". Siempre llama al número oficial de tu tarjeta o ve a la agencia.',
    feedbackWrong:
        '¡Ese enlace es phishing! El dominio "banco-union-seguro.com" es falso. Los bancos no usan enlaces por SMS. Entrar a ese sitio roba tus claves y vacía tu cuenta.',
    lupaHint:
        'La URL real del Banco Unión es www.bancounion.com.bo. Cualquier variación con guiones o palabras adicionales es sospechosa.',
    audioPrompt: 'Los bancos nunca envían enlaces de verificación por SMS',
  ),
  QuestionModel(
    id: 'n1q3',
    type: QuestionType.iaVsReal,
    question:
        'Vendiste un celular por Facebook y el comprador te muestra una captura de pantalla de su app bancaria confirmando la transferencia. Pero a ti no te ha llegado ninguna notificación. ¿Es suficiente evidencia esa captura?',
    imageUrl:
        'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&h=400&fit=crop',
    options: [
      'Sí, la captura es prueba suficiente y entrego el celular',
      'No, espero a que el dinero aparezca en mi propia app del banco antes de entregar',
      'Le tomo foto a su cédula y confío',
      'Le pido que me muestre su app en vivo en su celular',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Muy astuto! Las capturas de pantalla se editan fácilmente con apps. Solo entrega productos cuando el dinero esté reflejado EN TU PROPIA app bancaria.',
    feedbackWrong:
        '¡Las capturas de pantalla SE EDITAN! Hay apps que falsifican comprobantes en segundos. Nunca entregues nada hasta ver el dinero real en tu cuenta.',
    lupaHint:
        'Busca inconsistencias en la tipografía, bordes pixelados o números que no coinciden con el formato real de la app bancaria.',
    audioPrompt: 'Las capturas de pantalla se pueden falsificar fácilmente',
  ),
  QuestionModel(
    id: 'n1q4',
    type: QuestionType.multipleChoice,
    question:
        'Te llega un mensaje: "Entel 25 años: ¡GANASTE 1,000 Bs! Para reclamar tu premio llena este formulario". El enlace es bit.ly/entel-premio. ¿Qué detectas?',
    options: [
      'Nada raro, Entel sí tiene aniversario',
      'Es sospechoso: usa acortador de URL y Entel comunica sorteos solo en su página oficial',
      'Le pregunto a mis amigos si también les llegó',
      'Lleno el formulario pero no pongo datos bancarios',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Correcto! Tiwula dice: Los acortadores como bit.ly ocultan la URL real. Entel publica sus promociones en entel.bo, nunca por cadenas de WhatsApp. Es phishing para robar datos.',
    feedbackWrong:
        '¡Es estafa! Los acortadores de URL esconden páginas falsas. Además, Entel comunica sorteos oficiales solo en su web y redes verificadas. No llenes ese formulario.',
    lupaHint:
        'Siempre desconfía de acortadores como bit.ly, tinyurl, ow.ly. Copia el enlace y pégalo en la sección Radar para analizarlo.',
    audioPrompt: 'Los acortadores de URL esconden la dirección real del sitio',
  ),
  QuestionModel(
    id: 'n1q5',
    type: QuestionType.multipleChoice,
    question:
        'Te llega un correo con el logo del Servicio de Impuestos Nacionales: "ALERTA: Su NIT será suspendido. Actualice sus datos fiscales aquí antes de 24 horas". ¿Cómo verificas si es real?',
    options: [
      'Hago clic en el enlace del correo inmediatamente',
      'Cierro el correo, abro el navegador y entro directamente a www.impuestos.gob.bo',
      'Respondo el correo preguntando si es real',
      'Reenvío el correo a mis contactos para advertirles',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Perfecto! El SIN nunca envía amenazas urgentes por correo. Siempre escribe la URL oficial a mano en el navegador. Los estafadores crean urgencia falsa para que no pienses.',
    feedbackWrong:
        '¡Es phishing! Las instituciones usan lenguaje formal, no amenazas con plazos de 24 horas. El enlace lleva a una página idéntica que roba tus datos fiscales.',
    lupaHint:
        'Revisa la dirección de correo del remitente. El SIN usa @impuestos.gob.bo, no @gmail.com o dominios raros.',
    audioPrompt: 'Nunca hagas clic en enlaces de correos urgentes, ve al sitio oficial',
  ),
  QuestionModel(
    id: 'n1q6',
    type: QuestionType.multipleChoice,
    question:
        'Escaneas un QR de pago en una tienda. La app se abre pero muestra una URL externa (https://pago-facil.info/qr) en lugar del nombre del comercio. ¿Qué pasa?',
    options: [
      'Continúo con el pago, debe ser normal',
      'NO continúo. El QR fue manipulado y redirige a un sitio falso de pago',
      'Anoto la URL y la busco en Google',
      'Le aviso al vendedor que su QR está dañado y pago en efectivo',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Ojo de Tiwula activado! Un QR de pago legítimo muestra directamente el nombre del destinatario en la app, NUNCA abre una página web externa. Ese QR fue alterado.',
    feedbackWrong:
        '¡Estafa! Un QR legítimo abre la app de pago con el nombre del comercio. Si abre un navegador web, ese QR fue manipulado para robar datos de tu tarjeta.',
    lupaHint:
        'El QR legítimo de Tigo Money o Yape ABRE la app de pago directamente, nunca el navegador. Es la señal de alerta más clara.',
    audioPrompt: 'Un QR de pago legítimo nunca abre el navegador web',
  ),
  QuestionModel(
    id: 'n1q7',
    type: QuestionType.multipleChoice,
    question:
        'Un mensaje dice: "Tigo Money te DUPLICA tu crédito HOY. Transfiere cualquier monto a 70012345 y en 10 minutos se te acredita el DOBLE". ¿Es real esta promoción?',
    options: [
      'Sí, Tigo Money hace promociones de duplicar crédito frecuentemente',
      'Es FALSO. Ninguna empresa duplica dinero por transferencia a números personales',
      'Transfiero un monto pequeño para probar si es real',
      'Depende, si el número empieza con 7 es oficial de Tigo',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Correcto! Tiwula se ríe del estafador. Si algo suena demasiado bueno para ser verdad, ES falso. Tigo Money NUNCA te pide transferir a un número personal para "duplicar".',
    feedbackWrong:
        '¡Es una estafa clásica! Te prometen duplicar el dinero, pero cuando transfieres, el estafador solo recibe tu plata y desaparece. "Duplicar dinero" es siempre mentira.',
    lupaHint:
        'Tigo Money anuncia promociones solo desde su número oficial verificado con tilde azul, nunca desde números personales.',
    audioPrompt: 'Nadie duplica dinero por transferencia, es una estafa clásica',
  ),
  QuestionModel(
    id: 'n1q8',
    type: QuestionType.multipleChoice,
    question:
        'En Facebook ves: "Laptop Core i7 a solo 100 Bs. Últimas 3 unidades. Pago por adelantado a cuenta 4000-xxxx". ¿Qué señales de estafa identificas?',
    options: [
      'Ninguna, las ofertas de Facebook son reales',
      'Precio irreal (una laptop así cuesta 3,000+ Bs), pago adelantado y urgencia falsa',
      'Solo el precio es sospechoso',
      'Si la página tiene muchos seguidores, debe ser confiable',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Detective astuto! Combinación letal: precio absurdamente bajo + urgencia + pago adelantado. Es la receta de toda estafa en Marketplace. Reporta la página.',
    feedbackWrong:
        'Tres alertas rojas: precio irreal (100 Bs por una laptop), pago adelantado sin ver el producto, y urgencia artificial ("últimas 3 unidades"). Es estafa 100%.',
    lupaHint:
        'Revisa cuándo se creó la página de Facebook. Las páginas de estafadores suelen tener pocos días y los seguidores son comprados (bots).',
    audioPrompt: 'Precio demasiado bajo más pago adelantado es siempre estafa',
  ),
  QuestionModel(
    id: 'n1q9',
    type: QuestionType.multipleChoice,
    question:
        'Recibes por WhatsApp: "Bono Juancito Pinto 2026: Regístrese AQUÍ para cobrar los 200 Bs". El enlace va a una página que pide tu CI y fecha de nacimiento. ¿Es oficial?',
    options: [
      'Sí, el gobierno paga bonos por WhatsApp',
      'No. Los bonos se cobran en entidades bancarias con registro presencial, no por enlaces de WhatsApp',
      'Tal vez, entro y si no pide mi contraseña del banco, debe ser seguro',
      'Solo si el mensaje tiene el escudo de Bolivia',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Muy bien! Los bonos estatales en Bolivia (Juancito Pinto, Renta Dignidad, etc.) se gestionan PRESENCIALMENTE en bancos o unidades educativas. Nunca por WhatsApp.',
    feedbackWrong:
        '¡Es robo de identidad! Con tu CI y fecha de nacimiento los estafadores pueden suplantarte. Los bonos en Bolivia siempre requieren trámite presencial, no formularios web.',
    lupaHint:
        'Busca en Google "Bono Juancito Pinto sitio oficial". El gobierno usa sitios .gob.bo, nunca enlaces de WhatsApp.',
    audioPrompt: 'Los bonos en Bolivia se registran presencialmente, no por WhatsApp',
  ),
  QuestionModel(
    id: 'n1q10',
    type: QuestionType.multipleChoice,
    question:
        'Te llega un SMS: "NETFLIX: Su método de pago fue rechazado. Actualícelo en las próximas 2 HORAS o su cuenta será CERRADA PERMANENTEMENTE". ¿Es real?',
    options: [
      'Sí, Netflix sí cierra cuentas por falta de pago',
      'Es falso. La amenaza con cierre PERMANENTE en 2 horas y la urgencia extrema son señales de phishing',
      'Entro a Netflix desde el link del SMS para revisar',
      'Sí, porque dice "NETFLIX" en mayúsculas',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Correcto! Tiwula dice: El miedo y la urgencia ("CIERRE PERMANENTE en 2 horas") son herramientas de manipulación. Netflix te notifica dentro de la app, no con amenazas por SMS.',
    feedbackWrong:
        '¡Phishing! La amenaza de cierre "permanente" es manipulación. Netflix nunca cierra cuentas permanentemente por un pago rechazado, y JAMÁS envía enlaces por SMS.',
    lupaHint:
        'Abre la app de Netflix directamente y revisa tu cuenta. NUNCA uses el enlace del SMS.',
    audioPrompt: 'Ninguna empresa te amenaza con cerrar tu cuenta en 2 horas por SMS',
  ),
];

final List<QuestionModel> node2Questions = [
  QuestionModel(
    id: 'n2q1',
    type: QuestionType.sliderAnalysis,
    question:
        'Observa esta foto de un supuesto bloqueo en El Alto. Usa el deslizador para comparar. ¿Es real o generada por IA?',
    imageUrl:
        'https://images.unsplash.com/photo-1635365626712-5c6d125a6cc2?w=600&h=400&fit=crop',
    options: ['Es una Foto Real', 'Creada con Inteligencia Artificial'],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Excelente ojo! Es IA. Tiwula notó dedos con 6 falanges en los manifestantes, letras borrosas en los carteles de fondo y sombras que no coinciden con la luz del sol.',
    feedbackWrong:
        '¡Es IA! Fíjate bien: los dedos de las personas del fondo no tienen la anatomía correcta (demasiados dedos), las letras de los carteles son garabatos y las sombras apuntan en direcciones imposibles.',
    lupaHint:
        'Con el deslizador, fíjate en las manos de la gente del fondo. La IA dibuja dedos de más o fusionados.',
    audioPrompt: 'La IA aún falla dibujando manos correctamente, busca dedos de más',
  ),
  QuestionModel(
    id: 'n2q2',
    type: QuestionType.multipleChoice,
    question:
        'Recibes un audio de WhatsApp de una voz que suena EXACTAMENTE como tu hermano diciendo: "Estoy atrapado en Desaguadero, me robaron todo, deposítame 2,000 Bs a esta cuenta YA". ¿Cómo verificas?',
    options: [
      'Si la voz suena igual, debe ser él. Transfiero urgente',
      'Lo llamo a su número habitual y le hago una pregunta que solo él sabría responder',
      'Le escribo por WhatsApp preguntando si es real',
      'Transfiero la mitad por si acaso',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Muy astuto! La IA puede clonar voces con solo 3 segundos de audio. La regla de oro: llama al número original y haz una pregunta personal que un deepfake no pueda responder.',
    feedbackWrong:
        '¡Deepfake de voz! La IA clona voces tomando audios de redes sociales. La voz suena igual pero no es él. Una llamada directa con pregunta de verificación es la ÚNICA forma segura.',
    lupaHint:
        'Los deepfakes de voz no pueden responder preguntas personales improvisadas tipo "¿qué me regalaste en mi cumpleaños pasado?".',
    audioPrompt: 'La IA puede clonar voces, siempre llama y haz preguntas personales',
  ),
  QuestionModel(
    id: 'n2q3',
    type: QuestionType.iaVsReal,
    question:
        'Ves una foto: "Nevada histórica cubre El Alto con 2 metros de nieve". En la imagen hay llamas gigantes caminando sobre la nieve como si nada. ¿Es real?',
    imageUrl:
        'https://images.unsplash.com/photo-1517299321609-52687d1bc55a?w=600&h=400&fit=crop',
    options: ['Es real, el clima está muy cambiante', 'Es IA, hay inconsistencias evidentes'],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Claro que es IA! Tiwula se ríe: las proporciones de las llamas vs los edificios son imposibles, y la nieve en los techos no coincide con el ángulo de la tormenta.',
    feedbackWrong:
        'Es IA. Las llamas parecen pegadas con Photoshop pero generadas por IA. Las sombras de los animales no coinciden con las de los postes de luz. El clima no produce animales gigantes.',
    lupaHint: 'Compara las sombras. Si los objetos en la misma escena tienen sombras en direcciones diferentes, es IA.',
    audioPrompt: 'Las sombras que apuntan en diferentes direcciones son señal de IA',
  ),
  QuestionModel(
    id: 'n2q4',
    type: QuestionType.sliderAnalysis,
    question:
        '"Nuevo billete de 200 Bs con el rostro de Tupac Katari". Te llega esta imagen por WhatsApp. Usa la lupa deslizante para examinar la tipografía.',
    options: ['Es un billete real', 'Es una falsificación digital / IA'],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Correcto! Las letras del "200" tienen bordes borrosos y los microtextos de seguridad son garabatos ilegibles. El Banco Central publica nuevos billetes en bcb.gob.bo, no por WhatsApp.',
    feedbackWrong:
        '¡Falso! Los billetes reales tienen microtextos nítidos y marcas de agua. La IA no sabe replicar la tipografía de seguridad. Siempre verifica en el sitio del BCB.',
    lupaHint:
        'Desliza para ver los bordes de los números. La IA deja bordes borrosos y los microtextos de seguridad son manchas sin sentido.',
    audioPrompt: 'Los billetes se verifican en bcb.gob.bo, no por WhatsApp',
  ),
  QuestionModel(
    id: 'n2q5',
    type: QuestionType.multipleChoice,
    question:
        'Circula un video del presidente anunciando un "feriado nacional extraordinario mañana". El movimiento de la boca está ligeramente desincronizado con el audio. ¿Qué sospechas?',
    options: [
      'Es real, a veces los videos en WhatsApp se ven mal por la compresión',
      'Es probablemente un deepfake. La desincronización labial y la falta de fuente oficial son señales de manipulación',
      'Si lo compartió mucha gente debe ser cierto',
      'Busco el video en TikTok para ver si está en mejor calidad',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Bien! La desincronización entre labios y audio es la huella digital del deepfake. Además, un feriado se anunciaría en Gaceta Oficial, no solo por un video viral.',
    feedbackWrong:
        '¡Deepfake! La desincronización de labios NO es por compresión, es porque la IA genera el movimiento de boca por separado del audio. Los anuncios oficiales tienen Gaceta y decreto.',
    lupaHint:
        'Pon el video en cámara lenta con el deslizador. Los deepfakes muestran parpadeos poco naturales y bordes borrosos alrededor del rostro.',
    audioPrompt: 'Si los labios no coinciden con la voz, es un deepfake',
  ),
  QuestionModel(
    id: 'n2q6',
    type: QuestionType.sliderAnalysis,
    question:
        'Foto de una marcha multitudinaria en Cochabamba. Al examinar las sombras de los manifestantes, notas que algunas van hacia la izquierda y otras hacia la derecha. Usa el deslizador.',
    options: ['Es una foto documental real', 'Es una imagen generada por IA'],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Física imposible! Tiwula explica: el sol es UNA sola fuente de luz, todas las sombras deben apuntar en la MISMA dirección. La IA no entiende física básica y dibuja sombras al azar.',
    feedbackWrong:
        '¡Las sombras lo delatan! En una foto real, todas las sombras apuntan en la misma dirección porque hay un solo sol. Si ves sombras divergentes, la IA generó diferentes partes por separado.',
    lupaHint:
        'Busca la dirección de las sombras en objetos y personas. Si apuntan a diferentes lados, la IA no respetó las leyes de la luz.',
    audioPrompt: 'El sol solo puede crear sombras en una dirección, la IA no sabe esto',
  ),
  QuestionModel(
    id: 'n2q7',
    type: QuestionType.iaVsReal,
    question:
        'Una foto viral muestra un OVNI plateado flotando sobre el Salar de Uyuni con turistas señalándolo. La imagen tiene una marca de agua de "NASA".',
    imageUrl:
        'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=600&h=400&fit=crop',
    options: ['Si la NASA la publicó es oficial', 'Es IA, la marca de agua NASA es falsa'],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Buen ojo! Tiwula dice: La NASA no pone marcas de agua en sus imágenes. Además, el reflejo del OVNI no aparece en el espejo de agua del Salar, pero los turistas SÍ.',
    feedbackWrong:
        '¡Es IA! Falla doble: la NASA no usa marcas de agua, y el OVNI no tiene reflejo en el agua aunque los turistas sí. La IA olvidó reflejar el objeto principal.',
    lupaHint:
        'Busca el reflejo del OVNI en el agua del Salar. Si no se refleja pero todo lo demás sí, es una imagen compuesta por IA.',
    audioPrompt: 'La NASA no marca sus imágenes con marca de agua, verifica la fuente',
  ),
  QuestionModel(
    id: 'n2q8',
    type: QuestionType.multipleChoice,
    question:
        'Lees una "noticia" compartida en Facebook: "EL DEBER: Científicos bolivianos descubren cura del cáncer". El texto repite frases y cambia de tema sin sentido. ¿Qué detectas?',
    options: [
      'Es una excelente noticia, la comparto de inmediato',
      'Es texto generado por IA. La repetición de frases y la incoherencia son típicas de textos automáticos no revisados',
      'Busco la noticia en la página del periódico El Deber para confirmar',
      'No es generado por IA, es mala redacción nomás',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Detectaste el patrón! Los textos generados por IA sin supervisión humana suelen repetir frases, perder el hilo y mezclar temas sin sentido. Es una granja de contenido falso.',
    feedbackWrong:
        'Es IA generando texto basura. La repetición y pérdida de coherencia es la firma de ChatGPT/IA sin edición humana. Busca en el sitio web oficial del periódico para confirmar.',
    lupaHint:
        'Lee en voz alta. Si las frases se repiten o el texto "patina" de un tema a otro sin conexión, es texto de IA no revisado.',
    audioPrompt: 'Los textos con frases repetidas y sin coherencia son generados por IA',
  ),
  QuestionModel(
    id: 'n2q9',
    type: QuestionType.sliderAnalysis,
    question:
        'Ves el perfil de una persona en Tinder/Facebook. La foto de perfil es perfecta pero el fondo tiene patrones extraños y el cabello se funde con la pared. Usa el deslizador.',
    options: ['Es una persona real con buena cámara', 'Es un retrato generado por IA'],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Correcto! Tiwula revela: los fondos con texturas repetitivas, el cabello que se mezcla con la pared y aretes asimétricos son señales de rostros generados por IA (StyleGAN, Midjourney).',
    feedbackWrong:
        '¡Es IA! Los retratos de IA tienen artefactos: aretes que no coinciden, textura de piel demasiado perfecta y el fondo se "derrite" en patrones repetitivos. Es un perfil falso.',
    lupaHint:
        'Mira los accesorios (aretes, lentes). La IA suele hacerlos asimétricos o fusionados con la piel.',
    audioPrompt: 'Los rostros de IA tienen fondos borrosos con patrones extraños',
  ),
  QuestionModel(
    id: 'n2q10',
    type: QuestionType.iaVsReal,
    question:
        'Circularon supuestos "tuits de Lionel Messi diciendo que apoya a un candidato boliviano". Pero la fuente del tuit es Times New Roman y no se ve en su perfil oficial. ¿Cómo lo verificas?',
    options: [
      'Si tiene el nombre de Messi, debe ser verdad',
      'Voy a la cuenta verificada @TeamMessi en Twitter/X y busco el tuit. Si no está, es un montaje',
      'Le pregunto a alguien que sepa de fútbol',
      'Si el tuit tiene muchos likes es real',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Bien! Inspeccionar elemento del navegador y apps de edición permiten crear tuits falsos en segundos. La verificación es simple: ¿está en la cuenta OFICIAL? Si no, es falso.',
    feedbackWrong:
        '¡Es un montaje! Cualquiera puede crear un tuit falso con "inspeccionar elemento" del navegador o apps de edición. La única prueba es que esté en la cuenta VERIFICADA de la persona.',
    lupaHint:
        'Abre Twitter/X en tu navegador y busca en el perfil oficial de la persona. Si no está ahí, es 100% falso.',
    audioPrompt: 'Siempre verifica tuits en la cuenta oficial verificada, no en capturas',
  ),
];

final List<QuestionModel> node3Questions = [
  QuestionModel(
    id: 'n3mq1',
    type: QuestionType.whatsappSimulator,
    question: 'Simulador: Suplantación de familiar pidiendo giro urgente',
    options: ['Enviar dinero sin verificar', 'Llamar al número original primero'],
    correctAnswer: 1,
    feedbackCorrect:
        'La suplantación de familiares es la estafa más común en Bolivia. Siempre verifica con una llamada.',
    feedbackWrong:
        'Los estafadores se hacen pasar por nietos/hijos. Nunca gires dinero sin verificar.',
    lupaHint:
        'Escenario 1: Suplantación de Nieto - detecta la urgencia falsa y la petición de giro.',
  ),
  QuestionModel(
    id: 'n3mq2',
    type: QuestionType.whatsappSimulator,
    question: 'Simulador: Falso soporte técnico pidiendo código de 6 dígitos',
    options: ['Compartir el código SMS', 'Reportar y bloquear el número'],
    correctAnswer: 1,
    feedbackCorrect:
        'WhatsApp NUNCA pide códigos SMS. Esos 6 dígitos permiten robar tu cuenta completa.',
    feedbackWrong:
        'Compartiste el código y ahora el estafador tiene control total de tu WhatsApp.',
    lupaHint: 'Escenario 2: Falso Soporte Técnico - WhatsApp nunca te contacta por chat.',
  ),
  QuestionModel(
    id: 'n3mq3',
    type: QuestionType.whatsappSimulator,
    question: 'Simulador: Oferta de empleo falso pidiendo tarifa de inscripción',
    options: ['Pagar la tarifa de inscripción', 'Reconocer que es estafa'],
    correctAnswer: 1,
    feedbackCorrect:
        'Ningún empleo real te cobra por adelantado. "Paga para trabajar" es siempre estafa.',
    feedbackWrong:
        'Perdiste tu dinero. Las ofertas que piden pago previo son 100% fraudulentas.',
    lupaHint: 'Escenario 3: Empleo Falso - el pago por adelantado es la señal de alerta.',
  ),
  QuestionModel(
    id: 'n3mq4',
    type: QuestionType.whatsappSimulator,
    question: 'Simulador: Falso remate de Aduana pidiendo depósito de reserva',
    options: ['Depositar la reserva', 'Verificar en gaceta oficial'],
    correctAnswer: 1,
    feedbackCorrect:
        'Los remates de Aduana requieren publicación en gaceta y proceso formal, nunca WhatsApp.',
    feedbackWrong:
        'La Aduana no hace remates por WhatsApp ni pide depósitos previos a cuentas personales.',
    lupaHint: 'Escenario 4: Remate de Aduana - verifica siempre en la gaceta oficial.',
  ),
  QuestionModel(
    id: 'n3mq5',
    type: QuestionType.whatsappSimulator,
    question: 'Simulador: Comprador falso con supuesta transferencia de más',
    options: ['Devolver la diferencia sin verificar', 'Verificar en la app del banco'],
    correctAnswer: 1,
    feedbackCorrect:
        'Siempre revisa tu propia app bancaria. Los comprobantes falsos circulan sin parar.',
    feedbackWrong:
        'El comprobante era falso. Ahora perdiste el producto y el dinero de la "devolución".',
    lupaHint: 'Escenario 5: Falso Comprador - verifica en tu app bancaria antes de devolver.',
  ),
  QuestionModel(
    id: 'n3mq6',
    type: QuestionType.whatsappSimulator,
    question: 'Simulador: Cadena de pánico en grupo de WhatsApp',
    options: ['Compartir la cadena urgente', 'Verificar fuentes oficiales primero'],
    correctAnswer: 1,
    feedbackCorrect:
        'Las cadenas que piden "compartir urgente" sin fuente son fake news diseñadas para el pánico.',
    feedbackWrong:
        'Acabas de difundir desinformación. Siempre verifica antes de compartir mensajes alarmantes.',
    lupaHint: 'Escenario 6: Cadena de Pánico - si pide compartir urgente, desconfía.',
  ),
  QuestionModel(
    id: 'n3mq7',
    type: QuestionType.whatsappSimulator,
    question: 'Simulador: Falso agente de lotería pide tarjetas de recarga',
    options: ['Comprar y enviar tarjetas de recarga', 'Reconocer la estafa y bloquear'],
    correctAnswer: 1,
    feedbackCorrect:
        'Ninguna lotería pide tarjetas de recarga para entregar premios. Es el timo más viejo.',
    feedbackWrong:
        'Las tarjetas de recarga no son moneda de premios. Perdiste ese dinero para siempre.',
    lupaHint: 'Escenario 7: Lotería Falsa - nadie pide recargas para entregar premios.',
  ),
  QuestionModel(
    id: 'n3mq8',
    type: QuestionType.whatsappSimulator,
    question: 'Simulador: Archivo .apk malicioso enviado por supuesto conocido',
    options: ['Descargar e instalar el archivo', 'No abrir archivos .apk de desconocidos'],
    correctAnswer: 1,
    feedbackCorrect:
        'Los .apk son programas que pueden robar tus datos. Fotos reales serían .jpg, no .apk.',
    feedbackWrong:
        'Instalaste malware. Los .apk son aplicaciones que roban datos bancarios y contactos.',
    lupaHint: 'Escenario 8: Archivo Malicioso - las fotos son .jpg. Los .apk son aplicaciones.',
  ),
  QuestionModel(
    id: 'n3mq9',
    type: QuestionType.whatsappSimulator,
    question: 'Simulador: Encuesta que pide contraseña de Facebook para participar',
    options: ['Ingresar la contraseña de Facebook', 'Rechazar y reportar el enlace'],
    correctAnswer: 1,
    feedbackCorrect:
        'Ninguna encuesta legítima pide contraseñas de otras redes sociales. Es phishing.',
    feedbackWrong:
        'Robaron tu cuenta de Facebook. Ahora pueden estafar a tus contactos con tu identidad.',
    lupaHint: 'Escenario 9: Phishing - las encuestas no necesitan tu contraseña de Facebook.',
  ),
  QuestionModel(
    id: 'n3mq10',
    type: QuestionType.whatsappSimulator,
    question: 'Simulador: Falso mensaje de Courier pidiendo pago de reenvío',
    options: ['Pagar con tarjeta en el enlace', 'Verificar con la oficina central'],
    correctAnswer: 1,
    feedbackCorrect:
        'Correos de Bolivia no pide pagos por WhatsApp. Siempre verifica por canales oficiales.',
    feedbackWrong:
        'Era phishing. Robaron los datos de tu tarjeta de crédito en esa página falsa.',
    lupaHint: 'Escenario 10: Courier Falso - los servicios postales no cobran por WhatsApp.',
  ),
];

final List<QuestionModel> node4Questions = [
  QuestionModel(
    id: 'n4q1',
    type: QuestionType.multipleChoice,
    question:
        'Recibes un mensaje: "ALERTA MÁXIMA: Mañana no habrá agua en todo el país por 5 días. Llena todos tus baldes YA". No tiene fuente ni fecha. ¿Cómo actúas?',
    options: [
      'Lleno todos mis baldes y aviso a mis vecinos urgente',
      'Busco la noticia en medios oficiales como EPSAS o la alcaldía. Si no hay comunicado, es fake',
      'Comparto la cadena para prevenir a todos',
      'Creo que si me llegó por WhatsApp debe ser cierto',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Bien! Las noticias alarmantes sin fuente, fecha ni datos oficiales son fake news diseñadas para crear pánico. EPSAS y alcaldías publican cortes programados en sus páginas.',
    feedbackWrong:
        '¡Caíste en fake news! No hay fuente, fecha ni entidad que firme el mensaje. Las alertas reales vienen firmadas por instituciones con canales de comunicación oficiales.',
    lupaHint:
        'Busca: ¿Quién lo dice? ¿Cuándo? ¿Dónde está publicado oficialmente? Si no puedes responder las 3, es falso.',
    audioPrompt: 'Las noticias sin fuente ni fecha son desinformación, verifica siempre',
  ),
  QuestionModel(
    id: 'n4q2',
    type: QuestionType.multipleChoice,
    question:
        'Un audio de WhatsApp dice: "ESTÁN SAQUEANDO EL SUPERMERCADO DEL BARRIO. Manden a sus hijos a la escuela con cuidado". No se oye nada de fondo, ni sirenas ni ruido. ¿Qué falla?',
    options: [
      'Nada, el audio es prueba suficiente',
      'Falta evidencia contextual: no se oye ningún ruido de fondo de un supuesto saqueo activo. Sin sirenas ni gente, es un audio falso para generar pánico',
      'La persona suena asustada, debe ser real',
      'Si fue reenviado muchas veces es verdad',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Oído de Tiwula! Un saqueo real tendría ruido de fondo: gritos, sirenas, vidrios. El silencio total en el audio indica que es una grabación en un cuarto cerrado, no en la calle.',
    feedbackWrong:
        'Es un audio falso. Si estuviera ocurriendo un saqueo real, se oiría caos de fondo. Este audio fue grabado en silencio para manipular emociones.',
    lupaHint:
        'Escucha con atención: ¿hay ruido ambiente acorde a lo que dice? Un motín tiene sirenas, no silencio.',
    audioPrompt: 'Los audios de pánico sin ruido de fondo son fabricados',
  ),
  QuestionModel(
    id: 'n4q3',
    type: QuestionType.iaVsReal,
    question:
        'Te comparten una noticia del periódico "Los Tiempos" del 2019 sobre protestas, presentada como si fuera de hoy. ¿Qué tipo de manipulación es?',
    imageUrl:
        'https://images.unsplash.com/photo-1504711434969-e33886168d6c?w=600&h=400&fit=crop',
    options: [
      'Es noticia actual, el periódico la acaba de publicar',
      'Descontextualización: usar contenido antiguo fuera de su contexto temporal para generar indignación en el presente',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Correcto! Es descontextualización temporal. Reciclar noticias viejas para que parezcan actuales es una táctica clásica de desinformación para avivar conflictos.',
    feedbackWrong:
        'Es descontextualización. Las noticias de 2019 no reflejan la realidad de hoy. Siempre revisa la fecha de publicación original, no la del reenvío.',
    lupaHint:
        'Busca la nota original en Google con la fecha. Si es de hace años, no compartas como si fuera actual.',
    audioPrompt: 'Revisa siempre la fecha original de las noticias virales',
  ),
  QuestionModel(
    id: 'n4q4',
    type: QuestionType.multipleChoice,
    question:
        'Circula una foto de "represión policial en Santa Cruz" con gente corriendo. Pero en Google Lens aparece que la foto es de una protesta en Santiago de Chile de 2019. ¿Qué técnica es?',
    options: [
      'Las fotos pueden ser similares, da igual el país',
      'Atribución falsa de locación: usar una imagen de otro país/contexto y hacerla pasar por local',
      'Debe ser un error del buscador de imágenes',
      'Si muchas páginas bolivianas la publicaron, debe ser real',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Bien! Es la técnica de "falsa locación": agarrar una imagen impactante de otro país y atribuirla a Bolivia para manipular emociones. Siempre verifica con búsqueda inversa de imágenes.',
    feedbackWrong:
        'Es manipulación por falsa locación. Google Lens y la búsqueda inversa de imágenes te muestran la fuente real. La foto nunca fue tomada en Bolivia.',
    lupaHint:
        'Haz búsqueda inversa en Google Images. Si la foto aparece en noticias de otro país con otro contexto, es manipulación.',
    audioPrompt: 'Verifica fotos con búsqueda inversa en Google Images',
  ),
  QuestionModel(
    id: 'n4q5',
    type: QuestionType.multipleChoice,
    question:
        'Cadena de WhatsApp: "Toma agua con limón y bicarbonato en ayunas. CURA el cáncer, diabetes y COVID en 3 días. Doctores lo OCULTAN". ¿Cómo identificas esta desinformación de salud?',
    options: [
      'Voy a comprar limones y bicarbonato ahora mismo',
      'Falsa cura milagrosa: ningún remedio casero cura enfermedades complejas. La frase "doctores lo ocultan" es el sello de la charlatanería',
      'Lo consulto con el doctor de WhatsApp',
      'Si muchas personas lo comparten, algo de razón tendrá',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Muy bien! "Curas milagrosas" + "los doctores lo ocultan" + "cura todo en 3 días" = pseudociencia peligrosa. La salud se trata con profesionales médicos, no con cadenas.',
    feedbackWrong:
        '¡Es charlatanería peligrosa! El bicarbonato con limón no cura el cáncer. La frase "los médicos lo ocultan" es una táctica conspirativa para vender remedios falsos. Consulta SIEMPRE a un médico.',
    lupaHint:
        'Busca en Google "bicarbonato cáncer OMS". Organizaciones de salud serias desmienten estos mitos.',
    audioPrompt: 'Ningún remedio casero cura el cáncer, consulta siempre a un médico',
  ),
  QuestionModel(
    id: 'n4q6',
    type: QuestionType.sliderAnalysis,
    question:
        'Una gráfica con el logo de "Página Siete" muestra datos de intención de voto. Pero el logo está pixelado y hay errores ortográficos. Usa el deslizador para comparar.',
    options: ['Es una publicación oficial del periódico', 'Es un gráfico falso'],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Buen ojo! Los medios serios no publican gráficas con errores ortográficos ni logos pixelados. Es una suplantación de identidad del periódico para dar falsa credibilidad.',
    feedbackWrong:
        '¡Es falso! Los periódicos reales tienen diseñadores profesionales. Errores ortográficos y logos borrosos indican que alguien falsificó la gráfica. Busca en el sitio oficial.',
    lupaHint:
        'Abre el sitio web oficial del periódico y busca la noticia. Si no está publicada ahí, es un montaje.',
    audioPrompt: 'Las gráficas con errores y logos pixelados son falsificaciones',
  ),
  QuestionModel(
    id: 'n4q7',
    type: QuestionType.iaVsReal,
    question:
        'Recibes un "comunicado oficial del Ministerio de Salud" sin sello, sin firma del ministro, sin número de resolución y escrito en Word con Arial. ¿Es válido?',
    imageUrl:
        'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=600&h=400&fit=crop',
    options: ['Si dice Ministerio de Salud es oficial', 'No, carece de elementos de autenticidad'],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Exacto! Comunicados oficiales llevan: sello institucional, firma del titular, número de resolución ministerial y formato estándar. Sin estos elementos, es apócrifo.',
    feedbackWrong:
        'Es falso. Un comunicado oficial SIEMPRE tiene: sello de la institución, firma de la autoridad, número de resolución y formato oficial. Un Word con Arial no es documento público.',
    lupaHint:
        'Busca sello redondo, firma manuscrita escaneada, y número de resolución. Los comunicados falsos son documentos de Word genéricos.',
    audioPrompt: 'Los documentos oficiales llevan sello, firma y número de resolución',
  ),
  QuestionModel(
    id: 'n4q8',
    type: QuestionType.multipleChoice,
    question:
        'Noticia: "Bad Bunny dará concierto GRATIS en El Alto este sábado". La fuente: "personas cercanas al artista no reveladas". ¿Por qué es sospechoso?',
    options: [
      'Bad Bunny ha dado conciertos gratis antes',
      'Fuentes "no reveladas" sin confirmación oficial son la base de toda noticia falsa. Un concierto sale en la web oficial del artista',
      'Si el lugar del concierto es conocido es verdad',
      'Lo leí en un grupo de WhatsApp con miles de personas',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Bien! "Fuentes no reveladas" = nadie puede verificar nada. Artistas internacionales anuncian giras en sus páginas web oficiales y Ticketing, no por cadenas de WhatsApp.',
    feedbackWrong:
        '"Fuentes no reveladas" es código para "inventé esto". Bad Bunny anuncia conciertos en badbunny.com y boleterías oficiales. Si no está ahí, es falso.',
    lupaHint:
        'Busca en Google: "Bad Bunny gira 2026". Si no hay noticias de medios grandes, es falso.',
    audioPrompt: 'Fuentes no reveladas sin confirmación son señal de noticia falsa',
  ),
  QuestionModel(
    id: 'n4q9',
    type: QuestionType.multipleChoice,
    question:
        'Circula una encuesta: "El 95% de bolivianos aprueba esta ley". No menciona cuántas personas fueron encuestadas, dónde, cuándo ni margen de error. ¿Es creíble?',
    options: [
      '95% es un número alto, debe ser verdad',
      'No. Una encuesta sin ficha técnica (muestra, lugar, fecha, margen de error) es propaganda, no investigación',
      'Si el medio que la publica es conocido, es real',
      'Pregunto en los comentarios a ver qué dice la gente',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Correcto! Toda encuesta seria publica: quién la hizo, tamaño de muestra, metodología, fecha y margen de error (±3%). Sin estos datos, el número es inventado.',
    feedbackWrong:
        'Es propaganda disfrazada de encuesta. Sin ficha técnica el porcentaje es inventado. Encuesta real responde: ¿Cuántos?, ¿Dónde?, ¿Cuándo?, ¿Margen de error?',
    lupaHint:
        'Busca en la imagen: ¿dice cuántas personas respondieron? ¿Tiene margen de error? Si no, es falso.',
    audioPrompt: 'Las encuestas serias publican método, muestra y margen de error',
  ),
  QuestionModel(
    id: 'n4q10',
    type: QuestionType.multipleChoice,
    question:
        'Publicación viral: "ESTA PERSONA es un peligro. DIFUNDE antes de que lo BORREN". Señala a alguien con nombre y foto, incita al odio y no muestra evidencia de lo que acusa. ¿Cómo respondes?',
    options: [
      'Lo comparto rápido antes de que lo borren',
      'NO comparto. Es incitación al odio. La frase "difunde antes de que lo borren" es la marca de una campaña de linchamiento digital sin pruebas',
      'Comento "qué mal" para que se haga justicia',
      'Guardo la foto por si acaso',
    ],
    correctAnswer: 1,
    feedbackCorrect:
        '¡Eres un Guardián Digital! Las campañas de odio usan la urgencia falsa ("difunde antes de que lo borren") para viralizar acusaciones sin pruebas. Reporta y no compartas.',
    feedbackWrong:
        'Caíste en una campaña de linchamiento digital. Sin pruebas, sin fuente verificable y con urgencia forzada, es manipulación de odio. Reporta el contenido a la plataforma.',
    lupaHint:
        'Pregúntate: ¿Hay pruebas? ¿Fuente verificable? ¿O solo pide "compartir urgente" con emociones?',
    audioPrompt: 'Las publicaciones que incitan odio se reportan, no se comparten',
  ),
];
