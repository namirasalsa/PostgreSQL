create table product
    (id varchar(10) not null ,
    name varchar(100) not null ,
    description text,
    price int not null,
    quantity int not null default 0,
    created_at timestamp not null default current_timestamp,
    primary key (id)
    );
-- memasukkan data ke tabel
insert into product(id, name, price, quantity)
values('P0001', 'Mie ayam original' ,10000, 10);

insert into product(id, name, description, price, quantity)
values('P0002', 'Mie ayam bakso tahu' ,'mie ayam original dan tahu',10000, 10);

insert into product(id, name, price, quantity)
values('P0003', 'Mie ayam bakso' ,15000, 15),
    ('P0004', 'Mie ayam original', 10000, 5),
    ('P0005', 'Mie ayam bakso', 15000, 10)
;

select * from product;

-- UPDATE (mengubah value)
UPDATE product
set description = 'Mie ayam bakso + tahu'
where id = 'P0002';

UPDATE product
set description = 'Mie ayam original + bakso'
where id = 'P0003';

UPDATE product
set description = 'Mie ayam original + bakso'
where id = 'P0005';

create type category_product as enum ('makanan', 'minuman', 'lainnya');

--menambah kolom ke tabel yang sudah dibuat
alter table product
add column Category category_product;

update product
set category = 'makanan'
where id = 'P0001';

update product
set category = 'makanan'
where id = 'P0002';

update product
set category = 'makanan'
where id = 'P0003';

update product
set category = 'makanan'
where id = 'P0004';

update product
set category = 'makanan'
where id = 'P0005';

select * from product;

--SELECT
select * from product
where quantity > 10;

--ORDER BY
select * from product
order by price desc , id asc ;

select * from product
where quantity<15
order by quantity asc , id asc ;

-- mengambil 2 data teratas
select * from product
where quantity<15
order by quantity asc , id asc limit 2;

-- paging 1 limit 2 offset 0, 2 limit 2 offset w, 3 limit 2 offset 4
select * from product
where quantity < 15
order by quantity asc, id asc limit 2 offset 0;

select * from product
where quantity < 15
order by quantity asc, id asc limit 2 offset 2;

-- menampilkan data tanpa duplikat
select distinct name from product;

-- operasi aritmatika
select id, name, price/1000 as priceIn_k from product
order by price asc;

create table admin(
    id serial not null,
    first_name varchar(50) not null,
    last_name varchar(50),
    primary key (id)
);
-- insert data tanpa id
insert into admin(first_name, last_name)
values ('kim', 'taehyung'),
       ('nishimura', 'riki'),
       ('park', 'jihoom');

update admin
set last_name = 'jihoon'
where id = 3;

select * from admin;

--melihat id terakhir
select currval('admin_id_seq');

--SEQUENCE
create sequence contoh;
-- tiap dipanggil value nya naik
select nextval('contoh');
--mengetahui nilai terakhir
select currval('contoh');

--STRING FUNCTION
select first_name, last_name from admin;
select id, upper(first_name), lower(last_name) from admin;

/*DATE N TIME FUNCTIONA
-> extract mengambil informasi tertentu pada timestamp*/
select id, extract(hour from created_at), extract(year from created_at)
from product;

/* FLOW CONTROL FUNC
mirip if else
 CASE WHEN condition THEN result
     [WHEN ...]
     [ELSE result]
 END*/
select id, category,
       case category
            when 'makanan' then 'lapar ya?'
            when 'minuman' then 'haus ya?'
            else 'mau apa?'
        end as category_reason
from product;

select  id, price,
        case
            when price<=10000 then 'Terjangkau'
            when price<=20000 then 'Standar'
            else 'Mahal'
        end as price_category
from product;

select id, name,
       case
            when description is null then 'Deskripsi kosong'
            else description
        end as description
from product;

/*AGGREGATE FUNC
-> ex. avg, count, max, min, sum*/
select avg(price) as "Rata-rata harga" from product;
select count(id) as "Total pembeli" from product;
select max(price) as "Harga tertinggi" from product;
select min(price) as "Harga terendah" from product;

