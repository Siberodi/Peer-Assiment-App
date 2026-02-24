## 1. Referentes asociados a la App

### CATME Smarter Teamwork
CATME Smarter Teamwork es una plataforma de evaluación entre pares desarrollada por Purdue University, diseñada para analizar el desempeño individual dentro del trabajo en equipo. Su enfoque principal es medir la contribución real de cada integrante mediante evaluaciones anónimas entre compañeros y métricas detalladas que incluyen liderazgo, compromiso, interacción y responsabilidad. El sistema permite identificar miembros con baja participación y genera reportes automáticos que ayudan al docente a tomar decisiones más justas al asignar calificaciones. Aunque su interfaz no es moderna y presenta cierta curva de aprendizaje, su valor radica en la rigurosidad con la que evalúa el aporte individual. Este referente evidencia la importancia de incorporar criterios claros que permitan evaluar la contribución real dentro del grupo, lo cual se refleja en la propuesta mediante la evaluación de aspectos como compromiso, contribución y actitud.

<img width="299" height="100" alt="CATME1" src="https://github.com/user-attachments/assets/e50e7b35-c57a-4de6-b188-f58e79200dd6" />
<img width="598" height="327" alt="CATME2" src="https://github.com/user-attachments/assets/1d0b76db-d39c-4958-a783-116641ff8df0" />



### PeerScholar
PeerScholar es una plataforma educativa orientada al aprendizaje colaborativo mediante la revisión estructurada entre pares. Permite a los estudiantes evaluar el trabajo de sus compañeros utilizando rúbricas, además de valorar la calidad del feedback recibido, promoviendo así la reflexión crítica y la mejora continua. Este sistema no solo mide el desempeño, sino que también fortalece habilidades analíticas y de pensamiento crítico, al incentivar que los estudiantes analicen tanto el trabajo de otros como el propio. Aunque puede resultar más adecuado para trabajos escritos y puede ser complejo para evaluaciones rápidas, su estructura favorece una retroalimentación significativa y un aprendizaje más profundo. Este referente aporta a la propuesta la idea de que la evaluación entre pares no debe limitarse a asignar una calificación, sino que debe fomentar la reflexión, la responsabilidad y el aprendizaje colaborativo.

### Moodle: Workshop Peer Review
El módulo Workshop Peer Review de Moodle permite implementar evaluaciones entre pares dentro de cursos virtuales, integrándose directamente con el entorno educativo. Esta herramienta automatiza la asignación de evaluaciones entre estudiantes, permite el uso de rúbricas personalizadas, admite evaluaciones anónimas y posibilita calificar tanto el trabajo entregado como la calidad de la evaluación realizada. Su principal fortaleza es la integración con el ecosistema académico y la automatización del proceso, lo que facilita la gestión docente y garantiza coherencia con la estructura del curso. Sin embargo, su configuración inicial puede resultar compleja y la interfaz no siempre es intuitiva para usuarios nuevos. Este referente respalda la importancia de integrar la evaluación entre pares dentro del flujo natural del curso y justifica la integración con plataformas educativas como Brightspace en la solución propuesta.

## 2. Diseño de la solución

La solución propone desarrollar una única aplicación móvil en Flutter que funcione con dos roles diferenciados: docente y estudiante. A través del proceso de autenticación, la aplicación identifica el rol del usuario y habilita las funciones correspondientes, mostrando únicamente las pantallas y permisos permitidos para cada perfil.

El docente podrá crear y gestionar cursos, invitar participantes, importar categorías y grupos desde Brightspace, activar evaluaciones con ventanas de tiempo y visibilidad (pública o privada), y consultar reportes detallados del desempeño individual y grupal. Por su parte, el estudiante podrá acceder a sus cursos, responder evaluaciones dentro del periodo permitido y visualizar los resultados cuando estén disponibles según la configuración de visibilidad definida por el docente.

Esta separación por roles se implementa mediante control de permisos, rutas protegidas y vistas específicas, garantizando coherencia en la experiencia de usuario sin duplicar funcionalidades ni mantener aplicaciones separadas.

Desde el punto de vista técnico, la aplicación se estructura siguiendo **Clean Architecture**, lo que permite separar la presentación, la lógica de negocio y el acceso a datos, facilitando la escalabilidad, mantenibilidad y pruebas del sistema. **GetX** se emplea para la gestión de estado, navegación e inyección de dependencias, permitiendo interfaces reactivas y organizadas por módulos.

Para la autenticación y persistencia de datos se utiliza **Roble**, que gestiona usuarios, cursos, evaluaciones y resultados. Además, la integración con **Brightspace** permite sincronizar automáticamente las categorías y grupos del curso, garantizando coherencia con la estructura académica oficial.

La decisión de utilizar una sola aplicación con roles diferenciados reduce la complejidad de desarrollo, simplifica el mantenimiento y facilita la adopción por parte de los usuarios, ya que docentes y estudiantes acceden a la misma plataforma con experiencias adaptadas a sus necesidades.

