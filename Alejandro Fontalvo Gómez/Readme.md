# Proyecto Flutter - Aplicación de Evaluación entre Pares  
Elaborado por: Alejandro Fontalvo Gómez  

El presente proyecto tiene como finalidad el desarrollo de una aplicación móvil utilizando Flutter, orientada a facilitar la evaluación entre compañeros dentro de cursos académicos dirigidos por docentes. La problemática que se aborda surge de la necesidad de contar con una herramienta digital estructurada, clara y confiable que permita valorar el desempeño, compromiso y actitud de los estudiantes en actividades colaborativas, a partir de una rúbrica previamente establecida.

La aplicación estará diseñada contemplando dos roles principales: el rol de docente y el rol de estudiante. El docente será quien gestione los cursos, active evaluaciones y consulte los resultados obtenidos, mientras que el estudiante participará evaluando a sus compañeros dentro de los grupos previamente conformados en Brightspace e importados a la aplicación. Es importante resaltar que el sistema no permitirá la autoevaluación, garantizando así mayor objetividad en el proceso.

El proyecto consistirá en la implementación de una solución que permita activar evaluaciones dentro de una materia específica, establecer ventanas de tiempo para su diligenciamiento, definir la visibilidad de los resultados (pública o privada) y generar métricas detalladas como promedios por actividad, por grupo y por estudiante. Todo esto se desarrollará siguiendo principios de arquitectura limpia y buenas prácticas de desarrollo móvil.

Adicionalmente, como parte del proceso académico y con el fin de fortalecer el análisis y la propuesta integral del grupo, se incluirá en este archivo **README.md** el contenido de la propuesta individual de aplicación. Este documento incluirá:
- Al menos tres referentes (aplicaciones, plataformas o soluciones existentes relacionadas con la problemática).
- La composición y diseño de la solución propuesta, especificando la arquitectura seleccionada y su justificación (por ejemplo: una sola aplicación para ambos roles, aplicaciones separadas, integración con plataforma web, entre otras alternativas).
- Una descripción detallada del flujo funcional completo, desde la conformación del trabajo en equipo hasta la evaluación y visualización de resultados.
- La justificación de la propuesta basada en el análisis de los referentes y en entrevistas realizadas a docentes que implementen trabajos colaborativos.
- El enlace al prototipo desarrollado en Figma, acompañado de capturas de pantalla integradas dentro del README.md.
- Cualquier otro elemento que permita fortalecer la argumentación y claridad de la solución planteada.

1. Tres referentes (aplicaciones, plataformas o soluciones existentes relacionadas con la problemática).
<img width="313" height="161" alt="images (1)" src="https://github.com/user-attachments/assets/ee9816f3-6234-403b-a177-4b40ef316a06" />

Deel es una empresa tecnológica fundada en 2019 que ofrece soluciones integrales de recursos humanos enfocadas en la gestión de equipos globales y trabajo remoto. Su modelo de negocio se basa en proveer una plataforma SaaS (Software as a Service) que permite a las organizaciones contratar, pagar y administrar empleados y contratistas en más de 150 países, asegurando el cumplimiento de normativas laborales y fiscales locales (Deel, s. f.-a). La compañía ha experimentado un crecimiento acelerado en el mercado internacional, posicionándose como una de las soluciones más relevantes en el ámbito de la gestión global del talento, especialmente en un contexto donde el trabajo distribuido y remoto se ha vuelto una práctica común en múltiples industrias (Deel, s. f.-a).

La plataforma de **Deel** integra distintos módulos que abarcan todo el ciclo de vida del trabajador, desde la contratación hasta la gestión de nómina, beneficios y cumplimiento normativo. Entre sus principales funcionalidades se encuentra la automatización de pagos internacionales, la administración de contratos conforme a la legislación de cada país y la centralización de información del personal mediante un sistema de gestión de recursos humanos (HRIS) (Deel, s. f.-a). 

Dentro de su ecosistema de soluciones, uno de los componentes más relevantes es Deel Engage, una herramienta orientada a la gestión del desempeño y desarrollo del talento. Este módulo permite a las organizaciones diseñar ciclos de evaluación estructurados, personalizar criterios de valoración y recopilar retroalimentación desde diferentes perspectivas, incluyendo evaluaciones entre pares y evaluaciones 360° (Deel, s. f.-b). Además, facilita la alineación de las evaluaciones con objetivos estratégicos, como los OKR (Objectives and Key Results), permitiendo medir el rendimiento de manera cuantitativa y cualitativa (Deel, s. f.-b). Estas características evidencian un enfoque sistemático en la medición del desempeño, basado en criterios claros, ventanas de evaluación definidas y análisis posterior de resultados.

<img width="1512" height="742" alt="Captura de pantalla 2026-02-24 a la(s) 12 04 00 p m" src="https://github.com/user-attachments/assets/392a522e-57c0-4ed2-a1a7-039e39a48cf9" />

En sus canales oficiales, detallan que “el software de evaluación de desempeño de Deel ofrece un conjunto completo de herramientas diseñadas para agilizar las evaluaciones de desempeño y el intercambio de opiniones. Funciones clave incluyen:
- Recogida de comentarios de varios evaluadores de gerentes, colegas, subordinados directos y de las propias personas (con autoevaluaciones)
- Creador personalizado de formularios de evaluación de rendimiento con calificaciones y preguntas abiertas
- Preguntas ponderadas y tipos de retroalimentación ponderada para cálculos personalizados
- Configuración de anonimato
- La opción de vincular modelos de competencias y objetivos para revisar preguntas 
- Retroalimentación continua
- Paso de calibración de rendimiento
- Análisis de retroalimentación (9-box, mapas de calor de habilidades, gráficos de radar de competencias).

El software también admite comentarios de 360 grados para evaluaciones exhaustivas del equipo de múltiples fuentes.” (Deel, s. f.-a).

De igual manera, definen en su canal que: “Un proceso de implementación y puesta en marcha de una evaluación de desempeño que puede durar hasta cuatro semanas, dependiendo de varios aspectos, como el sistema de rendimiento existente, el número de miembros del equipo incorporados y las necesidades de formación.

Los pasos son:
1. Reúnete con las partes interesadas para evaluar el status quo, revisar los requisitos y alinearse con la fecha deseada de "puesta en marcha"
2. Diseña y crea el proceso de evaluación de desempeño (preguntas, evaluadores a incluir, cronograma, etc.) 
3. Define un plan para comunicar el despliegue a empleados y directivos
4. Capacitar a gerentes y miembros del equipo
5. Integra a los miembros de tu equipo a la plataforma
6. Inicia la revisión
7. Imparte capacitación adicional para gerentes para interpretar y compartir los resultados” (Deel, s. f.-a). 

2. 

