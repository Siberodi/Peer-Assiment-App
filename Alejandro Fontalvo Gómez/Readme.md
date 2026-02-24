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
<img width="1166" height="716" alt="Captura de pantalla 2026-02-24 a la(s) 12 08 59 p m" src="https://github.com/user-attachments/assets/fdbc317b-4f39-4319-ad0e-60807094cd60" />

Desde una perspectiva investigativa, Deel Engage puede considerarse un referente pertinente para el desarrollo del presente proyecto, aun cuando su contexto principal sea la gestión de recursos humanos en entornos empresariales. La plataforma ofrece un proceso de evaluación estructurado que permite recopilar retroalimentación tanto cuantitativa como cualitativa, configurable según criterios definidos por la organización, lo cual guarda una relación directa con la propuesta de implementar una rúbrica para evaluar el desempeño de estudiantes dentro de actividades colaborativas. 

Asimismo, Deel Engage incorpora evaluaciones entre pares (peer reviews), posibilitando que los colaboradores realicen comentarios y valoraciones sobre el desempeño de sus colegas, elemento que coincide conceptualmente con la dinámica de evaluación entre compañeros planteada en la aplicación académica. Adicionalmente, el sistema integra herramientas de análisis y visualización de resultados mediante métricas y reportes agregados, lo que puede servir como referencia para diseñar en Flutter módulos de consulta de promedios por criterio, por grupo y por estudiante. Otro aspecto relevante es la personalización de ciclos de evaluación, incluyendo la definición de ventanas de tiempo, criterios específicos y niveles de anonimato, características que pueden adaptarse al contexto educativo para fortalecer la objetividad y organización del proceso evaluativo.

![corubrics](https://github.com/user-attachments/assets/9bf977f2-8445-4b06-96da-ca916ddbbe20)
CoRubrics es una solución ya existente, fácil de implementar y gratuita que funciona como lo dice dentro de su manual de uso como: 

“Un complemento para hojas de cálculo de Google que permite realizar un proceso completo de evaluación con rúbricas. Sirve para que el profesor evalúe a los alumnos (o grupos de alumnos) con una rúbrica y también para que los alumnos se coevaluen entre ellos con una rúbrica. Sólo se puede utilizar si alumnos y profesores están en el mismo dominio de G suite.

Primero habrá que definir la rúbrica que queremos utilizar y, luego, indicar los alumnos y sus correo electrónicos. Una vez hecho, el complemento (o la plantilla) se encargará de:

- Crear un formulario con los contenidos de la Rúbrica.
- Enviar por mail este formulario a los alumnos o darnos el enlace (si sólo corrige el profesor).
- Una vez contestado el formulario (por los alumnos o por el profesor), procesar los datos para obtener las medias.
- Finalmente, enviar los resultados a los alumnos (cada uno sólo recibe su resultado) con un comentario personalizado.
<img width="1062" height="467" alt="Captura de pantalla 2026-02-24 a la(s) 12 21 40 p m" src="https://github.com/user-attachments/assets/4ca232bd-f7f5-449a-8e5b-b83c1d06aa8c" />
<img width="1066" height="506" alt="Captura de pantalla 2026-02-24 a la(s) 12 22 14 p m" src="https://github.com/user-attachments/assets/e16af9bc-f322-414f-acfa-30c99162dc15" />
<img width="1128" height="477" alt="Captura de pantalla 2026-02-24 a la(s) 12 22 59 p m" src="https://github.com/user-attachments/assets/c18741de-f729-458e-8195-fa7e110f41b5" />
<img width="1031" height="478" alt="Captura de pantalla 2026-02-24 a la(s) 12 23 31 p m" src="https://github.com/user-attachments/assets/d52d8e46-4a7b-4273-bbb2-3ec79f3d9a1b" />

Además, CoRubrics permite:
- Hacer comentarios cuando se contesta la rúbrica.
- Permitir Coevaluación, Autoevaluación y la evaluación del profesor en un solo CoRubrics.”

CoRubrics puede considerarse un referente altamente pertinente para el desarrollo del proyecto, ya que se trata de una solución existente específicamente diseñada para procesos de evaluación con rúbricas en contextos educativos. En primer lugar, evidencia la importancia de estructurar la evaluación a partir de criterios claros previamente definidos, aspecto central en la aplicación propuesta. En segundo lugar, integra en una sola solución la evaluación del docente, la coevaluación entre estudiantes e incluso la autoevaluación, lo cual demuestra la viabilidad de gestionar múltiples tipos de evaluación dentro de una misma plataforma. Asimismo, su capacidad para generar automáticamente formularios, recopilar respuestas, procesar datos y calcular promedios se relaciona con la necesidad de implementar en la aplicación un módulo que no solo recoja valoraciones, sino que también analice y visualice resultados de manera organizada.

Aunque CoRubrics depende del ecosistema de Google y funciona como complemento de hojas de cálculo, su lógica estructural puede trasladarse a una aplicación móvil independiente desarrollada en Flutter, permitiendo mayor flexibilidad en cuanto a roles diferenciados (docente y estudiante), configuración de visibilidad de resultados, control de ventanas de tiempo y acceso a métricas agregadas por grupo o actividad.





