drop database if exists proyecto;
drop user if exists apialmacen;
create user apialmacen identified by "urbgieubgiutg98rtygtgiurnindg8958y";
drop user if exists accessapi;
create user accessapi identified by "kwefbwibcakebvuyevbiubqury38";
drop user if exists apitransito;
create user apitransito identified by "samnibahsyehstwragsjfodkdsjcnbcgdgiuefw3r2t878y0hhjadsdvs";
create database proyecto;
use proyecto;

create table lugarenvio (
    idlugarenvio int unsigned not null,
    latitud decimal(9,6) not null,
    longitud decimal(9,6) not null,
    calle varchar(64) not null,
    numeropuerta int(4) not null,
    primary key (idlugarenvio)
);
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
        references lugarenvio (idlugarenvio),
    primary key (idlote)
);

create table rol(
    idrol tinyint unsigned not null,
    nombre varchar(64) unique not null,
    primary key (idrol)
);

create table usuario(
    usuario varchar(20) not null,
    nombre varchar(20) not null,
    apellido varchar(20) not null,
    pwd varchar(255) not null,
    idrol tinyint unsigned not null,
    foreign key (idrol)
        references rol (idrol),
    primary key (usuario)
);

create table tokens (
    usuario varchar(20) not null,
    tokn char(255) not null,
    foreign key (usuario)
        references usuario (usuario),
    primary key (tokn)
);

create table telefonousuario(
    usuario varchar(20) not null,
    numero int(9) unsigned not null,
    foreign key (usuario)
        references usuario (usuario),
    primary key (usuario, numero)
);

create table cliente (
    usuario varchar(20),
    foreign key (usuario)
        references usuario (usuario),
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

create table paquete (
    idpaquete int unsigned not null,
    comentarios varchar(64) not null,
    pesokg int unsigned not null,
    volumenm3 int unsigned not null,
    usuario varchar(20) not null,
    foreign key (usuario)
        references usuario (usuario),
    primary key (idpaquete)
);

create table lotepaquete(
    idlote int unsigned not null,
    idpaquete int unsigned not null,
    foreign key (idlote)
        references lote (idlote),
    foreign key (idpaquete)
        references paquete (idpaquete),
    primary key (idpaquete)
);

create table estado(
    idestado tinyint unsigned not null,
    estado varchar(64) not null,
    primary key (idestado)
);

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

create table camion(
    matricula char(6) not null,
    modelo varchar(64) not null,
    capacidadkg int not null,
    capacidadm3 int not null,
    primary key (matricula)
);

create table conductor(
    usuario varchar(20) not null,
    licencia char(8) unique not null,
    foreign key (usuario)
        references usuario (usuario),
    primary key (usuario)
);