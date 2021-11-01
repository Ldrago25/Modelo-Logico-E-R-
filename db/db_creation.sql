/*
    Creado por los equipos 3 y 4
    Base de datos I sección 1 2021-3
    
    Autores:
    Camargo Meaury, Franklin Josué; C.I: V.-27655989
    Contreras Rojas, Reyner David;  C.I: V.-26934400
    Vargas Rueda, Brandon José; C.I: V.-26566047

*/

CREATE TABLE tipos_dptos(
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nombre VARCHAR2(40) NOT NULL,
    
    CONSTRAINT tipos_dptos_pk PRIMARY KEY (id),
    
    CONSTRAINT tipos_dptos_ck CHECK (nombre IN ('CARRERA', 'APOYO')),
    
    CONSTRAINT tipos_dptos_uk UNIQUE (nombre)
);

/* Trigger de tipos_dptos para que el nombre se almacene en mayusculas */
CREATE OR REPLACE TRIGGER touppercasetiposdpto
BEFORE INSERT OR UPDATE ON tipos_dptos
FOR EACH ROW
BEGIN  
   :NEW.nombre := UPPER(:NEW.nombre);
END;
/

CREATE TABLE edificios(
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nombre VARCHAR2(30) NOT NULL,
    
    CONSTRAINT edificios_uk UNIQUE (nombre),
    
    CONSTRAINT edificios_pk PRIMARY KEY (id)
);

CREATE TABLE departamentos(
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    codigo VARCHAR2(12) NOT NULL,
    carrera VARCHAR2(50) NOT NULL,
    tipos_dptos_id INT NOT NULL,
    edificios_id INT NOT NULL,
    
    CONSTRAINT dptos_uk1 UNIQUE (codigo),
    CONSTRAINT dptos_uk2 UNIQUE (edificios_id),
    
    CONSTRAINT dptos_edificios_fk
        FOREIGN KEY (edificios_id) REFERENCES edificios(id)
        ON DELETE SET NULL,
        
    CONSTRAINT dptos_tipos_fk
        FOREIGN KEY (tipos_dptos_id) REFERENCES tipos_dptos(id)
        ON DELETE SET NULL,
        
    CONSTRAINT dptos_pk PRIMARY KEY (id)
);

CREATE TABLE aulas(
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nro_aula smallint NOT NULL,
    edificios_id int NOT NULL,
    
    CONSTRAINT aulas_pk PRIMARY KEY (id),
    
    CONSTRAINT aulas_uk UNIQUE (nro_aula, edificios_id),
    
    CONSTRAINT aulas_ck CHECK (nro_aula > 0) ,
    
    CONSTRAINT aulas_edificios_fk
        FOREIGN KEY (edificios_id) REFERENCES edificios(id)
        ON DELETE CASCADE
);

CREATE TABLE areas_saber(
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nombre VARCHAR2(20) NOT NULL,
    descripcion VARCHAR2(100) NOT NULL,
    dpto_id INT NOT NULL,
    
    CONSTRAINT areas_saber_pk PRIMARY KEY (id),
    
    CONSTRAINT areas_saber_uk UNIQUE (nombre),
    
    CONSTRAINT areas_saber_dpto_fk
        FOREIGN KEY (dpto_id) REFERENCES departamentos(id)
        ON DELETE CASCADE
);

CREATE TABLE asignaturas(
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    codigo VARCHAR2(12) NOT NULL,
    nombre VARCHAR2(30) NOT NULL,    
    hora_lab CHAR(5) DEFAULT NULL,
    hora_teoria CHAR(5) DEFAULT NULL,
    estado CHAR(1) NOT NULL,
    
    CONSTRAINT asignaturas_pk PRIMARY KEY (id),
    
    CONSTRAINT asignaturas_uk1 UNIQUE (codigo),
    CONSTRAINT asignaturas_uk2 UNIQUE (nombre),
    
    CONSTRAINT asignaturas_ck1 CHECK (estado IN ('A', 'I')),
    CONSTRAINT asignaturas_ck2
        CHECK (hora_lab IS NOT NULL OR hora_teoria IS NOT NULL)
);

