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

# Tres referentes (aplicaciones, plataformas o soluciones existentes relacionadas con la problemática).
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

<img width="373" height="135" alt="images (2)" src="https://github.com/user-attachments/assets/3e5882b6-7dd6-4b67-b271-7af919380506" />

Teamflect es una plataforma de gestión del desempeño y compromiso de equipos, diseñada para integrarse directamente con Microsoft Teams y Outlook, que facilita a las organizaciones establecer objetivos, realizar revisiones de desempeño, recopilar retroalimentación continua y mejorar el rendimiento de los empleados (Teamflect, s. f.). La solución ofrece herramientas como evaluación de desempeño estructurada, establecimiento y seguimiento de metas (incluyendo OKR), reuniones uno-a-uno, encuestas de compromiso, retroalimentación 360° y reconocimiento entre pares, todo dentro del flujo de trabajo habitual, sin necesidad de cambiar de aplicación (Teamflect, s. f.; Capterra, 2026)
<img width="1262" height="554" alt="Captura de pantalla 2026-02-24 a la(s) 12 27 15 p m" src="https://github.com/user-attachments/assets/f073fc81-0627-48e7-b273-49991edc6d9e" />

Este referente es pertinente para el proyecto porque, aunque su aplicación principal es corporativa, incorpora conceptos clave de evaluación estructurada y retroalimentación entre pares que se alinean con lo que se busca implementar en una aplicación académica. Teamflect permite definir plantillas de revisión personalizables, coordinar ciclos de evaluación y obtener informes de resultados, lo cual es metodológicamente similar a los requerimientos de una aplicación de evaluación entre estudiantes, donde también debe configurarse una rúbrica, habilitarse una ventana de evaluación y consolidarse resultados cuantitativos y cualitativos. Por lo tanto, la estructura funcional de Teamflect, especialmente en lo referente a revisiones de desempeño, retroalimentación de colegas y análisis de resultados, puede inspirar el diseño de los módulos de evaluación en la aplicación propuesta, adaptando estos elementos del contexto empresarial al educativo con terminología y flujos propios del ámbito académico.

Sería especialmente interesante profundizar e investigar de forma más exhaustiva cómo Teamflect realiza la integración y la conexión entre usuarios “pares” dentro del ecosistema de Microsoft (por ejemplo, cómo identifica miembros de un equipo, sincroniza estructuras organizacionales y asigna evaluaciones dentro de Microsoft Teams), ya que este componente de interoperabilidad se relaciona directamente con una de las necesidades críticas del proyecto: importar los grupos ya creados en Brightspace hacia la aplicación móvil.

En otras palabras, aunque Teamflect opera en un contexto distinto (Microsoft 365), su enfoque de integración puede aportar aprendizajes metodológicos y técnicos sobre mecanismos de autenticación, sincronización de miembros, mapeo de roles y actualización de grupos en tiempo real o bajo demanda, aspectos que resultan clave para diseñar un flujo sólido de importación de grupos desde una plataforma externa hacia Flutter. Analizar este funcionamiento podría orientar decisiones sobre cómo estructurar el módulo de “importación y actualización de grupos” en la app, cómo mantener consistencia entre el sistema externo y la aplicación, y cómo garantizar que las evaluaciones se asignen correctamente a los miembros del grupo importado (Teamflect, s. f.).

 Teamflect. (s. f.). Employee development software. https://teamflect.com/employee-development-software

# Contextualización de la problemática
  
Universidades como la Universidad del Norte, que promueven metodologías activas de aprendizaje y el desarrollo de competencias transversales, han incorporado de manera significativa el trabajo colaborativo como parte esencial de sus procesos formativos. En múltiples asignaturas, los estudiantes desarrollan proyectos en grupo que buscan fortalecer habilidades como el liderazgo, la comunicación efectiva, la responsabilidad compartida, la gestión del tiempo y la resolución de problemas complejos.

No obstante, uno de los principales retos académicos en estos espacios es la evaluación individual dentro del trabajo grupal. En muchos casos, la calificación final asignada al proyecto no logra reflejar de manera objetiva el nivel real de compromiso, aporte y desempeño de cada integrante del equipo. Esta situación puede generar percepciones de inequidad, inconformidad entre estudiantes y dificultades para el docente al momento de asignar notas justas y sustentadas.

