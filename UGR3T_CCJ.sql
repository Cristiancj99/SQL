
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
	direccion VARCHAR(50),
	beca CHAR(2) CHECK (beca IN ('SI', 'NO') ),
	PRIMARY KEY(DNI)
);
----------------------------------------------------------------------------
CREATE TABLE ASIGNATURA(
	CODASIG VARCHAR(8),
	nombre VARCHAR(20),
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

INSERT INTO ALUMNO VALUES ('76592866Z' , 'CHRISTIAN' , '12-12-12' , 'ALBAYZIN1' , 'SI');
INSERT INTO ALUMNO VALUES ('76500866Z' , 'EDUARDO' , '12-12-11' , 'ALBAYZIN1' , 'NO');



INSERT INTO ASIGNATURA VALUES ('PROG', 'PROGRAMACION','15', 'T', '5');
INSERT INTO ASIGNATURA VALUES ('BD', 'BASE DE DATOS','10', 'P', '3');
INSERT INTO ASIGNATURA VALUES ('SI', 'SISTEMAS','6', 'P', '2');


INSERT INTO AULA VALUES ('A202', 50);
INSERT INTO AULA VALUES ('A203', 50);


--ponemos valor null en los departamentos porque despues lo vamos a actualizar
INSERT INTO DEPARTAMENTOS VALUES ('INFOR', 'INFORMATICA', NULL);
INSERT INTO DEPARTAMENTOS VALUES ('MATE', 'MATEMATICAS', NULL);
INSERT INTO DEPARTAMENTOS VALUES ('LIT', 'LITERATURA', NULL);


-- vamos a alterar la tabla DEPARTAMENTOS añadiendole una fk (directores)
ALTER TABLE DEPARTAMENTOS ADD CONSTRAINT directores FOREIGN KEY (directores)  REFERENCES PROFESORES (NRP);
INSERT INTO PROFESORES VALUES ('1234567890GR45ESZ', 'Jaime', 'INFOR', 'INFORMATICA', 'LC', 'INFORM' );
INSERT INTO PROFESORES VALUES ('1234560090GR45ESZ', 'Luis', 'LIT', 'LITERATURA', 'LC', 'INFORM' );
INSERT INTO PROFESORES VALUES ('1234562290GR45ESZ', 'Laura', 'MATE', 'MATEMATICAS', 'LC', 'INFORM' );
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

--consulta para obtener el CodAula y la hora de las clases de los martes
SELECT CodAula, hora FROM clase WHERE Dia='M';

-- consulta para obtener el DNI y el nombre de aquellos alumnos que sean becados.
SELECT DNI, nombre FROM ALUMNO WHERE beca='SI';

--consulta para obtener el codasig y el nombre de las asignaturaas con caracter p
SELECT CODASIG,nombre FROM ASIGNATURA WHERE caracter='P';

--consulta para obtener el DNI y la convocatoria de los alumnos matriculados en PROG
SELECT DNI,Convocatoria FROM matricula WHERE CODASIG='PROG';

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