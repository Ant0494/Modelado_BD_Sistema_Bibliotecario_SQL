create database ProyectoBD_Finalv3

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


-- INSERCION DE REGISTROS:

INSERT INTO ESTADO (DESC_ESTADO) VALUES ('Activo');
INSERT INTO ESTADO (DESC_ESTADO) VALUES ('Inactivo');


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


INSERT INTO ESTADO_EJEMPLAR (DESC_ESTADO_EJEMPLAR) VALUES
('Disponible'),
('Reservado'),
('Prestado'),
('Dañado'),
('En reparacion');


-- Insertando los ejemplares para 'El Principito' (10 ejemplares)
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(1, 1),  -- Estado: 'Disponible'
(1, 2),  -- Estado: 'Reservado'
(1, 3),  -- Estado: 'Prestado'
(1, 4),  -- Estado: 'Dañado'
(1, 5),  -- Estado: 'En reparacion'
(1, 1),  -- Estado: 'Disponible'
(1, 2),  -- Estado: 'Reservado'
(1, 3),  -- Estado: 'Prestado'
(1, 4),  -- Estado: 'Dañado'
(1, 5);  -- Estado: 'En reparacion'

-- Insertando los ejemplares para '1984' (8 ejemplares)
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(2, 1),  -- Estado: 'Disponible'
(2, 2),  -- Estado: 'Reservado'
(2, 3),  -- Estado: 'Prestado'
(2, 4),  -- Estado: 'Dañado'
(2, 5),  -- Estado: 'En reparacion'
(2, 1),  -- Estado: 'Disponible'
(2, 2),  -- Estado: 'Reservado'
(2, 3);  -- Estado: 'Prestado'

-- Insertando los ejemplares para 'Cien Años de Soledad' (5 ejemplares)
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(3, 1),  -- Estado: 'Disponible'
(3, 2),  -- Estado: 'Reservado'
(3, 3),  -- Estado: 'Prestado'
(3, 4),  -- Estado: 'Dañado'
(3, 5);  -- Estado: 'En reparacion'

-- Insertando los ejemplares para 'Don Quijote de la Mancha' (15 ejemplares)
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(4, 1),  -- Estado: 'Disponible'
(4, 2),  -- Estado: 'Reservado'
(4, 3),  -- Estado: 'Prestado'
(4, 4),  -- Estado: 'Dañado'
(4, 5),  -- Estado: 'En reparacion'
(4, 1),  -- Estado: 'Disponible'
(4, 2),  -- Estado: 'Reservado'
(4, 3),  -- Estado: 'Prestado'
(4, 4),  -- Estado: 'Dañado'
(4, 5),  -- Estado: 'En reparacion'
(4, 1),  -- Estado: 'Disponible'
(4, 2),  -- Estado: 'Reservado'
(4, 3),  -- Estado: 'Prestado'
(4, 4),  -- Estado: 'Dañado'
(4, 5);  --  Estado: 'En reparacion'

-- Insertando los ejemplares para 'La Sombra del Viento' (12 ejemplares)
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(5, 1),  -- Estado: 'Disponible'
(5, 2),  -- Estado: 'Reservado'
(5, 3),  -- Estado: 'Prestado'
(5, 4),  -- Estado: 'Dañado'
(5, 5),  --  Estado: 'En reparacion'
(5, 1);  -- Estado: 'Disponible'

-- Insertando los ejemplares para 'Matar a un Ruiseñor' (6 ejemplares)
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(6, 1),  -- Estado: 'Disponible'
(6, 2),  -- Estado: 'Reservado'
(6, 3),  -- Estado: 'Prestado'
(6, 4),  --  Estado: 'Dañado'
(6, 5),  -- Estado: 'En reparacion'
(6, 1);  -- Estado: 'Disponible'

-- Insertando los ejemplares para 'Orgullo y Prejuicio' (9 ejemplares)
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(7, 1),  -- Estado: 'Disponible'
(7, 2),  -- Estado: 'Reservado'
(7, 3),  -- Estado: 'Prestado'
(7, 4),  -- Estado: 'Dañado'
(7, 5),  -- Estado: 'En reparacion'
(7, 1),  -- Estado: 'Disponible'
(7, 2),  -- Estado: 'Reservado'
(7, 3),  --  Estado: 'Prestado'
(7, 4);  -- Estado: 'Dañado'

