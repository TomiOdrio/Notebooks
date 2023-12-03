select nombre_estacion_origen, lat_estacion_origen ,long_estacion_origen , count(*) as cantidad
from tabla_conjunta tc 
where nombre_estacion_origen ='- Ciudad Universitaria II'
group by nombre_estacion_origen, lat_estacion_origen ,long_estacion_origen 


create table cant_recorridos_estacion as 
SELECT a.estacion, cantidad_origen, cantidad_destino, cantidad_origen+cantidad_destino as total_recorridos, cantidad_origen-cantidad_destino as diferencia
FROM (
   SELECT nombre_estacion_origen as estacion, count(*) as cantidad_origen from tabla_conjunta tc GROUP BY  estacion
) a
INNER JOIN (
   SELECT nombre_estacion_destino as estacion, count(*) as cantidad_destino from tabla_conjunta tc2 GROUP BY  estacion
) b on a.estacion = b.estacion


create table estaciones as 
SELECT a.estacion,latitud,longitud, cantidad_origen, cantidad_destino, cantidad_origen+cantidad_destino as total_recorridos, cantidad_origen-cantidad_destino as diferencia
FROM (
   SELECT nombre_estacion_origen as estacion,lat_estacion_origen as latitud, long_estacion_origen as longitud, count(*) as cantidad_origen from tabla_conjunta tc GROUP BY  estacion,latitud,longitud
) a
INNER JOIN (
   SELECT nombre_estacion_destino as estacion, count(*) as cantidad_destino from tabla_conjunta tc2 GROUP BY  estacion
) b on a.estacion = b.estacion


select *
from estaciones


select a.estacion  , count(*) as cantidad_origen
from tabla_conjunta tc 
group by nombre_estacion_destino
inner join
(select nombre_estacion_destino as estacion  , count(*) as cantidad_destino
from tabla_conjunta tc 
group by nombre_estacion_destino ) b on a.estacion=b.estacion

select EXTRACT(HOUR FROM fecha_origen_recorrido) as hora, count(*) as cantidad 
from tabla_conjunta tc 
group by hora
order by cantidad desc

select EXTRACT(year FROM fecha_origen_recorrido) as año,fecha_origen_recorrido
from tabla_conjunta tc 
where EXTRACT(year FROM fecha_origen_recorrido)=2023
order by fecha_origen_recorrido desc

select nombre_estacion_origen,count(*) as cantidad 
from tabla_conjunta tc 
where (left(nombre_estacion_origen,3)='155' or left(nombre_estacion_origen,3)='184' or left(nombre_estacion_origen,3)='387' or left(nombre_estacion_origen,3)='388')
	and fecha_origen_recorrido > '26/07/2021'
group by nombre_estacion_origen 
order by cantidad desc

select género, count(*) as cantidad 
from tabla_conjunta tc 
where género <> '' and EXTRACT(year FROM fecha_origen_recorrido)=2022
group by género
order by cantidad desc

select count(*) 
from tabla_conjunta tc 

select fecha_origen_recorrido 
from tabla_conjunta tc 
limit 1

select count(*)
from tabla_conjunta tc 


select DateTime.Date(fecha_origen_recorrido) as fecha, count(*)
from tabla_conjunta tc 
group by fecha

select count(*)
from tabla_conjunta tcp 
