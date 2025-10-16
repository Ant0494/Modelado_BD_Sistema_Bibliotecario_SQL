# Modelado de Base de Datos para Sistema de Préstamos Bibliotecarios 

<p align="center">
  <img src="https://github.com/Ant0494/Modelado_BD_Sistema_Bibliotecario_SQL/blob/e909c3b2bafd71170daca442bdf469e7ed982daa/assets/Biblioteca.png?raw=true" alt="Diagrama de Base de Datos SQL" width="500"/>
</p>


## Contexto y Visión General del Proyecto

Este proyecto muestra el diseño y desarrollo de la base de datos para un sistema de préstamo de ejemplares de libros en una biblioteca; el cual puede adaptarse a las bibliotecas de cualquier institución, siendo así que los actores involucrados sigan los procesos implicados en la reserva de préstamo, el préstamo, la devolución y la generación y pago de multas en casos corresponda.
El diseño es flexible y adaptable a las necesidades de cualquier institución que gestione una biblioteca. Permitirá una gestión eficiente de los libros y los usuarios, reflejando en una mejora en la experiencia de los usuarios y en la optimización de los recursos de la biblioteca.  

El objetivo principal es demostrar la capacidad de llevar un sistema desde la definición de los requisitos de negocio hasta su implementación física, asegurando:
1.  **Integridad y Consistencia:** Mediante la aplicación rigurosa de la **Tercera Forma Normal (3FN)**.
2.  **Lógica de Negocio:** Mediante la implementación de reglas complejas (sanciones, límites de préstamo, multas) en el modelo y en la capa de objetos programables (Vistas y SPs).

El modelo está diseñado para ser flexible y escalable, adaptándose a cualquier institución que requiera una gestión eficiente de sus ejemplares, usuarios y transacciones.

---

## Documentación del Proyecto y Navegación Modular

Explora cada fase del ciclo de diseño, desde los requisitos del negocio hasta la implementación física del esquema.

### 1. Requisitos y Diseño Metodológico
* **🧩 [Reglas de Negocio y Flujo de Procesos (BPMN)](./Reglas_Negocio.md)**
    * Documentación de los procesos operativos (Acceso, Reserva, Préstamo, Multa) y la definición de las Reglas de Negocio críticas que rigen el sistema (ej. Límite de 5 préstamos, Multa por día de retraso).

### 2. Análisis y Estructura Lógica
* **🔍 [Análisis de Datos y Proceso de Normalización a 3FN](./Normalizacion_3FN.md)**
    * El proceso detallado paso a paso para alcanzar la Tercera Forma Normal (3FN), justificando la eliminación de dependencias y la atomicidad de los datos.
* **🗺️ [Modelo Lógico, Relaciones y Diagrama Entidad-Relación (DER)](./Modelo_Logico_DER.md)**
    * Definición de las entidades, la estructura de las Tablas de Catálogo y la representación gráfica de las Relaciones Cardinales (1:N, 1:1).

### 3. Implementación Física y Pruebas
* **💾 [Script SQL Completo e Implementación Física](./Script_SQL_Completo.sql)**
    * El script SQL completo para la creación de la Base de Datos, Tablas, Restricciones (Constraints) y la capa de Objetos Programables (Vistas y Procedimientos Almacenados) que ejecutan la lógica de negocio.

---

## Tecnologías Utilizadas

| Categoría | Herramientas/Conceptos |
| :--- | :--- |
| **Modelado y Diseño** | Diagrama Entidad-Relación (DER), Flujo de Procesos (BPMN), Normalización 3FN |
| **Motor de Base de Datos** | SQL Server (T-SQL) |
| **Enfoque del Modelo** | Transaccional (OLTP) |


## 4. Implementación Física y Pruebas Paso a Paso (Evidencia SQL)

### 4.1. Verificación del Modelo Normalizado (Tablas Base)

**Objetivo:** Mostrar que el esquema se creó exitosamente y que las entidades principales (`USUARIO`, `PRESTAMO`, `EJEMPLAR_LIBRO`) están separadas y pobladas conforme a la 3FN.

**Código de Ejecución (SELECT):**

