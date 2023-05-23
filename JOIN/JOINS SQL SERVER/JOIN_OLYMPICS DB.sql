
------------------------------------OLYMPICS DB-----------------------------------------------

--1.Mostrar la lista de los ganadores de medalla de oro en eventos de Futbol, Baloncesto y Golf
SELECT P.FULL_NAME, E.EVENT_NAME, C.CITY_NAME, G.GAMES_NAME
FROM OLYMPICS.DBO.MEDAL M
JOIN OLYMPICS.DBO.COMPETITOR_EVENT CE ON CE.MEDAL_ID = M.ID
JOIN OLYMPICS.DBO.GAMES_COMPETITOR GC ON GC.ID = CE.COMPETITOR_ID
JOIN OLYMPICS.DBO.PERSON P ON P.ID = GC.PERSON_ID
JOIN OLYMPICS.DBO.EVENT E ON E.ID = CE.EVENT_ID
JOIN OLYMPICS.DBO.GAMES G ON G.ID = GC.GAMES_ID
JOIN OLYMPICS.DBO.GAMES_CITY GCIT ON GCIT.GAMES_ID = G.ID
JOIN OLYMPICS.DBO.CITY C ON C.ID = GCIT.CITY_ID
JOIN OLYMPICS.DBO.SPORT S ON S.ID = E.SPORT_ID
WHERE M.MEDAL_NAME = 'GOLD' AND S.SPORT_NAME IN ('FOOTBALL', 'BASKETBALL', 'GOLF');

--2.Cuales son los eventos que se jugaron en el a�o 2000
SELECT E.EVENT_NAME, G.GAMES_NAME
FROM OLYMPICS.DBO.EVENT E
JOIN OLYMPICS.DBO.GAMES_COMPETITOR GC ON GC.GAMES_ID = E.GAMES_ID
JOIN OLYMPICS.DBO.GAMES G ON G.ID = E.GAMES_ID
WHERE G.GAMES_YEAR = 2000;

--3.Cuales son las 20 principales ciudades donde se han jugado mas Olimpiadas
SELECT C.CITY_NAME, COUNT(GC.GAMES_ID) AS TOTAL_OLYMPICS
FROM OLYMPICS.DBO.CITY C
JOIN OLYMPICS.DBO.GAMES_CITY GC ON GC.CITY_ID = C.ID
GROUP BY C.CITY_NAME
ORDER BY TOTAL_OLYMPICS DESC;

--4.Liste los paises no tienen ningun participante en las ultimas 10 olimpiadas
SELECT NR.REGION_NAME
FROM OLYMPICS.DBO.NOC_REGION NR
LEFT JOIN OLYMPICS.DBO.PERSON_REGION PR ON PR.REGION_ID = NR.ID
LEFT JOIN OLYMPICS.DBO.GAMES_COMPETITOR GC ON GC.PERSON_ID = PR.PERSON_ID
LEFT JOIN OLYMPICS.DBO.GAMES G ON G.ID = GC.GAMES_ID
WHERE G.GAMES_YEAR >= YEAR(GETDATE()) - 10
GROUP BY NR.REGION_NAME
HAVING COUNT(GC.ID) = 0;

--5.liste los 5 paises que mas ganan medallas de oro, plata y bronce
SELECT NR.REGION_NAME, COUNT(MEDAL.ID) AS TOTAL_MEDALS
FROM OLYMPICS.DBO.NOC_REGION NR
JOIN OLYMPICS.DBO.PERSON_REGION PR ON PR.REGION_ID = NR.ID
JOIN OLYMPICS.DBO.GAMES_COMPETITOR GC ON GC.PERSON_ID = PR.PERSON_ID
JOIN OLYMPICS.DBO.MEDAL ON MEDAL.ID = GC.MEDAL_ID
WHERE MEDAL.MEDAL_NAME IN ('GOLD', 'SILVER', 'BRONZE')
GROUP BY NR.REGION_NAME
ORDER BY TOTAL_MEDALS DESC;

--6.El evento con mayor cantidad de personas participando
SELECT E.EVENT_NAME, COUNT(GC.ID) AS TOTAL_PARTICIPANTS
FROM OLYMPICS.DBO.EVENT E
JOIN OLYMPICS.DBO.COMPETITOR_EVENT CE ON CE.EVENT_ID = E.ID
JOIN OLYMPICS.DBO.GAMES_COMPETITOR GC ON GC.ID = CE.COMPETITOR_ID
GROUP BY E.EVENT_NAME
ORDER BY TOTAL_PARTICIPANTS DESC;

--7.Liste los deportes que en todas las olimpiadas siempre se llevan a cabo
SELECT S.SPORT_NAME
FROM OLYMPICS.DBO.SPORT S
WHERE NOT EXISTS (
  SELECT G.ID
  FROM OLYMPICS.DBO.GAMES G
  WHERE NOT EXISTS (
    SELECT E.ID
    FROM OLYMPICS.DBO.EVENT E
    WHERE E.SPORT_ID = S.ID
    AND E.ID IN (
      SELECT CE.EVENT_ID
      FROM OLYMPICS.DBO.COMPETITOR_EVENT CE
      JOIN OLYMPICS.DBO.GAMES_COMPETITOR GC ON GC.ID = CE.COMPETITOR_ID
      WHERE GC.GAMES_ID = G.ID
    )
  )
);

--8.Muestre la comparacion de la cantidad de veces entre los dos generos(M,F) que ganado medallas de cualquier tipo
SELECT P.GENDER, COUNT(*) AS TOTAL_MEDALS
FROM OLYMPICS.DBO.PERSON P
JOIN OLYMPICS.DBO.GAMES_COMPETITOR GC ON GC.PERSON_ID = P.ID
JOIN OLYMPICS.DBO.COMPETITOR_EVENT CE ON CE.COMPETITOR_ID = GC.ID
GROUP BY P.GENDER;

--9.Cual es la altura y peso que mas es mas frecuente en los participantes del deporte de Boxeo
SELECT P.HEIGHT, P.WEIGHT, COUNT(*) AS FREQUENCY
FROM OLYMPICS.DBO.PERSON P
JOIN OLYMPICS.DBO.GAMES_COMPETITOR GC ON GC.PERSON_ID = P.ID
JOIN OLYMPICS.DBO.COMPETITOR_EVENT CE ON CE.COMPETITOR_ID = GC.ID
JOIN OLYMPICS.DBO.EVENT E ON E.ID = CE.EVENT_ID
JOIN OLYMPICS.DBO.SPORT S ON S.ID = E.SPORT_ID
WHERE S.SPORT_NAME = 'BOXING'
GROUP BY P.HEIGHT, P.WEIGHT
ORDER BY COUNT(*) DESC;

--10.Muestre los participantes menores de edad que participan en las 
SELECT P.ID, P.FULL_NAME, P.AGE
FROM OLYMPICS.DBO.PERSON P
JOIN OLYMPICS.DBO.GAMES_COMPETITOR GC ON GC.PERSON_ID = P.ID
WHERE P.AGE < 18;
