# Peer-Assessment-App

Peer-Assessment-App es una aplicación móvil desarrollada en **Flutter** que permite a los estudiantes evaluar el desempeño, compromiso y contribución de sus compañeros dentro de actividades académicas colaborativas.

La aplicación busca apoyar procesos de **evaluación entre pares**, proporcionando a los docentes una herramienta estructurada para gestionar evaluaciones, recopilar resultados y analizar métricas de participación dentro de trabajos grupales.

---

# `Metas y alcance inicial de la propuesta`

## Metas del Proyecto

El objetivo principal del proyecto es diseñar y desarrollar una **aplicación móvil funcional y escalable** que permita implementar procesos de evaluación entre pares de manera estructurada dentro de entornos educativos.

Las metas principales del sistema son:

- Desarrollar una **aplicación móvil multiplataforma utilizando Flutter** que permita a docentes y estudiantes interactuar dentro de un mismo sistema.
- Facilitar la **evaluación del desempeño individual dentro de trabajos colaborativos**, permitiendo que los estudiantes valoren la participación de sus compañeros.
- Proporcionar a los docentes **métricas automáticas y resultados agregados** que permitan analizar el comportamiento y la dinámica de los grupos de trabajo.
- Implementar un sistema que permita **gestionar cursos, evaluaciones y resultados** dentro de un flujo de trabajo claro y estructurado.
- Diseñar una arquitectura de software **escalable, mantenible y modular** utilizando principios de **Clean Architecture**.
- Garantizar una **experiencia de usuario intuitiva** mediante el diseño iterativo de interfaces y la integración progresiva de propuestas de diseño desarrolladas por el equipo.

A largo plazo, este proyecto busca sentar las bases para una plataforma que pueda integrarse con sistemas de gestión de aprendizaje (LMS), facilitando la evaluación colaborativa dentro de entornos académicos digitales.

---

## Alcance de la Propuesta

El alcance del proyecto contempla el diseño e implementación de un **prototipo funcional de aplicación móvil**, enfocado en los procesos principales de evaluación entre pares dentro de actividades académicas colaborativas.

Dentro del alcance del sistema se incluyen las siguientes funcionalidades:

### Para Docentes

- Creación y gestión de cursos dentro de la aplicación.
- Envío de invitaciones a estudiantes para unirse a los cursos.
- Importación de grupos de trabajo desde plataformas externas (como Brightspace).
- Creación y configuración de evaluaciones entre pares.
- Definición de criterios de evaluación.
- Activación y publicación de evaluaciones.
- Visualización de resultados agregados y métricas de desempeño.

### Para Estudiantes

- Registro o acceso al sistema mediante autenticación.
- Unión a cursos mediante invitación.
- Visualización de evaluaciones activas.
- Evaluación del desempeño de sus compañeros dentro de actividades grupales.
- Consulta de resultados según la configuración de visibilidad definida por el docente.

### Procesamiento del Sistema

El sistema será responsable de:

- Gestionar la autenticación de usuarios.
- Controlar los permisos según el rol del usuario.
- Validar las ventanas de tiempo de las evaluaciones.
- Procesar automáticamente los resultados una vez finalizada una evaluación.
- Generar métricas como:
  - Promedio por criterio.
  - Promedio por estudiante.
  - Promedio por grupo.
  - Promedio general de la actividad.

---

## Limitaciones del Alcance

El proyecto se enfoca principalmente en el **desarrollo del sistema base y su arquitectura**, por lo que algunos aspectos quedan fuera del alcance actual, como:

- Implementación completa de infraestructura de producción.
- Integración completa con plataformas LMS externas.
- Sistemas avanzados de analítica educativa.
- Implementación de algoritmos avanzados de detección de sesgos en evaluaciones.

Sin embargo, la arquitectura propuesta permite que estas funcionalidades puedan ser **incorporadas en futuras versiones del sistema**.

---

# Decisión Final de Arquitectura y Diseño del Sistema

Tras el análisis comparativo de las propuestas iniciales de diseño, los diagramas de flujo planteados y la evaluación técnica realizada en equipo, se tomó la decisión definitiva de implementar la solución como **una única aplicación móvil**, gestionando múltiples roles de usuario dentro del mismo sistema, bajo el enfoque de **Clean Architecture** previamente establecido.