--Group by
select name, count(id) as "Total Pembeli" from product
group by name;

select name,
        avg(price) as "Rata-rata penjualan",
        sum(price) as "Total penjualan"
from product
group by name;

/*Having. sama kaya where.
 harus menambahkan aggregate func lagi*/
select name, count(id) as "Total Pembeli" from product
group by name
having count(id)>1;

/*CONSTRAINT
Unique constrains. memastikan data tetap unik(tdk ada duplikat)*/
create table customer(
  id serial not null,
  email varchar(50) not null ,
  first_name varchar(50) not null,
  last_name varchar(50),
  primary key (id),
  constraint unique_email UNIQUE (email)
);
select * from customer;
insert into customer(email, first_name, last_name)
values ('ruto@abc.com', 'Watanabe', 'Haruto');

--akan error krn email harus unik
insert into customer(email, first_name, last_name)
values ('ruto@abc.com', 'Haruto', 'Watanabe');

insert into customer(email, first_name, last_name)
values ('sahi@abc.com', 'Hamada', 'Asahi') ,
       ('oci@abc.com', 'Kanemoto','Yoshinori'),
       ('cio@abc.com', 'Takata','Mashiho');

--menambah/ menghapus Unique Constraint
alter table customer
    drop constraint unique_email;

alter table customer
    ADD CONSTRAINT unique_email unique (email);

/*Check Constraint
 untuk tabel baru:
 constraint price_check check (prize >= 15000)*/

--Menambah/ menghapus Check Constraint
alter table product
    drop constraint price_check;

-- tidak bisa memasukkan harga apabila kurang dari 10k
alter table product
    add constraint price_check check ( price>=10000 );
-- tidak  bisa memasukkan quantity 0
alter table product
    add constraint quantity_check check ( quantity>0 );

/*INDEX
1. Mempercepat select, memperlambat proses manipulasi(insert, update, delete)
2. primary key dan Unique constraint tidah perlu menambahkan index. krn suadah auto*/
create table sellers
(
    id    serial       not null, --index
    name  varchar(100) not null,
    email varchar(100) not null,
    primary key (id),
    constraint email_unique unique(email) --index
);

insert into sellers(name, email)
values ('Yang jungwon', 'wonnie@abc.com'),
       ('seungchol', 'choichoi@abc.com'),
       ('soobin', 'subinn@abc.com'),
       ('namjoon', 'joon@abc.com');
select * from sellers;

--MENAMBAH/MENGHAPUS INDEX
CREATE INDEX name_index on sellers(name);
DROP INDEX name_index;
create index id_and_name_index on sellers(id, name); --index= id dan id,name

select * from sellers where name = 'seungchol';
select * from sellers where id=1 or name = 'soobin';

/* FULL-TEXT SEARCH
tidak sefleksibel like, krn dipotong perkata. tapi proses search lebih cepat*/
--kalau menggunakan like
select * from product
where name ilike '%mie%';

--mencari tanpa index. dr record pertama sampai terakhir
SELECT * FROM product
WHERE to_tsvector(name) @@ to_tsquery('mie');

/* FUll-text search index. step-stepnya sebagai berikut
 1. menentukan bahasa yang akan dipakai yang disediakan oleh postgresql.
   cara mengeceknya: */
select cfgname from pg_ts_config;

--2. membuat index dari kolom yang akan dicari
create index product_name_search ON product using gin(to_tsvector('indonesian', name));
create index product_desc_search on product using gin(to_tsvector('indonesian', description));
drop index product_name_search;
drop index product_desc_search;

--3. mencari dengan full-text search. bisa langsung dengan to_tsquery
select * from product
where name @@ to_tsquery('mie');

select * from product
where description @@ to_tsquery('bakso');

/* Mencari dengan operator.
   to_tsquery mendukung operator and(&), or(|), not(!)  */
select * from product
where name @@ to_tsquery('mie & ayam');

