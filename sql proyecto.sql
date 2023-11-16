drop database if exists joule;
create database if not exists joule;
use joule;
create table lugarenvio(
    idlugarenvio int unsigned not null,
    latitud decimal(9,6) not null,
    longitud decimal(9,6) not null,
    calle varchar(64) not null,
    numeropuerta int(4) unsigned not null,
    primary key (idlugarenvio)
);
insert into lugarenvio values (1,-34.901084, -56.138456, 'luis alberto de herrera', 1234),
(2,-34.902476,-56.149578,'26 de marzo',1366),
(3,-34.921458,-56.155796,'Blanca del tabaré',2125),
(4,-34.811366,-56.151623,'las flores',1059);


create table telefonolugarenvio(
    idlugarenvio int unsigned not null,
    numero int(9) unsigned not null,
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (idlugarenvio, numero)
);
insert into telefonolugarenvio values (1,099236789),
(2,092653879),
(3,093854269),
(4,099456789);


create table almacen(
    idlugarenvio int unsigned not null,
    capacidadkg int unsigned not null,
    volumenm3 int unsigned not null,
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (idlugarenvio)
);

insert into almacen values (1, 10000000, 1000000),
(2, 20000000, 3000000);


create table domicilio(
    idlugarenvio int unsigned not null,
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (idlugarenvio)
);
insert into domicilio values (3),
(4);




create table lote(
    idlote int unsigned not null,
    idlugarenvio int unsigned not null,
    foreign key (idlugarenvio)
        references almacen (idlugarenvio),
    primary key (idlote)
);
insert into lote values (1, 1),
(2,1),
(3,1),
(4,2),
(5,2),
(6,2),
(7,1);

create table rol(
    idrol tinyint unsigned not null,
    nombre varchar(64) unique not null,
    primary key (idrol)
);
insert into rol values
(1, 'administrador'),
(2, 'almacenero'),
(3, 'camionero'),
(4, 'cliente');

create table usuario(
    usuario varchar(20) not null,
    idrol tinyint unsigned not null,
    pwd varchar(255) not null,
    nombre varchar(20) not null,
    apellido varchar(20) not null,
    foreign key (idrol)
        references rol (idrol),
    primary key (usuario)
);
insert into usuario values ('daud', 1, '25536671091981511766355543188227253985418610202146632211173824120110919497153220178', 'Mateo', 'Daud'),
('rodriguez', 1, '25536671091981511766355543188227253985418610202146632211173824120110919497153220178', 'Christian', 'Rodriguez'),
('arreche', 1, '25536671091981511766355543188227253985418610202146632211173824120110919497153220178', 'Agustina', 'Arreche'),
('joselito', 2, '25536671091981511766355543188227253985418610202146632211173824120110919497153220178', 'Joselito', 'Perez'),
('pedro', 3, '25536671091981511766355543188227253985418610202146632211173824120110919497153220178', 'Pedro', 'Martinez'),
('adictoalospaquetes', 4, '25536671091981511766355543188227253985418610202146632211173824120110919497153220178', 'Juan', 'Gonzalez');


create table tokens (
    usuario varchar(20) not null,
    tokn char(255) not null,
    foreign key (usuario)
        references usuario (usuario),
    primary key (tokn)
);

insert into tokens values ('adictoalospaquetes', 'Y-g*B89DdBh5SU!gJsRJJb?nLl8bgn%ArsesJJ.3Ly_uh%?BMdmjd1Gis_R.g&vnWP2s?EBXOVp=$-=9$%vaOY2!2jE%H_GEC8kS$HoEpxMaJe4rX1spf43_7K+3h6*Rj=Oglzi14_=XS-5KIuyDHTk=ncUpMyutyfct41#EuP1g#vMCr7hra4O9Gqj&EMgkpi+jCs*8W7ZgF?I0Gzcaw5SM$meikb-xmSY6*2ekf0dKbsW=%YKxWsu*HjWbdYG');
insert into tokens values ('pedro','C?WEGFoJ?&s8%27sfE-UYB%VUZUowPd!d#Xqc+?Q5GZe&5F+&k=+C1u&Ut.L?h9=qB*JCljiYX&5$&+oH=ZBcURRzAD!Hg4+dQtXxAQOyg5P-KxM&8-DD3zc9oC2T$f.B_53d8#Epx=ws4%t%x-hO9ud6Ezkg-xEnxeB*0LxFKV4AVdGRvYewvSk?%TaE_188SsISaGEyfUYqWYDu&3Y5I7W+-4Vgs1S7AOx7ASF#tpf9DcF8%+*M=I0HQSL2yS');