/* Trigger de asignaturas para que el nombre se almacene en mayusculas */
CREATE OR REPLACE TRIGGER touppercaseasig
BEFORE INSERT OR UPDATE ON asignaturas
FOR EACH ROW
BEGIN  
   :NEW.nombre := UPPER(:NEW.nombre);
END; 
/

CREATE TABLE profesores(
    cedula CHAR(11) NOT NULL,
    nro_carnet INT NOT NULL,    
    nombre VARCHAR2(200) NOT NULL,
    telefono CHAR(15) NOT NULL,
    correo VARCHAR2(50) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    profesion VARCHAR2(30) NOT NULL,
    dpto_id INT NOT NULL,
    areas_saber_id INT NOT NULL,
    
    CONSTRAINT profesores_pk PRIMARY KEY (cedula),
    
    CONSTRAINT profesores_uk1 UNIQUE (nro_carnet),
    CONSTRAINT profesores_uk2 UNIQUE (correo),
    
    /* 
        Por alguna extrana razon el checks de telefono no validan
        correctamente. Problemas al validar que todo sea numeros.
    */
    CONSTRAINT profesores_ck1
        CHECK (
            REGEXP_LIKE(cedula, '((^E)|(^V))[0-9]')
            AND TO_NUMBER(SUBSTR(cedula, 2)) > 0
        ),
    CONSTRAINT profesores_ck2 CHECK (nro_carnet > 0),
    CONSTRAINT profesores_ck3 CHECK (REGEXP_LIKE(telefono, '[0-9]+')),
    /* Check para longitud de numeros, variable por si incluye codigo de pais */
    CONSTRAINT profesores_ck4 CHECK (LENGTH(telefono) > 10),
    CONSTRAINT profesores_ck5 CHECK 
            (REGEXP_LIKE(correo,'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')),
            
    CONSTRAINT profesores_dpto_fk 
        FOREIGN KEY (dpto_id) REFERENCES departamentos(id)
        ON DELETE SET NULL,
    CONSTRAINT profesores_areas_saber_fk
        FOREIGN KEY (areas_saber_id) REFERENCES areas_saber(id)
        ON DELETE SET NULL
);

/* Trigger de profesores para que el nombre se almacene en mayusculas */
CREATE OR REPLACE TRIGGER touppercaseprof
BEFORE INSERT OR UPDATE ON profesores
FOR EACH ROW
BEGIN
   :NEW.nombre := UPPER(:NEW.nombre);
   :NEW.cedula := UPPER(:NEW.cedula);
END; 
/

CREATE TABLE secciones(
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nro_seccion INT NOT NULL,
    asignaturas_id INT NOT NULL,
    profesores_cedula CHAR(11) NOT NULL,
    
    CONSTRAINT secciones_uk1 UNIQUE (nro_seccion, asignaturas_id),
    CONSTRAINT secciones_uk2 UNIQUE (id),
    
    CONSTRAINT secciones_ck CHECK (nro_seccion > 0 AND nro_seccion < 100),
    
    CONSTRAINT secciones_asignaturas_fk
        FOREIGN KEY (asignaturas_id) REFERENCES asignaturas(id)
        ON DELETE CASCADE,
    CONSTRAINT secciones_profesores_fk
        FOREIGN KEY (profesores_cedula) REFERENCES profesores(cedula)
        ON DELETE SET NULL,
        
    CONSTRAINT secciones_pk PRIMARY KEY (id, profesores_cedula)   
);

/* Trigger de secciones para que cedula se almacene en mayusculas */
CREATE OR REPLACE TRIGGER touppercasesecc
BEFORE INSERT OR UPDATE ON secciones
FOR EACH ROW
BEGIN
   :NEW.profesores_cedula := UPPER(:NEW.profesores_cedula);
END; 
/

