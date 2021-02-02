--antes de comenzar a borrar, debemos de borrar la fk de DEPARTAMENTOS para que el borrado sea correcto.
--ALTER TABLE DEPARTAMENTOS DROP CONSTRAINT directores;
-- borramos las tablas en orden inverso para que no haya errores
DROP TABLE clase;
DROP TABLE matricula;
DROP TABLE GRUPO;
DROP TABLE PROFESORES CASCADE CONSTRAINTS;
DROP TABLE DEPARTAMENTOS CASCADE CONSTRAINTS;
DROP TABLE AULA;
DROP TABLE ASIGNATURA;
DROP TABLE ALUMNO;
-----------------------------------------------------------
--creación de tanlas
CREATE TABLE ALUMNO(
	DNI CHAR(9),
	nombre VARCHAR(35) not null,
	fechaNac date,
	provincia VARCHAR(50),
	beca CHAR(2) CHECK (beca IN ('SI', 'NO') ),
	PRIMARY KEY(DNI)
);
----------------------------------------------------------------------------
CREATE TABLE ASIGNATURA(
	CODASIG VARCHAR(8),
	nombre VARCHAR(35),
	creditos INT CHECK(creditos BETWEEN 0 AND 20),
	caracter CHAR (1) CHECK ( CARACTER IN ('T', 'P') ),
	curso INT CHECK (curso BETWEEN 0 AND 7),
	PRIMARY KEY(CODASIG)
);

------------------------------------------------------------------------------
CREATE TABLE AULA(
	CodAula CHAR(4),
	capacidad INT CHECK ( capacidad BETWEEN 10 AND 70),
	PRIMARY KEY(CodAula)
);



-----------------------------------------------------------------------------
CREATE TABLE DEPARTAMENTOS(
	CodDep VARCHAR(8),
	NombreDep VARCHAR(20) not null,
	directores CHAR(17),
	PRIMARY KEY(CodDep, NombreDep)
);



--------------------------------------------------------------------------
CREATE TABLE PROFESORES(
	NRP CHAR(17),
	nombre VARCHAR(20) not null,
	CodDep VARCHAR(8),
	NombreDep VARCHAR(20),
	Categoria CHAR(2),
	area CHAR(6),
	FOREIGN KEY(CodDep, NombreDep)REFERENCES DEPARTAMENTOS (CodDep, NombreDep),
	PRIMARY KEY (NRP)
);


--------------------------------------------------------------------------
CREATE TABLE GRUPO(
	CODASIG VARCHAR(8),
	CodGrupo CHAR(1),
	Tipo CHAR (2) CHECK( Tipo IN ('TE', 'PR')),
	NRP char(17),
	MaxAlumn INT CHECK(MaxAlumn BETWEEN 5 AND 40),
	FOREIGN KEY (CODASIG)REFERENCES ASIGNATURA (CODASIG),
	FOREIGN KEY (NRP) REFERENCES PROFESORES(NRP),
	PRIMARY KEY (CODASIG, CodGrupo, Tipo)
);


-------------------------------------------------------------------------
CREATE TABLE matricula(
	DNI CHAR(9),
	Convocatoria CHAR(5),
	CODASIG VARCHAR(8),
	CodGrupo CHAR(1),
	Tipo CHAR (2) CHECK (Tipo IN ('TE','PR')),
	calificacion VARCHAR(5),
	FOREIGN KEY (CODASIG, CodGrupo, Tipo) REFERENCES GRUPO (CODASIG,CodGrupo,Tipo),
	FOREIGN KEY (DNI) REFERENCES ALUMNO(DNI),
	PRIMARY KEY (DNI,Convocatoria)
);

----------------------------------------------------------------------
CREATE TABLE clase(
	CodAula CHAR(4),
	Dia CHAR(1)CHECK(Dia IN('L','M','X','J','V') ),
	hora NUMBER,
	CODASIG VARCHAR(8),
	CodGrupo CHAR(1),
	Tipo CHAR (2) CHECK ( Tipo IN('TE','PR') ),
	FOREIGN KEY (CodAula) REFERENCES AULA(CodAula),
	FOREIGN KEY (CODASIG, CodGrupo, Tipo) REFERENCES GRUPO(CODASIG,CodGrupo,Tipo),
	PRIMARY KEY(CodAula,Dia,hora,CODASIG,CodGrupo,Tipo)
);

