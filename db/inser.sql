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
