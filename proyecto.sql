drop database if exists proyecto;
drop user if exists apialmacen;
create user apialmacen identified by "urbgieubgiutg98rtygtgiurnindg8958y";
drop user if exists accessapi;
create user accessapi identified by "kwefbwibcakebvuyevbiubqury38";
drop user if exists apitransito;
create user apitransito identified by "samnibahsyehstwragsjfodkdsjcnbcgdgiuefw3r2t878y0hhjadsdvs";
create database proyecto;
use proyecto;

create table roles(
    rol VARCHAR(64) NOT NULL,
    PRIMARY KEY (rol)
);
insert into roles values ('admin'),('almacenero'),('camionero'),('cliente');
grant select on roles to accessapi;

create table usuarios(
    usuario varchar(20) NOT NULL,
    rol varchar(64) NOT NULL,
    pwd varchar(255) NOT NULL,
    nombre varchar(20) not null,
    apellido varchar(20) not null,
    foreign key (rol) references roles (rol),
    PRIMARY key (usuario)
);
insert into usuarios values ('daud', 'admin', '25536671091981511766355543188227253985418610202146632211173824120110919497153220178', 'Mateo', 'Daud');
grant insert, select, update, delete on usuarios to accessapi;
grant select on usuarios to apialmacen;

create table cliente(
    usuario varchar(20) not null,
    foreign key (usuario) references usuarios(usuario),
    PRIMARY key (usuario)
);

create table paquete(
    idpaquete int not null,
    comentarios varchar(256),
    pesokg decimal(4,2) not null,
    volumen decimal(3,2) not null,
    usuario varchar(20) not null,
    primary key (idpaquete),
    foreign key (usuario) references cliente(usuario)
);
grant insert, select, update, delete on paquete to apialmacen;

create table caracteristicas(
    id int AUTO_INCREMENT,
    nombre VARCHAR(64) NOT NULL,
    PRIMARY KEY (id)
);
insert into caracteristicas(nombre) values ('fragil'),('refrigerado'),('toxico'),('inflamable'),('carga viva');
grant select on caracteristicas to apialmacen;

create table caracteristicaspaquete(
    idpaquete int not null,
    caracteristica int not null,
    primary key(idpaquete,caracteristica),
    FOREIGN KEY(idpaquete) REFERENCES paquete(idpaquete),
    FOREIGN KEY (caracteristica) REFERENCES caracteristicas (id)
);
grant insert, select, update, delete on caracteristicaspaquete to apialmacen;

create table lugarenvio(
    idlugarenvio int not null,
    primary key(idlugarenvio)
);

create table almacen(
    idlugarenvio int not null,
    capacidadpesokg int not null,
    capacidadvolumen int not null,
    foreign key (idlugarenvio) references lugarenvio (idlugarenvio),
    primary key(idlugarenvio)
);
grant select on almacen to apialmacen;

create table clienteenvio(
    usuario varchar(20),
    idlugarenvio int,
    preferida boolean not null,
    primary key (usuario, idlugarenvio),
    foreign key (usuario) references cliente (usuario),
    foreign key (idlugarenvio) references lugarenvio (idlugarenvio)
);

create table lote(
    idlote int not null,
    idlugarenvio int not null,
    foreign key(idlugarenvio) references almacen(idlugarenvio),
    primary key (idlote)
);
grant insert, select, update, delete on lote to apialmacen;

create table paquetelote(
    idlote int not null,
    idpaquete int not null,
    foreign key (idlote) references lote (idlote),
    foreign key (idpaquete) references paquete (idpaquete),
    primary key (idpaquete)
);
grant insert, select, update, delete on paquetelote to apialmacen;

create table camion(
    matricula varchar(12) not null,
    modelo varchar(64) not null,
    capacidadkg int not null,
    capacidadm3 int not null,
    primary key(matricula)
);

create table conductor(
    usuario varchar(20) not null,
    licencia int not null,
    primary key(usuario)
);

create table conduce(
    matricula varchar(12) not null,
    usuario varchar(20) not null,
    fechasalida date not null,
    fechallegada date not null,
    horasalida time not null,
    horallegada time not null,
    primary key(matricula,usuario,fechasalida),
    FOREIGN KEY(matricula) REFERENCES camion(matricula),
    FOREIGN key(usuario) REFERENCES conductor(usuario)
);

create table cargalote(
    idlote int not null,
    matricula varchar(12) not null,
    usuario varchar(20) not null,
    fechasalida date not null,
    foreign key (idlote) references lote (idlote),
    foreign key (matricula, usuario, fechasalida) references
        conduce (matricula, usuario, fechasalida),
    primary key (idlote)
);
grant insert, select, update, delete on cargalote to apialmacen;

create table telefonolugarenvio(
    idlugarenvio int not null,
    telefono int(9) not null,
    foreign key (idlugarenvio) references lugarenvio (idlugarenvio),
    primary key(idlugarenvio, telefono)
);

create table loteenvio(
    idlote int not null,
    idlugarenvio int not null,
    estado varchar(32) not null,
    fechaestimada date not null,
    fechallegada date not null,
    foreign key (idlote) references lote (idlote),
    foreign key (idlugarenvio) references lugarenvio (idlugarenvio),
    primary key(idlote, idlugarenvio)
);

create table domicilio(
    idlugarenvio int not null,
    foreign key (idlugarenvio) references lugarenvio (idlugarenvio),
    primary key (idlugarenvio)
);

create table tokens(
	token varchar(255),
	usuario varchar(20) not null,
    foreign key (usuario) references usuarios (usuario),
    primary key (token)
);
grant insert, select, update, delete on tokens to accessapi;
grant select on tokens to apialmacen;

CREATE table telefonousuarios(
    usuario varchar(20) not null,
    telefono int(9) NOT NULL,
    PRIMARY KEY(usuario,telefono),
    FOREIGN KEY(usuario) REFERENCES usuarios(usuario)
);