-------------------------------------------------------------------
--rellenamos las tablas

INSERT INTO ALUMNO VALUES ('76592866Z' , 'CHRISTIAN' , '12-12-12' , 'Granada' , 'SI');
INSERT INTO ALUMNO VALUES ('76500866Z' , 'EDUARDO' , '12-12-11' , 'Jaen' , 'NO');
INSERT INTO ALUMNO VALUES ('76543211A' , 'JAIME' , '12-12-11' , 'Sevilla' , 'NO');
INSERT INTO ALUMNO VALUES ('76000866Z' , 'MANOLO' , '1-12-12' , 'Granada' , 'SI');
INSERT INTO ALUMNO VALUES ('76549877K' , 'Hilario' , '12-12-10' , 'Jaen' , 'SI');




INSERT INTO ASIGNATURA VALUES ('PROG', 'PROGRAMACION','15', 'T', '5');
INSERT INTO ASIGNATURA VALUES ('BD', 'BASE DE DATOS','10', 'P', '3');
INSERT INTO ASIGNATURA VALUES ('SI', 'SISTEMAS','8', 'P', '2');
INSERT INTO ASIGNATURA VALUES ('LM', 'LENGUAJE MARCAS','7', 'P', '2');
INSERT INTO ASIGNATURA VALUES ('FOL', 'FORMACION Y ORIENTACION LABORAL',NULL, 'P', '2');

INSERT INTO AULA VALUES ('A202', 15);
INSERT INTO AULA VALUES ('A203', 40);


--ponemos valor null en los departamentos porque despues lo vamos a actualizar
INSERT INTO DEPARTAMENTOS VALUES ('INFOR', 'INFORMATICA', NULL);
INSERT INTO DEPARTAMENTOS VALUES ('MATE', 'MATEMATICAS', NULL);
INSERT INTO DEPARTAMENTOS VALUES ('LIT', 'LITERATURA', NULL);


-- vamos a alterar la tabla DEPARTAMENTOS añadiendole una fk (directores)
ALTER TABLE DEPARTAMENTOS ADD CONSTRAINT directores FOREIGN KEY (directores)  REFERENCES PROFESORES (NRP);
INSERT INTO PROFESORES VALUES ('1234567890GR45ESZ', 'Jaime', 'INFOR', 'INFORMATICA', 'LC', 'ELECTR' );
INSERT INTO PROFESORES VALUES ('1234560090GR45ESZ', 'Luis', 'LIT', 'LITERATURA', 'LC', 'COMPUT' );
INSERT INTO PROFESORES VALUES ('1234562290GR45ESZ', 'Laura', 'MATE', 'MATEMATICAS', 'AS', 'INFORM' );
-- una vez insetados los valores en profesores, actualizamos las tablas de departamentos
UPDATE DEPARTAMENTOS SET directores = '1234567890GR45ESZ' WHERE CodDep = 'INFOR';
UPDATE DEPARTAMENTOS SET directores = '1234560090GR45ESZ' WHERE CodDep = 'LIT';
UPDATE DEPARTAMENTOS SET directores = '1234562290GR45ESZ' WHERE CodDep = 'MATE';

-- imprimimos la tabla departamentos despues de insertar valores
--SELECT * FROM DEPARTAMENTOS;



INSERT INTO GRUPO VALUES('PROG', 'A', 'PR', '1234567890GR45ESZ', '30');
INSERT INTO GRUPO VALUES('BD', 'A', 'PR', '1234567890GR45ESZ', '30');


INSERT INTO matricula VALUES ('76592866Z', '19/20', 'PROG', 'A', 'PR', 9);

INSERT INTO clase VALUES ('A202', 'L','10','PROG','A','PR');
INSERT INTO clase VALUES ('A203', 'M','12','BD','A','PR');




----------------------------------------------------------------------
--vamos a realizar algunas consultas

--7.17 Encontrar los profesores que hay en la Base de datos, Mostrando su NRP, nombre y categoria

SELECT NRP, nombre, categoria FROM PROFESORES;

--7.18 Mostrar las aulas que hay en la base de datos con todos sus atributos