<img width="141" height="306" alt="Captura de pantalla 2026-03-09 a la(s) 7 50 33 p m" src="https://github.com/user-attachments/assets/0588c27c-a2e2-4d4b-a39b-e6f66f46767b" />

## 1. Decisión sobre la estructura de la aplicación

Inicialmente se contempló la posibilidad de desarrollar aplicaciones separadas para docentes y estudiantes. Sin embargo, después de evaluar los impactos técnicos, de mantenimiento y escalabilidad, se concluyó que la mejor alternativa es **mantener una sola base de código**, diferenciando funcionalidades mediante un sistema de autenticación y control de acceso basado en roles.

Esta decisión se fundamenta en los siguientes criterios:

- **Mantenibilidad:** Una única aplicación reduce la duplicación de lógica, evita inconsistencias y simplifica las actualizaciones futuras.
- **Consistencia en la experiencia de usuario:** Permite una interfaz coherente y uniforme para todos los actores del sistema.
- **Escalabilidad:** Facilita la incorporación futura de nuevos roles o funcionalidades sin necesidad de desarrollar sistemas independientes.
- **Optimización técnica:** Centraliza la gestión de estado, navegación e inyección de dependencias (GetX) en un solo entorno estructural.
- **Reducción de costos de desarrollo:** Disminuye complejidad, tiempo de implementación y esfuerzo de mantenimiento.

Por lo tanto, el sistema operará con **autenticación centralizada**, donde el usuario inicia sesión y, según su rol (docente o estudiante), el sistema habilita o restringe funcionalidades específicas.

---

## 2. Confirmación del enfoque arquitectónico

Se ratifica la implementación bajo el modelo de **Clean Architecture**, organizado en las siguientes capas:

- **Presentation Layer:** Interfaces en Flutter y controladores con GetX.
- **Domain Layer:** Casos de uso, entidades y reglas de negocio.
- **Data Layer:** Implementación de repositorios e integración con servicios externos.
- **Servicios Externos:** Autenticación, base de datos y APIs (como Brightspace).

Este enfoque garantiza:

- Separación clara de responsabilidades.
- Independencia del dominio respecto a frameworks y servicios externos.
- Cumplimiento del principio de inversión de dependencias.
- Mayor modularidad y facilidad de pruebas.
- Escalabilidad estructural del sistema.

La arquitectura ya establecida se mantiene sin modificaciones estructurales, asegurando coherencia con el diseño técnico previamente aprobado.

---

## 3. Decisión sobre el flujo funcional (Merge de propuestas)

Se realizó un proceso de integración (merge) entre los distintos diagramas de flujo propuestos, consolidando los elementos más sólidos de cada versión. El flujo final integra:

### Para el Docente:

- Creación de curso.
- Envío de invitaciones privadas.
- Importación de grupos desde Brightspace.
- Creación y configuración de evaluación (nombre, duración, visibilidad, criterios).

- Activación/publicación de evaluación.
- Generación automática de resultados:
  - Promedio por criterio.
  - Promedio por estudiante.
  - Promedio por grupo.
  - Promedio general de la actividad.
- Visualización de métricas detalladas.

### Para el Estudiante:

- Unión a curso mediante invitación.
- Visualización de evaluaciones activas.
- Evaluación de compañeros (sin autoevaluación).
- Envío de evaluación dentro de la ventana de tiempo.

- Consulta de resultados según configuración de visibilidad.

Además, el flujo consolidado incorpora:

- Validaciones de ventana de tiempo.
- Manejo de errores.
- Control de visibilidad pública o restringida.
- Procesamiento automático de resultados al cierre de la evaluación.

Esta integración permite un flujo más claro, estructurado y alineado con la lógica de negocio definida en la capa de dominio.

---

## 4. Conclusión de la Decisión

La decisión final establece que el sistema será:

- Una única aplicación móvil.
- Con gestión de roles diferenciados.
- Implementada bajo Clean Architecture.
- Con flujo funcional consolidado y validado.
- Orientada a escalabilidad, mantenibilidad y coherencia técnica.

