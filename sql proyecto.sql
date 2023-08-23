drop database if exists proyecto;
drop user if exists apialmacen;
create user apialmacen identified by "urbgieubgiutg98rtygtgiurnindg8958y";
drop user if exists accessapi;
create user accessapi identified by "kwefbwibcakebvuyevbiubqury38";
drop user if exists transito;
create user transito identified by "gbiugbiuerbgieurgbiuerbgiubre";
create database proyecto;
use proyecto;

create table lugarenvio(
    idlugarenvio int unsigned not null,
    latitud decimal(9,6) not null,
    longitud decimal(9,6) not null,
    calle varchar(64) not null,
    numeropuerta int(4) unsigned not null,
    primary key (idlugarenvio)
);
insert into lugarenvio values (1,-34.741011,-56.181727, 'obelisco', 1234),
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
grant insert, select, update on lote to apialmacen;
grant select on lote to transito;
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
grant select on usuario to accessapi;
grant select on usuario to apialmacen;
grant select on usuario to transito;

create table tokens (
    usuario varchar(20) not null,
    tokn char(255) not null,
    foreign key (usuario)
        references usuario (usuario),
    primary key (tokn)
);
grant select, insert on tokens to accessapi;
grant select on tokens to apialmacen;
grant select on tokens to transito;

create table telefonousuario(
    usuario varchar(20) not null,
    numero int(9) unsigned not null,
    foreign key (usuario)
        references usuario (usuario),
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
        references usuario (usuario),
    primary key (usuario)
);
insert into cliente values ('daud'),
('rodriguez');


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
        references usuario (usuario),
    foreign key (idlugarenvio)
        references almacen (idlugarenvio),
    primary key (usuario)
);
insert into almacenero values ('arreche',1),
('joselito',2);



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
        references usuario (usuario),
    foreign key (idestadofisico)
        references estadofisico (idestadofisico),
    foreign key (usuarioestado)
        references usuario (usuario),
    primary key (idpaquete)
);
grant insert, select, update on paquete to apialmacen;

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
(10,'',360,420,'rodriguez',2,'joselito');





create table paquetecaracteristicas(
    idpaquete int unsigned not null,
    idcaracteristica tinyint unsigned not null,
    foreign key (idpaquete)
        references paquete (idpaquete),
    foreign key (idcaracteristica)
        references caracteristicas (idcaracteristica),
    primary key (idpaquete, idcaracteristica)        
);
grant insert, select, update on paquetecaracteristicas to apialmacen;

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
grant insert, select, update on lotepaquete to apialmacen;

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
insert into loteenvio values (1,1,'2023-08-09',3),
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



create table camion(
    matricula char(6) not null,
    modelo varchar(64) not null,
    capacidadkg int not null,
    capacidadm3 int not null,
    primary key (matricula)
);
insert into camion values ('ABC123', 'Mercedes-Benz', 2000, 20),
('CBA321', 'Mercedes-Benz', 2000, 20);



create table conductor(
    usuario varchar(20) not null,
    licencia char(8) unique not null,
    foreign key (usuario)
        references usuario (usuario),
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
grant select on conduce to transito;


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
grant insert, select, update on cargalote to apialmacen;
grant select on cargalote to transito;
insert into cargalote values (1, 'pedro', 'ABC123', (select fechasalida from conduce where matricula='ABC123' order by fechasalida desc limit 1));