```sql
SELECT * FROM USUARIO;
```
<img src="https://github.com/Ant0494/Modelado_BD_Sistema_Bibliotecario_SQL/blob/c1714f232f899b615b651219ad1eb70b821a56b5/assets/fromUSUARIO.png?raw=true" alt="Resultado de SELECT * FROM USUARIO"/>

```sql
SELECT * FROM LIBRO;
```
<img src="https://github.com/Ant0494/Modelado_BD_Sistema_Bibliotecario_SQL/blob/c1714f232f899b615b651219ad1eb70b821a56b5/assets/fromLIBRO.png?raw=true" alt="Resultado de SELECT * FROM LIBRO"/>


```sql
SELECT * FROM BIBLIOTECARIO;
```
<img width="660" height="262" alt="image" src="https://github.com/user-attachments/assets/0d62bd43-472b-4c40-92d9-df1813fc039c" />

```sql
SELECT * FROM PRESTAMO;
```
<img width="787" height="257" alt="image" src="https://github.com/user-attachments/assets/950da381-4248-4221-a3e6-fd1d3de69e45" />

```sql
SELECT * FROM EJEMPLAR_LIBRO;
```
<img width="422" height="385" alt="image" src="https://github.com/user-attachments/assets/7b26f0b5-4f78-4f04-83a0-16379d8cddb4" />

```sql
SELECT * FROM MULTA;
```
<img width="711" height="117" alt="image" src="https://github.com/user-attachments/assets/a673e62c-72a9-436b-8dca-88cbe7b677f0" />


### 4.2. Evidencia de Normalización: Tablas de Catálogo de Estados

```sql
SELECT * FROM ESTADO_EJEMPLAR;;
```
<img width="392" height="157" alt="image" src="https://github.com/user-attachments/assets/68a85114-579d-4f6e-970d-d5e33825ae4a" />

```sql
SELECT * FROM ESTADO_PRESTAMO;
```
<img width="393" height="122" alt="image" src="https://github.com/user-attachments/assets/bf784cd2-9965-4e33-900c-f9872f541e73" />

```sql
SELECT * FROM ESTADO_MULTA;
```
<img width="357" height="101" alt="image" src="https://github.com/user-attachments/assets/a94a3300-de4c-4e7b-9249-d92961e6e934" />

### 4.3. Evidencia de Vistas (Consultas de Análisis y Reporte)
Las Vistas permiten simplificar consultas complejas y proporcionar un resumen de datos para reportes:

#### a. Vista: `VistaDeLibrosDisponibles`

```sql
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

SELECT * FROM VistaDeLibrosDisponibles
```

<img width="788" height="377" alt="image" src="https://github.com/user-attachments/assets/ed4aba2a-d2dd-45f6-90b4-4e577fb1dfcd" />

#### b. Vista: `VistaReservasActivas`
Proporciona un listado completo de las reservas que aún se encuentran en estado 'Activa', esencial para monitorear la caducidad (regla de 24 horas).

```sql
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

SELECT * FROM VistaReservasActivas
```
<img width="806" height="152" alt="image" src="https://github.com/user-attachments/assets/9483e384-9dd1-4a5e-9177-5ace9c3c09d4" />

#### c. Vista: `VistaResumenEstados`
Una vista de Análisis Gerencial que agrupa y cuenta el total de ejemplares por su Estado_Libro (ej. Activo, No Disponible) y su Estado_Ejemplar (ej. Disponible, Prestado, Dañado), proporcionando un inventario consolidado.
```sql
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

SELECT * FROM VistaResumenEstados
```

<img width="382" height="157" alt="image" src="https://github.com/user-attachments/assets/b2144b71-b03b-4871-a458-532e967de907" />

#### d. Vista: `VistaUsuariosMultasPagas`
Vista de Análisis Financiero. Suma el total de multas que cada usuario ha pagado, facilitando el análisis del impacto económico de las sanciones y el comportamiento del usuario respecto a sus obligaciones.

```sql
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
    M.CODESTADO_MULTA = 2 -- Ajusta este filtro si "Pagada" es un valor en tu tabla MULTA
GROUP BY 
    U.CODUSUARIO, U.NOMBRE;


	SELECT * FROM VistaUsuariosMultasPagas
```
<img width="405" height="73" alt="image" src="https://github.com/user-attachments/assets/e3e27196-e203-471b-870a-2a84f6844d06" />