CREATE TABLE bloque_hora(
    hora_desde CHAR(5) NOT NULL,
    hora_hasta CHAR(5) NOT NULL,
    dia CHAR(10) NOT NULL,
    
    CONSTRAINT bloque_hora_pk PRIMARY KEY (hora_desde, hora_hasta, dia),
    
    CONSTRAINT bloque_hora_ck1
        CHECK (dia IN ('LUNES', 'MARTES', 'MIERCOLES', 'JUEVES',
            'VIERNES', 'SABADO', 'DOMINGO')),
            
    CONSTRAINT bloque_hora_ck2
        CHECK (
            REGEXP_LIKE(hora_desde,'^([0-9]{2,2}):([0-9]{2,2})$') AND
            REGEXP_LIKE(hora_hasta,'^([0-9]{2,2}):([0-9]{2,2})$')
        ),
    
    CONSTRAINT bloque_hora_ck3 CHECK (
        TO_NUMBER(SUBSTR(hora_desde, 1, 2)) < 24 AND
        TO_NUMBER(SUBSTR(hora_desde, 4, 2)) < 60
    ),
    CONSTRAINT bloque_hora_ck4 CHECK (
        TO_NUMBER(SUBSTR(hora_hasta, 0, 2)) < 24 AND
        TO_NUMBER(SUBSTR(hora_hasta, 4, 2)) < 60
    ),
    CONSTRAINT bloque_hora_ck5 CHECK (
        TO_NUMBER(REPLACE(hora_desde,':', '')) <=
        TO_NUMBER(REPLACE(hora_hasta,':', ''))
    )
);

/* Trigger de bloque_hora para que el dia se almacene en mayusculas */
CREATE OR REPLACE TRIGGER touppercasebloquehora
BEFORE INSERT OR UPDATE ON bloque_hora
FOR EACH ROW
BEGIN  
   :NEW.dia := UPPER(:NEW.dia);
END; 
/

CREATE TABLE disponibilidad(
    profesores_cedula CHAR(11) NOT NULL,
    bloque_hora_desde CHAR(5) NOT NULL,
    bloque_hora_hasta CHAR(5) NOT NULL,
    bloque_dia CHAR(10) NOT NULL,
    
    CONSTRAINT disponibilidad_profesor_fk
        FOREIGN KEY (profesores_cedula) REFERENCES profesores(cedula)
        ON DELETE CASCADE,
    CONSTRAINT disponibilidad_hora_fk
        FOREIGN KEY (bloque_hora_desde, bloque_hora_hasta, bloque_dia)
        REFERENCES bloque_hora(hora_desde, hora_hasta, dia) ON DELETE CASCADE,
        
    CONSTRAINT disponibilidad_uk
        UNIQUE (profesores_cedula, bloque_hora_desde, bloque_dia),
        
    CONSTRAINT disponibilidad_hora_pk
        PRIMARY KEY
        (profesores_cedula, bloque_hora_desde, bloque_hora_hasta, bloque_dia)
);

/* Trigger de disponibilidad para que cedula y dia se almacenen en mayusculas */
CREATE OR REPLACE TRIGGER touppercasedisp
BEFORE INSERT OR UPDATE ON disponibilidad
FOR EACH ROW
BEGIN  
   :NEW.bloque_dia := UPPER(:NEW.bloque_dia);
   :NEW.profesores_cedula := UPPER(:NEW.profesores_cedula);
END; 
/

CREATE TABLE hor_clases(
    profesores_cedula CHAR(11) NOT NULL,
    secciones_id INT NOT NULL,
    aulas_id INT NOT NULL,
    bloque_hora_desde CHAR(5) NOT NULL,
    bloque_hora_hasta CHAR(5) NOT NULL,
    bloque_dia CHAR(10) NOT NULL,
    tipo_clase CHAR(1) NOT NULL,
        
    CONSTRAINT hor_clases_aulas_fk
        FOREIGN KEY (aulas_id) REFERENCES aulas(id)
        ON DELETE SET NULL,
    CONSTRAINT hor_clases_secciones_fk
        FOREIGN KEY (secciones_id, profesores_cedula)
        REFERENCES secciones(id, profesores_cedula)
        ON DELETE CASCADE,
    CONSTRAINT hor_clases_bloque_hora_fk
        FOREIGN KEY (bloque_hora_desde, bloque_hora_hasta, bloque_dia)
        REFERENCES bloque_hora(hora_desde, hora_hasta, dia) ON DELETE CASCADE,
        
    CONSTRAINT hor_clases_uk1
        UNIQUE (profesores_cedula, bloque_hora_desde, bloque_dia),
    CONSTRAINT hor_clases_uk2 /* en teoria no deberia hacer falta */
        UNIQUE (secciones_id, bloque_hora_desde, bloque_dia),
    CONSTRAINT hor_clases_uk3
        UNIQUE (aulas_id, bloque_hora_desde, bloque_dia),
    CONSTRAINT hor_clases_uk4 CHECK (tipo_clase IN ('T', 'L')),
    
     CONSTRAINT hor_clases_pk
        PRIMARY KEY
        (secciones_id, aulas_id, bloque_hora_desde, bloque_hora_hasta, bloque_dia)  
);

