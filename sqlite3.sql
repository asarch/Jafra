-- -*- mode: sql; sql-product: firebird -*-

--"id" integer primary key autoincrement
--"id"serial primary key autoincrement
-- "Fecha" timestamp default current_timestamp

--
-- Jafra
--

--
-- Con el siguiente esquema en PostgreSQL:
--
--
-- Significa que el comando funcionó:
-- 1: at ./connectivity/source/drivers/firebird/StatementCommonBase.cxx:459
--
-- generamos un "Pedido" y luego agregamos las "Cantidad"es de los n "Producto"s de ese pedido en la tabla venta, así, con los "Precio"s actuales de cada producto se puede saber el total a pagar de cada pedido.
-- Con el tiempo, cada "Producto" actualiza su "Precio" (algunos bajan y otros suben), ¿cómo le puedo hacer 

-- connect "localhost:/home/asarch/Documentos/Jafra - Firebird.fdb" user sysdba password xpgbjapan;

create table "Vendedor" (
    "id" integer primary key autoincrement,
    "Nombre" text,
    "Apellido paterno" text,
    "Apellido materno" text,
    "Fecha" timestamp default current_timestamp
);

create table "Cliente" (
    "id" integer primary key autoincrement,
    "Nombre" text,
    "Apellido paterno" text,
    "Apellido materno" text,
    "Fecha" timestamp default current_timestamp
);

create table "Pedido" (
    "id" integer primary key autoincrement,
    "Vendedor" integer references "Vendedor"("id") on delete cascade on update cascade,
    "Cliente" integer references "Cliente"("id") on delete cascade on update cascade,
    "Fecha" timestamp default current_timestamp
);

create table "Categoría" (
    "id" integer primary key autoincrement,
    "Nombre" text,
    "Fecha" timestamp default current_timestamp
);

create table "Marca" (
   "id" integer primary key autoincrement,
    "Nombre" text,
    "Fecha" timestamp default current_timestamp
);

create table "Producto" (
   "id" integer primary key autoincrement,
    "Nombre" text,
    "Categoría" integer references "Categoría"("id") on delete cascade on update cascade,
    "Marca" integer references "Marca"("id") on delete cascade on update cascade,
    "Precio" numeric(10, 2),
    "Fecha" timestamp default current_timestamp
);

create table "Venta" (
   "id" integer primary key autoincrement,
    "Pedido" integer references "Pedido"("id") on delete cascade on update cascade,
    "Producto" integer references "Producto"("id") on delete cascade on update cascade,
    "Cantidad" integer,
    "Precio" numeric(10, 2),
    "Descuento" numeric(10, 2),
    "Fecha" timestamp default current_timestamp
);

create table "Comentario producto" (
   "id" integer primary key autoincrement,
    "Producto" integer references "Producto"("id") on delete cascade on update cascade,
    "Comentario" text,
    "Fecha" timestamp default current_timestamp
);

create table "Comentario venta" (
   "id" integer primary key autoincrement,
    "Venta" integer references "Venta"("id") on delete cascade on update cascade,
    "Comentario" text,
    "Fecha" timestamp default current_timestamp
);
   
create table "Comentario pedido" (
   "id" integer primary key autoincrement,
    "Pedido" integer references "Pedido"("id") on delete cascade on update cascade,
    "Comentario" text,
    "Fecha" timestamp default current_timestamp
);

create table "Histórico" (
   "id" integer primary key autoincrement,
    "Producto" integer references "Producto"("id") on delete cascade on update cascade,
    "Precio" numeric(10, 2),
    "Fecha" timestamp default current_timestamp
);

create table "Inventario" (
   "id" integer primary key autoincrement,
    "Producto" integer references "Producto"("id") on delete cascade on update cascade,
    "Cantidad" integer,
    "Fecha" timestamp default current_timestamp
);

create table "Pago" (
   "id" integer primary key autoincrement,
    "Pedido" integer references "Pedido"("id") on delete cascade on update cascade,
    "Cantidad" numeric(10, 2),
    "Fecha" timestamp default current_timestamp
);

insert into "Categoría"("Nombre") values ('Perfume para dama');
insert into "Categoría"("Nombre") values ('Perfume para caballero');
insert into "Categoría"("Nombre") values ('Desodorante en aerosol para dama');
insert into "Categoría"("Nombre") values ('Desodorante en aerosol para caballero');
insert into "Categoría"("Nombre") values ('Desodorante en roll-on para dama');
insert into "Categoría"("Nombre") values ('Desodorante en roll-on para caballero');
insert into "Categoría"("Nombre") values ('Perfume para niña');
insert into "Categoría"("Nombre") values ('Perfume para niño');
insert into "Categoría"("Nombre") values ('Desodorante en aerosol para niña');
insert into "Categoría"("Nombre") values ('Desodorante en aerosol para niño');
insert into "Categoría"("Nombre") values ('Desodorante en roll-on para niña');
insert into "Categoría"("Nombre") values ('Desodorante en roll-on para niño');

insert into "Cliente"("Nombre", "Apellido paterno", "Apellido materno") values ('Alef Sheridan Ariel', 'Ramírez', 'Chiñas');
insert into "Cliente"("Nombre", "Apellido paterno", "Apellido materno") values ('Adam Jean Michael', 'Ramírez', 'Chiñas');
insert into "Cliente"("Nombre", "Apellido paterno", "Apellido materno") values ('Marcks Anthony', 'Ramírez', 'Luis');
insert into "Cliente"("Nombre", "Apellido paterno", "Apellido materno") values ('Richard David', 'Ramírez', 'Luis');

insert into "Marca"("Nombre") values ('Jafra');
insert into "Marca"("Nombre") values ('Tupperware');
insert into "Marca"("Nombre") values ('Arabela');
insert into "Marca"("Nombre") values ('Betterware');
insert into "Marca"("Nombre") values ('Avon');
insert into "Marca"("Nombre") values ('Fuller');
insert into "Marca"("Nombre") values ('Stanhome');

insert into "Vendedor"("Nombre", "Apellido paterno", "Apellido materno") values ('Reyna', 'Luis', 'Altamirano');
insert into "Vendedor"("Nombre", "Apellido paterno", "Apellido materno") values ('Elena', 'Luis', 'Altamirano');
insert into "Vendedor"("Nombre", "Apellido paterno", "Apellido materno") values ('Betsaida Nathalí', 'Tamariz', 'Chiñas');
insert into "Vendedor"("Nombre", "Apellido paterno", "Apellido materno") values ('Rubicel', 'Pérez', 'Gómez');

insert into "Producto"("Nombre", "Categoría", "Marca", "Precio") values ('JF9 Verde', 2, 1, 189.45);
insert into "Producto"("Nombre", "Categoría", "Marca", "Precio") values ('JF9 Rojo', 2, 1, 199.45);
insert into "Producto"("Nombre", "Categoría", "Marca", "Precio") values ('JF9 Negro', 2, 1, 210.85);
insert into "Producto"("Nombre", "Categoría", "Marca", "Precio") values ('JF9 Azul', 2, 1, 189.45);

-- drop table "Histórico";
-- drop table "Inventario";
-- drop table "Comentario producto";
-- drop table "Comentario venta";
-- drop table "Pago";
-- drop table "Venta";
-- drop table "Pedido";
-- drop table "Producto";
-- drop table "Vendedor";
-- drop table "Cliente";
-- drop table "Marca";
-- drop table "Categoría";