Aunque la Universidad del Norte utiliza plataformas institucionales como Brightspace para la gestión de cursos y grupos, dichas herramientas no siempre ofrecen un sistema especializado y flexible de evaluación entre pares que permita configurar criterios personalizados, definir ventanas de evaluación, establecer reglas de visibilidad de resultados (pública o privada) y generar métricas consolidadas por actividad, grupo o estudiante. Como consecuencia, muchos docentes recurren a herramientas externas como formularios, hojas de cálculo o procesos manuales, lo que incrementa la carga administrativa y dificulta la trazabilidad y el análisis estructurado de la información.

Desde la perspectiva estudiantil, tampoco existe una herramienta institucional centralizada que permita realizar evaluaciones entre pares de manera estructurada, controlada y bajo reglas claras, como la restricción de autoevaluación y la limitación a los miembros reales del grupo. Esto afecta la estandarización del proceso y puede comprometer la confiabilidad de los resultados.
En este contexto, se identifica la necesidad de desarrollar una solución tecnológica que responda específicamente a las dinámicas académicas de la Universidad del Norte, permitiendo:
- Integrar o importar los grupos conformados en la plataforma institucional.
- Brindar a los docentes la posibilidad de crear actividades de evaluación entre pares con parámetros configurables (nombre, criterios, ventana de tiempo, visibilidad de resultados).
- Garantizar que los estudiantes evalúen únicamente a sus compañeros de grupo, excluyendo la autoevaluación.
- Generar métricas automáticas como promedios por actividad, por grupo y por estudiante.
- Diferenciar accesos según el rol (docente o estudiante), asegurando la confidencialidad y el control adecuado de la información.
- Adicionalmente, la solución debe diseñarse bajo principios de arquitectura limpia, modularidad y escalabilidad, de manera que pueda adaptarse a futuras necesidades 

# Composición y diseño de la solución, especificando la arquitectura propuesta (por ejemplo: una sola aplicación para profesores y estudiantes; una aplicación independiente para cada rol; aplicaciones separadas más una plataforma web de soporte; u otra configuración debidamente justificada).

Teniendo en cuenta los requerimientos planteados y, además, la necesidad de garantizar una aplicación funcional con características de eficacia, precisión y gestión real del proceso de evaluaciones entre pares, se realizó un análisis de alternativas de composición de la solución para su posible implementación en escenarios académicos como los de la Universidad del Norte. 

En este contexto, el objetivo no es únicamente cumplir con las funcionalidades mínimas, sino asegurar que la solución sea usable en condiciones reales, con control de accesos, trazabilidad, consistencia de resultados y capacidad de soportar pruebas piloto con usuarios (docentes y estudiantes) en cursos universitarios.

Como resultado de esta evaluación, logro concluir que la alternativa más conveniente es el desarrollo de una única aplicación móvil en Flutter con roles diferenciados (Docente/Estudiante). Esta decisión se justifica porque permite centralizar el sistema en una sola base de código, reduciendo duplicidades y facilitando el mantenimiento, la escalabilidad y el aseguramiento de calidad. Adicionalmente, esta arquitectura favorece una gestión más coherente de los flujos compartidos, como autenticación, inscripción a cursos, sincronización de grupos, control de ventanas de evaluación y visualización de resultados, garantizando que cada usuario acceda únicamente a las funcionalidades permitidas según su rol.

Esta decisión, como ya se comenta, parece la más viable gracias a referentes adicionales de soluciones tecnológicas consolidadas que aplican esta misma dinámica de una sola aplicación con diferenciación de roles dentro del mismo ecosistema digital.

En el ámbito educativo, plataformas ampliamente reconocidas como Moodle, Canvas y Brightspace no desarrollan aplicaciones independientes para cada tipo de usuario, sino que implementan un modelo centralizado en el cual la experiencia se adapta dinámicamente según el rol asignado (estudiante, docente, administrador). Este enfoque permite que todos los actores académicos interactúen dentro de un mismo entorno tecnológico, compartiendo infraestructura, base de datos y reglas de negocio, pero con niveles de acceso y funcionalidades diferenciadas.

Este modelo responde a un principio fundamental de diseño de sistemas: la separación entre autenticación, autorización y presentación. La identidad del usuario se gestiona de manera unificada, mientras que los permisos determinan qué acciones puede ejecutar y qué información puede visualizar. De esta manera, el sistema mantiene coherencia estructural sin necesidad de fragmentarse en múltiples aplicaciones.

Adicionalmente, desde una perspectiva de ingeniería de software, esta decisión se alinea con principios como:
- Single Source of Truth (SSOT): mantener una única fuente de verdad para la lógica de negocio y los datos evita inconsistencias en reglas críticas como ventanas de evaluación, visibilidad de resultados y restricciones de autoevaluación.
- Principio de responsabilidad única (SRP): cada módulo cumple una función clara (evaluaciones, cursos, resultados), sin duplicarse entre aplicaciones.
- Escalabilidad horizontal funcional: es más sencillo agregar nuevos roles o capacidades dentro de una misma arquitectura modular que mantener múltiples aplicaciones desacopladas.
- Reducción de deuda técnica: menos duplicación implica menor riesgo de divergencia en actualizaciones futuras.