/* Trigger de hor_clases para que cedula, dia y tipo_clase dia se almacenen
en mayusculas */
CREATE OR REPLACE TRIGGER touppercasehor_clases
BEFORE INSERT OR UPDATE ON hor_clases
FOR EACH ROW
BEGIN  
   :NEW.bloque_dia := UPPER(:NEW.bloque_dia);
   :NEW.profesores_cedula := UPPER(:NEW.profesores_cedula);
   :NEW.tipo_clase := UPPER(:NEW.tipo_clase);
END; 
/
    -- Falta hacer checks de que profesor tenga 16 horas o menos de clase a la semana


/* AQUI EMPIEZAN LOS INSERT */

-- tipos_dptos
INSERT INTO tipos_dptos (nombre) 
VALUES ('CARRERA');
INSERT INTO tipos_dptos (nombre) 
VALUES ('APOYO');
	--ERROR
INSERT INTO tipos_dptos (nombre) 
VALUES ('');
INSERT INTO tipos_dptos (nombre) 
VALUES ('CIENCIAS');
INSERT INTO tipos_dptos (nombre) 
VALUES ('apoyo');

SELECT * FROM TIPOS_DPTOS;

-- edificios
INSERT INTO edificios (nombre)
VALUES ('A');
INSERT INTO edificios (nombre) 
VALUES ('B');
	--ERROR
INSERT INTO edificios (nombre) 
VALUES ('');

SELECT * FROM EDIFICIOS;

-- departamentos-------------------
INSERT INTO departamentos(codigo,carrera,tipos_dptos_id,edificios_id)
VALUES(123,'matematica',1,1); --carrera edi_A
INSERT INTO departamentos(codigo,carrera,tipos_dptos_id,edificios_id)
VALUES(1234,'informatica',1,2);--carrera edi_B
	--ERROR
INSERT INTO departamentos(codigo,carrera,tipos_dptos_id,edificios_id)
VALUES(123,'electronica',1,1); --carrera edi_A
INSERT INTO departamentos(codigo,carrera,tipos_dptos_id,edificios_id)
VALUES(1,'matematica',1,1); --carrera edi_A
INSERT INTO departamentos(codigo,carrera,tipos_dptos_id,edificios_id)
VALUES(123,1,1); --carrera edi_A

SELECT * FROM DEPARTAMENTOS;

-- aulas
INSERT INTO aulas (nro_aula,edificios_id)
VALUES ('1',1); -- nro 1 edificio A
INSERT INTO aulas (nro_aula,edificios_id)
VALUES ('2',1); -- nro 2 edificio A
INSERT INTO aulas (nro_aula,edificios_id)
VALUES ('1',2); -- nro 1 edificio B
INSERT INTO aulas (nro_aula,edificios_id)
VALUES ('2',2); -- nro 2 edificio B
	-- error
INSERT INTO aulas (nro_aula,edificios_id)
VALUES ('1',1); -- ya existe
INSERT INTO aulas (nro_aula,edificios_id)
VALUES ('1',3); -- edificio de ID 3 no existe

SELECT * FROM AULAS;

-- areas_saber
INSERT INTO areas_saber (nombre,descripcion,dpto_id)
VALUES ('humanidades','Humanidad1',1);
INSERT INTO areas_saber (nombre,descripcion,dpto_id)
VALUES ('arte','Arte.',2);
	-- error
INSERT INTO areas_saber (nombre,descripcion,dpto_id)
VALUES ('humanidades','humanidad2',1);

