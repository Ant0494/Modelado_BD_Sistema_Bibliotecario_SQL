# Modelado de Base de Datos para Sistema de Préstamos Bibliotecarios

## 1. Contexto General y Objetivo (OLTP)

**Tema:** Diseño y desarrollo de la base de datos para un sistema de gestión de préstamos de ejemplares en una biblioteca.

**Objetivo:** Demostrar el dominio del ciclo completo de diseño de la Base de Datos, desde la comprensión del negocio hasta la implementación física. El modelo es **Transaccional (OLTP)**, rigurosamente normalizado a **Tercera Forma Normal (3FN)**.

Este proyecto muestra el diseño y desarrollo de la base de datos para un sistema de préstamo de ejemplares de libros en una biblioteca; el cual puede adaptarse a las bibliotecas de cualquier institución, siendo así que los actores involucrados sigan los procesos implicados en la reserva de préstamo, el préstamo, la devolución y la generación y pago de multas en casos corresponda.
El diseño es flexible y adaptable a las necesidades de cualquier institución que gestione una biblioteca. Permitirá una gestión eficiente de los libros y los usuarios, reflejando en una mejora en la experiencia de los usuarios y en la optimización de los recursos de la biblioteca.

---

## 2. Diseño Metodológico: Procesos y Reglas de Negocio

### 2.1. Flujo de Procesos (BPMN)
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



## 3. Reglas de Negocio Implementadas: 
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

---

## 3. Análisis de Datos y Normalización Detallada (3FN)

### 3.1. Lista de Atributos Iniciales y Clarificación
El modelado se inició con el análisis de la siguiente lista exhaustiva de atributos, que representaba la base de datos desnormalizada:

* **Atributos Completos:**
    `CODLIBRO`, `TITULO`, `AUTOR`, `CANTIDAD`, `CODUSUARIO`, `NOMBREUSUARIO`, `TELEFONOUSUARIO`, `CORREOUSUARIO`, `CODBIBLIOTECARIO`, `NOMBREBIBLIO`, `TELEFONOBIBLIO`, `CORREOBIBLIO`, `ESTADO`, `CODEJEMPLAR`, `ESTADO_EJEMPLAR`, `CODRESERVA`, `ESTADO_RESERVA`, `FEC_INICIO_RESERVA`, `HOR_INICIO_RESERVA`, `FEC_FIN_RESERVA`, `HOR_FIN_RESERVA`, `CODPRESTAMO`, `ESTADO_PRESTAMO`, `FECHAPRESTAMO`, `FECHAENTREGA`, `DETALLE_PRESTAMO`, `FECHADEVOLUCIONREAL`, `CODMULTA`, `ESTADO_MULTA`, `MOTIVO_MULTA`, `MONTO`, `FECHAGENERACION`, `CODPAGOMULTA`, `FECHAPAGO`, `MONTOPAGADO`, `METODOPAGO`.
    
### 3.2. Proceso de Normalización (1FN, 2FN, 3FN)

#### **a. Resultado 1.ª Forma Normal (1FN)**
Se eliminaron los grupos repetitivos y se definió una clave primaria para las relaciones:
¡Absolutamente! Continuemos paso a paso. He aplicado las comillas invertidas simples (backticks) a todos los atributos de la Primera Forma Normal (1FN).

Aquí tienes la sección de Normalización con el formato actualizado. Observa cómo los atributos de 1FN ahora están resaltados:

Markdown

## 3. Análisis de Datos y Normalización Detallada (3FN)

### 3.1. Lista de Atributos Iniciales y Clarificación
El modelado se inició con el análisis de la siguiente lista exhaustiva de atributos, que representaba el estado inicial de la base de datos desnormalizada:

* **Atributos Completos:**
    `CODLIBRO`, `TITULO`, `AUTOR`, `CANTIDAD`, `CODUSUARIO`, `NOMBREUSUARIO`, `TELEFONOUSUARIO`, `CORREOUSUARIO`, `CODBIBLIOTECARIO`, `NOMBREBIBLIO`, `TELEFONOBIBLIO`, `CORREOBIBLIO`, `ESTADO`, `CODEJEMPLAR`, `ESTADO_EJEMPLAR`, `CODRESERVA`, `ESTADO_RESERVA`, `FEC_INICIO_RESERVA`, `HOR_INICIO_RESERVA`, `FEC_FIN_RESERVA`, `HOR_FIN_RESERVA`, `CODPRESTAMO`, `ESTADO_PRESTAMO`, `FECHAPRESTAMO`, `FECHAENTREGA`, `DETALLE_PRESTAMO`, `FECHADEVOLUCIONREAL`, `CODMULTA`, `ESTADO_MULTA`, `MOTIVO_MULTA`, `MONTO`, `FECHAGENERACION`, `CODPAGOMULTA`, `FECHAPAGO`, `MONTOPAGADO`, `METODOPAGO`.

### 3.2. Proceso de Normalización (1FN, 2FN, 3FN)


#### **a. Resultado 1.ª Forma Normal (1FN)**
Se eliminaron los grupos repetitivos y se definió una clave primaria para las relaciones:

PRESTAMO: `CODPRESTAMO`, `ESTADO_PRESTAMO`, `FECHAPRESTAMO`, `FECHAENTREGA`, `CODBIBLIOTECARIO`, `ESTADOB`, `NOMBRE`, `TELEFONO`, `CORREO`, `CODRESERVA`, `ESTADO_RESERVA`, `FEC_INICIO_RESERVA`, `HOR_INICIO_RESERVA`, `FEC_FIN_RESERVA`, `HOR_FIN_RESERVA`, `CODUSUARIO`, `ESTADOU`, `NOMBRE`, `TELEFONO`, `CORREO`, `CODLIBRO`, `ESTADOL`, `TITULO`, `AUTOR`, `CANTIDAD`, `CODEJEMPLAR`, `ESTADO_EJEMPLAR`, `CODDETALLE_PRESTAMO`, `ESTADO_LIBRO`, `FECHADEVOLUCIONREAL` 

MULTA: `CODMULTA`, `ESTADO_MULTA`, `MOTIVO_MULTA`, `MONTO`, `FECHAGENERACION`, `CODPAGOMULTA`, `FECHAPAGO`, `MONTOPAGADO`, `METODOPAGO`.


#### **b. Resultado 2.ª Forma Normal (2FN)**
Se eliminaron las dependencias parciales, aislando la información que no dependía de la clave primaria completa:

