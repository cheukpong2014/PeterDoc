--mysql -u -p -h  (-u 用户名  -p 密码  -h host主机)
--age float(M,D) zerofill not null default 0
--zerofill = zerofill + unsigned
--zerofill unsigned not null default 0 auto_increment
set names gbk;

status;
show databases;
use (dbname);
create database (dbname) charset utf8;
drop database (dbname);

show tables;
desc (tname);
show create table (tname);
create table (tname)(
	id int auto_increment,
	username varchar(30) not null unsigned default'',
	index id(id)
)engine=innodb/myisam charset=utf8;

*******************************************************************
alter table (tname) add age int zerofill not null default 0;
alter table (tname) change age ages int not null unsigned default 0;
alter table (tname) drop ages;

8. Primary Key, Unique Key, Index Key
show index from (tname)
truncate (tbName);  --清空表的数据
8.1
alter table (tbName) add primary key('id');
alter table (tbName) drop primary key;
8.2
alter table goods add unique index unikey(goods_name);
alter table goods drop index unikey;
8.3
alter table goods add unique(goods_name);
alter table goods drop index goods_name;


insert into user(uid,name,age) values (1,'lisi',23),(2,'peter',24);
update user set age=9,name='nobody' where uid=2;
delete from user where uid=4;

**(1.where 2.group by 3.having 4.order by 5.limit)
select * from user where 1;
select * from user where (like, not like, in, not in , between and, is null, is not null);
(group by/ having)

做所有練習
-----------------------------
inner join 左右平衡
left join		- select t1.tname as hname, t2.tname as gname, mres from m left join t as t1 on hid=t1.tid left join t as t2 on gid=t2.tid;
right join		- select 列名 from table A left join table B on tableA.col1 = tableB.col2
union
union all 		- select id, sum(num) from (a union all b) as tmp group by id;
subquery(where)	- select * from tableA where colA = (select colB from tableB where ...);
subquery(from)	- select * from (select * from ...) as tName where ....
--28 create table

-- 29 整型列 
	-- Number:
	-- tinyint    -128-127
	-- smallint   -32768-32767 三萬幾
	-- mediumint  -8388608-8388607 八百幾萬
	-- int        -2147483648-2147483647 二十幾億
	-- bigint     

-- 30 整型列的可選參數 (unsigned, zerofill)
create table t2(
	num tinyint
);
insert into t2 values (-128);
insert into t2 values (127);
alter table t2 add unum tinyint unsigned;
insert into t2 values (3,0);
insert into t2 values (4,255);
desc t2;
    -- zerofill (0001, 0002) will be unsigned automatically
alter table t2 add sn tinyint(5) zerofill;
insert into t2 values (5,5,3);
insert into t2 values (5,5,23);
insert into t2 values (5,5,123);
desc t2;

alter table t2 add sx tinyint(1); -- the number '1' is useless
insert into t2 values (6,6,6,111);

-- 31 浮點列與定點列 float, double 有精度損失，demical 沒有
    -- float(m,d)[unsigned][zerofill] (same as double)
create table t3(
	salary float(5,2); --eg. 000.00
)
insert into t3 values(9999); -- fail
insert into t3 values(999.99); --max value
    -- demical
create table t4(
	f float(9,2),
	d decimal(9,2)
);
insert into t4 values(1234567.23,1234567.23);
select *  from t4;
-- 32 string types

    -- char(7); max = 'xxxxxxx'; need space = 7
    -- varchar(7) max = 'xxxxxxx' need space = it depends
create table t5 (
	m1 char(10),
	m2 varchar(10)
);
insert into t5 values (' hello ',' hello ');
select * from t5;
select concat('!',m1,'!'),concat('!',m2,'!') from t5; -- char will eat the space at the right

    -- text vs blob (blob 用二進制紀錄，不會被過濾)
create table t6(
	tx text
);
insert into t6 values ('afvcx');
select * from t6;

    -- enum
create table t7(
	gender enum('male','female')
);
insert into t7 values('male');
-- 33 日期時間型列
	-- Year 1995
	-- Date 1998-12-7
	-- Time 13:38:24
	-- datetime 1998-12-7 13:38:24
create table t8(
	ya year,
	dt date,
	tm Time,
	dttm datetime
);
insert into t8 (ya)values (1901);
insert into t8 (ya)values (56);
insert into t8 (dt)values ('1990-12-23');
insert into t8 (tm)values ('18:23:34');
insert into t8 (dttm)values ('1234-12-25 23:34:56');

create table t9(
	id int,
	ts timestamp
);
insert into t9 (id)values (1);

-- 34 列的默認值 (not null, default)
create table t10(
	id int not null default 0,
	name char(10) not null default ''
);
insert into t10 values(1,'lisi');
insert into t10(id) values(1);