SELECT * FROM AULA;

--7.19 encontrar los profesores cuya categoria sea 'AS'

SELECT * FROM PROFESORES WHERE Categoria='AS';

--7.20 Encontrar aquillos profesores cuya categoria no es 'AS' y cuyo area de conocimiento es 'COMPUT' o 'ELECTR'

-- <> --> negacion
SELECT * FROM PROFESORES WHERE Categoria <> 'AS' AND (area='COMPUT' or area='ELECTR'); 

--7.21 Encontrar aquellas aulas que tienen una capacidad entre 30 y 50 alumnos.
-- between...and... lo utilizamos para comparar que un numero este entre un número y otro
SELECT * FROM AULA WHERE capacidad BETWEEN 30 and 50;

--7.22 Mostrar Alumnos procedentes de Granada o Jaén con beca
-- usamos el in para comprobar entre unas cadenas
SELECT * FROM ALUMNO WHERE provincia in('Granada', 'Jaen') and beca='SI';

--7.23 Encontrar Alumnos cuyo nombre precede a juan en una lista alfabética 
-- conforme a la tabla ASCII (igual que un string de C++. CUIDADO CON LA MAYÚSCULA AL PRINCIPIO)
SELECT nombre FROM ALUMNO WHERE nombre < 'Juan';

--7.24 Mostrar los datos de aquellos alumnos cuyo nombre empieza por H.
-- vamos a utilizar el %  para representar que despues de H puede ir cualquier valor. Like es como el = cuando comparamos cadenas con patrones
SELECT * FROM ALUMNO WHERE nombre LIKE'H%';

--7.25 Mostrar aquellos Alumnos cuyo nombre contenga una H
-- utilizaremos el operador % a los dos lados de H para decir que por delante y por detras puede tener cualquier valor
SELECT DNI, nombre FROM ALUMNO WHERE nombre LIKE'%H%';

--7.26 mostrar los datos de aquellos alumnos cuyo nombre tenga de segunda letra la H.
-- aqui vamos a utilizar el operador _, que significa que antes habrá UN SOLO CARACTER

SELECT * FROM ALUMNO WHERE nombre LIKE'_H%';

-- 7.27 Mostrar el precio en euros si suponemos que el precio por credito es de 12.45 euros.
-- vamos a multiplicar cada valor de creditos por 12.45 . para ellos multiplicaremos el atributo creditos *12.45

SELECT nombre, creditos * 12.45 FROM ASIGNATURA;

-- 7.28 Mostrar las asignaturas cuyo numero de créditos esta comprendio entre 7 y 9
-- utilizaremos el BETWEEN

SELECT * FROM ASIGNATURA WHERE creditos BETWEEN 7 and 9;
-- 7.29  encontar aquellas asignaturas que desconozcamos sus creditos
-- Para el valor NULL, deberemos de utilizar el operador IS

SELECT * FROM ASIGNATURA WHERE (creditos IS NULL);

-- 7.30 imprimir las provincias sin tuplas repetidas.
-- Para que no nos devuelva las tuplas repetidas, debemos usar la palabra reservada DISTINCT.

SELECT DISTINCT provincia FROM ALUMNO;

-- 7.31 Moatrar la lista de becarios ordenados en orden alfabético creciente 
-- paara ordenar utilizaremos ORDER BY (nombre de la tabla) ASC(ascendente)/DESC(descendiente) POR DEFECTO ES ASCENDENTE

SELECT DNI, nombre FROM ALUMNO WHERE beca='SI' ORDER BY nombre;

--7.32 Mostrar la lista de alumnos ordenados por su provicincia de forma descendente y, dentro de cada provincia, ordenadas alfabeticamente por su nombre
-- aqui tengo duda
SELECT nombre, provincia FROM ALUMNO ORDER BY provincia DESC, nombre ASC;

------------------------------------------------------------------------
--Vamos a imprimir toda la base de datos

SELECT * FROM ALUMNO;

SELECT * FROM ASIGNATURA;

SELECT * FROM AULA;

SELECT * FROM DEPARTAMENTOS;

SELECT * FROM PROFESORES;

SELECT * FROM GRUPO;

SELECT * FROM matricula;

SELECT * FROM clase;