PRESTAMO: `CODPRESTAMO`, `ESTADO_PRESTAMO`, `FECHAPRESTAMO`, `FECHAENTREGA`, `CODBIBLIOTECARIO`, `CODRESERVA`, `CODUSUARIO`, `CODLIBRO`, `CODEJEMPLAR`, `CODDETALLE_PRESTAMO`  

BIBLIOTECARIO: `CODBIBLIOTECARIO`, `ESTADOB`, `DESC_ESTADOB`, `NOMBRE`, `TELEFONO`, `CORREO`  

RESERVA: `CODRESERVA`, `ESTADO_RESERVA`, `FEC_INICIO_RESERVA`, `HOR_INICIO_RESERVA`, `FEC_FIN_RESERVA`, `HOR_FIN_RESERVA`, `CODUSUARIO`, `CODLIBRO`, `CODEJEMPLAR`  

USUARIO: `CODUSUARIO`, `ESTADOU`, `DESC_ESTADOU`, `NOMBRE`, `TELEFONO`, `CORREO`  

LIBRO: `CODLIBRO`, `CODEJEMPLAR`, `ESTADOL`, `DESC_ESTADOL`, `TITULO`, `AUTOR`, `CANTIDAD`  

EJEMPLAR_LIBRO: `CODLIBRO`, `CODEJEMPLAR`, `CODESTADO_EJEMPLAR`, `DESC_ESTADO_EJEMPLAR`  

DETALLE_PRESTAMO: `CODPRESTAMO`, `CODEJEMPLAR` `CODDETALLE_PRESTAMO`, `CODESTADO_LIBRO`, `DESC_ESTADO_LIBRO`, `FECHADEVOLUCIONREAL`  

MULTA: `CODMULTA`, `CODESTADO_MULTA`, `DESC_ESTADO_MULTA`, `CODMOTIVO_MULTA`, `DESC_MOTIVO_MULTA`, `MONTO`, `FECHAGENERACION`, `CODPAGOMULTA`  

PAGO_MULTA: `CODPAGOMULTA`, `FECHAPAGO`, `MONTOPAGADO`, `METODOPAGO`  


#### **c. Resultado 3.ª Forma Normal (2FN)**
Se eliminaron las dependencias transitivas, logrando el modelo final con la creación de Tablas de Catálogo para normalizar todos los estados:

PRESTAMO: `CODPRESTAMO`, `ESTADO_PRESTAMO`, `FECHAPRESTAMO`, `FECHAENTREGA`, `CODBIBLIOTECARIO`, `CODRESERVA`, `CODUSUARIO`, `CODLIBRO`, `CODEJEMPLAR`, `CODDETALLE_PRESTAMO`  

BIBLIOTECARIO: `CODBIBLIOTECARIO`, `CODESTADO`, `NOMBRE`, `TELEFONO`, `CORREO`  

RESERVA: `CODRESERVA`, `ESTADO_RESERVA`, `FEC_INICIO_RESERVA`, `HOR_INICIO_RESERVA`, `FEC_FIN_RESERVA`, `HOR_FIN_RESERVA`, `CODUSUARIO`, `CODLIBRO`, `CODEJEMPLAR`  

USUARIO: `CODUSUARIO`, `CODESTADO`, `NOMBRE`, `TELEFONO`, `CORREO`  

LIBRO: `CODLIBRO`, `CODEJEMPLAR`, `CODESTADO`, `TITULO`, `AUTOR`, `CANTIDAD`  

ESTADO: `CODESTADO`, `DESC_ESTADO`  

EJEMPLAR_LIBRO: `CODLIBRO`, `CODEJEMPLAR`, `CODESTADO_EJEMPLAR`  

ESTADO_EJEMPLAR: `CODESTADO_EJEMPLAR`, `DESC_ESTADO_EJEMPLAR`  

DETALLE_PRESTAMO: `CODPRESTAMO`, `CODEJEMPLAR` `CODDETALLE_PRESTAMO`, `CODESTADO_LIBRO`, `FECHADEVOLUCIONREAL`  

ESTADO_LIBRO: `CODESTADO_LIBRO`, `DESC_ESTADO_LIBRO`  

MULTA: `CODMULTA`, `CODESTADO_MULTA`, `CODMOTIVO_MULTA`, `MONTO`, `FECHAGENERACION`, `CODPAGOMULTA`  

MOTIVO_MULTA: `CODMOTIVO_MULTA`, `DESC_MOTIVO_MULTA`  

ESTADO_MULTA: `CODESTADO_MULTA`, `DESC_ESTADO_MULTA`  

PAGO_MULTA: `CODPAGOMULTA`, `FECHAPAGO`, `MONTOPAGADO`, `METODOPAGO`  

## 4. Diseño del Modelo Lógico (Entidades y Atributos)

El siguiente es el resultado final del proceso de normalización (3FN), donde se detallan las entidades y todos sus atributos, especificando las claves primarias (PK) y foráneas (FK).

### 4.1. Entidades y Atributos de la Base de Datos de la Biblioteca

#### a. ESTADO
**Representa el estado general de entidades como LIBRO, BIBLIOTECARIO y USUARIO.**
* **Atributos:**
    * `CODESTADO` (ID único del estado, **Clave Primaria - PK**)
    * `DESC_ESTADO` (Descripción del estado)

#### b. LIBRO
**Representa el libro registrado en la biblioteca.**
* **Atributos:**
    * `CODLIBRO` (ID único del libro, **PK**)
    * `CODESTADO` (ID único del estado, **Clave Foránea - FK**)
    * `TITULO` (Título del libro)
    * `AUTOR` (Autor del libro)
    * `CANTIDAD` (Cantidad de copias)

#### c. USUARIO
**Registra a los miembros que utilizan los servicios de la biblioteca.**
* **Atributos:**
    * `CODUSUARIO` (ID único del usuario, **PK**)
    * `CODESTADO` (ID único del estado, **FK**)
    * `NOMBRE` (Nombre del usuario)
    * `TELEFONO` (Número de teléfono)
    * `CORREO` (Correo electrónico único)

#### d. BIBLIOTECARIO
**Registra al personal encargado de la biblioteca.**
* **Atributos:**
    * `CODBIBLIOTECARIO` (ID único del empleado, **PK**)
    * `CODESTADO` (ID único del estado, **FK**)
    * `NOMBRE` (Nombre del empleado)
    * `TELEFONO` (Teléfono del empleado)
    * `CORREO` (Correo del empleado)

#### e. ESTADO_EJEMPLAR
**Registra el detalle del estado físico del ejemplar.**
* **Atributos:**
    * `CODESTADO_EJEMPLAR` (ID único del estado de cada ejemplar, **PK**)
    * `DESC_ESTADO_EJEMPLAR` (Descripción del estado en el que se encuentra el ejemplar)