## 3. Descripción detallada del flujo funcional

1. **Inicio de sesión y rol:** el usuario entra a la app, se autentica (Roble) y el sistema identifica si es docente o estudiante; con eso se habilitan pantallas y permisos según el rol.

2. **Creación del curso (docente):** el docente crea un curso (nombre/código/descripción). El curso queda registrado en Roble y aparece en el panel del docente.

3. **Invitación y unión al curso:** el docente invita estudiantes al curso. El estudiante acepta y el curso se agrega a su lista.

4. **Importación de grupos desde Brightspace:** en el curso, el docente selecciona “Importar desde Brightspace”, elige la categoría de grupo correspondiente y la app sincroniza categorías, grupos y miembros. La estructura importada se guarda en Roble como base para evaluaciones.

5. **Actualización opcional de grupos:** si hubo cambios en Brightspace, el docente puede “Actualizar sincronización” para traer la composición más reciente y mantener coherencia con el LMS.

6. **Creación y activación de evaluación (docente):** el docente crea una evaluación y define: nombre, categoría de grupo, ventana de tiempo (inicio/cierre o duración) y visibilidad (pública o privada). Al activar, la evaluación pasa a estado “activa”.

7. **Notificación a estudiantes:** al activarse la evaluación, la app envía una notificación a los estudiantes de los grupos.

8. **Acceso a evaluación (estudiante):** el estudiante entra al curso, abre la evaluación activa y la app carga automáticamente su grupo y la lista de compañeros.

9. **Regla de no autoevaluación:** la app excluye al estudiante de la lista de evaluados; sólo puede calificar a sus compañeros.

10. **Evaluación por rúbrica:** para cada compañero, el estudiante selecciona niveles basados en los criterios (puntualidad, contribuciones, compromiso y actitud) según la escala definida. La app valida que todos los criterios estén completados.

11. **Envío de la evaluación:** el estudiante confirma y envía. La app guarda en Roble el registro con fecha/hora y marca el estado como “enviado”.

12. **Control de ventana de tiempo:** mientras la evaluación esté activa, otros estudiantes pueden enviar; al llegar la hora de cierre, la app bloquea el envío y marca la evaluación como “cerrada” (cierre automático).

13. **Consolidación de resultados:** al cerrarse, el sistema calcula promedios por estudiante (por criterio y total), además de agregados por grupo y por actividad; estos resultados quedan disponibles en el módulo de reportes.

14. **Visualización de reportes (docente):** el docente consulta reportes en varias vistas: promedio por actividad, por grupo, por estudiante y detalle por criterio.

15. **Resultados para estudiantes (opcional por visibilidad):** si la evaluación es pública, los estudiantes pueden ver resultados consolidados (puntajes por criterio y total) de su grupo; si es privada, los resultados solo los ve el docente.

## 4. Justificación de la propuesta

La aplicación propuesta constituye una solución pertinente para evaluar el trabajo colaborativo, ya que responde a una dificultad frecuente en el ámbito académico: determinar de manera justa el aporte individual dentro de los equipos. Referentes como **CATME Smarter Teamwork** evidencian que la evaluación entre pares permite identificar niveles reales de participación, compromiso y responsabilidad, evitando que todos los estudiantes reciban la misma calificación sin considerar su contribución. Implementar este enfoque en una aplicación móvil facilita un proceso estructurado, accesible y basado en criterios objetivos.

Asimismo, plataformas como **PeerScholar** demuestran que la evaluación entre compañeros no solo sirve para asignar calificaciones, sino que también fortalece el pensamiento crítico, la autoevaluación y la responsabilidad individual. Al evaluar a sus pares, los estudiantes reflexionan sobre el desempeño del equipo y desarrollan habilidades de análisis y retroalimentación constructiva, convirtiendo la evaluación en una herramienta formativa que mejora el aprendizaje colaborativo.

Por su parte, el módulo **Workshop Peer Review de Moodle** resalta la importancia de integrar la evaluación dentro del flujo natural del curso y del ecosistema educativo. Siguiendo este principio, la aplicación propuesta se integra con Brightspace para sincronizar grupos y automatizar procesos como la asignación de evaluaciones, el control de tiempos y la consolidación de resultados. De esta manera, la solución no solo reduce la carga administrativa del docente, sino que también promueve una experiencia de aprendizaje colaborativo más transparente, equitativa y eficiente.

## 5. Diagrama de flujo (Figma)

https://www.figma.com/design/UaG4cOGVYFf9znask4ky0l/Peer-Review-App?node-id=0-1&t=SiUXcwRFr1pXpfpb-1

**Docs adicional:** https://docs.google.com/document/d/1_WIdR1pM9a7EVggrL1flk5wtCQurQ1poYbLEBWXNYqs/edit?usp=sharing 
