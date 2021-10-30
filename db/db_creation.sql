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
    hora_lab CHAR(5),
    hora_teoria CHAR(5),
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
    
    CONSTRAINT profesores_ck1 CHECK (REGEXP_LIKE(cedula, '^(E|V)[0-9]$')),
    CONSTRAINT profesores_ck2 CHECK (nro_carnet > 0),
    CONSTRAINT profesores_ck3 CHECK (REGEXP_LIKE(telefono, '^[0-9]$')),
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
END; 

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
        
    CONSTRAINT secciones_pk PRIMARY KEY (id, asignaturas_id, profesores_cedula)   
);

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

/* Trigger de tipos_dptos para que el nombre se almacene en mayusculas */
CREATE OR REPLACE TRIGGER touppercasebloquehora
BEFORE INSERT OR UPDATE ON bloque_hora
FOR EACH ROW
BEGIN  
   :NEW.dia := UPPER(:NEW.dia);
END; 

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

CREATE TABLE hor_clases(
    profesores_cedula CHAR(11) NOT NULL,
    aulas_id INT NOT NULL,
    secciones_id INT NOT NULL,
    bloque_hora_desde CHAR(5) NOT NULL,
    bloque_hora_hasta CHAR(5) NOT NULL,
    bloque_dia CHAR(10) NOT NULL,
    tipo_clase CHAR(1) NOT NULL,
        
    CONSTRAINT hor_clases_profesor_fk
        FOREIGN KEY (profesores_cedula) REFERENCES profesores(cedula)
        ON DELETE SET NULL,
    CONSTRAINT hor_clases_aulas_fk
        FOREIGN KEY (aulas_id) REFERENCES aulas(id)
        ON DELETE SET NULL,
    CONSTRAINT hor_clases_secciones_fk
        FOREIGN KEY (secciones_id) REFERENCES secciones(id)
        ON DELETE CASCADE,
    CONSTRAINT hor_clases_bloque_hora_fk
        FOREIGN KEY (bloque_hora_desde, bloque_hora_hasta, bloque_dia)
        REFERENCES bloque_hora(hora_desde, hora_hasta, dia) ON DELETE CASCADE,
        
    CONSTRAINT hor_clases_uk1
        UNIQUE (profesores_cedula, bloque_hora_desde, bloque_dia),
    CONSTRAINT hor_clases_uk2
        UNIQUE (secciones_id, bloque_hora_desde, bloque_dia),
    CONSTRAINT hor_clases_uk3
        UNIQUE (aulas_id, bloque_hora_desde, bloque_dia),
        
     CONSTRAINT hor_clases_pk
        PRIMARY KEY
        (aulas_id, secciones_id, bloque_hora_desde, bloque_hora_hasta, bloque_dia),
        
    CONSTRAINT hor_clases_uk4 CHECK (tipo_clase IN ('T', 'L'))
);

/*  Falta hacer checks de que profesor tenga 16 horas o menos de clase a la semana
    Aparte, profesores tiene problemas con la restriccion de telefono no se por que
*/