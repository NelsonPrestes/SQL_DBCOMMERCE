create database dbteste;
use dbteste;

create table Produto(
   cdProduto int(5) not null primary key,
   descricao varchar(80)not null
);

create table Estoque(
   cdProduto int(5) not null primary key,
   qtdeMin int(3) not null,
   qtdeMax int(3) not null,
   qtdeAtual int(3) not null,
   constraint fk_cdproduto foreign key(cdproduto) references Produto (cdproduto)
   );
   
   create table Cliente(
   id int not null primary key auto_increment,
   Nome varchar(40),
   Celular varchar (11)
);

create table Nota(
   id int not null auto_increment,
   Nro varchar(10) not null,
   idcliente int null,
   Dtvenda date not null,
   primary key (id),
   constraint fk_idcliente foreign key(idcliente) references cliente (id)
);

create table Itensnota(
   id int not null auto_increment,
   idnota int(10) not null,
   codProduto int(5) not null,
   VlUnitario decimal(10,2) not null,
   Qtde decimal(4,1) not null,
   primary key (id),
   constraint fk_idnota foreign key(idnota) references Nota (id),
   constraint fk_codproduto foreign key(codProduto) references Produto (cdProduto)
);

insert into produto values(10,'xiaomi redmi note 9');
insert into produto values(20,'Batedeira Planetária Mondial BP-03 com 12 Velocidades e 700W');
insert into produto values(30,'Geladeira/Refrigerador Frost Free cor Inox 310L Electrolux 127V');
insert into produto values(40,'Smart TV UHD 4K LED 50” LG');

insert into estoque values(10,5,15,6);
insert into estoque values(20,3,8,7);
insert into estoque values(30,2,5,5);

insert into cliente values(null,'Maria da Silva',51984730344);
insert into cliente values(null,'Carlos da Silva Feijó',51984723379);
insert into cliente values(null,'Suani Mendez Gonzales',51965824402);

insert into nota values(null,000358785,1,'2020-01-20');
insert into nota values(null,000358343,1,'2020-04-11');
insert into nota values(null,000333343,2,'2021-02-12');

insert into itensnota values(null,1,10,1500.00,1);
insert into itensnota values(null,1,20,248.00,1);
insert into itensnota values(null,2,30,2112.00,1);
insert into itensnota values(null,3,20,220.00,2);

DELIMITER //	
	create procedure gravar_estoque(in cdProduto int, in qtdeMin int , in qtdeMax int)
	begin
	   if qtdemin > 0 and qtdeMax > 0 and qtdemax >= qtdemin then
		insert into estoque values (cdProduto, qtdeMin, qtdeMax, 0);
	      else
		select "não foi possível gravar";
	      end if;	
	end //
DELIMITER ;
	
call gravar_estoque(40, 20,100);

delimiter $$
create procedure sp_atualizar_preco(in vnro char(10),in vcdproduto int,in vvlunitario decimal(10,2))
begin
update itensnota i,nota n set vlunitario=vvlunitario where n.id=i.idNota and n.nro-vnro and i.codproduto=vcdproduto;
end $$
delimiter ;
call sp_atualizar_preco(30,'000358343',150.00);

delimiter $$
create function FC_totalPcli(codCli int(5))returns float(10,2)deterministic
begin
        declare resultado float(10,2);
        select sun(vlUnitario)into resultado from ItensNota
        inner join Nota on ItensNota.idNota = Nota.id
        inner join Cliente on Nota.idCliente = Cliente.id and Cliente.id=codCli;
        return resultado;
end $$
           
