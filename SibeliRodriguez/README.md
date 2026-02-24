# Documento Peer Assessment App

**Estudiante:** Sibeli Rodriguez  

---

# Referentes Peer Assessment App

## 1. FeedbackFruits

<img width="1440" height="779" alt="Captura de pantalla 2026-02-24 a la(s) 11 56 51 a m" src="https://github.com/user-attachments/assets/062a815d-ed41-4cda-8bea-4775b11ac816" />

**Tomado de:** https://feedbackfruits.com/peer-assessment-get-started-bundle  

FeedbackFruits es una herramienta enfocada específicamente en evaluaciones entre pares para contextos educativos dentro de cursos digitales.

### Se caracteriza por:

- Facilitar la creación y gestión de actividades de evaluación entre pares al automatizar la asignación de trabajos para revisión.
- Estructurar la retroalimentación con criterios y rúbricas personalizables.
- Generar reportes que permitan a los docentes supervisar el progreso y la calidad del feedback de los estudiantes.

La plataforma reduce la carga del instructor mediante flujos de trabajo automatizados (recordatorios, asignaciones y seguimiento de tareas), permite configuraciones flexibles como evaluaciones individuales o grupales, anónimas o abiertas, soporta múltiples formatos de entregables, y promueve un feedback significativo y reflexivo que fortalece el aprendizaje colaborativo.

---

## 2. Kritik


<img width="1440" height="776" alt="Captura de pantalla 2026-02-24 a la(s) 12 01 34 p m" src="https://github.com/user-attachments/assets/12afe7fe-fccb-40b0-bf2f-8fd6f0e14e0c" />

**Tomado de:** https://www.kritik.io/  

Kritik es una plataforma de evaluación entre pares diseñada para entornos educativos que permite a los docentes crear actividades en las que los estudiantes revisan y retroalimentan el trabajo de sus compañeros mediante rúbricas y criterios definidos, promoviendo así el pensamiento crítico y la participación activa.

La herramienta facilita flujos de trabajo estructurados con:

- Asignación automática de tareas para evaluación.
- Plazos configurables.
- Escalas y criterios personalizables.
- Integraciones con sistemas de gestión de aprendizaje (LMS).
- Reportes detallados que permiten supervisar la calidad del feedback y el desempeño individual y grupal.

Kritik enfatiza la retroalimentación formativa, el aprendizaje colaborativo y el desarrollo de habilidades de comunicación entre estudiantes, convirtiéndose en una solución pedagógica completa para la implementación de evaluaciones *peer-to-peer*.

---

## 3. Insightful


<img width="1440" height="775" alt="Captura de pantalla 2026-02-24 a la(s) 12 03 09 p m" src="https://github.com/user-attachments/assets/75991aab-997b-4eec-ab5d-1f66ba693b7c" />

**Tomado de:** https://www.insightful.io/  

Insightful es una plataforma de análisis y monitoreo de productividad laboral diseñada para ayudar a organizaciones a comprender cómo se realiza el trabajo y mejorar la eficiencia de sus equipos mediante la captura automática de datos en tiempo real sobre actividad, uso de aplicaciones, tiempo dedicado a tareas y rendimiento.

### La herramienta proporciona:

- Seguimiento automático de tiempo y tareas.
- Métricas detalladas de productividad por individuo y equipo.
- Informes personalizables.
- Paneles de análisis con tendencias de desempeño.
- Integraciones con herramientas clave de gestión (como Jira, Trello o Asana).
- Soporte para entornos remotos, híbridos y presenciales.

---

## Justificación de Referentes

| Herramienta | Justificación como referente |
|-------------|------------------------------|
| **Insightful** | Constituye un referente en términos de analítica de desempeño y visualización de métricas, ya que transforma datos de actividad en indicadores estructurados y reportes comparativos. Aunque su enfoque es empresarial, su modelo de generación de métricas, paneles de control y análisis por usuario y equipo resulta pertinente como inspiración para el diseño del sistema de promedios, estadísticas y visualización de resultados en la aplicación propuesta. |
| **Kritik** | Representa un referente directo en el ámbito de la evaluación entre pares en contextos académicos, al permitir la configuración de rúbricas y criterios estructurados mediante los cuales los estudiantes evalúan el trabajo de sus compañeros. Su enfoque pedagógico, la automatización del proceso de asignación de evaluaciones y la generación de reportes individuales y grupales guardan una relación directa con la funcionalidad central de la aplicación planteada. |
| **FeedbackFruits – Peer Assessment Bundle** | Se constituye como referente por su integración con sistemas de gestión de aprendizaje (LMS) y por ofrecer un módulo especializado de evaluación entre pares con configuración de actividades, ventanas temporales, criterios personalizados y control de visibilidad de resultados. Su estructura funcional y su enfoque en la supervisión docente de métricas académicas se alinean directamente con los requerimientos del proyecto propuesto. |


---

# Composición y Diseño