select * from product
where name @@ to_tsquery('original | tahu');

select * from product
where name @@ to_tsquery('! bakso');

--   mencari kata yang gabung dengan petik satu 2 kali('''')
select * from product
where name @@ to_tsquery('''bakso tahu''');

/*TABLE RELATIONSHIP - FOREIGN KEY
 1. membuat tabel dengan foreign key
 */
create table cart
(
    id serial not null ,
    id_product varchar(10) not null , -- tipe data harus sama dengan yg di tabel produk
    description text,
    primary key (id),
    constraint fk_cart_product FOREIGN KEY (id_product) references product(id)
);

-- 2. Menambah/menghapus FK
alter table cart
    drop constraint fk_cart_product;

alter table cart
    add constraint fk_cart_product FOREIGN KEY (id_product) references product(id);

insert into cart(id_product, description)
values ('P0001', 'Mie favorit'),
       ('P0002', 'Mie favorit'),
       ('P0004', 'Mie favorit');

/*JOIN
  lebih dari 5 tabel, query akan terasa lambat
  */
select *
from cart
    join product on product.id = cart.id_product;

select product.id, product.name, cart.description
from cart
    join product on product.id = cart.id_product;

--Membuat relasi ke table customers dengan id
alter table cart
    add column id_cust INT;

alter table cart
    add constraint fk_cart_cust foreign key (id_cust) references customer(id);

update cart
set id_cust = 1
where id in (1,3);

select * from customer;

update cart
set id_cust = 3
where id in (4,2);

select * from cart;

select customer.email, product.id, product.name, cart.description
from cart
    join product on product.id = cart.id_product
    join customer on customer.id = cart.id_cust;

/*LEFT JOIN
  data yang ada di tabel pertama akan diambil.
  apabila tidak ada relasi di table 2, maka NULL*/
select * from cart
left join product on product.id = cart.id_product;

/*RIGT JOIN
  data yang ada di tabel Kedua akan diambil.
  apabila tidak ada relasi di table 1, maka NULL*/
select * from cart
right join product on product.id = cart.id_product;

/*Full join
  menampilkan seluruh data pada kedua tabel*/
select * from cart
full join product on product.id = cart.id_product;

/*SUBQUERY dengan WHERE CLAUSE*/
select * from product
where price > (select avg(price) from product);

/*SUBQUERY dengan FROM Clause*/
select max(price)
from (select product.price as price
      from cart
            join product on product.id = cart.id_product) as tertingi;

/*SET OPERATOR
  union, union all, intersect, except*/

create table vip
(
    id serial not null ,
    email varchar(50) not null ,
    tittle varchar(50) not null ,
    content text,
    primary key (id)
);

select * from customer;

insert into vip(email, tittle, content)
values ('ruto@abc.com', 'vip', 'vip kita'),
       ('oci@abc.com', 'vip', 'vip kita'),
       ('wawan@abc.com', 'vip', 'vip kita nih'),
       ('sahi@abc.com', 'vip', 'vip juga'),
       ('oci@abc.com', 'vip', 'vip kita nih');

/*1. Union
  menggabungkan dua buah select, jika ada yang duplikat maka disebut sekali*/
  select distinct email
  from customer
  union
  select distinct email
  from vip;

/*2. Union All
  data duplikat tetap di tampilkan lebih dari sekali*/
  select email
  from customer
  union all
  select email
  from vip;
-- mencari email berapa kali muncul dengan subquery
select email, count(email)
from (select distinct email
      from customer
      union all
      select distinct email from vip) as hitung
group by email;

/* 3. INTERSECT
    Memunculkan data yang terdapat di table 1 dan 2*/
 select email
  from customer
  intersect
  select email
  from vip;

/* 4. EXCEPT
  menampilkan data yang hanya ada di tabel 1,
  seluruh data tabel 2 akan dihapus
    melihat customer mana yang belum pernah menjadi vip*/
 select email
  from customer
  except
  select email
  from vip;