SELECT * FROM AREAS_SABER;

-- asignaturas
INSERT INTO asignaturas (codigo,nombre,hora_lab,hora_teoria,estado)
VALUES ('123','matematica','3','2','A');
INSERT INTO asignaturas (codigo,nombre,hora_lab,hora_teoria,estado)
VALUES ('124','fisica','3','2','I');
INSERT INTO asignaturas (codigo,nombre,hora_teoria,estado)
VALUES ('125','historia','4','I');
INSERT INTO asignaturas (codigo,nombre,hora_lab,estado)
VALUES ('126','lab fisica','4','I');
	-- error
INSERT INTO asignaturas (codigo,nombre,hora_lab,hora_teoria,estado)
VALUES ('123','calculo','3','2','A');  -- codigo
INSERT INTO asignaturas (codigo,nombre,hora_lab,hora_teoria,estado)
VALUES ('127','algebra lineal','3','2','P'); -- estado no valido
INSERT INTO asignaturas (codigo,nombre,hora_lab,hora_teoria,estado)
VALUES ('128','matematica','1','1','A'); -- nombre
INSERT INTO asignaturas (codigo,nombre,estado)
VALUES ('129','matematica I','A'); -- ambas horas nulas
INSERT INTO asignaturas (codigo,nombre,hora_lab,hora_teoria,estado)
VALUES ('130','matemati','','','A');  -- codigo

SELECT * FROM ASIGNATURAS;

-- PROFESORES
INSERT INTO profesores 
VALUES ('v12123123',1,'jose barrera','121231231231','jose@correo.com','Sc edo tachira','docente',1,1);
INSERT INTO profesores 
VALUES ('e12123123',2,'maria sandoval','121231231230','mariajo@correo.com','pueblo nuevo','docente',1,1);
INSERT INTO profesores 
VALUES ('v23545444',3,'jose barrera','121231231231','jose3@correo.com','Sc edo tachira','docente',1,1);
		-- ERROR
INSERT INTO profesores 
VALUES ('v12123123',4,'jose barrera','121231','jose@correo','Sc edo tachira','docente',1,1); -- cedula
INSERT INTO profesores 
VALUES ('V0',5,'jose barrera','121231','jose@correo.com','Sc edo tachira','docente',1,1); -- cedula
INSERT INTO profesores 
VALUES ('V',5,'jose barrera','121231','jose@correo.com','Sc edo tachira','docente',1,1); -- cedula
INSERT INTO profesores 
VALUES ('V32123123',1,'jose piedra','121231','jose4@correo.com','Sc edo tachira','docente',1,1); -- nro carnet
INSERT INTO profesores 
VALUES ('v1212312323',12,'jose barrera'); -- faltan datos
INSERT INTO profesores 
VALUES ('v23545444',5,'jose piedra','121231231231','jose@correo.com','Sc edo tachira','docente',1,1); -- correo
INSERT INTO profesores 
VALUES ('v23545444',5,'jose piedra','121231231231','jose @correo.com','Sc edo tachira','docente',1,1); -- correo
INSERT INTO profesores 
VALUES ('v23545444',5,'jose piedra','121231231231','jose@ correo.com','Sc edo tachira','docente',1,1); -- correo
INSERT INTO profesores 
VALUES ('v23545444',5,'jose piedra','121231231231','jose@correocom','Sc edo tachira','docente',1,1); -- correo
INSERT INTO profesores 
VALUES ('v23545444',5,'jose piedra','121231231231','josecorreo.com','Sc edo tachira','docente',1,1); -- correo

SELECT * FROM PROFESORES;

-- secciones
INSERT INTO secciones (nro_seccion,asignaturas_id,profesores_cedula)
VALUES(1,1,'v12123123');
INSERT INTO secciones (nro_seccion,asignaturas_id,profesores_cedula)
VALUES(1,2,'v23545444');
INSERT INTO secciones (nro_seccion,asignaturas_id,profesores_cedula)
VALUES(2,1,'e12123123');
INSERT INTO secciones (nro_seccion,asignaturas_id,profesores_cedula)
VALUES(2,2,'v12123123');
	-- error