-- Insertando los ejemplares para 'El Gran Gatsby' (7 ejemplares)
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(8, 1),  -- Estado: 'Disponible'
(8, 2),  -- Estado: 'Reservado'
(8, 3),  -- Estado: 'Prestado'
(8, 4),  -- Estado: 'Dañado'
(8, 5),  --  Estado: 'En reparacion'
(8, 1),  -- Estado: 'Disponible'
(8, 2);  --  Estado: 'Reservado'

--- Insertando los ejemplares para 'Crónica de una Muerte Anunciada' (10 ejemplares)
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(9, 1),  -- Estado: 'Disponible'
(9, 2),  -- Estado: 'Reservado'
(9, 3),  -- Estado: 'Prestado'
(9, 4),  -- Estado: 'Dañado'
(9, 5),  -- Estado: 'En reparacion'
(9, 1),  -- Estado: 'Disponible'
(9, 2),  --  Estado: 'Reservado'
(9, 3),  -- Estado: 'Prestado'
(9, 4),  -- Estado: 'Dañado'
(9, 2);  --  Estado: 'Reservado'


---- Insertando los ejemplares para 'Codigo Da Vinci' (13 ejemplares)
INSERT INTO EJEMPLAR_LIBRO (CODLIBRO, CODESTADO_EJEMPLAR) VALUES
(10, 1),  -- Estado: 'Disponible'
(10, 2),  -- Estado: 'Reservado'
(10, 3),  -- Estado: 'Prestado'
(10, 4),  -- Estado: 'Dañado'
(10, 5),  -- Estado: 'En reparacion'
(10, 1),  -- Estado: 'Disponible'
(10, 2),  -- Estado: 'Reservado'
(10, 3),  -- Estado: 'Prestado'
(10, 4),  -- Estado: 'Dañado'
(10, 1),  -- Estado: 'Disponible'
(10, 2),  -- Estado: 'Reservado'
(10, 3),  -- Estado: 'Prestado'
(10, 4);  -- Estado: 'Dañado'


INSERT INTO ESTADO_RESERVA (DESC_ESTADO_RESERVA) VALUES 
('Activa'),
('Inactiva'),
('Procesada');


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


INSERT INTO ESTADO_PRESTAMO (DESC_ESTADO_PRESTAMO) VALUES
('En préstamo'),
('Devuelto'),
('Retrasado');


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


INSERT INTO ESTADO_MULTA (DESC_ESTADO_MULTA) VALUES
('Pendiente'),
('Pagada');


INSERT INTO MOTIVO_MULTA (DESC_MOTIVO_MULTA) VALUES
('Retraso'),
('Dañado'),
('No devuelto');


INSERT INTO MULTA (CODESTADO_MULTA,CODMOTIVO_MULTA,CODDETALLE,MONTO,FECHAGENERACION)VALUES
(1,1,1,140,'2024-12-18'),
(2,1,1,100,'2024-12-19'),
(2,1,1,20,'2024-12-20');

INSERT INTO PAGO_MULTA(CODMULTA,FECHAPAGO,MONTOPAGADO,METODOPAGO)VALUES
(2,'2024-12-23',100,'Tarjeta'),
(3,'2024-12-20',20,'Tarjeta');


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

SELECT * FROM VistaDeLibrosDisponibles




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

SELECT * FROM LIBRO



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

EXEC ObtenerLibrosNoDisponibles



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
    WHERE r.CODUSUARIO = @CodUsuario; -- Filtro por el usuario
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




CREATE PROCEDURE CambiarEstadoLibroSinStock
AS
BEGIN
    -- Actualizar el estado de los libros con cantidad cero
    UPDATE LIBRO
    SET CODESTADO = (SELECT CODESTADO FROM ESTADO WHERE DESC_ESTADO = 'No Disponible')
    WHERE CANTIDAD = 0;
END;

EXEC CambiarEstadoLibroSinStock