#### f. EJEMPLAR_LIBRO
**Registra el detalle de cada ejemplar por tipo de libro.**
* **Atributos:**
    * `CODEJEMPLAR` (ID único del ejemplar, **PK**)
    * `CODLIBRO` (ID único del libro, **FK**)
    * `CODESTADO_EJEMPLAR` (ID único del estado de cada ejemplar, **FK**)

#### g. ESTADO_RESERVA
**Estado de la reserva registrada por el usuario en el sistema.**
* **Atributos:**
    * `CODESTADO_RESERVA` (ID único del estado de la reserva, **PK**)
    * `DESC_ESTADO_RESERVA` (Descripción del estado de la reserva)

#### h. RESERVA
**Reserva registrada por el usuario en el sistema.**
* **Atributos:**
    * `CODRESERVA` (ID único de la reserva, **PK**)
    * `CODESTADO_RESERVA` (ID único del estado de la reserva, **FK**)
    * `CODUSUARIO` (ID único del usuario, **FK**)
    * `CODEJEMPLAR` (ID único del ejemplar, **FK**)
    * `FEC_INICIO_RESERVA` (Fecha de registro de la reserva)
    * `HOR_INICIO_RESERVA` (Hora en que se realizó la reserva)
    * `FEC_FIN_RESERVA` (Fecha de fin de la reserva)
    * `HOR_FIN_RESERVA` (Hora en que caduca la reserva)

#### i. ESTADO_PRESTAMO
**Estado del préstamo registrado por el bibliotecario.**
* **Atributos:**
    * `CODESTADO_PRESTAMO` (ID único del estado de la reserva, **PK**)
    * `DESC_ESTADO_PRESTAMO` (Descripción del estado del préstamo)

#### j. PRÉSTAMO
**Registra los préstamos realizados por los usuarios.**
* **Atributos:**
    * `CODPRESTAMO` (ID único del préstamo, **PK**)
    * `CODESTADO_PRESTAMO` (ID único del estado de la reserva, **FK**)
    * `CODRESERVA` (ID único de la reserva, **FK**)
    * `CODBIBLIOTECARIO` (ID único del empleado, **FK**)
    * `FECHAPRESTAMO` (Fecha de registro del préstamo)
    * `FECHAENTREGA` (Fecha de devolución del bien prestado)

#### k. DETALLE_PRESTAMO
**Registra el detalle del préstamo de libros por los usuarios.**
* **Atributos:**
    * `CODDETALLE` (ID único del detalle del préstamo, **PK**)
    * `CODPRESTAMO` (ID único del préstamo, **FK**)
    * `CODEJEMPLAR` (ID único del ejemplar, **FK**)
    * `FECHADEVOLUCIONREAL` (Fecha registrada si se devuelve el libro)

#### l. ESTADO_MULTA
**Estado de la multa registrada en el sistema.**
* **Atributos:**
    * `CODESTADO_MULTA` (ID único del estado de la multa, **PK**)
    * `DESC_ESTADO_MULTA` (Descripción del estado de la multa)

#### m. MOTIVO_MULTA
**Razón o causa de la multa registrada en el sistema.**
* **Atributos:**
    * `CODMOTIVO_MULTA` (ID único del motivo de la multa, **PK**)
    * `DESC_MOTIVO_MULTA` (Descripción del motivo de la multa)

#### n. MULTA
**Detalle de la multa, en caso exista retraso en la devolución o daños.**
* **Atributos:**
    * `CODMULTA` (ID único de la multa, **PK**)
    * `CODDETALLE` (ID único del detalle del préstamo, **FK**)
    * `CODMOTIVO_MULTA` (ID único del motivo de la multa, **FK**)
    * `CODESTADO_MULTA` (ID único del estado de la multa, **FK**)
    * `MONTO` (Valor monetario de la multa)
    * `FECHAGENERACION` (Fecha en la que se generó la multa)

#### ñ. PAGO_MULTA
**Registro del pago de la multa generada.**
* **Atributos:**
    * `CODPAGOMULTA` (ID único del pago de la multa, **PK**)
    * `CODMULTA` (ID único de la multa, **FK**)
    * `FECHAPAGO` (Fecha de registro de pago de la multa)
    * `MONTOPAGADO` (Monto pagado en base a lo generado en el sistema)
    * `METODOPAGO` (Forma de pago de la multa: Efectivo, Tarjeta)

### 4.2. Tablas de Catálogo y Definición de Estados

Las siguientes tablas contienen los valores permitidos (dominios) para los atributos de estado en el modelo lógico:

| Tabla de Catálogo | Descripción | Ejemplos de Valores Insertados |
| :--- | :--- | :--- |
| `ESTADO` | Estado general de entidades (`Usuario`, `Libro`, `Bibliotecario`). | `'Activo'`, `'Inactivo'` |
| `ESTADO_EJEMPLAR` | Estado físico o de préstamo del libro específico. | `'Disponible'`, `'Reservado'`, `'Prestado'`, `'Dañado'`, `'En reparación'` |
| `ESTADO_RESERVA` | Estado de la solicitud de reserva. | `'Activa'`, `'Inactiva'`, `'Procesada'` |
| `ESTADO_PRESTAMO` | Estado del préstamo en sí. | `'En préstamo'`, `'Devuelto'`, `'Retrasado'` |
| `ESTADO_MULTA` | Estado financiero de la multa. | `'Pendiente'`, `'Pagada'` |
| `MOTIVO_MULTA` | Causa de la sanción. | `'Retraso'`, `'Dañado'`, `'No devuelto'` |

## 4.3. Relaciones entre Entidades

A continuación, se detalla la lógica de las relaciones del Modelo Lógico, definiendo la cardinalidad y la clave foránea (FK) que se utiliza para implementar la relación.

#### a. USUARIO - RESERVA
* **Relación:** Uno a muchos (Un usuario puede realizar varias reservas, pero cada reserva pertenece a un único usuario).
* **Clave Foránea:** `CODUSUARIO`.

#### b. LIBRO - EJEMPLAR_LIBRO
* **Relación:** Uno a muchos (Un libro puede estar asociado con muchos ejemplares, pero cada ejemplar corresponde a un único libro).
* **Clave Foránea:** `CODLIBRO`.

#### c. EJEMPLAR_LIBRO – RESERVA
* **Relación:** Uno a muchos (Un ejemplar puede estar asociado con muchas reservas, pero cada reserva corresponde a un único ejemplar).
* **Clave Foránea:** `CODEJEMPLAR`.