create table telefonousuario(
    usuario varchar(20) not null,
    numero int(9) unsigned not null,
    foreign key (usuario)
        references usuario (usuario) on delete cascade,
    primary key (usuario, numero)
);
insert into telefonousuario values ('daud',096578423),
('rodriguez',096785412),
('arreche',098456123),
('joselito',095487023),
('pedro',095666472),
('adictoalospaquetes',093658785);

create table cliente (
    usuario varchar(20) not null,
    foreign key (usuario)
        references usuario (usuario) on delete cascade,
    primary key (usuario)
);
insert into cliente values ('daud'),
('rodriguez'), ("adictoalospaquetes");

create table clienteenvio(
    cliente varchar(20) not null,
    idlugarenvio int unsigned not null,
    preferida boolean not null,
    foreign key (cliente)
        references cliente (usuario),
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (cliente, idlugarenvio)
);

insert into clienteenvio values ('daud',3,true),
('rodriguez',4,true);


create table almacenero(
    usuario varchar(20) not null,
    idlugarenvio int unsigned not null,
    foreign key (usuario)
        references usuario (usuario) on delete cascade,
    foreign key (idlugarenvio)
        references almacen (idlugarenvio),
    primary key (usuario)
);
insert into almacenero values ('joselito', 2);



create table caracteristicas (
    idcaracteristica tinyint unsigned not null,
    nombre varchar(64) not null,
    primary key (idcaracteristica)
);
insert into caracteristicas values
(1, 'fragil'),
(2, 'refrigerado'),
(3, 'toxico'),
(4, 'inflamable'),
(5, 'carga viva');

create table estadofisico(
    idestadofisico tinyint unsigned not null,
    nombreestadofisico varchar(64) unique not null,
    primary key (idestadofisico)
);
insert into estadofisico values (1, 'sano'),
(2, 'ligeramente dañado'),
(3, 'medianamente dañado'),
(4, 'gravemente dañado');

create table paquete (
    idpaquete int unsigned not null,
    comentarios varchar(64) not null,
    pesokg decimal(5,2) unsigned not null,
    volumenm3 decimal(5.2) unsigned not null,
    usuario varchar(20) not null,
    idestadofisico tinyint unsigned not null,
    usuarioestado varchar(20) not null,
    foreign key (usuario)
        references cliente (usuario),
    foreign key (idestadofisico)
        references estadofisico (idestadofisico),
    foreign key (usuarioestado)
        references usuario (usuario),
    primary key (idpaquete)
);
insert into paquete values
(1,'',25,12,'daud',1,'daud'),
(2,'',5,2,'daud',3,'arreche'),
(3,'',50,60,'daud',2,'daud'),
(4,'',100,120,'daud',1,'daud'),
(5,'',25,12,'daud',4,'arreche'),
(6,'',300,102,'rodriguez',1,'joselito'),
(7,'',80,92,'rodriguez',1,'arreche'),
(8,'',800,902,'rodriguez',2,'joselito'),
(9,'',500,700,'rodriguez',4,'arreche'),
(10,'',360,420,'rodriguez',2,'joselito'),
(89,'',40,0.5,'adictoalospaquetes',1,'joselito');



create table paquetecaracteristicas(
    idpaquete int unsigned not null,
    idcaracteristica tinyint unsigned not null,
    foreign key (idpaquete)
        references paquete (idpaquete),
    foreign key (idcaracteristica)
        references caracteristicas (idcaracteristica),
    primary key (idpaquete, idcaracteristica)        
);

insert into paquetecaracteristicas values (1,1),
(2,1),
(3,1),
(4,3),
(5,4),
(6,3),
(7,4),
(8,4),
(9,1),
(10,2);


create table lotepaquete(
    idlote int unsigned not null,
    idpaquete int unsigned not null,
    foreign key (idlote)
        references lote (idlote),
    foreign key (idpaquete)
        references paquete (idpaquete),
    primary key (idpaquete)
);

insert into lotepaquete values (6,10),
(1,1),
(1,2),
(2,3),
(3,4),
(4,5),
(5,6),
(5,7),
(6,8),
(7,9);




create table estado(
    idestado tinyint unsigned not null,
    estado varchar(64) not null,
    primary key (idestado)
);

