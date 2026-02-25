# Peer-Assiment-App
Students will develop a mobile application using Flutter that allows students to evaluate the performance and commitment of their peers in collaborative course activities.

# Decisión Final de Arquitectura y Diseño del Sistema

Tras el análisis comparativo de las propuestas iniciales de diseño, los diagramas de flujo planteados y la evaluación técnica realizada en equipo, se tomó la decisión definitiva de implementar la solución como una única aplicación móvil, gestionando múltiples roles de usuario dentro del mismo sistema, bajo el enfoque de Clean Architecture previamente establecido.

## 1. Decisión sobre la estructura de la aplicación

Inicialmente se contempló la posibilidad de desarrollar aplicaciones separadas para docentes y estudiantes. Sin embargo, después de evaluar los impactos técnicos, de mantenimiento y escalabilidad, se concluyó que la mejor alternativa es mantener una sola base de código, diferenciando funcionalidades mediante un sistema de autenticación y control de acceso basado en roles.

Esta decisión se fundamenta en los siguientes criterios:

- **Mantenibilidad:** Una única aplicación reduce la duplicación de lógica, evita inconsistencias y simplifica las actualizaciones futuras.
- **Consistencia en la experiencia de usuario:** Permite una interfaz coherente y uniforme para todos los actores del sistema.
- **Escalabilidad:** Facilita la incorporación futura de nuevos roles o funcionalidades sin necesidad de desarrollar sistemas independientes.
- **Optimización técnica:** Centraliza la gestión de estado, navegación e inyección de dependencias (GetX) en un solo entorno estructural.
- **Reducción de costos de desarrollo:** Disminuye complejidad, tiempo de implementación y esfuerzo de mantenimiento.

Por lo tanto, el sistema operará con autenticación centralizada, donde el usuario inicia sesión y, según su rol (docente o estudiante), el sistema habilita o restringe funcionalidades específicas.

## 2. Confirmación del enfoque arquitectónico

Se ratifica la implementación bajo el modelo de Clean Architecture, organizado en las siguientes capas:

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