---

## Proceso de Diseño del Flujo Funcional

Durante la fase de diseño del sistema, diferentes integrantes del equipo desarrollaron múltiples **propuestas de flujo de usuario** con el objetivo de explorar distintos modelos de interacción y enfoques estructurales para la aplicación, asi como se puede evidenciar en cada uno de sus propios README.md

Después de analizar las distintas propuestas, el equipo identificó dos diseños particularmente completos y bien estructurados, desarrollados por:

- **Juan Sebastián**
- **Sibeli Rodríguez**

En lugar de seleccionar únicamente una de las propuestas, el equipo decidió adoptar un **enfoque de integración híbrida**, combinando los aspectos más sólidos de ambos diseños.

Esta decisión permite aprovechar las fortalezas complementarias presentes en cada propuesta, dando como resultado un diseño del sistema más refinado, equilibrado y alineado con las necesidades funcionales del proyecto.

### Beneficios de la Integración

Al integrar elementos de ambos diseños, el sistema final se beneficia de:

- **Mayor claridad estructural** proveniente de uno de los modelos de flujo propuestos.
- **Mejoras en la usabilidad y en los patrones de interacción del usuario** introducidas en el otro diseño.
- **Refinamientos y optimizaciones adicionales** identificados durante la fase de implementación del proyecto.

Este enfoque colaborativo de diseño garantiza que el flujo final del sistema no se limite a una sola perspectiva, sino que represente una **solución sintetizada a partir de múltiples iteraciones de diseño y de la contribución conjunta del equipo**.

---

## Diseños Originales Propuestos

### Diseño de Interfaz – Sibeli Rodríguez

Este diseño define principalmente la **estructura de las pantallas y la organización de los componentes de la interfaz**.

