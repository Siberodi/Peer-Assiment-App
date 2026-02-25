# 1. Introducción

En muchos trabajos colaborativos es difícil medir realmente el compromiso y la participación individual de cada integrante del grupo. Aunque los docentes asignan notas grupales, muchas veces no se tiene evidencia clara del desempeño individual.

Por esta razón, propongo el desarrollo de una aplicación móvil en Flutter que permita gestionar evaluaciones entre pares dentro de cursos académicos, integrando los grupos que ya están creados en Brightspace y generando métricas automáticas por estudiante, grupo y actividad.

# 2. Referentes Analizados

## Peergrade

Es una plataforma enfocada en evaluación entre pares. Permite crear rúbricas y generar resultados automáticos.

Lo que aporta a mi propuesta:

	•	Sistema estructurado de evaluación.
	•	Resultados individuales y grupales.
	•	Organización clara por actividad.

## Brightspace

Es el LMS institucional donde se crean los cursos y los grupos (group categories).

Lo que aporta a mi propuesta:

	•	Gestión formal de estudiantes.
	•	Organización académica estructurada.
	•	Base para importar grupos al sistema.

## Google Forms

Herramienta comúnmente utilizada por docentes para realizar evaluaciones manuales.

Lo que aporta:

	•	Simplicidad.
	•	Formularios rápidos.
	•	Resultados automáticos.

Limitación: no ofrece métricas avanzadas ni análisis por grupo o estudiante a lo largo del tiempo.

# 3. Problema Identificado

Después de analizar las herramientas anteriores y conversar con docentes que trabajan con proyectos colaborativos, identifiqué los siguientes problemas:

	•	No existe una herramienta móvil especializada en evaluación de desempeño colaborativo.
	•	Los docentes pierden tiempo consolidando resultados manualmente.
	•	Se generan conflictos cuando no hay evidencia objetiva del compromiso individual.
	•	No hay trazabilidad del rendimiento a lo largo del curso.

# 4. Propuesta de Solución

Propongo desarrollar una única aplicación móvil con dos roles:

	•	Docente
	•	Estudiante

Decidí que fuera una sola aplicación con manejo de roles porque:

	•	Reduce la complejidad del sistema.
	•	Permite reutilizar componentes.
	•	Facilita el mantenimiento.
	•	Mejora la experiencia de usuario al mantener coherencia visual.


# 5. Arquitectura Propuesta

La aplicación seguirá el modelo de Arquitectura Limpia visto en clase.

Se dividirá en tres capas principales:

## Domain
Contiene la lógica de negocio, entidades y casos de uso.

## Data
Se encarga de la comunicación con Roble (autenticación y almacenamiento de datos).

## Presentation
Incluye las pantallas, controladores y widgets utilizando Flutter y GetX.

Esta estructura permite:

	•	Separación de responsabilidades.
	•	Escalabilidad.
	•	Mantenibilidad.
	•	Facilidad para realizar pruebas.

# 6. Tecnologías a Utilizar
	•	Flutter
	•	Dart
	•	GetX (manejo de estado, navegación e inyección de dependencias)
	•	Roble (autenticación y base de datos)
	•	Material Design

# 7. Manejo de Permisos

Siguiendo lo visto en clase sobre privacidad y control del usuario:

La aplicación solicitará únicamente los permisos necesarios:

	•	Permiso de ubicación (para validación contextual académica si se requiere).
	•	Permisos en segundo plano para notificaciones de evaluaciones activas.

Se aplicarán los principios de:

	•	Transparencia
	•	Minimización de datos
	•	Control del usuario

# 8. Flujo Funcional

## Flujo del Docente
	1.	Inicia sesión.
	2.	Crea un curso.
	3.	Envía invitaciones privadas a estudiantes.
	4.	Importa los grupos desde Brightspace.
	5.	Crea una evaluación con:
	•	Nombre
	•	Duración
	•	Tipo de visibilidad (pública o privada)
	6.	Activa la evaluación.
	7.	Visualiza resultados:
	•	Promedio por actividad
	•	Promedio por grupo
	•	Promedio por estudiante
	•	Detalle por criterio

## Flujo del Estudiante
	1.	Inicia sesión.
	2.	Se une a un curso mediante invitación.
	3.	Visualiza su grupo.
	4.	Recibe notificación de evaluación activa.
	5.	Evalúa a cada compañero (sin autoevaluación).
	6.	Envía la evaluación.
	7.	Visualiza resultados si la evaluación es pública.

# 9. Experiencia de Usuario

La aplicación se diseñará siguiendo los principios vistos en clase:

	•	Diseño limpio y minimalista.
	•	Navegación intuitiva.
	•	Botones ubicados en zonas accesibles (uso con pulgar).
	•	Reducción de escritura mediante opciones predefinidas.
	•	Optimización para sesiones rápidas.
	•	Diseño responsivo.

# 10. Justificación Final

Esta propuesta responde a una necesidad real en entornos académicos donde el trabajo colaborativo es frecuente, pero la evaluación individual es limitada.

La aplicación permite:

	•	Generar métricas objetivas.
	•	Reducir conflictos entre estudiantes.
	•	Facilitar el trabajo del docente.
	•	Centralizar el proceso de evaluación.
	•	Garantizar trazabilidad a lo largo del curso.