La presente solución consiste en una **única aplicación móvil desarrollada en Flutter**, que gestiona ambos roles (**docente** y **estudiante**) dentro de la misma base de código, diferenciando funcionalidades mediante un sistema de autenticación y control de acceso basado en roles.

La aplicación contará con un sistema de **login centralizado**, donde cada usuario se autentica y, según su rol asignado (`teacher` o `student`), el sistema habilita o restringe funcionalidades específicas mediante control de permisos en la capa de presentación y lógica de negocio. Esta arquitectura evita la duplicación de código y permite mantener coherencia en el diseño, navegación y mantenimiento del sistema.

## Razones para una única aplicación

Mantener una sola base de código:

- Reduce significativamente la complejidad y los costos de mantenimiento, evitando duplicación de lógica y sincronización de cambios en dos proyectos distintos.
- Garantiza una experiencia de usuario coherente y unificada (evitando inconsistencias de diseño y funcionamiento).
- Facilita la escalabilidad, permitiendo incorporar nuevos roles o funcionalidades sin desarrollar sistemas adicionales.
- Centraliza la gestión de dependencias y del estado (por ejemplo, mediante **GetX**) en un solo entorno, simplificando la arquitectura técnica.

En contraste, mantener aplicaciones separadas incrementaría la complejidad técnica, los costos de desarrollo y la fragmentación de la lógica compartida, reduciendo la eficiencia estructural del sistema.

---

## Arquitectura (Clean Architecture)

Desde el punto de vista arquitectónico, se implementará bajo el enfoque de **Clean Architecture**, separando la solución en capas:

- **Presentation Layer:** Interfaces y controladores (GetX para estado, navegación e inyección de dependencias).
- **Domain Layer:** Casos de uso y reglas de negocio (gestión de evaluaciones, cálculo de promedios, control de visibilidad).
- **Data Layer:** Repositorios e implementación de servicios (autenticación, almacenamiento en Roble, importación de grupos).

> Como se puede representar en el diagrama a continuación:
<img width="252" height="1065" alt="Peer Assessment App-Arquitectura" src="https://github.com/user-attachments/assets/71ccac17-a1c0-4cde-8e43-93264cee8075" />

## Arquitectura del Sistema

La arquitectura propuesta sigue el modelo de **Clean Architecture**, organizada en cuatro capas claramente diferenciadas: Presentación, Dominio, Data y Servicios Externos. En la capa de Presentación se encuentra la interfaz desarrollada en Flutter junto con GetX, incluyendo pantallas como login y dashboards, así como los controladores encargados de gestionar el estado y coordinar la interacción con los casos de uso.  

La capa de Dominio constituye el núcleo del sistema e incluye las entidades, los casos de uso y las interfaces de repositorios; esta capa contiene la lógica de negocio y es completamente independiente de frameworks, bases de datos o servicios externos.  

La capa de Data implementa las interfaces definidas en el dominio mediante `RepositoryImpl` y actúa como intermediaria entre la aplicación y los servicios externos, integrando adaptadores y servicios específicos como Roble y Brightspace. Finalmente, la capa de Servicios Externos agrupa los sistemas de terceros (autenticación, base de datos y APIs), los cuales son consumidos por la capa Data pero no influyen directamente en el dominio, garantizando así el cumplimiento del principio de inversión de dependencias y asegurando modularidad, mantenibilidad y escalabilidad del sistema.


---

## Sistema de Roles

El sistema de roles permitirá:

### Docentes

- Crear cursos.
- Invitar estudiantes.
- Importar grupos desde Brightspace.
- Activar evaluaciones.
- Definir criterios.
- Consultar métricas agregadas.

### Estudiantes

- Unirse a cursos.
- Responder evaluaciones dentro de la ventana de tiempo.
- Consultar resultados según el nivel de visibilidad configurado.

---

## Justificación de Aplicación Única

Se propone una única aplicación por las siguientes razones:

- **Mantenibilidad:** Se mantiene una sola base de código, reduciendo complejidad y costos de desarrollo.
- **Consistencia de experiencia de usuario:** Interfaz unificada para todos los actores del sistema.
- **Escalabilidad:** Facilita la incorporación de nuevos roles en el futuro.
- **Mejor gestión de dependencias:** Uso centralizado de GetX para estado y navegación.
- **Menor redundancia lógica:** Muchas funcionalidades (cursos, grupos, evaluaciones) son compartidas entre roles, aunque con permisos distintos.

---

# Flujo Funcional

El flujo funcional del sistema inicia con el inicio de sesión del usuario, quien es autenticado mediante el servicio correspondiente. Una vez validado, el sistema identifica el rol del usuario (docente o estudiante) y redirige al dashboard correspondiente, activando únicamente las funcionalidades asociadas a dicho rol.

## Flujo del Docente