#### e. Vista: `VistaLibrosDañados`
Vista de Gestión de Inventario Físico. Identifica y lista todos los ejemplares cuyo estado físico ha sido marcado como 'Dañado'. Esta información es crítica para la depreciación de activos y la toma de decisiones sobre reposición.

```sql
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
    EE.DESC_ESTADO_EJEMPLAR = 'Dañado'; -- Filtra únicamente los ejemplares dañados

	SELECT * FROM VistaLibrosDañados
```
<img width="711" height="381" alt="image" src="https://github.com/user-attachments/assets/e02cee75-a3fd-4452-8bfc-5e3b9dd1363d" />

### 4.4. Evidencia de Procedimientos Almacenados (Lógica de Negocio y Transaccional)
Los Procedimientos Almacenados (SPs) encapsulan la lógica de negocio y las transacciones, asegurando la integridad y la correcta aplicación de las reglas del negocio. Aquí se muestran los más representativos:

#### a. SP Crítico: `VerificarFechaDevolucion` (Regla de Sanción)
Es la principal rutina para la gestión de multas. Compara la fecha de devolución real contra la fecha de entrega esperada (`FECHAENTREGA`). Si la real es mayor, activa un mensaje de retraso (paso previo a la multa de S/.20 por día).

```sql
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
```
<img width="456" height="82" alt="image" src="https://github.com/user-attachments/assets/c2e537cd-c5d9-482b-ba10-c5ec8442e526" />

#### b. SP Crítico: `VerificarMultasPendientes` (Regla de Bloqueo)
Implementa la regla de negocio que impide que un usuario realice un nuevo préstamo si tiene multas pendientes. Demuestra el uso de lógica de consulta (JOINs y SUM) para aplicar una restricción funcional.

```sql
CREATE PROCEDURE VerificarMultasPendientes
    @CodUsuario INT
AS
BEGIN
    DECLARE @SaldoPendiente INT;
    SELECT @SaldoPendiente = SUM(MONTO) FROM MULTA m
    JOIN DETALLE_PRESTAMO d ON m.CODDETALLE = d.CODDETALLE
    JOIN PRESTAMO p ON d.CODPRESTAMO = p.CODPRESTAMO
    WHERE p.CODRESERVA IN (SELECT CODRESERVA FROM RESERVA WHERE CODUSUARIO = @CodUsuario)
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
```
<img width="431" height="87" alt="image" src="https://github.com/user-attachments/assets/55b230a8-78cc-48ef-92dd-3069ca71f279" />

#### c. SP: `RealizarPrestamo` (Transacción DML Central)
El procedimiento central del sistema, que registra un nuevo préstamo en la tabla PRESTAMO. Es un ejemplo de una transacción DML que opera con claves foráneas (`@CodReserva`, `@CodBibliotecario`).

```sql
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
```
<img width="428" height="106" alt="image" src="https://github.com/user-attachments/assets/a4bddbb5-1efa-455e-b9b9-13012ea2e220" />

```sql
SELECT * FROM PRESTAMO
WHERE CODRESERVA=16
```
<img width="807" height="92" alt="image" src="https://github.com/user-attachments/assets/ad723f6e-7736-409b-8865-aa57b17c11f2" />

#### d. SP: `EliminarLibro` (Manejo de Integridad Referencial)
Demuestra una práctica de defensa de la integridad de datos. El SP verifica si el libro tiene ejemplares reservados o prestados antes de permitir la eliminación. Si la condición se cumple, el libro no se borra.

```sql
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
```
<img width="540" height="98" alt="image" src="https://github.com/user-attachments/assets/fe182b62-7b9c-4e6b-81d9-10961cbd2af1" />

#### e. SP Crítico: `VerificarDevolucionYGenerarMulta` (Regla de Sanción y Cálculo)
Este SP encapsula la lógica de negocio completa: Compara la fecha de devolución real contra la fecha límite. **Si hay retraso, el procedimiento calcula automáticamente el monto de la multa** (usando la tasa interna de S/. 20 por día) y genera el registro correspondiente en la tabla `MULTA`. El procedimiento es **autónomo** y no requiere que la aplicación le envíe el monto.

