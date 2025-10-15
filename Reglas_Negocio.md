# 🧩 Reglas de Negocio y Flujo de Procesos (BPMN)

## Reglas de Negocio Implementadas: 
  El modelo de datos fue diseñado para soportar las siguientes reglas de negocio críticas, que aseguran la consistencia y la integridad del sistema (implementadas mediante restricciones y Procedimientos Almacenados):

a. **Restricción de Unicidad (Integridad de Entidad):**  
* Un ejemplar no puede tener dos registros con el mismo código (`CODEJEMPLAR`).
* Un usuario no puede tener dos cuentas con el mismo código (`CODUSUARIO`).

b. **Límite de Préstamos Activos:**  
* Un usuario puede tener un **máximo de 5 préstamos activos** a la vez.

c. **Control de Disponibilidad y Recojo:**  
* Un ejemplar solo puede prestarse si hay al menos una copia disponible.
* Si todas las copias están prestadas, el libro se marca como "No Disponible".
* Para el recojo del ejemplar, es obligatorio que el usuario muestre el **Ticket de Reserva** generado por el sistema.

d. **Sistema de Notificaciones e Historial:**  
* **Notificaciones:** El sistema centralizará la visualización de vencimientos, multas, estado de reserva/préstamo y disponibilidad de ejemplares para el usuario.
* **Historial:** Se mantiene un historial detallado de préstamos y multas de cada usuario para el monitoreo de plazos y cumplimiento.

e. **Plazo de Devolución:**  
* La fecha de devolución esperada es **15 días calendario** después de la fecha inicial del préstamo.
* Al devolver el ejemplar, el usuario debe presentar el **Ticket de Préstamo** como comprobante.

f. **Gestión de Multas por Retraso:**  
* Si el ejemplar se devuelve después de la fecha esperada, se registra una multa automática.
* **Costo por Retraso:** Se genera un monto de **S/.20.00** por cada día calendario de retraso.

g. **Multas por Daño al Bien Prestado:**  
* Los bibliotecarios son los encargados de reportar los daños y generar la multa correspondiente.
* **Daños Menores (Superficiales):** Multa equivalente al **35% del valor del ejemplar**.
* **Daños Irreparables (Páginas/Cubiertas):** El usuario deberá pagar el **100% del valor del libro**.

h. **No Devolución de Ejemplares (Regla de Sanción Máxima):**  
* Si el ejemplar no ha sido devuelto **15 días después de la fecha límite**, se considera como "No Devuelto".
* **Sanción:** Se genera una multa equivalente al **valor total del libro**.
* **Bloqueo:** El usuario será **bloqueado permanentemente** del sistema de préstamo hasta que se resuelva la situación (pago o devolución).
* **Excepciones:** Las multas pueden ser ajustadas a criterio del bibliotecario responsable si el usuario presenta una razón válida y justificada.

## Flujo de Procesos (BPMN)
Los procesos se distinguen de la siguiente manera:

a. ACCESO AL SISTEMA DE PRÉSTAMO DE LIBROS  
Objetivo: El usuario inicia sesión en el sistema para comenzar un préstamo.
* El usuario ingresa al sistema mediante su nombre de usuario y contraseña.
* El sistema valida las credenciales: si son correctas, da acceso; de lo contrario, muestra un mensaje de error.

b. VERIFICACIÓN DE USUARIOS Y RESERVA DE LIBROS  
Objetivo: El sistema verifica la cantidad de préstamos activos del usuario antes de permitir una nueva reserva.
* El sistema consulta el historial de préstamos activos del usuario.
* Regla Crítica: Si el usuario ya tiene 5 préstamos activos, se muestra un mensaje de bloqueo.
* Si el usuario tiene menos de 5 préstamos activos, se permite continuar con la reserva.

c. GENERACIÓN DEL TICKET DE RESERVA  
Objetivo: Generar un ticket con la información de la solicitud de reserva para el préstamo.
* El usuario selecciona el libro y confirma la solicitud.
* El sistema genera un ticket de reserva con el código de libro, código de usuario, fecha de reserva y estado.
* El ticket es entregado al usuario de manera virtual (correo electrónico) como comprobante.

d. CONFIRMACIÓN DE RECOJO DEL LIBRO  
Objetivo: Confirmar la presencia física del usuario en la biblioteca dentro del plazo establecido.
* Regla Crítica: El ticket de reserva se mantiene activo solo durante 24 horas.
* El usuario debe acercarse a la biblioteca en ese plazo, mostrando el ticket de reserva.
* Si el usuario no recoge el libro, el sistema elimina automáticamente el ticket y notifica la cancelación.

e. GENERACIÓN DEL TICKET DE PRÉSTAMO  
Objetivo: El bibliotecario formaliza el préstamo en el sistema y genera el comprobante.
* El bibliotecario verifica la validez del ticket de reserva y la disponibilidad del ejemplar.
* Se genera el ticket de préstamo, incluyendo la fecha de devolución esperada (15 días calendario).
* El ticket es impreso y entregado al usuario.

f. ENTREGA DEL LIBRO AL USUARIO  
Objetivo: El bibliotecario entrega el libro y actualiza el estado del sistema.
* El bibliotecario marca el préstamo como realizado en el sistema, actualizando la disponibilidad del libro.
* El sistema agrega el préstamo al historial del usuario.
* El sistema envía un recordatorio automático de la fecha de devolución por correo.

g. PROCESO DE DEVOLUCIÓN DEL LIBRO  
Objetivo: Recibir el libro devuelto y verificar la fecha límite.
* El usuario devuelve el libro.
* El bibliotecario verifica la fecha de devolución esperada.
* Regla Crítica: Si el libro se devuelve tarde, se aplica una multa por retraso (S/.20.00 por cada día de retraso).

h. INSPECCIÓN DE DAÑOS AL LIBRO  
Objetivo: Revisar el estado físico del libro al momento de la devolución.
* El bibliotecario inspecciona el ejemplar.
* Si detecta daños, genera la multa correspondiente en el sistema, basándose en el tipo de daño evaluado.
* El sistema registra la multa en el historial del usuario.

i. PAGO DE MULTAS  
Objetivo: Gestionar el registro y la actualización del estado de las multas.
* El sistema muestra el monto total de multas acumuladas.
* El usuario puede pagar en línea o directamente en la biblioteca.
* El pago se registra, el saldo se actualiza y el estado de la multa cambia a 'Pagada'.

j. CIERRE DEL PROCESO  
Objetivo: Finalizar el ciclo de préstamo y mantener la consistencia del sistema.
* El sistema actualiza el historial del usuario.
* El libro devuelto (si está en buen estado) se marca como Disponible.
* En caso de no devolución en el plazo, el proceso culmina automáticamente con el registro de la sanción o pérdida.

El Diagrama BPMN es el pilar de la arquitectura, definiendo las secuencias operacionales del sistema.

![Proyecto BD](https://github.com/user-attachments/assets/495410b2-7c16-43fd-bfde-215bee737013)