Si el usuario tiene rol de docente, accede a su panel de control donde puede gestionar las evaluaciones. El primer paso consiste en la importación de grupos desde Brightspace, integrando automáticamente la información de cursos y estudiantes. El sistema valida si la importación fue exitosa; en caso contrario, se muestra un mensaje de error y el proceso se detiene.

Si la importación es correcta, el docente procede a crear una nueva evaluación, configurando los siguientes parámetros:

- Nombre de la actividad  
- Ventana de tiempo (fecha de apertura y cierre)  
- Nivel de visibilidad de resultados  
- Criterios de evaluación  

Posteriormente, la evaluación es publicada y el sistema envía notificaciones a los estudiantes correspondientes, habilitando el acceso a la actividad dentro del periodo definido.

---

## Flujo del Estudiante

Si el usuario tiene rol de estudiante, accede a su dashboard donde puede visualizar las evaluaciones disponibles. Al seleccionar una actividad, el sistema verifica si la evaluación se encuentra dentro de la ventana de tiempo activa.

- Si la evaluación está fuera del periodo permitido, el sistema muestra el estado de evaluación cerrada.
- Si la evaluación está activa, el estudiante puede proceder a evaluar a sus compañeros.

Durante el proceso de evaluación, el estudiante:

- Selecciona a los compañeros asignados.
- Asigna puntajes según los criterios definidos.
- Guarda la evaluación en la base de datos.

El sistema almacena cada evaluación individual para su posterior procesamiento.

---

## Cierre de la Evaluación y Procesamiento de Resultados

Una vez finaliza la ventana de evaluación, el sistema ejecuta automáticamente el módulo de procesamiento de resultados. Este módulo realiza los siguientes cálculos:

- Promedio por criterio  
- Promedio por estudiante  
- Promedio por grupo  
- Promedio general de la actividad  

Estos cálculos se realizan a nivel de dominio mediante los casos de uso correspondientes, garantizando independencia de la capa de presentación.

---

## Gestión de la Visibilidad de Resultados

Tras el cálculo de resultados, el sistema verifica la configuración de visibilidad definida por el docente:

- Si la visibilidad es pública, los estudiantes pueden visualizar los resultados grupales.
- Si la visibilidad es restringida, los resultados detallados son accesibles únicamente para el docente.

En todos los casos, el docente puede acceder a métricas detalladas y estadísticas agregadas para análisis del desempeño.

---

A continuación se evidencia el gráfico del flujo establecido en figma:

<img width="1080" height="1786" alt="fila-1-columna-1 (1)" src="https://github.com/user-attachments/assets/f82bc747-e957-4637-ae4e-f8189feb2d6c" />
<img width="1080" height="1785" alt="fila-2-columna-1 (1)" src="https://github.com/user-attachments/assets/e62c53be-0eed-4297-9ec5-4ffcd5de6ca6" />


## link de figma en donde se encuentra diseño de arquitectura y flujo de trabajo: https://www.figma.com/design/4j8UsgSlzQwDYfqMSoJR4C/Peer-Assessment-App-SibeliRodriguez?node-id=0-1&t=qiE0SfnopRlZp2vH-1


---

## Justificación de la propuesta

La propuesta del sistema de evaluación entre pares se fundamenta tanto en el análisis de referentes tecnológicos existentes como en la validación obtenida mediante entrevistas realizadas a docentes que implementan trabajos colaborativos en sus cursos. Plataformas como Kritik, Feedback Fruits e Insightful evidencian la importancia de integrar mecanismos estructurados de evaluación entre pares, automatización de resultados y analítica de desempeño. Es así como, la propuesta adquiere relevancia no sólo en contextos educativos, sino también en escenarios organizacionales donde la colaboración, la rendición de cuentas y la evaluación objetiva del desempeño son fundamentales para el éxito colectivo.  

Durante las entrevistas realizadas, los docentes manifestaron que uno de los principales desafíos en los trabajos colaborativos es la dificultad para evaluar equitativamente la participación individual de cada estudiante. Asimismo, señalaron la necesidad de contar con herramientas que permitan configurar criterios claros, definir ventanas de tiempo y obtener métricas consolidadas sin aumentar la carga administrativa. En este sentido, la propuesta responde directamente a estas necesidades al incorporar: (1) importación automática de grupos, (2) configuración flexible de criterios y visibilidad, (3) cálculo automático de promedios por estudiante y grupo, y (4) generación de resultados estructurados.  

De igual manera, estuvieron de acuerdo con la implementación de un sistema con roles diferenciados (docente y estudiante), ya que permite controlar permisos y asegurar una experiencia adecuada para cada usuario. La inclusión de ventanas de evaluación y reglas de visibilidad también fue considerada pertinente para garantizar transparencia y control del proceso.  

Por lo que, la solución propuesta no solo se encuentra alineada con buenas prácticas observadas en plataformas consolidadas del mercado, sino que también responde a necesidades reales identificadas en el contexto académico local, lo que valida su pertinencia funcional, pedagógica y técnica.