insert into estado values (1, 'En deposito'),
(2, 'En tránsito'),
(3, 'Entregado');

create table loteenvio(
    idlote int unsigned not null,
    idlugarenvio int unsigned not null,
    fechaestimada date not null,
    idestado tinyint unsigned not null,
    foreign key (idlote)
        references lote (idlote),
    foreign key (idlugarenvio)
        references lugarenvio(idlugarenvio),
    foreign key (idestado)
        references estado (idestado),
    primary key (idlote)
);
insert into loteenvio values (1,1,'2023-08-09', 2),
(2,1,'2023-07-23',2),
(3,2,'2023-05-28',2),
(4,3,'2023-09-23',1),
(5,4,'2023-12-11',3),
(6,1,'2023-11-21',3),
(7,2,'2023-10-29',2);

create table lotellegada(
    idlote int unsigned not null,
    fechallegada date not null,
    foreign key (idlote)
        references loteenvio (idlote),
    primary key (idlote, fechallegada)
);
insert into lotellegada values (1,'2023-08-09'),
(5,'2023-12-11'),
(6,'2023-11-21');

create table modelo(
    idmodelo int unsigned not null,
    nombre varchar(30),
    primary key (idmodelo)
);
insert into modelo values (1, 'Mercedes-Benz'),
(2, 'Scania'),
(3, 'Ford');

create table camion(
    matricula char(6) not null,
    modelo int unsigned not null,
    capacidadkg int unsigned not null,
    capacidadm3 int unsigned not null,
    foreign key (modelo) references modelo (idmodelo),
    primary key (matricula)
);
insert into camion values ('ABC123', 1, 2000, 20),
('CBA321', 2, 2000, 20);

create table conductor(
    usuario varchar(20) not null,
    licencia char(8) unique not null,
    foreign key (usuario)
        references usuario (usuario) on delete cascade,
    primary key (usuario)
);
insert into conductor values ('pedro', 12345678),
('adictoalospaquetes',56485968);

create table conduce(
    usuario varchar(20) not null,
    matricula char(6) not null,
    fechasalida date not null,
    horasalida time not null,
    foreign key (usuario)
        references conductor (usuario),
    foreign key (matricula)
        references camion (matricula),
    primary key (usuario, matricula, fechasalida)
);
insert into conduce values ('pedro', 'ABC123', '2023-8-22', '14:23:00'),
('adictoalospaquetes', 'CBA321', '2023-8-23', '14:23:00');


create table conducellegada(
    usuario varchar(20) not null,
    matricula char(6) not null,
    fechasalida date not null,
    fechallegada date not null,
    horallegada time not null,
    foreign key (usuario, matricula, fechasalida)
        references conduce (usuario, matricula, fechasalida),
    primary key (usuario, matricula, fechasalida, fechallegada)        
);

create table cargalote(
    idlote int unsigned not null,
    usuario varchar(20) not null,
    matricula char(6) not null,
    fechasalida date not null,
    foreign key (idlote)
        references lote (idlote),
    foreign key (usuario, matricula, fechasalida)
        references conduce (usuario, matricula, fechasalida),
    primary key (idlote)
);

insert into cargalote values (1, 'pedro', 'ABC123', (select fechasalida from conduce where matricula='ABC123' order by fechasalida desc limit 1));
insert into cargalote values (2, 'pedro', 'ABC123', (select fechasalida from conduce where matricula='ABC123' order by fechasalida desc limit 1));
insert into cargalote values (3, 'pedro', 'ABC123', (select fechasalida from conduce where matricula='ABC123' order by fechasalida desc limit 1));


select *
from joule.lugarenvio
    join joule.almacen on joule.lugarenvio.idlugarenvio=joule.almacen.idlugarenvio
    join joule.domicilio on joule.lugarenvio.idlugarenvio=joule.domicilio.idlugarenvio
    join joule.lote on joule.lugarenvio.idlugarenvio=joule.lote.idlugarenvio;

select * 
    from joule.cargalote 
        join joule.conduce on joule.cargalote.usuario=conduce.usuario
        join joule.lote on joule.cargalote.idlote=lote.idlote
        join joule.lotepaquete on joule.cargalote.idlote=lotepaquete.idlote;

create view joule.usuariorol as 
    select usuario.usuario, rol.nombre
    from joule.usuario
        inner join joule.rol on usuario.idrol=rol.idrol;

select * from joule.usuariorol;

select * from joule.loteenvio;

select * from joule.cargalote;