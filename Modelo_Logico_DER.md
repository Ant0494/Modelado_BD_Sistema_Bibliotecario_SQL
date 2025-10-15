# 🗺️ Modelo Lógico, Relaciones y Diagrama Entidad-Relación (DER)

## Diseño del Modelo Lógico (Entidades y Atributos)

El siguiente es el resultado final del proceso de normalización (3FN), donde se detallan las entidades y todos sus atributos, especificando las claves primarias (PK) y foráneas (FK).

### Entidades y Atributos de la Base de Datos de la Biblioteca

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

### Tablas de Catálogo y Definición de Estados

Las siguientes tablas contienen los valores permitidos (dominios) para los atributos de estado en el modelo lógico:

| Tabla de Catálogo | Descripción | Ejemplos de Valores Insertados |
| :--- | :--- | :--- |
| `ESTADO` | Estado general de entidades (`Usuario`, `Libro`, `Bibliotecario`). | `'Activo'`, `'Inactivo'` |
| `ESTADO_EJEMPLAR` | Estado físico o de préstamo del libro específico. | `'Disponible'`, `'Reservado'`, `'Prestado'`, `'Dañado'`, `'En reparación'` |
| `ESTADO_RESERVA` | Estado de la solicitud de reserva. | `'Activa'`, `'Inactiva'`, `'Procesada'` |
| `ESTADO_PRESTAMO` | Estado del préstamo en sí. | `'En préstamo'`, `'Devuelto'`, `'Retrasado'` |
| `ESTADO_MULTA` | Estado financiero de la multa. | `'Pendiente'`, `'Pagada'` |
| `MOTIVO_MULTA` | Causa de la sanción. | `'Retraso'`, `'Dañado'`, `'No devuelto'` |

## Relaciones entre Entidades

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

## Diagrama Entidad-Relación (DER)

El Diagrama Entidad-Relación (DER) representa gráficamente el Modelo Lógico de la base de datos de la biblioteca, mostrando todas las entidades normalizadas (3FN) y las relaciones.

La imagen a continuación ilustra las tablas y sus conexiones.

![ProyectoBD](https://github.com/user-attachments/assets/c53ea37b-a629-4610-91a6-02dec9f601ff)