Además, en el contexto específico de la Universidad del Norte, donde ya existen plataformas institucionales que gestionan usuarios y grupos académicos, la adopción de una sola aplicación con roles diferenciados facilita la integración futura con sistemas existentes, evitando la fragmentación tecnológica y promoviendo una experiencia digital coherente para la comunidad universitaria.
Otro aspecto relevante es la experiencia de usuario. Cuando docentes y estudiantes utilizan la misma aplicación:

- Se fortalece la percepción de pertenencia a un mismo ecosistema académico.
- Se simplifica la capacitación y adopción institucional.
- Se reduce la confusión derivada de múltiples aplicaciones.
- Se facilita la realización de pruebas piloto reales con ambos perfiles dentro del mismo entorno controlado.

Desde el punto de vista operativo, una sola aplicación también mejora la gestión de actualizaciones, despliegues y mantenimiento. Cualquier mejora en seguridad, optimización o funcionalidad impacta simultáneamente a todos los usuarios, garantizando uniformidad en el servicio.

Basado en mi opinión, como estudiante, la mejor decisión es desarrollar una sola aplicación con manejo de roles (profesor y estudiante), ya que esta solución resulta más limpia, más escalable, más profesional, más fácil de mantener y más justificable académicamente. 

Es más limpia porque permite aplicar correctamente los principios de Clean Architecture, separando dominio, datos y presentación sin duplicar lógica entre dos aplicaciones distintas; los mismos casos de uso, entidades y repositorios pueden servir para ambos roles, cambiando únicamente la capa de presentación según el tipo de usuario. 

Es más escalable porque, si en el futuro se requiere agregar nuevos roles (por ejemplo, administrador o coordinador), solo sería necesario extender la lógica de roles sin crear una nueva aplicación. Es más profesional porque sigue buenas prácticas de desarrollo móvil moderno, centralizando autenticación, navegación y control de estado mediante GetX, lo que permite gestionar dependencias, rutas protegidas y controladores de forma organizada y eficiente. Además, es más fácil de mantener porque cualquier cambio en modelos, reglas de negocio o servicios (como autenticación con Roble o manejo de evaluaciones) se realiza en un único proyecto, evitando inconsistencias y duplicación de código.

Ahora, la composición general de como se llevaría la app y sus características y funcionamientos bases serían de la siguiente manera:
Desde la perspectiva Macro, Se desarrollará una sola aplicación móvil, en la cual podrán ingresar tanto docentes como estudiantes. La diferencia entre ambos no será una aplicación distinta, sino que dependerá del rol que tenga cada usuario dentro del curso. Divida en tres componentes claros, que serán: La aplicación móvil de flutter con roles, el servicio backend (Uso de Roble) y la Integración con Brightspace.

Esto significa que:
- El docente tendrá acceso a funciones de creación, configuración y consulta de evaluaciones.
- El estudiante tendrá acceso únicamente a las evaluaciones que debe diligenciar y, según la configuración, a los resultados.
- La aplicación móvil se conectará a servicios externos que se encargarán de:
- Validar el inicio de sesión (autenticación) con Roble.
- Guardar la información de cursos, evaluaciones y resultados con base de datos como Firebase o roble (A definir).

Aplicar reglas importantes como:
- No permitir autoevaluaciones.
- Respetar las fechas de apertura y cierre.
- Controlar la visibilidad pública o privada de los resultados.

Un requisito fundamental del proyecto es que los grupos no se creen dentro de la aplicación, sino que se formen previamente en Brightspace.
La aplicación únicamente:
- Importará las categorías de grupos.
- Importará los grupos.
- Importará los miembros.
- Permitirá actualizar esta información cuando sea necesario.