#### d. BIBLIOTECARIO - PRESTAMO
* **Relación:** Uno a muchos (Un bibliotecario puede gestionar varios préstamos, pero cada préstamo es gestionado por un solo bibliotecario).
* **Clave Foránea:** `CODBIBLIOTECARIO`.

#### e. RESERVA - PRESTAMO
* **Relación:** Uno a uno (Una reserva puede generar un préstamo único, y cada préstamo corresponde a una única reserva).
* **Clave Foránea:** `CODRESERVA`.

#### f. PRESTAMO – DETALLE_PRESTAMO
* **Relación:** Uno a muchos (Un préstamo puede incluir varios detalles de préstamo, pero cada detalle de préstamo pertenece a un único préstamo).
* **Clave Foránea:** `CODPRESTAMO`.

#### g. EJEMPLAR_LIBRO – DETALLE_PRESTAMO
* **Relación:** Uno a muchos (Un ejemplar puede estar relacionado con múltiples detalles de préstamo, pero cada detalle de préstamo hace referencia a un único ejemplar).
* **Clave Foránea:** `CODEJEMPLAR`.

#### h. DETALLE_PRESTAMO – MULTA
* **Relación:** Uno a muchos (Un detalle de préstamo puede generar varias multas, como por retraso o daño, pero cada multa corresponde a un único detalle de préstamo).
* **Clave Foránea:** `CODDETALLE`.

#### i. MULTA – PAGO_MULTA
* **Relación:** Uno a uno (Cada multa puede ser pagada en un único pago, y cada pago se relaciona con una única multa).
* **Clave Foránea:** `CODMULTA`.

  ## 5. Diagrama Entidad-Relación (DER)

El Diagrama Entidad-Relación (DER) representa gráficamente el Modelo Lógico de la base de datos de la biblioteca, mostrando todas las entidades normalizadas (3FN) y las relaciones.

La imagen a continuación ilustra las tablas y sus conexiones.

