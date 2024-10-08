
1)
CREATE TABLE TRENER(

	ID NUMBER(10,0),
	IME VARCHAR(15)NOT NULL,
	PREZIME VARCHAR(20)NOT NULL,
	POL CHAR(1),
	DATUM_RODJ DATE,
	TELEFON NUMBER(13),
	MESTO_RODJ VARCHAR(15),
	CONSTRAINT TRENER_PK PRIMARY KEY(ID),
	CONSTRAINT POL_CK CHECK (POL IN ('M','Z'))
);

CREATE TABLE KLUB(

	ID NUMBER(10,0),
	NAZIV VARCHAR(20) NOT NULL,
	VRSTA VARCHAR(8),
	DATUM_OSNIVANJA DATE,
	KAPACITET INT,
	CONSTRAINT KLUB_PK PRIMARY KEY (ID),
	CONSTRAINT VRSTA_CK CHECK (VRSTA IN ('privatni','drzavni'))
);

CREATE TABLE TRENIRA(

	ID NUMBER(10,0),
	TRENER_ID NUMBER(10,0),
	KLUB_ID NUMBER(10,0),
	SPORT VARCHAR(18),
	DATUM_OD DATE ,
	DATUM_DO DATE DEFAULT NULL,
	CONSTRAINT TRENIRA_PK PRIMARY KEY (ID,KLUB_ID,TRENER_ID),
	CONSTRAINT TRENIRA_KLUB_FK FOREIGN KEY (KLUB_ID) REFERENCES KLUB(ID),
	CONSTRAINT TRENIRA_TRENER_FK FOREIGN KEY(TRENER_ID) REFERENCES TRENER(ID)
);

2)
	SELECT KLUB.ID,KLUB.NAZIV
	FROM KLUB
	WHERE EXTRACT(YEAR FROM DATUM_OSNIVANJA)>1975 AND KLUB.VRSTA='DRZAVNI'
	ORDER BY KLUB.NAZIV DESC

3)
	SELECT TRENER.ID, TRENER.IME || '-' || TRENER.PREZIME AS IME_PREZIME
	FROM TRENER
	WHERE TRENER.ID IN (
	SELECT TRENIRA.TRENER_ID
	FROM TRENIRA
	INNER JOIN KLUB ON TRENIRA.KLUB_ID = KLUB.ID
	WHERE TRENIRA.SPORT = 'Fudbal' AND KLUB.NAZIV = 'Radnicki'
	)
	AND TRENER.ID NOT IN (
	SELECT TRENIRA.TRENER_ID
	FROM TRENIRA
	INNER JOIN KLUB ON TRENIRA.KLUB_ID = KLUB.ID
	WHERE KLUB.NAZIV = 'Radnicki' AND TRENIRA.SPORT = 'Rukomet'

4)
	SELECT KLUB.ID, KLUB.DATUM_OSNIVANJA
	FROM (SELECT KLUB.ID, KLUB.DATUM_OSNIVANJA FROM KLUB ORDER BY KLUB.KAPACITET ASC)
	WHERE ROWNUM = 1;

5)
	SELECT KLUB.ID,KLUB.NAZIV,COUNT(TRENER.ID) AS BROJ_TRENERA
	FROM KLUB
	INNER JOIN TRENIRA ON KLUB.ID=TRENIRA.KLUB_ID
	INNER JOIN TRENER ON TRENIRA.TRENER_ID=TRENER.ID
	WHERE TRENIRA.SPORT='FUDBAL'
	GROUP BY KLUB.ID,KLUB.NAZIV
	ORDER BY BROJ_TRENERA DESC

6)

	CREATE VIEW TRENER_TRENIRA AS
    SELECT 
    TRENER.ID,
    TRENER.IME,
    TRENER.PREZIME,
    TRENER.POL,
    TRENER.DATUM_RODJ,
    COUNT(DISTINCT TRENIRA.KLUB_ID) AS UKUPNO_TRENINGA
    FROM 
    TRENER
    INNER JOIN 
    TRENIRA ON TRENER.ID = TRENIRA.TRENER_ID
    GROUP BY 
    TRENER.ID, TRENER.IME, TRENER.PREZIME, TRENER.POL, TRENER.DATUM_RODJ;

    SELECT *
    FROM TRENER_TRENIRA
    WHERE POL = 'Z'
    AND EXTRACT(YEAR FROM DATUM_RODJ) > 1978
    GROUP BY IME, PREZIME, ID, POL, DATUM_RODJ
    HAVING SUM(UKUPNO_TRENINGA) > 20;

7) 
   UPDATE KLUB
   SET KLUB.KAPACITET = KLUB.KAPACITET-5
   WHERE KLUB.ID IN(SELECT KLUB.ID FROM KLUB WHERE EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM DATUM_OSNIVANJA)>30)
   AND KLUB.VRSTA='drzavni'

8)
DELETE FROM TRENER
WHERE TRENER.ID IN (SELECT DISTINCT TRENER.ID FROM TRENER INNER JOIN TRENIRA ON TRENER.ID=TRENIRA.TRENER_ID WHERE TRENIRA.DATUM_DO IS NULL
AND TRENIRA.SPORT='Fudbal' 
GROUP BY TRENER.ID 
HAVING COUNT(DISTINCT TRENIRA.KLUB_ID)>2)