![WhatsApp Image 2026-02-24 at 13 35 15](https://github.com/user-attachments/assets/d3745e26-c7c4-4114-976f-5f0c1039695b)

# Importante:  Módulos principales de la aplicación
1. **Autenticación y perfil**: Inicio de sesión, Identificación automática del rol (docente o estudiante) y Visualización de perfil.
2. **Cursos e invitaciones**: 
- El docente podrá: Crear cursos e Invitar estudiantes. 
- El estudiante podrá: Unirse a un curso mediante código o invitación.
3. **Sincronización de grupos**: Importar grupos desde Brightspace, actualizar la información cuando haya cambios.
4. **Evaluaciones**:
- El docente podrá: Crear una evaluación, Definir nombre, Definir fecha de apertura y cierre y Definir si los resultados serán públicos o privados.
- El estudiante podrá: Ver evaluaciones activas, Evaluar únicamente a sus compañeros de grupo y No podrá evaluarse a sí mismo.
5. **Resultados y análisis**:
- El docente podrá consultar: Promedio general por actividad, Promedio por grupo, Promedio por estudiante, Detalle por criterio.
- El estudiante: Solo podrá ver resultados si la evaluación fue configurada como pública y Si es privada, solo el docente podrá verlos.
6. **Permisos y funcionamiento en segundo plano**: La aplicación solicitará permisos como: Permisos de ejecución en segundo plano.
Estos pueden justificarse para: Recordatorios cuando una evaluación esté por cerrar y Sincronización automática de grupos.

# Descripción detallada del flujo funcional, desde el trabajo en equipo hasta la evaluación y visualización de resultados.
<img width="2472" height="1146" alt="Group 1" src="https://github.com/user-attachments/assets/2cd829a1-93f4-451b-aeb3-61df1271f132" />
Link: https://www.figma.com/design/51czOcjJ2NY01pD6DYmlzd/Sin-t%C3%ADtulo?node-id=0-1&t=OUk1M8fb0FLOdxp5-1

# Justificación de la propuesta con base en los referentes analizados y en entrevistas realizadas a profesores que implementen trabajos colaborativos.
En el marco de la validación de la solución, sostuve una reunión con dos profesores, entre ellos una docente de Cálculo reconocida por innovar constantemente en sus procesos pedagógicos, especialmente mediante el desarrollo de proyectos en grupos y equipos de trabajo que permiten a sus estudiantes representar y aplicar las matemáticas en distintos campos de formación. Durante el encuentro le presenté la idea de la herramienta de evaluación entre pares, y manifestó que le parecía altamente pertinente, particularmente en su contexto como profesora de materias de primer semestre, donde frecuentemente se enfrenta a estudiantes desmotivados y poco dispuestos a trabajar en equipo. Considera que una solución como esta podría contribuir significativamente a fortalecer la participación, promover la corresponsabilidad y generar evaluaciones más justas entre compañeros, permitiendo conocer la apreciación real del desempeño dentro de los grupos. No obstante, también planteó inquietudes relevantes sobre su factibilidad, señalando que la emocionalidad y la subjetividad propias de los estudiantes pueden convertirse en un factor de riesgo importante, capaz de distorsionar las evaluaciones y eventualmente afectar el clima del aula si no se establecen mecanismos adecuados de control y acompañamiento.

De igual manera, se sostuvo una conversación con un profesor del área de Sistemas, quien manifestó que la herramienta podría convertirse en un verdadero llamado de atención para aquellos estudiantes que no están asumiendo con responsabilidad su rol dentro del equipo, funcionando como un mecanismo que los motive a “ponerse las pilas” y mejorar su desempeño de manera progresiva y consciente. Desde su perspectiva, la evaluación entre pares no solo aporta información académica, sino que también genera retroalimentación social directa que puede impulsar cambios positivos en el comportamiento y el compromiso. Sin embargo, al igual que la profesora de Cálculo, expresó reservas frente al componente emocional y la subjetividad de los estudiantes, señalando que los sentimientos personales, afinidades o conflictos interpersonales podrían influir en las calificaciones. En este sentido, destacó que dicha problemática trasciende el alcance puramente tecnológico de la solución, pues involucra dimensiones humanas y formativas que requieren acompañamiento pedagógico y criterios claros para mitigar posibles sesgos.

Frente a estas inquietudes, resulta evidente que la única manera de abordar de forma responsable el componente emocional y la subjetividad es salir del plano teórico y realizar pruebas reales de la herramienta en contextos controlados. Implementar pilotos permitirá comprender cómo se comportan los usuarios, qué tan objetiva resulta la evaluación entre pares en la práctica y cuáles son los posibles sesgos o distorsiones que pueden surgir. A través de estas pruebas se podrá recolectar evidencia, identificar patrones de comportamiento, ajustar criterios de evaluación y diseñar mecanismos de mitigación como rúbricas más estructuradas, anonimato o ponderaciones, que reduzcan el impacto de la emocionalidad. En definitiva, la validación en campo no solo permitirá entender mejor a los estudiantes, sino también fortalecer la solución desde una perspectiva pedagógica y tecnológica basada en datos reales y no únicamente en supuestos.

