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
insert into lugarenvio values (1, 100.000000, 10.000000, 'unacalle', 1234);
create table telefonolugarenvio(
    idlugarenvio int unsigned not null,
    numero int(9) unsigned not null,
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (idlugarenvio, numero)
);

create table almacen(
    idlugarenvio int unsigned not null,
    capacidadkg int unsigned not null,
    volumenm3 int unsigned not null,
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (idlugarenvio)
);
insert into almacen values (1, 10000000, 1000000);

create table domicilio(
    idlugarenvio int unsigned not null,
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (idlugarenvio)
);

create table lote(
    idlote int unsigned not null,
    idlugarenvio int unsigned not null,
    foreign key (idlugarenvio)
        references almacen (idlugarenvio),
    primary key (idlote)
);
grant insert, select, update on lote to apialmacen;
grant select on lote to transito;
insert into lote values (1, 1);

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

create table cliente (
    usuario varchar(20) not null,
    foreign key (usuario)
        references usuario (usuario),
    primary key (usuario)
);

create table clienteenvio(
    cliente varchar(20) not null,
    idlugarenvio int unsigned not null,
    foreign key (cliente)
        references cliente (usuario),
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (cliente, idlugarenvio)
);

create table almacenero(
    usuario varchar(20) not null,
    idlugarenvio int unsigned not null,
    foreign key (usuario)
        references usuario (usuario),
    foreign key (idlugarenvio)
        references almacen (idlugarenvio),
    primary key (usuario)
);

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

create table paquete (
    idpaquete int unsigned not null,
    comentarios varchar(64) not null,
    pesokg decimal(5,2) unsigned not null,
    volumenm3 decimal(3,2) unsigned not null,
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

create table estado(
    idestado tinyint unsigned not null,
    estado varchar(64) not null,
    primary key (idestado)
);
insert into estado values (1, 'sano'),
(2, 'ligeramente dañado'),
(3, 'medianamente dañado'),
(4, 'gravemente dañado');

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

create table lotellegada(
    idlote int unsigned not null,
    fechallegada date not null,
    foreign key (idlote)
        references loteenvio (idlote),
    primary key (idlote, fechallegada)
);

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
insert into conductor values ('pedro', 12345678);

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
('pedro', 'ABC123', '2023-8-23', '14:23:00');
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
