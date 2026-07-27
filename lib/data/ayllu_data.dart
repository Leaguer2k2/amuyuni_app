import '../models/models.dart';

const List<Map<String, dynamic>> aylluChallenges = [
  {
    'id': 'ch1',
    'title': 'Verificar destinatario en pago QR',
    'description':
        'Enséñale a un adulto mayor a verificar el nombre del destinatario antes de escanear cualquier código QR de pago.',
    'role': 'Nieto-Abuelo',
    'rewardPoints': 50,
  },
  {
    'id': 'ch2',
    'title': 'Activar verificación en 2 pasos',
    'description':
        'Ayuda a tus padres o abuelos a configurar la verificación en dos pasos en WhatsApp.',
    'role': 'Familiar',
    'rewardPoints': 50,
  },
  {
    'id': 'ch3',
    'title': 'Identificar comprobante falso',
    'description':
        'Muéstrale a un comerciante del mercado cómo identificar un comprobante de pago falso.',
    'role': 'Comerciante',
    'rewardPoints': 50,
  },
  {
    'id': 'ch4',
    'title': 'Detectar enlaces maliciosos',
    'description':
        'Enséñale a un familiar a NO hacer clic en enlaces sospechosos de WhatsApp sin verificar la fuente.',
    'role': 'Familiar',
    'rewardPoints': 50,
  },
  {
    'id': 'ch5',
    'title': 'Reportar número sospechoso',
    'description':
        'Ayuda a alguien de tu comunidad a reportar y bloquear un número sospechoso en WhatsApp.',
    'role': 'Comerciante',
    'rewardPoints': 50,
  },
];

const List<Map<String, dynamic>> defaultBadges = [
  {
    'id': 'guardian_digital',
    'name': 'Guardián Digital',
    'description': 'Completa todos los nodos de aprendizaje',
    'icon': '🛡️',
    'progressTotal': 4,
  },
  {
    'id': 'ojo_tiwula',
    'name': 'Ojo de Tiwula',
    'description': 'Responde correctamente 20 preguntas',
    'icon': '🦊',
    'progressTotal': 20,
  },
  {
    'id': 'maestro_radar',
    'name': 'Maestro del Radar',
    'description': 'Contribuye a 10,000 verificaciones comunitarias',
    'icon': '📡',
    'progressTotal': 10,
  },
  {
    'id': 'ayllu_protector',
    'name': 'Ayllu Protector',
    'description': 'Completa 5 misiones intergeneracionales',
    'icon': '👨‍👩‍👧',
    'progressTotal': 5,
  },
];

const List<String> defaultTestimonials = [
  '🦊 Doña Martha aprendió a verificar enlaces hoy en el mercado de La Paz.',
  '🦊 Carlos protegió el WhatsApp de su abuelo activando la verificación en 2 pasos.',
  '🦊 La familia Quispe capacitó a todo su barrio sobre QR falsos en El Alto.',
  '🦊 Juan detectó una estafa de "Bono 500 Bs" y evitó que 5 vecinos cayeran.',
  '🦊 María enseñó a su casera a identificar un comprobante de pago falso.',
];