![ProyectoBD](https://github.com/user-attachments/assets/c53ea37b-a629-4610-91a6-02dec9f601ff)

## 6. Implementación del Script SQL

El script de la base de datos se ha dividido en cuatro secciones lógicas, siguiendo las mejores prácticas para la implementación y gestión de bases de datos. Esta división facilita la ejecución progresiva y la identificación de errores en cada etapa.

### 6.1. Estructura del Script SQL

| Sección del Script | Descripción y Contenido | Propósito |
| :--- | :--- | :--- |
| **a. Creación de la BD y Tablas** | Contiene el comando `CREATE DATABASE` y las sentencias `CREATE TABLE` para todas las entidades definidas en el Modelo Lógico. | Establecer la estructura base del sistema. |
| **b. Definición de Relaciones (FK)** | Incluye las sentencias `ALTER TABLE` con las cláusulas `ADD CONSTRAINT` para definir todas las Claves Foráneas (`FK`). | Garantizar la integridad referencial y las reglas de negocio entre entidades. |
| **c. Población de Tablas (INSERT)** | Contiene las sentencias `INSERT INTO` para cargar los datos iniciales o de catálogo (`ESTADO`, `MOTIVO_MULTA`, etc.). | Proporcionar datos base para el funcionamiento inmediato del sistema. |
| **d. Creación de Objetos Programables** | Incluye la creación de Vistas, Funciones (UDFs) y Procedimientos Almacenados (`Stored Procedures`). | Optimizar consultas complejas, automatizar tareas y mejorar la seguridad de las transacciones. |


### 6.2. Script SQL

#### a. Creación de la BD y Tablas

Esta sección incluye la creación de la base de datos y todas las tablas del sistema de gestión bibliotecaria, estableciendo las claves primarias (PK) y las claves foráneas (FK) necesarias para la integridad inicial.

```sql
CREATE DATABASE ProyectoBD_Finalv3

USE ProyectoBD_Finalv3

CREATE TABLE ESTADO(
CODESTADO INT PRIMARY KEY IDENTITY(1,1),
DESC_ESTADO VARCHAR(40) NOT NULL)
;

CREATE TABLE LIBRO(
CODLIBRO INT PRIMARY KEY IDENTITY(1,1),
CODESTADO INT NOT NULL,
TITULO NVARCHAR(100) NOT NULL,
AUTOR NVARCHAR(50) NOT NULL,
CANTIDAD INT NOT NULL,
CONSTRAINT FK_ESTADOL FOREIGN KEY (CODESTADO) REFERENCES ESTADO(CODESTADO));

CREATE TABLE USUARIO(
CODUSUARIO INT PRIMARY KEY IDENTITY(1,1),
CODESTADO INT NOT NULL,
NOMBRE NVARCHAR(50) NOT NULL,
TELEFONO VARCHAR(9) NOT NULL,
CORREO NVARCHAR(100) NOT NULL,
CONSTRAINT FK_ESTADOU FOREIGN KEY (CODESTADO) REFERENCES ESTADO(CODESTADO))
;

CREATE TABLE BIBLIOTECARIO(
CODBIBLIOTECARIO INT PRIMARY KEY IDENTITY(1,1),
CODESTADO INT NOT NULL,
NOMBRE NVARCHAR(50) NOT NULL,
TELEFONO VARCHAR(9) NOT NULL,
CORREO NVARCHAR(100) NOT NULL,
CONSTRAINT FK_ESTADOB FOREIGN KEY (CODESTADO) REFERENCES ESTADO(CODESTADO))
;

CREATE TABLE ESTADO_EJEMPLAR(
CODESTADO_EJEMPLAR INT PRIMARY KEY IDENTITY(1,1),
DESC_ESTADO_EJEMPLAR VARCHAR(40) NOT NULL)
;

CREATE TABLE EJEMPLAR_LIBRO (
CODEJEMPLAR INT PRIMARY KEY IDENTITY(1,1),
CODLIBRO INT NOT NULL,
CODESTADO_EJEMPLAR INT NOT NULL,
CONSTRAINT FK_CODLIBRO FOREIGN KEY (CODLIBRO) REFERENCES LIBRO(CODLIBRO),
CONSTRAINT FK_ESTADO_EJEMPLAR FOREIGN KEY (CODESTADO_EJEMPLAR) REFERENCES ESTADO_EJEMPLAR(CODESTADO_EJEMPLAR)
);


CREATE TABLE ESTADO_RESERVA(
CODESTADO_RESERVA INT PRIMARY KEY IDENTITY(1,1),
DESC_ESTADO_RESERVA VARCHAR(40) NOT NULL)
;

CREATE TABLE RESERVA(
CODRESERVA INT PRIMARY KEY IDENTITY(1,1),
CODESTADO_RESERVA INT NOT NULL,
CODUSUARIO INT NOT NULL,
CODEJEMPLAR INT NOT NULL,
FEC_INICIO_RESERVA DATE NOT NULL,
HOR_INICIO_RESERVA TIME NOT NULL,
FEC_FIN_RESERVA DATE NOT NULL,
HOR_FIN_RESERVA TIME NOT NULL,
CONSTRAINT FK_ESTADO_RESERVA FOREIGN KEY (CODESTADO_RESERVA) REFERENCES ESTADO_RESERVA(CODESTADO_RESERVA),
CONSTRAINT FK_CODUSUARIO FOREIGN KEY (CODUSUARIO) REFERENCES USUARIO(CODUSUARIO),
CONSTRAINT FK_RESERVA_EJEMPLAR FOREIGN KEY (CODEJEMPLAR) REFERENCES EJEMPLAR_LIBRO(CODEJEMPLAR))
;

CREATE TABLE ESTADO_PRESTAMO(
CODESTADO_PRESTAMO INT PRIMARY KEY IDENTITY(1,1),
DESC_ESTADO_PRESTAMO VARCHAR(40) NOT NULL)
;


CREATE TABLE PRESTAMO(
CODPRESTAMO INT PRIMARY KEY IDENTITY(1,1),
CODESTADO_PRESTAMO INT NOT NULL,
CODRESERVA INT NOT NULL,
CODBIBLIOTECARIO INT NOT NULL,
FECHAPRESTAMO DATE NOT NULL,
FECHAENTREGA DATE NOT NULL,
CONSTRAINT FK_ESTADO_PRESTAMO FOREIGN KEY (CODESTADO_PRESTAMO) REFERENCES ESTADO_PRESTAMO(CODESTADO_PRESTAMO),
CONSTRAINT FK_CODRESERVA FOREIGN KEY (CODRESERVA) REFERENCES RESERVA(CODRESERVA),
CONSTRAINT FK_BIBLIOTECARIO FOREIGN KEY (CODBIBLIOTECARIO) REFERENCES BIBLIOTECARIO(CODBIBLIOTECARIO))
;

CREATE TABLE DETALLE_PRESTAMO(
CODDETALLE INT PRIMARY KEY IDENTITY(1,1),
CODPRESTAMO INT NOT NULL,
CODEJEMPLAR INT NOT NULL,
FECHADEVOLUCIONREAL DATE NOT NULL,
CONSTRAINT FK_PRESTAMO FOREIGN KEY (CODPRESTAMO) REFERENCES PRESTAMO(CODPRESTAMO),
CONSTRAINT FK_DETALLE_EJEMPLAR FOREIGN KEY (CODEJEMPLAR) REFERENCES EJEMPLAR_LIBRO(CODEJEMPLAR))
;	

CREATE TABLE ESTADO_MULTA(
CODESTADO_MULTA INT PRIMARY KEY IDENTITY(1,1),
DESC_ESTADO_MULTA VARCHAR(40) NOT NULL)
;

CREATE TABLE MOTIVO_MULTA(
CODMOTIVO_MULTA INT PRIMARY KEY IDENTITY(1,1),
DESC_MOTIVO_MULTA VARCHAR(40) NOT NULL)
;

CREATE TABLE MULTA(
CODMULTA INT PRIMARY KEY IDENTITY(1,1),
CODESTADO_MULTA INT NOT NULL,
CODMOTIVO_MULTA INT NOT NULL,
CODDETALLE INT NOT NULL,
MONTO INT NOT NULL,
FECHAGENERACION DATE NOT NULL,
CONSTRAINT FK_ESTADO_MULTA FOREIGN KEY (CODESTADO_MULTA) REFERENCES ESTADO_MULTA(CODESTADO_MULTA),
CONSTRAINT FK_MOTIVO_MULTA FOREIGN KEY (CODMOTIVO_MULTA) REFERENCES MOTIVO_MULTA(CODMOTIVO_MULTA),
CONSTRAINT FK_DETALLE FOREIGN KEY (CODDETALLE) REFERENCES DETALLE_PRESTAMO(CODDETALLE))
;	

CREATE TABLE PAGO_MULTA(
CODPAGOMULTA INT PRIMARY KEY IDENTITY(1,1),
CODMULTA INT NOT NULL,
FECHAPAGO DATE NOT NULL,
MONTOPAGADO INT,
METODOPAGO VARCHAR(50) NOT NULL,
CONSTRAINT FK_MULTA FOREIGN KEY (CODMULTA) REFERENCES MULTA(CODMULTA))
;
```
#### b. Población de Tablas (INSERT)  
Esta sección contiene los comandos INSERT INTO para cargar los datos de prueba en las tablas de catálogo y las tablas transaccionales.

```sql
-- INSERCIÓN DE REGISTROS DE CATÁLOGO:

INSERT INTO ESTADO (DESC_ESTADO) VALUES ('Activo');
INSERT INTO ESTADO (DESC_ESTADO) VALUES ('Inactivo');

INSERT INTO ESTADO_EJEMPLAR (DESC_ESTADO_EJEMPLAR) VALUES
('Disponible'),
('Reservado'),
('Prestado'),
('Dañado'),
('En reparacion');

INSERT INTO ESTADO_RESERVA (DESC_ESTADO_RESERVA) VALUES 
('Activa'),
('Inactiva'),
('Procesada');

INSERT INTO ESTADO_PRESTAMO (DESC_ESTADO_PRESTAMO) VALUES
('En préstamo'),
('Devuelto'),
('Retrasado');

INSERT INTO ESTADO_MULTA (DESC_ESTADO_MULTA) VALUES
('Pendiente'),
('Pagada');

INSERT INTO MOTIVO_MULTA (DESC_MOTIVO_MULTA) VALUES
('Retraso'),
('Dañado'),
('No devuelto');


-- INSERCIÓN DE DATOS MAESTROS:

INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD) VALUES (1, 'El Principito', 'Antoine de Saint-Exupéry', 10);
INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD) VALUES (1, '1984', 'George Orwell', 8);
INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD) VALUES (1, 'Cien Años de Soledad', 'Gabriel García Márquez', 5);
INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD) VALUES (1, 'Don Quijote de la Mancha', 'Miguel de Cervantes', 15);
INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD) VALUES (1, 'La Sombra del Viento', 'Carlos Ruiz Zafón', 12);
INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD) VALUES (1, 'Matar a un Ruiseñor', 'Harper Lee', 6);
INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD) VALUES (1, 'Orgullo y Prejuicio', 'Jane Austen', 9);
INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD) VALUES (1, 'El Gran Gatsby', 'F. Scott Fitzgerald', 7);
INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD) VALUES (1, 'Crónica de una Muerte Anunciada', 'Gabriel García Márquez', 10);
INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD) VALUES (1, 'El Código Da Vinci', 'Dan Brown', 13);


INSERT INTO USUARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES (1, 'Juan Pérez', '987654321', 'juanperez@example.com');
INSERT INTO USUARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES (1, 'María Gómez', '912345678', 'mariagomez@example.com');
INSERT INTO USUARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES (1, 'Carlos López', '923456789', 'carloslopez@example.com');
INSERT INTO USUARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES (1, 'Ana Martínez', '934567890', 'anamartinez@example.com');
INSERT INTO USUARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES (1, 'Luis Torres', '945678901', 'luistorres@example.com');
INSERT INTO USUARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES (1, 'Pedro Rodríguez', '956789012', 'pedrorodriguez@example.com');
INSERT INTO USUARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES (1, 'Laura Fernández', '967890123', 'laurafernandez@example.com');
INSERT INTO USUARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES (1, 'Sofía Díaz', '978901234', 'sofiadiaz@example.com');
INSERT INTO USUARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES (1, 'Marta Pérez', '989012345', 'martaperez@example.com');
INSERT INTO USUARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES (1, 'David Gómez', '990123456', 'davidgomez@example.com');


INSERT INTO BIBLIOTECARIO (CODESTADO, NOMBRE, TELEFONO, CORREO) VALUES 
(1, 'Ana Rodríguez', '987654321', 'anarodriguez@example.com'),
(1, 'Carlos García', '912345678', 'carlosgarcia@example.com'),
(1, 'Luis Martínez', '923456789', 'luismartinez@example.com'),
(1, 'María López', '934567890', 'marialopez@example.com'),
(1, 'Pedro Fernández', '945678901', 'pedrofernandez@example.com'),
(2, 'Laura Sánchez', '956789012', 'laurasanchez@example.com'),
(2, 'Marta Pérez', '967890123', 'martaperez@example.com'),
(2, 'David Gómez', '978901234', 'davidgomez@example.com'),
(2, 'Sofía Díaz', '989012345', 'sofiadiaz@example.com'),
(2, 'Juan Pérez', '990123456', 'juanperez@example.com');


-- Insertando los ejemplares por libro
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 1), (2, 2), (2, 3),
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5),
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 1), (4, 2), (4, 3), (4, 4), (4, 5),
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 1),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 1),
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 1), (7, 2), (7, 3), (7, 4),
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5), (8, 1), (8, 2),
(9, 1), (9, 2), (9, 3), (9, 4), (9, 5), (9, 1), (9, 2), (9, 3), (9, 4), (9, 2),
(10, 1), (10, 2), (10, 3), (10, 4), (10, 5), (10, 1), (10, 2), (10, 3), (10, 4), (10, 1), (10, 2), (10, 3), (10, 4);


INSERT INTO RESERVA (CODESTADO_RESERVA, CODUSUARIO, CODEJEMPLAR, FEC_INICIO_RESERVA, HOR_INICIO_RESERVA, FEC_FIN_RESERVA, HOR_FIN_RESERVA)
VALUES 
(3, 1, 1, '2024-12-01', '08:00', '2024-12-03', '18:00'),
(3, 2, 2, '2024-12-02', '09:00', '2024-12-04', '19:00'),
(3, 3, 3, '2024-12-03', '10:00', '2024-12-05', '20:00'),
(3, 4, 4, '2024-12-04', '11:00', '2024-12-06', '21:00'),
(3, 5, 5, '2024-12-05', '12:00', '2024-12-07', '22:00'),
(3, 6, 6, '2024-12-06', '13:00', '2024-12-08', '23:00'),
(3, 7, 7, '2024-12-07', '14:00', '2024-12-09', '10:00'),
(3, 8, 8, '2024-12-08', '15:00', '2024-12-10', '11:00'),
(3, 9, 9, '2024-12-09', '16:00', '2024-12-11', '12:00'),
(3, 10, 10, '2024-12-10', '17:00', '2024-12-12', '13:00'),
(1, 1, 1, '2024-12-01', '08:00', '2024-12-03', '18:00'),
(1, 2, 2, '2024-12-02', '09:00', '2024-12-04', '19:00'),
(2, 3, 3, '2024-12-03', '10:00', '2024-12-05', '20:00'),
(1, 4, 4, '2024-12-04', '11:00', '2024-12-06', '21:00'),
(2, 5, 5, '2024-12-05', '12:00', '2024-12-07', '22:00'),
(1, 6, 6, '2024-12-06', '13:00', '2024-12-08', '23:00'),
(2, 7, 7, '2024-12-07', '14:00', '2024-12-09', '10:00'),
(2, 8, 8, '2024-12-08', '15:00', '2024-12-10', '11:00'),
(1, 9, 9, '2024-12-09', '16:00', '2024-12-11', '12:00'),
(2, 10, 10, '2024-12-10', '17:00', '2024-12-12', '13:00');


INSERT INTO PRESTAMO (CODESTADO_PRESTAMO,CODRESERVA,CODBIBLIOTECARIO,FECHAPRESTAMO,FECHAENTREGA) VALUES
(3, 1, 1, '2024-12-02','2024-12-17'),
(3, 2, 2, '2024-12-03','2024-12-18'),
(3, 3, 3, '2024-12-04','2024-12-19'),
(2, 4, 4, '2024-12-05','2024-12-20'),
(2, 5, 5, '2024-12-06','2024-12-21'),
(2, 6, 1, '2024-12-07','2024-12-22'),
(2, 7, 2, '2024-12-08','2024-12-23'),
(1, 8, 3, '2024-12-09','2024-12-24'),
(1, 9, 4, '2024-12-10','2024-12-25'),
(1, 10, 5, '2024-12-11','2024-12-26');


INSERT INTO DETALLE_PRESTAMO (CODPRESTAMO,CODEJEMPLAR,FECHADEVOLUCIONREAL) VALUES
(1,1,'2024-12-24'),
(2,2,'2024-12-23'),
(3,3,'2024-12-20'),
(4,4,'2024-12-20'),
(5,5,'2024-12-21'),
(6,6,'2024-12-22'),
(7,7,'2024-12-23'),
(8,8,'2024-12-24'),
(9,9,'2024-12-25'),
(10,10,'2024-12-26');


INSERT INTO MULTA (CODESTADO_MULTA,CODMOTIVO_MULTA,CODDETALLE,MONTO,FECHAGENERACION)VALUES
(1,1,1,140,'2024-12-18'),
(2,1,1,100,'2024-12-19'),
(2,1,1,20,'2024-12-20');

INSERT INTO PAGO_MULTA(CODMULTA,FECHAPAGO,MONTOPAGADO,METODOPAGO)VALUES
(2,'2024-12-23',100,'Tarjeta'),
(3,'2024-12-20',20,'Tarjeta');
```
#### c. Creación de Objetos Programables (Vistas y Procedimientos)
Esta sección incluye todas las Vistas para consultas complejas y los Procedimientos Almacenados para encapsular la lógica transaccional y operativa del sistema.

```sql
-- VISTAS

CREATE VIEW VistaDeLibrosDisponibles AS
SELECT 
    L.CODLIBRO,
    L.TITULO,
    L.AUTOR,
    L.CANTIDAD AS Total_Ejemplares,
    E.DESC_ESTADO AS Estado_Libro,
    EE.DESC_ESTADO_EJEMPLAR AS Estado_Ejemplar
FROM 
    LIBRO L
    INNER JOIN ESTADO E ON L.CODESTADO = E.CODESTADO
    INNER JOIN EJEMPLAR_LIBRO EL ON L.CODLIBRO = EL.CODLIBRO
    INNER JOIN ESTADO_EJEMPLAR EE ON EL.CODESTADO_EJEMPLAR = EE.CODESTADO_EJEMPLAR
WHERE 
    E.DESC_ESTADO = 'Activo' AND EE.DESC_ESTADO_EJEMPLAR = 'Disponible';

SELECT * FROM VistaDeLibrosDisponibles;


CREATE VIEW VistaReservasActivas AS
SELECT 
    R.CODRESERVA,
    U.NOMBRE AS Usuario,
    U.CORREO AS Correo_Usuario,
    L.TITULO AS Libro,
    R.FEC_INICIO_RESERVA AS Fecha_Inicio,
    R.FEC_FIN_RESERVA AS Fecha_Fin,
    ER.DESC_ESTADO_RESERVA AS Estado_Reserva
FROM 
    RESERVA R
    INNER JOIN USUARIO U ON R.CODUSUARIO = U.CODUSUARIO
    INNER JOIN EJEMPLAR_LIBRO EL ON R.CODEJEMPLAR = EL.CODEJEMPLAR
    INNER JOIN LIBRO L ON EL.CODLIBRO = L.CODLIBRO
    INNER JOIN ESTADO_RESERVA ER ON R.CODESTADO_RESERVA = ER.CODESTADO_RESERVA
WHERE 
    ER.DESC_ESTADO_RESERVA = 'Activa';

SELECT * FROM VistaReservasActivas;


CREATE VIEW VistaResumenEstados AS
SELECT 
    E.DESC_ESTADO AS Estado_Libro,
    EE.DESC_ESTADO_EJEMPLAR AS Estado_Ejemplar,
    COUNT(EL.CODEJEMPLAR) AS Total_Ejemplares
FROM 
    ESTADO E
    INNER JOIN LIBRO L ON E.CODESTADO = L.CODESTADO
    INNER JOIN EJEMPLAR_LIBRO EL ON L.CODLIBRO = EL.CODLIBRO
    INNER JOIN ESTADO_EJEMPLAR EE ON EL.CODESTADO_EJEMPLAR = EE.CODESTADO_EJEMPLAR
GROUP BY 
    E.DESC_ESTADO, EE.DESC_ESTADO_EJEMPLAR;

SELECT * FROM VistaResumenEstados;


CREATE VIEW VistaUsuariosMultasPagas AS
SELECT 
    U.CODUSUARIO,
    U.NOMBRE AS Nombre_Usuario,
    SUM(M.MONTO) AS Total_Multas_Pagadas
FROM 
    USUARIO U
    INNER JOIN RESERVA R ON U.CODUSUARIO = R.CODUSUARIO
	INNER JOIN PRESTAMO P ON P.CODRESERVA = R.CODRESERVA
	INNER JOIN DETALLE_PRESTAMO D ON D.CODPRESTAMO = P.CODPRESTAMO
    INNER JOIN MULTA M ON D.CODDETALLE = M.CODDETALLE
WHERE 
    M.CODESTADO_MULTA = 2
GROUP BY 
    U.CODUSUARIO, U.NOMBRE;

SELECT * FROM VistaUsuariosMultasPagas;


CREATE VIEW VistaLibrosDañados AS
SELECT 
    L.CODLIBRO,
    L.TITULO AS Titulo_Libro,
    L.AUTOR AS Autor_Libro,
    EL.CODEJEMPLAR AS Codigo_Ejemplar,
    EE.DESC_ESTADO_EJEMPLAR AS Estado_Ejemplar
FROM 
    LIBRO L
    INNER JOIN EJEMPLAR_LIBRO EL ON L.CODLIBRO = EL.CODLIBRO
    INNER JOIN ESTADO_EJEMPLAR EE ON EL.CODESTADO_EJEMPLAR = EE.CODESTADO_EJEMPLAR
WHERE 
    EE.DESC_ESTADO_EJEMPLAR = 'Dañado';

SELECT * FROM VistaLibrosDañados;


-- PROCESOS ALMACENADOS

CREATE PROCEDURE RegistrarLibro 
    @Titulo NVARCHAR(100),
    @Autor NVARCHAR(50),
    @Cantidad INT,
    @Estado INT
AS
BEGIN
    INSERT INTO LIBRO (CODESTADO, TITULO, AUTOR, CANTIDAD)
    VALUES (@Estado, @Titulo, @Autor, @Cantidad);
END;

EXEC RegistrarLibro @Titulo = 'Manual de Base de Datos',
    @Autor= 'Profesor X',
    @Cantidad= 5,
    @Estado=1;

SELECT * FROM LIBRO;


CREATE PROCEDURE ActualizarEstadoLibro 
    @CodLibro INT,
    @NuevoEstado INT
AS
BEGIN
    UPDATE LIBRO 
    SET CODESTADO = @NuevoEstado
    WHERE CODLIBRO = @CodLibro;
END;

EXEC ActualizarEstadoLibro @CodLibro= 11,
    @NuevoEstado= 2;


CREATE PROCEDURE EliminarLibro 
    @CodLibro INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM RESERVA WHERE CODEJEMPLAR IN (SELECT CODEJEMPLAR FROM EJEMPLAR_LIBRO WHERE CODLIBRO = @CodLibro))
    BEGIN
        DELETE FROM LIBRO WHERE CODLIBRO = @CodLibro;
    END
    ELSE
    BEGIN
        PRINT 'El libro tiene ejemplares reservados o prestados, no puede eliminarse.';
    END
END;

EXEC EliminarLibro @CodLibro=1;


CREATE PROCEDURE RegistrarReserva
    @CodUsuario INT,
    @CodEjemplar INT,
    @FechaInicio DATE,
    @HoraInicio TIME,
    @FechaFin DATE,
    @HoraFin TIME,
    @EstadoReserva INT
AS
BEGIN
    INSERT INTO RESERVA (CODESTADO_RESERVA, CODUSUARIO, CODEJEMPLAR, FEC_INICIO_RESERVA, HOR_INICIO_RESERVA, FEC_FIN_RESERVA, HOR_FIN_RESERVA)
    VALUES (@EstadoReserva, @CodUsuario, @CodEjemplar, @FechaInicio, @HoraInicio, @FechaFin, @HoraFin);
END;

EXEC RegistrarReserva @CodUsuario=12,
    @CodEjemplar=93,
    @FechaInicio='2024-12-02',
    @HoraInicio='08:00:00',
    @FechaFin='2024-12-03',
    @HoraFin='08:00:00',
    @EstadoReserva=1;


CREATE PROCEDURE ActualizarCantidadLibro
    @CodLibro INT,
    @NuevaCantidad INT
AS
BEGIN
    UPDATE LIBRO
    SET CANTIDAD = @NuevaCantidad
    WHERE CODLIBRO = @CodLibro;
END;

EXEC ActualizarCantidadLibro @CodLibro=10,
    @NuevaCantidad=20;


CREATE PROCEDURE RealizarPrestamo
    @CodReserva INT,
    @CodBibliotecario INT,
    @FechaPrestamo DATE,
    @FechaEntrega DATE,
    @EstadoPrestamo INT
AS
BEGIN
    INSERT INTO PRESTAMO (CODESTADO_PRESTAMO, CODRESERVA, CODBIBLIOTECARIO, FECHAPRESTAMO, FECHAENTREGA)
    VALUES (@EstadoPrestamo, @CodReserva, @CodBibliotecario, @FechaPrestamo, @FechaEntrega);
END;

EXEC RealizarPrestamo @CodReserva=16,
    @CodBibliotecario=2,
    @FechaPrestamo='2024-12-05',
    @FechaEntrega='2024-12-20',
    @EstadoPrestamo=1;


CREATE PROCEDURE ObtenerLibrosNoDisponibles
AS
BEGIN
    SELECT * FROM LIBRO WHERE CODESTADO = 2 AND CANTIDAD > 0;
END;

EXEC ObtenerLibrosNoDisponibles;


CREATE PROCEDURE GenerarMulta
    @CodDetalle INT,
    @CodMotivo INT,
    @Monto INT,
    @FechaGeneracion DATE,
    @EstadoMulta INT
AS
BEGIN
    INSERT INTO MULTA (CODESTADO_MULTA, CODMOTIVO_MULTA, CODDETALLE, MONTO, FECHAGENERACION)
    VALUES (@EstadoMulta, @CodMotivo, @CodDetalle, @Monto, @FechaGeneracion);
END;

EXEC GenerarMulta @CodDetalle=11,
    @CodMotivo=2,
    @Monto=40,
    @FechaGeneracion='2024-12-19',
    @EstadoMulta=1;


CREATE PROCEDURE ObtenerMultasUsuario
    @CodUsuario INT
AS
BEGIN
    SELECT m.CODMOTIVO_MULTA, m.MONTO, m.FECHAGENERACION, p2.FECHAPAGO
    FROM PRESTAMO p
    JOIN DETALLE_PRESTAMO d ON p.CODPRESTAMO = d.CODPRESTAMO
    JOIN MULTA m ON m.CODDETALLE = d.CODDETALLE
    JOIN PAGO_MULTA p2 ON p2.CODMULTA = m.CODMULTA
    JOIN RESERVA r ON r.CODRESERVA = p.CODRESERVA
    WHERE r.CODUSUARIO = @CodUsuario;
END;

EXEC ObtenerMultasUsuario @CodUsuario=1;


CREATE PROCEDURE VerificarFechaDevolucion
    @CodDetalle INT
AS
BEGIN
    DECLARE @FechaDevolucionReal DATE, @FechaEntrega DATE;
    SELECT @FechaDevolucionReal = FECHADEVOLUCIONREAL FROM DETALLE_PRESTAMO WHERE CODDETALLE = @CodDetalle;
    SELECT @FechaEntrega = FECHAENTREGA FROM PRESTAMO WHERE CODPRESTAMO IN (SELECT CODPRESTAMO FROM DETALLE_PRESTAMO WHERE CODDETALLE = @CodDetalle);
    
    IF @FechaDevolucionReal > @FechaEntrega
    BEGIN
        PRINT 'El libro fue devuelto con retraso.';
    END
    ELSE
    BEGIN
        PRINT 'El libro fue devuelto a tiempo.';
    END
END;

EXEC VerificarFechaDevolucion @CodDetalle=2;


CREATE PROCEDURE VerificarMultasPendientes
    @CodUsuario INT
AS
BEGIN
    DECLARE @SaldoPendiente INT;
    SELECT @SaldoPendiente = ISNULL(SUM(MONTO), 0) FROM MULTA m
    JOIN DETALLE_PRESTAMO d ON m.CODDETALLE = d.CODDETALLE
    JOIN PRESTAMO p ON d.CODPRESTAMO = p.CODPRESTAMO
    JOIN RESERVA r ON r.CODRESERVA = p.CODRESERVA
    WHERE r.CODUSUARIO = @CodUsuario
    AND m.CODESTADO_MULTA = 1; -- 1 = pendiente
    
    IF @SaldoPendiente > 0
    BEGIN
        PRINT 'El usuario tiene multas pendientes, no puede realizar un nuevo préstamo.';
    END
    ELSE
    BEGIN
        PRINT 'El usuario está habilitado para un nuevo préstamo.';
    END
END;


EXEC VerificarMultasPendientes @CodUsuario=2;


CREATE PROCEDURE CambiarEstadoLibroSinStock
AS
BEGIN
    -- Actualizar el estado de los libros con cantidad cero
    UPDATE LIBRO
    SET CODESTADO = (SELECT CODESTADO FROM ESTADO WHERE DESC_ESTADO = 'Inactivo')
    WHERE CANTIDAD = 0;
END;

EXEC CambiarEstadoLibroSinStock;
```
---


