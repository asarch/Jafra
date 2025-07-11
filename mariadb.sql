-- -*- mode: sql; sql-product: mariadb -*-

-- id int auto_increment primary key
-- id serial primary key
-- fecha timestamp default current_timestamp

--
-- Jafra
--

-- generamos un pedido y luego agregamos las cantidades de los n productos de ese pedido en la tabla venta, así, con los precios actuales de cada producto se puede saber el total a pagar de cada pedido.
-- Con el tiempo, cada producto actualiza su precio (algunos bajan y otros suben), ¿cómo le puedo hacer?

-- Con el siguiente esquema en PostgreSQL:

create table vendedor (
    id int auto_increment primary key,
    nombre text,
    apellido_paterno text,
    apellido_materno text,
    fecha timestamp default current_timestamp
);

create table cliente (
    id int auto_increment primary key,
    nombre text,
    apellido_paterno text,
    apellido_materno text,
    fecha timestamp default current_timestamp
);

create table pedido (
    id int auto_increment primary key,
    vendedor int references vendedor(id) on delete cascade on update cascade,
    cliente int references cliente(id) on delete cascade on update cascade,
    fecha timestamp default current_timestamp
);

create table categoria (
    id int auto_increment primary key,
    nombre text,
    fecha timestamp default current_timestamp
);

create table marca (
    id int auto_increment primary key,
    nombre text,
    fecha timestamp default current_timestamp
);

create table producto (
    id int auto_increment primary key,
    nombre text,
    categoria int references categoria(id) on delete cascade on update cascade,
    marca int references marca(id) on delete cascade on update cascade,
    precio numeric(10, 2),
    fecha timestamp default current_timestamp
);

create table venta (
    id int auto_increment primary key,
    pedido int references pedido(id) on delete cascade on update cascade,
    producto int references producto(id) on delete cascade on update cascade,
    cantidad int,
    precio numeric(10, 2),
    descuento numeric(10, 2),
    fecha timestamp default current_timestamp
);

create table comentario_producto (
    id int auto_increment primary key,
    producto int references producto(id) on delete cascade on update cascade,
    comentario text,
    fecha timestamp default current_timestamp
);

create table comentario_venta (
    id int auto_increment primary key,
    venta int references venta(id) on delete cascade on update cascade,
    comentario text,
    fecha timestamp default current_timestamp
);
   
create table comentario_pedido (
    id int auto_increment primary key,
    pedido int references pedido(id) on delete cascade on update cascade,
    comentario text,
    fecha timestamp default current_timestamp
);
 create table historico (
    id int auto_increment primary key,
    producto int references producto(id) on delete cascade on update cascade,
    precio numeric(10, 2),
    fecha timestamp default current_timestamp
);

create table inventario (
    id int auto_increment primary key,
    producto int references producto(id) on delete cascade on update cascade,
    cantidad int,
    fecha timestamp default current_timestamp
);

create table pago (
    id int auto_increment primary key,
    pedido int references pedido(id) on delete cascade on update cascade,
    cantidad numeric(10, 2),
    fecha timestamp default current_timestamp
);

DELIMITER //

CREATE TRIGGER tr_insertar_historico
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
	IF OLD.precio <> NEW.precio THEN
    	INSERT INTO historico(producto, precio) values (OLD.id, OLD.precio);
    END IF;
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER tr_precio_producto
BEFORE INSERT ON venta
FOR EACH ROW
BEGIN
	SET NEW.precio = (SELECT precio FROM producto WHERE id = NEW.producto);
END//

DELIMITER ;

insert into categoria(nombre) values ('Perfume para dama');
insert into categoria(nombre) values ('Perfume para caballero');
insert into categoria(nombre) values ('Desodorante en aerosol para dama');
insert into categoria(nombre) values ('Desodorante en aerosol para caballero');
insert into categoria(nombre) values ('Desodorante en roll-on para dama');
insert into categoria(nombre) values ('Desodorante en roll-on para caballero');
insert into categoria(nombre) values ('Perfume para niña');
insert into categoria(nombre) values ('Perfume para niño');
insert into categoria(nombre) values ('Desodorante en aerosol para niña');
insert into categoria(nombre) values ('Desodorante en aerosol para niño');
insert into categoria(nombre) values ('Desodorante en roll-on para niña');
insert into categoria(nombre) values ('Desodorante en roll-on para niño');

insert into cliente(nombre, apellido_paterno, apellido_materno) values ('Alef Sheridan Ariel', 'Ramírez', 'Chiñas');
insert into cliente(nombre, apellido_paterno, apellido_materno) values ('Adam Jean Michael', 'Ramírez', 'Chiñas');
insert into cliente(nombre, apellido_paterno, apellido_materno) values ('Marcks Anthony', 'Ramírez', 'Luis');
insert into cliente(nombre, apellido_paterno, apellido_materno) values ('Richard David', 'Ramírez', 'Luis');

insert into marca(nombre) values ('Jafra');
insert into marca(nombre) values ('Tupperware');
insert into marca(nombre) values ('Arabela');
insert into marca(nombre) values ('Betterware');
insert into marca(nombre) values ('Avon');
insert into marca(nombre) values ('Fuller');
insert into marca(nombre) values ('Stanhome');

insert into vendedor(nombre, apellido_paterno, apellido_materno) values ('Reyna', 'Luis', 'Altamirano');
insert into vendedor(nombre, apellido_paterno, apellido_materno) values ('Elena', 'Luis', 'Altamirano');
insert into vendedor(nombre, apellido_paterno, apellido_materno) values ('Betsaida Nathalí', 'Tamariz', 'Chiñas');
insert into vendedor(nombre, apellido_paterno, apellido_materno) values ('Rubicel', 'Pérez', 'Gómez');

insert into producto(nombre, categoria, marca, precio) values ('JF9 Verde', 2, 1, 189.45);
insert into producto(nombre, categoria, marca, precio) values ('JF9 Rojo', 2, 1, 199.45);
insert into producto(nombre, categoria, marca, precio) values ('JF9 Negro', 2, 1, 210.85);
insert into producto(nombre, categoria, marca, precio) values ('JF9 Azul', 2, 1, 189.45);
