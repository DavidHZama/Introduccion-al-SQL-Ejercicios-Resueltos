  /*                  GRUPO 2                         */
  
  /* 2) */
  
SELECT d.OTRO_ID FROM DESCARGA d WHERE  d.OTRO_ID IS NOT NULL; /* Saca los OTRO de DESCARGA */

SELECT o.ID, d.USO_ID, o.TIPO /* Saca las claves y los usuario from DESCARGA y OTRO cuando es Album o pelicula*/
FROM OTRO o
JOIN (SELECT OTRO_ID, USO_ID FROM DESCARGA WHERE  OTRO_ID IS NOT NULL) d 
ON d.OTRO_ID = o.ID
WHERE o.TIPO = 'Musica' OR o.TIPO = 'Pelicula'; 

SELECT d.USO_ID /* Saca los USUARIOS (sin repetir)  que han descargado peliculas o musica*/
FROM OTRO o
JOIN (SELECT OTRO_ID, USO_ID FROM DESCARGA WHERE  OTRO_ID IS NOT NULL) d 
ON d.OTRO_ID = o.ID
WHERE o.TIPO = 'Musica' OR o.TIPO = 'Pelicula'
GROUP BY d.USO_ID;


SELECT u.ID, u.NOMBRE FROM USUARIO u /* Muestra el nombre  y id de los usuarios que nunca han comprado musica o pelicula */
JOIN (
  SELECT ID FROM USUARIO
  MINUS
  SELECT d.USO_ID 
  FROM OTRO o
  JOIN (SELECT OTRO_ID, USO_ID FROM DESCARGA WHERE  OTRO_ID IS NOT NULL) d 
  ON d.OTRO_ID = o.ID
  WHERE o.TIPO = 'Musica' OR o.TIPO = 'Pelicula'
  GROUP BY d.USO_ID) r
ON u.ID = r.ID;

/* 3) */

SELECT d.USO_ID, o.ID, o.NOMBRE, o.TIPO /* saca todos las descargas que son OTRO */
FROM (SELECT OTRO_ID, USO_ID FROM DESCARGA WHERE OTRO_ID IS NOT NULL) d
JOIN OTRO o ON d.OTRO_ID = o.ID;

SELECT u.ID, ds.USO_ID, ds.TIPO /* Saca todos los ID que coinciden */
FROM USUARIO u
JOIN (
    SELECT d.USO_ID, o.ID, o.NOMBRE, o.TIPO /* saca todos las descargas que son OTRO */
    FROM (SELECT OTRO_ID, USO_ID FROM DESCARGA WHERE OTRO_ID IS NOT NULL) d
    JOIN OTRO o ON d.OTRO_ID = o.ID) ds
ON u.ID = ds.USO_ID;

/* TEMPORAAAAAAL!!!
SELECT u.ID, 
       SUM(DECODE(ds.TIPO,'Libro',1,0)) "Libros", 
       SUM(DECODE(ds.TIPO,'Musica',1,0)) "Album",
       SUM(DECODE(ds.TIPO,'Pelicula',1,0)) "Pelicula"
FROM USUARIO u
JOIN (
    SELECT d.USO_ID, 
           o.TIPO
    FROM (SELECT OTRO_ID, USO_ID FROM DESCARGA WHERE OTRO_ID IS NOT NULL) d
    JOIN OTRO o ON d.OTRO_ID = o.ID) ds
ON u.ID = ds.USO_ID
GROUP BY u.ID
ORDER BY u.ID ASC;*/

SELECT d.USO_ID, /* Más óptimo que el de arriba */
      SUM(DECODE(o.TIPO,'Libro',1,0)) "Libros", 
      SUM(DECODE(o.TIPO,'Musica',1,0)) "Album",
      SUM(DECODE(o.TIPO,'Pelicula',1,0)) "Pelicula"
FROM (SELECT OTRO_ID, USO_ID FROM DESCARGA WHERE OTRO_ID IS NOT NULL) d
JOIN OTRO o ON d.OTRO_ID = o.ID
GROUP BY d.USO_ID;

SELECT u.ID "ID usuario",u.NOMBRE "Usuario", ds.l, ds.a, ds.p /* listo, resuelta*/
FROM USUARIO u
JOIN (SELECT d.USO_ID as ident, /* Más óptimo que el de arriba */
             SUM(DECODE(o.TIPO,'Libro',1,0)) as l, 
             SUM(DECODE(o.TIPO,'Musica',1,0)) as a,
             SUM(DECODE(o.TIPO,'Pelicula',1,0)) as p
      FROM (SELECT OTRO_ID, USO_ID FROM DESCARGA WHERE OTRO_ID IS NOT NULL) d
      JOIN OTRO o ON d.OTRO_ID = o.ID
      GROUP BY d.USO_ID) ds
ON u.ID = ds.ident
ORDER BY u.ID;
