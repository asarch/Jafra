-- -*- mode: sql; sql-product: postgres -*-

-- id integer generated by default as identity primary key
-- id serial primary key
-- fecha timestamp with time zone default now()

--
-- Jafra
--

-- generamos un pedido y luego agregamos las cantidades de los n productos de ese pedido en la tabla venta, así, con los precios actuales de cada producto se puede saber el total a pagar de cada pedido.
-- Con el tiempo, cada producto actualiza su precio (algunos bajan y otros suben), ¿cómo le puedo hacer?

-- Con el siguiente esquema en PostgreSQL:

create table vendedor (
    id integer generated by default as identity primary key,
    nombre text,
    apellido_paterno text,
    apellido_materno text,
    fecha timestamp with time zone default now()
);

create table cliente (
    id integer generated by default as identity primary key,
    nombre text,
    apellido_paterno text,
    apellido_materno text,
    fecha timestamp with time zone default now()
);

create table pedido (
    id integer generated by default as identity primary key,
    vendedor integer references vendedor(id) on delete cascade on update cascade,
    cliente integer references cliente(id) on delete cascade on update cascade,
    fecha timestamp with time zone default now()
);

create table categoria (
    id integer generated by default as identity primary key,
    nombre text,
    fecha timestamp with time zone default now()
);

create table marca (
    id integer generated by default as identity primary key,
    nombre text,
    fecha timestamp with time zone default now()
);

create table producto (
    id integer generated by default as identity primary key,
    nombre text,
    categoria integer references categoria(id) on delete cascade on update cascade,
    marca integer references marca(id) on delete cascade on update cascade,
    precio numeric(10, 2),
    fecha timestamp with time zone default now()
);

create table venta (
    id integer generated by default as identity primary key,
    pedido integer references pedido(id) on delete cascade on update cascade,
    producto integer references producto(id) on delete cascade on update cascade,
    cantidad integer,
    precio numeric(10, 2),
    descuento numeric(10, 2),
    fecha timestamp with time zone default now()
);

create table comentario_producto (
    id integer generated by default as identity primary key,
    producto integer references producto(id) on delete cascade on update cascade,
    comentario text,
    fecha timestamp with time zone default now()
);

create table comentario_venta (
    id integer generated by default as identity primary key,
    venta integer references venta(id) on delete cascade on update cascade,
    comentario text,
    fecha timestamp with time zone default now()
);
   
create table comentario_pedido (
    id integer generated by default as identity primary key,
    pedido integer references pedido(id) on delete cascade on update cascade,
    comentario text,
    fecha timestamp with time zone default now()
);

create table historico (
    id integer generated by default as identity primary key,
    producto integer references producto(id) on delete cascade on update cascade,
    precio numeric(10, 2),
    fecha timestamp with time zone default now()
);

create table inventario (
    id integer generated by default as identity primary key,
    producto integer references producto(id) on delete cascade on update cascade,
    cantidad integer,
    fecha timestamp with time zone default now()
);

create table pago (
    id integer generated by default as identity primary key,
    pedido integer references pedido(id) on delete cascade on update cascade,
    cantidad numeric(10, 2),
    fecha timestamp with time zone default now()
);

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

CREATE OR REPLACE FUNCTION copiar_precio_producto()
RETURNS TRIGGER AS $$
BEGIN
    -- Obtener el precio del producto y asignarlo a la venta
    SELECT precio 
    INTO NEW.precio
    FROM producto 
    WHERE id = NEW.producto;
    
    -- Verificar si se encontró el producto
    IF NEW.precio IS NULL THEN
        RAISE EXCEPTION 'No se encontró el producto con ID: %', NEW.producto;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_copiar_precio_venta
    BEFORE INSERT ON venta
    FOR EACH ROW
    EXECUTE FUNCTION copiar_precio_producto();

-- Función del trigger para guardar cambios de precio
CREATE OR REPLACE FUNCTION guardar_cambio_precio()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo ejecutar si el precio ha cambiado
    IF OLD.precio IS DISTINCT FROM NEW.precio THEN
        insert into historico(producto, precio) values(NEW.id, OLD.precio);
    END IF;
 
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger
CREATE TRIGGER trigger_cambio_precio
    BEFORE UPDATE ON producto
    FOR EACH ROW
    EXECUTE FUNCTION guardar_cambio_precio();