-- 35 主鍵與自增
create table t11(
	id int primary key,
	name char(2)
);
create table t12(
	id int,
	name char(2),
	primary key(id)
);
create table t13(
	id int auto_increment,
	name char(2),
	key id(id)
);
create table t14(
	id int primary key auto_increment
);

-- 36 綜合建表案例

-- 37 列的增刪改
 create table reg3(
 	id int unsigned primary key AUTO_INCREMENT,
 	username char(10) NOT NULL DEFAULT '',
 	gender tinyint(4) NOT NULL DEFAULT 0,
 	weight tinyint unsigned NOT NULL DEFAULT 0,
 	Birth date NOT NULL DEFAULT '0000-00-00',
 	Salary decimal(8,2) NOT NULL DEFAULT '000000.00',
 	lastlogin int unsigned NOT NULL DEFAULT 0,
);
 create table reg1(
	id int unsigned primary key AUTO_INCREMENT,
 	username char(10) NOT NULL DEFAULT '',
 	intro varchar(1500) NOT NULL DEFAULT '',
);
desc reg3;
alter table reg3 add height tinyint unsigned not null default 0;
desc reg3;
alter table reg3 drop column height;
desc reg3;
alter table reg3 add height tinyint unsigned after weight;
desc reg3;
alter table reg3 change height shengao smallint;
alter table reg3 modify shengao tinyint;

-- 38 視圖
select goods_id, (market_price-shop_price) as sheng from goods;
create view v1goods as select goods_id, (market_price-shop_price) as sheng from goods;
select * from v1goods;
create view v2goods as select goods_id, shop_price from goods;
select * from v2goods;
select cat_id, avg(shop_price) as pj from goods group by goods_id;
create view v3goods as select cat_id, avg(shop_price) as pj from goods group by goods_id;
select * from v3goods order by pj desc limit 0,3;

create view v1user as select uid,name from user;
update user set name='lixiaolei' where uid=3;
update vuser set name='lidalei' where uid=3;

update v3goods set pj=80 where cat_id=15; -- error

-- 39 視圖2
create view v4goods as select goods_id, shop_price from goods;
select * from v4goods order by shop_price desc limit 3;
select goods_id, shop_price from goods order by shop_price desc limit 3;
create view v5goods as select cat_id, avg(shop_price) as pj, avg(market_price) as mpj from goods;
create view v6goods as select cat_id, avg(shop_price) as pj, avg(market_price) as mpj from goods group by cat_id;
select cat_id, mpj-pj as pjsheng from v6goods;

	--below is useless
create algorithm=merge view v7goods as select goods_id,goods_name from goods;
create algorithm=temptable view v8goods as select goods_id,goods_name from goods;
create view v9goods as select goods_id,goods_name from goods;

-- 40 table/view管理語句
show tables;
desc t12;
desc vgoods;

drop table tmp;
drop view vuser;

show create table goods;
desc vgoods;

show create table vvgoods;
show create view vvgoods;

show table status \G
show table status where name = 'goods' \G

rename table goods to goodsgoods;

delete from t15 where id = 2;
truncate t15;

-- 41 儲存引擎的概念
-- 43 index
    -- select ... where id = 10000;
    -- MyI
    -- key普通, unique key唯一, primary key主鍵, fulltext全文(cannot use in chinese, use sphinx)
create table t16(
	name char (10),
	email char (20),
	key name(name),
	unique key email(email)
);

create table t17(
	id int,
	name char (10),
	email char (20),
	primary key (id),
	key name(name),
	unique key email(email)
);

create table t18(
	id int,
	name char (10),
	email char (20),
	primary key (id),
	key name(name),
	unique key email(email(10))
);

create table t19(
	xing char(2),
	ming char(10),
	key xm(xing, ming)
);
show index from t19 \G
select * from t19 where firstname='peter' and lastname='tang';

create table t20(
	xing char(2),
	ming char(10),
	key xm(xing, ming), m(ming)
);

-- 44 index control
show index from t20;
show create table t20;
alter table t20 drop index m;
drop index xm on t20;
alter table t20 add index xm(xing, ming);
alter table t20 add unique m(ming);
alter table t20 add primary key(xing);
alter table t20 drop primary key;

-- 45 常用涵數
select 3+2;
select 3*2;
select abs(-3);


-- 46 事務(匯款)
create table account(
	id int,
	name char(10),
	money int
)engine innodb charset utf8;

insert into account values(1, 's3', 5000);
insert into account values(2, 'l4', 5000);

start transaction;
update account set money=money+500 where id=2;
update account set money=money-500 where id=1;
commit;

start transaction;
update account set money=money+500 where id=2;
update account set money=money-500 where id=1;
rollback;

alter table account change money
money int unsigned ;