```sql
CREATE PROCEDURE VerificarDevolucionYGenerarMulta
    @CodDetalle INT
AS
BEGIN
      DECLARE @FechaDevolucionReal DATE, 
            @FechaEntrega DATE, 
            @DiasRetraso INT,
            @MontoPorDia INT = 20, -- Regla de negocio: S/. 20 fijos por día de retraso.
            @MontoTotal INT,
            @CodMotivoRetraso INT = 1, -- Asumimos que 1 = Retraso en tu tabla MOTIVO_MULTA
            @CodPrestamo INT;

    -- Obtener las fechas clave y el CodPrestamo
    SELECT @FechaDevolucionReal = FECHADEVOLUCIONREAL, 
           @CodPrestamo = CODPRESTAMO 
    FROM DETALLE_PRESTAMO 
    WHERE CODDETALLE = @CodDetalle;

    SELECT @FechaEntrega = FECHAENTREGA 
    FROM PRESTAMO 
    WHERE CODPRESTAMO = @CodPrestamo;
    
    -- Verificar Retraso
    IF @FechaDevolucionReal > @FechaEntrega
    BEGIN
        -- Cálculo de días y monto total
        SET @DiasRetraso = DATEDIFF(day, @FechaEntrega, @FechaDevolucionReal);
        SET @MontoTotal = @DiasRetraso * @MontoPorDia;

        -- Generar Registro de Multa
        INSERT INTO MULTA (CODESTADO_MULTA, CODMOTIVO_MULTA, CODDETALLE, MONTO, FECHAGENERACION)
        VALUES (
            1, -- Asumimos que 1 = Pendiente
            @CodMotivoRetraso, -- 1 = Multa por Retraso
            @CodDetalle,
            @MontoTotal,
            GETDATE() -- Fecha actual del sistema
        );

        -- Mensaje de confirmación
        PRINT '¡MULTA GENERADA! El libro fue devuelto con ' + 
               CAST(@DiasRetraso AS NVARCHAR) + ' días de retraso.';
        PRINT 'Monto total de la multa: S/. ' + CAST(@MontoTotal AS NVARCHAR);
    END
    ELSE
    BEGIN
        PRINT 'El libro fue devuelto a tiempo. No se genera multa.';
    END
END;

EXEC VerificarDevolucionYGenerarMulta @CodDetalle =2
```
<img width="511" height="122" alt="image" src="https://github.com/user-attachments/assets/863f5a86-37f7-4ede-8d7c-c7c08c6d16b2" />

## 5. Conclusiones y Valor Estratégico del Proyecto

Este proyecto valida la capacidad de diseñar e implementar un **Modelo de Datos OLTP** robusto, demostrando una solución que es tanto técnica como operacionalmente eficiente.

### Valor Estratégico Demostrado:

* **Integridad del Esquema y Gestión Eficiente:** La aplicación rigurosa de la **Tercera Forma Normal (3FN)** garantiza que los datos sean coherentes, fácilmente actualizables y escalables. Esto es la base para una **gestión eficiente** de préstamos y la confiabilidad de los registros.
* **Automatización de Lógica de Negocio (SPs):** El uso de **Procedimientos Almacenados (SPs)** como **`VerificarDevolucionYGenerarMulta`** y **`VerificarMultasPendientes`** automatiza las funciones críticas del negocio (cálculo de multas, control de bloqueo de usuarios). Esta práctica mejora la **eficiencia operativa** del personal bibliotecario y reduce significativamente el riesgo de errores.
* **Soporte a la Toma de Decisiones (Vistas):** Las **Vistas** implementadas (ej. `VistaResumenEstados`) simplifican consultas complejas para los gestores administrativos, facilitando la creación de **reportes automatizados** y permitiendo una mejor **toma de decisiones** sobre el inventario y el comportamiento de los usuarios.
* **Garantía de Confiabilidad y Seguridad:** La **implementación de pruebas** (mostrada en la Sección 4) y el desarrollo de SPs que aplican lógica condicional (como la validación de fechas) aseguran que el sistema funcione de manera efectiva, garantizando la **confiabilidad** del servicio a los usuarios.