![WhatsApp Image 2026-03-09 at 19 15 40](https://github.com/user-attachments/assets/4bd37872-1301-4fd2-bb7a-5e63e1441b9f)


---

### Diseño Visual – Juan Sebastián

Este diseño aporta principalmente los **elementos de identidad visual del sistema**, incluyendo colores, tipografía y estilos gráficos.

<img width="488" height="486" alt="Captura de pantalla 2026-03-09 a la(s) 7 41 43 p m" src="https://github.com/user-attachments/assets/a7744bcd-2bb1-44ae-a52c-1c5f41da796c" />



---

## Disenos finales de la propuesta 
https://www.figma.com/design/UaG4cOGVYFf9znask4ky0l/Peer-Review-App?node-id=0-1&p=f&t=weJsNB1AcAWkuVEj-0



---
# Estado actual de la implementación

---


## Funcionalidades principales 

### Para docentes
- Registro e inicio de sesión.
- Gestión de cursos.
- Carga de archivos CSV para creación masiva de cursos, grupos y asignación de estudiantes.
- Visualización de cursos y grupos.
- Creación de evaluaciones.
- Definición de nombre, fechas, visibilidad y estado de la evaluación.
- Visualización de evaluaciones activas e inactivas.
- Consulta de respuestas y resultados agregados.
- Publicación de resultados para estudiantes.

### Para estudiantes
- Registro, verificación de correo e inicio de sesión.
- Visualización de cursos asociados.
- Visualización de grupos y compañeros.
- Consulta de evaluaciones activas.
- Evaluación de compañeros con criterios definidos.
- Consulta de resultados publicados.

## Alcance

El alcance actual de la solución cubre el flujo académico esencial del proceso de evaluación entre pares:

- autenticación por roles,
- gestión básica de cursos y grupos,
- carga de estructura académica mediante CSV,
- creación y respuesta de evaluaciones,
- consolidación y publicación de resultados,
- y optimización de ciertas consultas mediante caché local.

La aplicación se encuentra en un estado funcional para demostrar un flujo completo de uso dentro del contexto académico planteado.

---

# 2. Arquitectura de la solución

La aplicación fue estructurada bajo un enfoque de **Clean Architecture**, organizado por módulos o features. Esta decisión permite mantener una separación clara de responsabilidades y facilita la evolución del sistema a medida que se agregan nuevas funcionalidades.

## Enfoque general

La arquitectura se divide en tres capas principales:

### Presentation Layer
Contiene la interfaz construida en Flutter y los controladores de estado utilizando **GetX**.  
Aquí se encuentran:

- páginas,
- widgets,
- controladores/viewmodels,
- y lógica relacionada con la interacción del usuario.

### Domain Layer
Define las reglas del negocio y los contratos principales del sistema.  
Aquí se encuentran:

- modelos,
- entidades,
- interfaces de repositorios.

Esta capa representa la lógica central del sistema y permanece desacoplada de detalles de infraestructura.

### Data Layer
Implementa el acceso a datos y conecta la aplicación con fuentes remotas y locales.  
Aquí se encuentran:

- datasources remotos,
- datasources locales,
- implementaciones de repositorios.

## Organización por módulos

El sistema se encuentra organizado por funcionalidades principales:

- `auth`
- `courses`
- `groups`
- `assessments`
- `home`

Esta estructura permite que cada módulo evolucione de manera más aislada, facilitando el mantenimiento y la escalabilidad.

## Decisión arquitectónica principal

Se decidió mantener **una sola aplicación móvil** con múltiples roles, en lugar de construir aplicaciones separadas para docentes y estudiantes. Esta decisión aporta:

- mayor mantenibilidad,
- menor duplicación de lógica,
- consistencia de experiencia de usuario,
- y una base de código más escalable.

---

# 3. Tecnologías utilizadas

El proyecto fue desarrollado con las siguientes tecnologías y herramientas:

- **Flutter**: framework principal para desarrollo móvil multiplataforma.
- **Dart**: lenguaje de programación.
- **GetX**: gestión de estado, navegación e inyección de dependencias.
- **Dio**: cliente HTTP para comunicación con servicios externos.
- **SharedPreferences**: almacenamiento local para implementación de caché.
- **Mockito**: soporte para pruebas automatizadas.
- **CSV package**: procesamiento de archivos CSV.
- **File Picker**: selección de archivos desde el dispositivo.
- **ROBLE API**: autenticación y persistencia de datos.

---

# 4. Funcionalidades implementadas

## Gestión de autenticación
- Registro de usuarios.
- Verificación de correo.
- Inicio y cierre de sesión.
- Gestión de roles: docente y estudiante.
- Renovación de token de acceso.

## Gestión académica
- Carga de estructura académica mediante CSV.
- Creación de cursos.
- Creación de grupos.
- Registro de estudiantes por curso.
- Registro de miembros por grupo.

## Evaluación entre pares
- Creación de evaluaciones por parte del docente.
- Definición de fechas de inicio y fin.
- Activación e inactivación según estado y tiempo.
- Respuesta de evaluación por parte de estudiantes.
- Validación de envío único por estudiante.
- Consulta de respuestas por parte del docente.
- Cálculo de resultados agregados.
- Publicación de resultados.

## Visualización de resultados
- Consulta de resultados publicados en el perfil del estudiante.
- Visualización de nombre de la evaluación, curso y promedio.
- Distinción entre resultados provisionales y finales.

---

# 5. Gestión de caché

Como parte de la optimización del sistema, se implementó una estrategia de caché local en los módulos de **courses** y **groups**.

## Objetivo de la caché

Reducir llamadas innecesarias a la API y mejorar la velocidad de carga de pantallas que consultan datos relativamente estables.

## Datos cacheados

### En `courses`
- cursos del docente,
- cursos del estudiante.

### En `groups`
- grupos por curso,
- grupos del estudiante por curso.

## Estrategia de funcionamiento

La lógica de caché se implementó a través de:

- una interfaz de caché (`ICoursesCacheSource`, `IGroupsCacheSource`),
- una implementación concreta con `SharedPreferences`,
- y repositorios que deciden si leer desde caché o desde la API.

El flujo general es:

1. la UI solicita datos al controller,
2. el controller delega al repository,
3. el repository verifica si la caché sigue vigente,
4. si es válida, devuelve datos locales,
5. si no es válida, consulta la API,
6. guarda la nueva respuesta junto con un timestamp,
7. y retorna los datos a la interfaz.

## TTL e invalidación

La caché incluye un timestamp que permite validar su vigencia mediante un TTL.

Además, se implementó una invalidación manual en un caso crítico: la **subida del CSV**.  
Como este proceso crea o modifica cursos, grupos y miembros, la caché de cursos y grupos se limpia automáticamente cuando la carga finaliza con éxito.

También se incorporó `forceRefresh` en flujos específicos para garantizar que, después de ciertos eventos, la UI vuelva a consultar directamente la API.

---

# 6. Pruebas automatizadas

El proyecto incluye pruebas automatizadas en distintos niveles.

## Nivel 1 - Widget Tests
Se implementaron pruebas para validar componentes y comportamientos de interfaz en pantallas como:

- `HomeScreen`
- `LoginScreen`
- `RegisterScreen`
- `VerifyEmailScreen`

Estas pruebas verifican:

- renderización de componentes,
- interacción básica del usuario,
- presencia de elementos esperados,
- y comportamiento visual controlado.

## Nivel 3 - Integración
Se implementaron pruebas de integración para validar flujos completos del sistema, particularmente relacionados con autenticación y navegación.

Estas pruebas utilizan:

- interfaz real,
- controller real,
- red simulada mediante cliente mockeado.

## Importancia de las pruebas
Las pruebas automatizadas permitieron:

- validar la estabilidad de la interfaz,
- comprobar flujos completos de uso,
- detectar regresiones durante cambios del proyecto,
- y aumentar la confianza sobre la versión final funcional.

---

# 7. Estructura del proyecto

Una versión simplificada de la estructura del proyecto es la siguiente:

```text
lib/
├── core/
├── features/
│   ├── auth/
│   ├── courses/
│   ├── groups/
│   ├── assessments/
│   └── home/
└── main.dart
```
Esta organización responde a un enfoque **modular basado en funcionalidades**, lo que permite que cada parte del sistema esté mejor separada, sea más fácil de mantener y pueda crecer de forma ordenada.

### `main.dart`

Es el punto de entrada de la aplicación.  
Desde este archivo se inicializa Flutter, se configura la aplicación principal y se registran dependencias iniciales necesarias para arrancar el sistema.

En términos prácticos, `main.dart` es el archivo que pone en marcha toda la app.

---

### `core/`

La carpeta `core` contiene componentes compartidos por varios módulos del sistema.  
Aquí se ubican recursos reutilizables que no pertenecen a una funcionalidad específica, pero que son necesarios para el funcionamiento general de la aplicación.

Por ejemplo, en esta carpeta se incluyen:

- definiciones globales como roles de usuario,
- abstracciones para acceso a preferencias locales,
- servicios compartidos como `SharedPreferencesService`,
- y utilidades base que pueden ser reutilizadas por distintos módulos.

El objetivo de `core` es centralizar elementos transversales y evitar duplicación de lógica.

---

### `features/`

La carpeta `features` organiza el sistema por funcionalidades del negocio.  
En lugar de agrupar únicamente por tipo de archivo, el proyecto se estructura por módulos funcionales, lo que mejora la mantenibilidad y hace más clara la relación entre lógica, datos e interfaz.

Cada feature suele dividirse internamente en tres capas:

- `data/`
- `domain/`
- `ui/`

#### `data/`

Contiene la lógica de acceso a datos. Aquí se ubican:

- datasources remotos,
- datasources locales,
- implementaciones de caché,
- implementaciones concretas de repositorios.

Esta capa define cómo se obtiene, almacena o consulta la información.

#### `domain/`

Contiene la lógica central del negocio. Aquí se ubican:

- modelos,
- entidades,
- contratos de repositorios.

Esta capa representa qué necesita hacer el sistema, sin depender directamente de detalles de infraestructura.

#### `ui/`

Contiene la capa de presentación. Aquí se ubican:

- páginas,
- controladores o viewmodels,
- widgets relacionados con la interacción del usuario.

Esta capa es la que define la experiencia visual e interactiva de la aplicación.


## Módulos principales

### `features/auth/`

Este módulo agrupa toda la lógica relacionada con autenticación y gestión del usuario.

Incluye funcionalidades como:

- registro de usuarios,
- verificación de correo,
- inicio y cierre de sesión,
- manejo de roles,
- control de sesión,
- y refresco de token.

Es un módulo crítico porque define el acceso al sistema y determina qué funcionalidades estarán disponibles según el rol autenticado.

---

### `features/courses/`

Este módulo se encarga de la gestión de cursos.

Aquí se implementa la lógica necesaria para:

- consultar cursos del docente,
- consultar cursos del estudiante,
- almacenar caché de cursos,
- y exponer esta información a la interfaz.

Su función principal es representar la relación entre los usuarios y los espacios académicos dentro de la aplicación.

---

### `features/groups/`

Este módulo administra la estructura de grupos y miembros.

Incluye funcionalidades como:

- consulta de grupos por curso,
- consulta de grupos del estudiante,
- consulta de miembros de un grupo,
- almacenamiento en caché de grupos,
- y acceso a compañeros asociados.

Este módulo es esencial para el proceso de evaluación entre pares, ya que define sobre quiénes puede evaluar cada estudiante.

---

### `features/assessments/`

Este módulo contiene la lógica relacionada con las evaluaciones.

Aquí se maneja:

- creación de evaluaciones,
- consulta de evaluaciones activas e inactivas,
- envío de respuestas por parte de los estudiantes,
- consulta de respuestas,
- consolidación de resultados,
- publicación de resultados,
- y visualización de métricas asociadas.

Este módulo representa el núcleo funcional del sistema, ya que implementa el flujo principal de evaluación entre pares.

---

### `features/home/`

Este módulo agrupa las pantallas principales de navegación según el rol del usuario.

Aquí se ubican vistas como:

- el home del estudiante,
- el home del docente,
- accesos rápidos a funcionalidades principales,
- navegación hacia cursos, grupos y evaluaciones,
- y pantallas auxiliares como la carga de CSV.

Su propósito es centralizar la experiencia inicial del usuario dentro de la aplicación.

---

## Ventajas de esta estructura

Esta organización del proyecto aporta varios beneficios:

- **Separación clara de responsabilidades:** cada módulo tiene un propósito específico.
- **Mayor mantenibilidad:** es más fácil ubicar dónde vive cada parte de la lógica.
- **Escalabilidad:** se pueden agregar nuevas funcionalidades sin desordenar la base de código.
- **Reutilización:** los recursos comunes se centralizan en `core`.
- **Mejor alineación con Clean Architecture:** la estructura favorece el desacoplamiento entre interfaz, lógica de negocio y acceso a datos.

En conjunto, esta estructura permite que la aplicación evolucione de manera ordenada, manteniendo coherencia técnica y facilitando tanto el desarrollo como las pruebas del sistema.
##  Cómo ejecutar

```bash
flutter pub get
flutter test -r expanded
```

---

## Link a videos demo con explicacion

- Demo de gestión académica: creación de usuarios, cursos, registro de estudiantes, procesamiento de CSV y verificación de grupos. Link: https://youtu.be/OTvEsbAeYAU
- Demo de evaluación y reportes. Link: https://youtu.be/FNSj_MzvMVM
- Pruebas de widget: ejecución y explicación cubriendo todos los widgets con mocks de controladores. Link: https://youtu.be/1kJik5O0iW4
- Pruebas de integración: flujo completo (profesor/estudiante) usando mock de cliente HTTP. Link: https://youtu.be/1kJik5O0iW4
- Implementación de caché: decisiones de diseño, datos almacenados y gestión (lectura/escritura/invalidez). Link: https://youtu.be/D729hQP_WD8
- Revisión del código: explicación del enfoque de arquitectura limpia (no archivo por archivo). Link: https://youtu.be/RnnTs1lVo3U


 ## Participación en pruebas con CEDU

El equipo desarrollador de este proyecto manifiesta su interés en que la aplicación sea evaluada en escenarios reales con cursos y profesores.

Entendemos que esto implica la cesión del código a la universidad para permitir su uso, evaluación y posibles modificaciones futuras, manteniendo el reconocimiento de los autores originales.

Integrantes del equipo:
- Alejandro Fontalvo Gómez
- Juan Morales Rincón
- Valerie Perez Contreras
- Sibeli Rodriguez Díaz

