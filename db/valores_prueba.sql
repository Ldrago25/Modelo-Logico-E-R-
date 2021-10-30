INSERT INTO EDIFICIOS(NOMBRE) VALUES ('A');
INSERT INTO TIPOS_DPTOS(NOMBRE) VALUES ('apoyo');
INSERT INTO DEPARTAMENTOS(carrera,codigo,edificios_id,tipos_dptos_id) VALUES ('PEPETIÑO', 'DSA', 1, 1);
INSERT INTO AREAS_SABER(NOMBRE, DESCRIPCION, dpto_id) VALUES ('PEPO', 'DNO', 2);
INSERT INTO PROFESORES(cedula,nro_carnet,nombre,telefono,correo,profesion,direccion,areas_saber_id,dpto_id) VALUES ('V26934400', 1, 'Reyner COntreras', '04147005384', 'reynercontreras0@gmail.com', 'papaapa', 'estu', 2, 2);

INSERT INTO BLOQUE_HORA(hora_desde, hora_hasta, dia) VALUES ('22:59', '22:59', 'LUNES');
SELECT * FROM BLOQUE_HORA;
TRUNCATE TABLE BLOQUE_HORA;

SELECT * from tipos_dptos;
SELECT * from departamentos;
SELECT * from areas_saber;

select * from profesores;
TRUNCATE TABLE profesores;