const List<WhatsAppScenario> whatsAppScenarios = [
  WhatsAppScenario(
    id: 'ws1',
    title: 'Suplantación de Nieto',
    scammerName: '📵 +591 67890123',
    initialMessage:
        'Hola abuelita/o, soy tu nieto. Tuve un accidente y cambié de número. Necesito que me hagas un giro urgente de 500 Bs al Tigo Money de un amigo que me está ayudando.',
    optionAText: '😰 Claro hijito, voy al agente ahora mismo a girarte',
    optionBText: '🛡️ Déjame llamarte a tu número de siempre primero para confirmar',
    feedbackA:
        '¡Cuidado! Los estafadores se hacen pasar por familiares. NUNCA envíes dinero sin verificar llamando al número que ya conoces.',
    feedbackB:
        '¡Excelente! Siempre verifica llamando al número original de tu familiar. Esta es una de las estafas más comunes.',
  ),
  WhatsAppScenario(
    id: 'ws2',
    title: 'Falso Soporte Técnico de WhatsApp',
    scammerName: '📵 WhatsApp-Soporte',
    initialMessage:
        'Hola, somos el equipo de soporte de WhatsApp. Detectamos actividad sospechosa en tu cuenta. Para verificar tu identidad, envíanos el código de 6 dígitos que te llegó por SMS.',
    optionAText: '📱 Ok, el código es: 482391',
    optionBText: '🛡️ No comparto códigos. Bloquearé y reportaré este número.',
    feedbackA:
        '¡Alerta! WhatsApp NUNCA te pedirá códigos SMS. Esos 6 dígitos permiten que roben tu cuenta. Ahora el estafador tiene acceso a tus chats y contactos.',
    feedbackB:
        '¡Bien hecho! WhatsApp nunca te contacta por chat para pedir códigos. Protegiste tu cuenta y la de tus contactos.',
  ),
  WhatsAppScenario(
    id: 'ws3',
    title: 'Oferta de Empleo Falsa',
    scammerName: '📵 +591 71234567',
    initialMessage:
        '¡Oportunidad laboral! Gana 500 Bs al día dando "me gusta" en TikTok. Solo necesitas pagar una tarifa de inscripción de 100 Bs para activar tu cuenta. Trabajo 100% remoto.',
    optionAText: '💰 ¡Qué buena oferta! ¿A qué cuenta transfiero los 100 Bs?',
    optionBText:
        '🛡️ Ningún trabajo serio te pide pagar por adelantado. Esto es una estafa.',
    feedbackA:
        '¡Caíste! Las ofertas de empleo que piden dinero por adelantado son SIEMPRE estafas. Perdiste 100 Bs y ellos desaparecerán.',
    feedbackB:
        '¡Correcto! "Paga para trabajar" es la frase de alerta roja. Ningún empleo legítimo te cobra por contratarte.',
  ),
  WhatsAppScenario(
    id: 'ws4',
    title: 'Remate Falso de Aduana',
    scammerName: '📵 Remates-Aduana-Bol',
    initialMessage:
        'Remate de Aduana Nacional: vehículos incautados desde \$500 USD, laptops desde \$50. Deposite 300 Bs de reserva a la cuenta 1000-xxxx para separar su lote.',
    optionAText: '🚗 ¡Quiero uno! Ya mismo deposito los 300 Bs',
    optionBText:
        '🛡️ Esto es falso. La Aduana publica remates solo en su página oficial con GACETA.',
    feedbackA:
        '¡Es una estafa! La Aduana Nacional publica sus remates con aviso público en gaceta y medios oficiales, nunca por WhatsApp ni pide depósitos previos.',
    feedbackB:
        '¡Muy astuto! Los remates de Aduana requieren procesos formales con publicación en gaceta oficial, no se hacen por WhatsApp.',
  ),
  WhatsAppScenario(
    id: 'ws5',
    title: 'Falso Comprador de Marketplace',
    scammerName: '📵 +591 72345678',
    initialMessage:
        'Hola, me interesa el producto que vendes en Facebook. Te transfiero el dinero ahora. Por error te transferí 500 Bs de más. ¿Puedes devolverme la diferencia antes de que revise mi banco?',
    optionAText: '💸 Claro, te devuelvo los 500 Bs ahora mismo. Dame tu QR.',
    optionBText: '🛡️ Primero reviso en mi app del banco si realmente recibí el pago.',
    feedbackA:
        '¡Estafa! Te enviaron un comprobante falso. Nunca devuelvas dinero sin verificar en tu propia app bancaria que la transferencia es real.',
    feedbackB:
        '¡Perfecto! Siempre verifica en tu app bancaria antes de hacer cualquier devolución. El comprobante que te enviaron era falso.',
  ),
  WhatsAppScenario(
    id: 'ws6',
    title: 'Cadena de Pánico en Grupo',
    scammerName: '📵 Vecinos-Alerta (Grupo)',
    initialMessage:
        'URGENTE: Están robando niños en la zona Sur. Comparte este mensaje con todos tus contactos. La policía ya lo confirmó. ¡Pásalo antes de que sea tarde!',
    optionAText: '😱 ¡Dios mío! Lo comparto con todos mis grupos ahora mismo',
    optionBText:
        '🛡️ Esto parece una cadena de pánico. Voy a verificar con fuentes oficiales primero.',
    feedbackA:
        'Acabas de difundir desinformación. Las cadenas de pánico sin fuente ni fecha son fake news diseñadas para viralizarse con miedo.',
    feedbackB:
        '¡Bien! Las cadenas que piden "compartir urgente" sin fuente oficial son desinformación. Siempre verifica con la policía o medios oficiales.',
  ),
  WhatsAppScenario(
    id: 'ws7',
    title: 'Falso Agente de Lotería',
    scammerName: '📵 Lotería-Nacional-Bol',
    initialMessage:
        '¡Felicitaciones! Su número fue seleccionado para el premio mayor de Lotería Nacional. Para reclamar sus 50,000 Bs, necesita enviar 5 tarjetas de recarga Entel de 100 Bs cada una para "activar el proceso".',
    optionAText: '🎉 ¡Gané! Ahora mismo compro las tarjetas y le envío los códigos',
    optionBText:
        '🛡️ La Lotería nunca pide tarjetas de recarga para entregar premios. Es una estafa.',
    feedbackA:
        '¡Es un clásico fraude! Ninguna lotería legítima te pide comprar tarjetas de recarga. Perdiste 500 Bs.',
    feedbackB:
        '¡Correcto! La Lotería Nacional nunca pide tarjetas de recarga ni pagos para entregar premios. Es una estafa muy común en Bolivia.',
  ),
  WhatsAppScenario(
    id: 'ws8',
    title: 'Archivo Adjunto Malicioso',
    scammerName: '📵 +591 73456789',
    initialMessage:
        'Mira las fotos del evento de ayer jaja 😂 Ver_fotos_evento.apk',
    optionAText: '📎 Descargo el archivo para ver las fotos',
    optionBText: '🛡️ No abro archivos .apk de desconocidos. Puede ser un virus.',
    feedbackA:
        '¡Peligro! Los archivos .apk son aplicaciones que pueden robar tus datos bancarios, contactos y fotos. NUNCA instales APKs de fuentes desconocidas.',
    feedbackB:
        '¡Muy bien! Los archivos .apk de desconocidos son la principal vía de robo de datos en Bolivia. Si fuera una foto, sería .jpg, no .apk.',
  ),
  WhatsAppScenario(
    id: 'ws9',
    title: 'Encuesta Política Fraudulenta',
    scammerName: '📵 Encuestas-Bolivia',
    initialMessage:
        'Encuesta política anónima: ¿Apoyas al gobierno actual? Responde aquí: https://bit.ly/encuesta-bol y GANA 100 Bs. Necesitas ingresar con tu contraseña de Facebook para validar tu voto.',
    optionAText: '📋 Entro a la encuesta y pongo mi contraseña de Facebook',
    optionBText: '🛡️ Ninguna encuesta debería pedir mi contraseña de otra red social.',
    feedbackA:
        '¡Robaron tu cuenta! Ese enlace era phishing. Ahora los estafadores tienen acceso a tu Facebook y pueden estafar a tus contactos haciéndose pasar por ti.',
    feedbackB:
        '¡Excelente! Una encuesta legítima JAMÁS te pedirá la contraseña de tu red social. Es phishing para robar identidades.',
  ),
  WhatsAppScenario(
    id: 'ws10',
    title: 'Falso Paquete de Courier',
    scammerName: '📵 Correos-Bolivia',
    initialMessage:
        'Correos de Bolivia: Su paquete no pudo ser entregado por falta de información. Para reprogramar el envío, pague 10 Bs de gestión en este enlace: https://bit.ly/correo-pago',
    optionAText: '📦 Entro al enlace y pago los 10 Bs con mi tarjeta',
    optionBText:
        '🛡️ Correos de Bolivia no pide pagos por WhatsApp. Llamaré a la oficina central.',
    feedbackA:
        '¡Phishing bancario! Esa página falsa robó los datos de tu tarjeta. Los 10 Bs eran solo la carnada para obtener tu información bancaria completa.',
    feedbackB:
        '¡Perfecto! Correos de Bolivia notifica entregas por aviso físico o su sitio oficial, nunca te cobra por WhatsApp o SMS.',
  ),
];