INSERT INTO secciones (nro_seccion,asignaturas_id,profesores_cedula)
VALUES(1,1,'v12123123'); -- combinacion
INSERT INTO secciones (nro_seccion,asignaturas_id,profesores_cedula)
VALUES(100,1,'v12123111'); -- nro seccion
INSERT INTO secciones (nro_seccion,asignaturas_id,profesores_cedula)
VALUES(-1,1,'v12123123'); -- nro seccion
INSERT INTO secciones (nro_seccion,asignaturas_id,profesores_cedula)
VALUES(0,1,'v12123123'); -- nro seccion

SELECT * FROM SECCIONES;

-- bloque_hora
INSERT INTO bloque_hora
VALUES ('08:00','10:00','lunes');
INSERT INTO bloque_hora
VALUES ('02:00','17:00','lunes');
INSERT INTO bloque_hora
VALUES ('00:50','00:50','lunes');
INSERT INTO bloque_hora
VALUES ('08:00','15:00','lunes');
	-- ERROR
INSERT INTO bloque_hora
VALUES ('20:00am','10:00am','lunes'); --datos mal, debe ser hora militar
INSERT INTO bloque_hora
VALUES ('24:50','00:50','lunes'); --hora desde
INSERT INTO bloque_hora
VALUES ('00:60','00:50','lunes'); -- hora desde
INSERT INTO bloque_hora
VALUES ('00:50','24:50','lunes'); -- hora hasta
INSERT INTO bloque_hora
VALUES ('00:50','00:60','lunes'); -- hora hasta
INSERT INTO bloque_hora
VALUES ('08:00','10:00','algo'); -- dia
INSERT INTO bloque_hora
VALUES ('08:00','10:00','lunes'); -- repetido
INSERT INTO bloque_hora
VALUES ('00:50','00:00','lunes'); -- hora hasta menor a hora desde

SELECT * FROM BLOQUE_HORA;

-- disponibilidad
INSERT INTO disponibilidad
VALUES ('V12123123','08:00','10:00','lunes');
INSERT INTO disponibilidad
VALUES ('V12123123','02:00','17:00','lunes');
INSERT INTO disponibilidad
VALUES ('V23545444','02:00','17:00','lunes');
    -- ERROR
INSERT INTO disponibilidad
VALUES ('V12123123 ','02:00','17:00','lunes'); --PK
INSERT INTO disponibilidad
VALUES ('V23545444','02:00','17:00','martes'); --bloque_hora
INSERT INTO disponibilidad
VALUES ('V23545444','03:00','17:00','lunes'); --bloque_hora
INSERT INTO disponibilidad
VALUES ('V12123123','08:00','15:00','lunes'); --hora_desde y dia repetidos para mismo prof

SELECT * FROM DISPONIBILIDAD;

-- hor_clases
-- (cedula, secciones_id, aula_id, bloque_desde bloque_hasta bloque_dia, tipo_clase)
INSERT INTO hor_clases
VALUES ('v12123123',1, 1,'08:00','10:00','LUNES', 'T');
INSERT INTO hor_clases
VALUES ('V23545444',2, 2,'08:00','10:00','LUNES', 'l');
INSERT INTO hor_clases
VALUES ('V23545444',2, 1,'02:00','17:00','LUNES', 't');
    -- ERROR
INSERT INTO hor_clases
VALUES ('v12123123',1, 1,'08:00','10:00','LUNES', 'T'); --aula ocupada
INSERT INTO hor_clases
VALUES ('V23545444',1, 1,'08:00','10:00','LUNES', 'T'); --prof no corresponde a seccion
INSERT INTO hor_clases
VALUES ('v12123123',1, 1,'02:00','17:00','LUNES', 'l'); -- profesor ocupado
INSERT INTO hor_clases
VALUES ('V23545444',2, 2,'08:00','10:00','LUNES', 'D'); --tipo_clase
INSERT INTO hor_clases
VALUES ('v23545444',1, 2,'02:00','17:00','martes', 'T'); --bloque_hora no existe
INSERT INTO hor_clases
VALUES ('V23545444',2, 1,'08:00','10:00','LUNES', 'l'); -- error seccion

SELECT * FROM HOR_CLASES;
