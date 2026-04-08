# Peer-Assessment-App

Peer-Assessment-App es una aplicación móvil desarrollada en **Flutter** que permite a los estudiantes evaluar el desempeño, compromiso y contribución de sus compañeros dentro de actividades académicas colaborativas.

La aplicación busca apoyar procesos de **evaluación entre pares**, proporcionando a los docentes una herramienta estructurada para gestionar evaluaciones, recopilar resultados y analizar métricas de participación dentro de trabajos grupales.

---

# Metas y Alcance de la Propuesta

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

## Propuestas seleccionadas

- **Propuesta de Sibeli Rodriguez** 
**link de figma en donde se encuentra diseño de arquitectura y flujo de trabajo:** https://www.figma.com/design/4j8UsgSlzQwDYfqMSoJR4C/Peer-Assessment-App-SibeliRodriguez?node-id=0-1&t=qiE0SfnopRlZp2vH-1
<img width="924" height="474" alt="Captura de pantalla 2026-03-04 a la(s) 8 18 24 a m" src="https://github.com/user-attachments/assets/951632a4-3364-4ad0-8e9d-bc65bcd598f5" />

- **Propuesta de Juan Morales**
**link de figma en donde se encuentra diseño de arquitectura y flujo de trabajo:** https://www.figma.com/design/UaG4cOGVYFf9znask4ky0l/Peer-Review-App?node-id=0-1&t=SiUXcwRFr1pXpfpb-1
<img width="718" height="723" alt="Captura de pantalla 2026-02-25 a la(s) 2 20 00 p m" src="https://github.com/user-attachments/assets/9cdbe970-6fca-4604-8436-723920cee85f" />

En lugar de descartar uno de los diseños, el equipo adoptó una **estrategia de integración (merge)** para la experiencia de usuario y la estructura de las pantallas.

El producto final combinará progresivamente:

- Patrones de navegación  
- Jerarquía de pantallas  
- Lógica de interacción  
- Flujo de datos entre módulos  

Esta integración se realizará de forma **iterativa durante el proceso de desarrollo**, permitiendo al equipo evaluar la usabilidad y el comportamiento del sistema a medida que se construye la aplicación.

A medida que avance el desarrollo, el equipo realizará las siguientes acciones:

- Implementar los flujos principales del sistema.  
- Comparar la usabilidad entre los distintos diseños propuestos.  
- Integrar los elementos de interfaz que proporcionen la mejor experiencia de usuario.  
- Refinar progresivamente las pantallas del sistema.  

Este enfoque flexible garantiza que la aplicación final evolucione hacia una **interfaz más intuitiva, coherente y técnicamente sólida**.


## Integración de Diseños en las Primeras Pantallas del Sistema (Login y Home)

Como parte del proceso de desarrollo de la interfaz de usuario de la aplicación, el equipo adoptó una estrategia de **integración progresiva de los diseños propuestos por los diferentes integrantes**. Este enfoque busca aprovechar las fortalezas presentes en cada propuesta para construir una interfaz que combine una estructura clara de interacción con una identidad visual consistente.

Para el **primer paso del flujo del sistema**, correspondiente al acceso inicial de los usuarios, se desarrollaron las pantallas de **Login** y **Home**, las cuales representan el punto de entrada principal a la aplicación.

En esta etapa del desarrollo se utilizó como base **la estructura de interfaz propuesta por Sibeli Rodríguez**, específicamente en lo relacionado con:

- La organización general de los elementos dentro de la pantalla.
- La jerarquía visual de los componentes.
- La disposición de los campos de autenticación.
- La ubicación de los botones de acción.
- La separación entre secciones de contenido y elementos interactivos.

Este diseño proporciona una **estructura clara y funcional**, permitiendo que el usuario identifique rápidamente los elementos necesarios para iniciar sesión y navegar dentro de la aplicación.

Sin embargo, con el objetivo de mantener una **identidad visual uniforme**, se decidió incorporar los elementos gráficos del diseño desarrollado por **Juan Sebastián**, particularmente en los siguientes aspectos:

- **Paleta de colores del sistema**
- **Tipografía utilizada en títulos y textos**
- **Estilos de botones**
- **Apariencia visual de los campos de entrada**

Gracias a esta combinación, las primeras pantallas del sistema integran elementos de ambas propuestas de la siguiente manera:

- **Estructura del layout:** Diseño de Sibeli Rodríguez  
- **Estilo visual (colores y tipografía):** Diseño de Juan Sebastián  Morales

Este enfoque permite validar en la práctica cómo interactúan ambos diseños dentro de la implementación real de la aplicación, permitiendo realizar ajustes y mejoras a medida que el desarrollo avanza.

Además, esta estrategia facilita un proceso de diseño **iterativo**, en el cual las futuras pantallas del sistema continuarán integrando y refinando elementos de ambas propuestas con el objetivo de lograr una interfaz final que sea tanto **intuitiva para el usuario como visualmente coherente**.

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

## Resultado de la Integración

Las primeras pantallas implementadas en el proyecto utilizan la **estructura del diseño de Sibeli combinada con la identidad visual del diseño de Juan Sebastián**, generando una interfaz equilibrada que combina claridad estructural con coherencia visual.

<img width="581" height="543" alt="Captura de pantalla 2026-03-09 a la(s) 7 42 42 p m" src="https://github.com/user-attachments/assets/024dbe50-5d90-46af-85b5-55f794b950bd" />
<img width="225" height="679" alt="Captura de pantalla 2026-03-09 a la(s) 7 48 50 p m" src="https://github.com/user-attachments/assets/e19abe62-ea9a-4c57-9861-0ab1990bc9bb" />

<img width="234" height="496" alt="Captura de pantalla 2026-03-09 a la(s) 7 49 42 p m" src="https://github.com/user-attachments/assets/c81a83f8-bde0-47ae-87d4-ffd75722442d" />

Esta integración continuará aplicándose en las siguientes etapas del desarrollo para construir una experiencia de usuario consistente en toda la aplicación.

---

##  Pruebas Automatizadas

Este proyecto incluye pruebas en dos niveles:

### Nivel 1 - Widget Tests con Mockito
Validan UI y comportamiento:
- Home
- Login
- Register
- Verify Email

### Nivel 3 - Integración
Valida flujo completo de autenticación usando:
- UI real
- Controller real
- Red mockeada (FakeDio)

Se implementaron pruebas automatizadas en el proyecto siguiendo dos niveles:

Nivel 1 (Widget Tests):
- HomeScreen
- LoginScreen
- RegisterScreen
- VerifyEmailScreen

Estas pruebas validan la interfaz gráfica, la interacción del usuario y la correcta renderización de elementos.

Nivel 3 (Integración):
- Se desarrolló un test para LoginScreen que utiliza:
  - Widget real
  - AuthenticationController real
  - Cliente HTTP simulado (MOCK FakeDio)

Este test valida el flujo completo de autenticación (login + consulta de usuario) sin depender de servicios externos.

Ejecución de pruebas:
flutter test -r expanded


##  Cómo ejecutar

```bash
flutter pub get
flutter test -r expanded

---

# 5. MUY IMPORTANTE

Antes de subir, asegúrate de NO incluir:

- `build/`
- `.dart_tool/`
- `.idea/`

Si no tienes `.gitignore`, dime y te lo doy.

---

# RESULTADO FINAL


1. Clonar el repo  
2. Ejecutar:

```bash
flutter pub get
flutter test -r expanded
