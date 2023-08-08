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
    idlugarenvio int,
    latitud decimal(9,6),
    longitud decimal(9,6),
    calle varchar(64),
    numero int(4),
    primary key (idlugarenvio)
);
create table telefonolugarenvio(
    idlugarenvio int,
    numero int(9),
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (idlugarenvio, numero)
);

create table almacen(
    idlugarenvio int,
    capacidadkg int,
    volumenm3 int,
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (idlugarenvio)
);

create table domicilio(
    idlugarenvio int,
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (idlugarenvio)
);

create table lote(
    idlote int,
    idlugarenvio int,
    foreign key (idlugarenvio)
        references lugarenvio (idlugarenvio),
    primary key (idlote)
);

create table rol(
    idrol int,
    nombre varchar(64) unique,
    primary key (idrol)
);

create table usuario(
    usuario varchar(20),
    nombre varchar(20),
    apellido varchar(20),
    pwd varchar(255),
    idrol int,
    foreign key idrol
        references rol (idrol),
    primary key (usuario)
);

create table tokens (
    usuario varchar (20),
    tokn char (255),
    primary key (tokn)
);

create table telefonousuario(
    usuario varchar(20),
    numero int(9),
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

create table caracterisicas (
    idcaracteristica int,
    nombre varchar(64),
    primary key (idcaracteristica)
);
insert into caracteristicas values
(1, 'fragil'),
(2, 'refrigerado'),
(3, 'toxico'),
(4, 'inflamable'),
(5, 'carga viva');

create table paquete (
    idpaquete int,
    comentarios varchar(64),
    pesokg int,
    volumenm3 int,
    usuario varchar(20),
    foreign key (usuario)
        references usuario (usuario),
    primary key (idpaquete)
);

create table lotepaquete(
    idlote int,
    idpaquete int,
    foreign key (idlote)
        references lote (idlote),
    foreign key (idpaquete)
        references paquete (idpaquete)
);

create table estado(
    idestado int,
    estado varchar(64),
    primary key (idestado)
);

create table loteenvio(
    idlote int,
    idlugarenvio int,
    fechaestimada date,
    idestado int,
    foreign key (idlote)
        references lote (idlote),
    foreign key (idlugarenvio)
        references lugarenvio(idlugarenvio),
    foreign key (idestado)
        references estado (idestado),
    primary key (idlote)
);

create table camion(
    matricula char(6),
    modelo varchar(64),
    capacidadkg int,
    capacidadm3 int,
    primary key (matricula)
);

create table conductor(
    usuario varchar(20),
    licencia char(8) unique,
    primary key (usuario)
);