create database jocVideo
use jocVideo

create TABLE Jucator (
    id_j int NOT NULL PRIMARY KEY,
    Name varchar(20) NOT NULL,
    Scor int
);


create TABLE ModDeJoc (
    id_Mdj int NOT NULL PRIMARY KEY,
);


create table Meniu(
	
	Name varchar(20) NOT NULL,
	JucatorId int FOREIGN KEY REFERENCES Jucator(id_j)
	ON DELETE CASCADE 
	ON UPDATE CASCADE,
	ModJocId int FOREIGN KEY REFERENCES ModDeJoc(id_Mdj)
	ON DELETE CASCADE 
	ON UPDATE CASCADE,
	CONSTRAINT id_M PRIMARY KEY (JucatorId, ModJocId)
);

drop table Jucator
drop table Meniu
drop table ModDeJoc
	

insert into Jucator values (1,'tennis McQueen',70)
insert into Jucator values (4,'hank',30)
insert into Jucator values (5,'jonsnow',70)
insert into Jucator values (6,'dizonauru',35)

insert into ModDeJoc values (1)
insert into ModDeJoc values (2)

select * from Jucator
select * from ModDeJoc

insert into Skin values (1,'ak_vulcan',1)
insert into Skin values (2,'awp_asi',2)
insert into Skin values (7,'deagle_blaze',5)
insert into Skin values (8,'glock18_weasel',6)

select * from Skin

insert into Harta values (1,'de_dust_2',1)
insert into Harta values (2,'de_mirage',2)
insert into Harta values (3,'de_cache',1)
insert into Harta values (4,'de_inferno',2)
insert into Harta values (9,'de_inferno',2)

select * from Harta

insert into Meniu values ('main',1,1)
insert into Meniu values ('selectskin',2,2)
insert into Meniu values ('main',5,1)
insert into Meniu values ('selectskin',6,2)

select * from Jucator

select * from Meniu

update Skin
set nume = 'ak_vulcan'
where id_s < 2

delete from Skin
where id_s = 7 or id_s = 8


update Harta
set nume = 'de_dust2'
where id_H is not null

update Jucator
set Name = 'hank'
where id_j > 2 OR Scor < 60

--laborator 3
--2
--trebuie 3 inner joinuri
select h.nume from Harta h
inner join ModDeJoc m on m.id_Mdj = h.id_Mf
where h.id_Mf = 2

select j.name from Jucator j
inner join Meniu m on m.JucatorID = j.id_j
where j.scor > 50

select s.nume from Skin s
left outer join Jucator j on j.id_j = s.id_jf
--ce e intre astea doua -- nu e suficient

select s.nume from Skin s
inner join Jucator j on s.id_jf = j.id_j
inner join Meniu m on m.JucatorId = j.id_j
inner join ModDeJoc MJ on MJ.id_Mdj = m.ModJocId
where j.scor > 50

select h.nume from Harta h
inner join ModDeJoc mj on mj.id_Mdj = h.id_Mf
inner join Meniu m on m.ModJocId = mj.id_Mdj
inner join Jucator j on m.JucatorId = j.id_j
where h.id_Mf = 2

select j.name from Jucator j
left outer join Meniu m on m.JucatorID = j.id_j
inner join ModDeJoc MJ on MJ.id_Mdj = m.ModJocId
inner join Harta h on h.id_Mf=MJ.id_Mdj


--1
select distinct j.id_j 
from Jucator j
where j.scor > 50 or j.scor < 40
union
select s.id_s
from Skin s
where s.nume = 'deagle_blaze'

--3
select id_H,count(h.id_H),min(id_Mf) as harTot from Harta h
inner join ModDeJoc m on h.id_Mf = m.id_Mdj
where h.nume = 'de_inferno'
group by h.id_H

select nume,count(id_jf) as nrSkinuri from Skin s
group by s.nume
having count(id_jf) >= 1

select scor,count(id_j),sum(scor) as nrJuc from Jucator j
group by j.scor


--laborator 4

--1

create function nrJuc(@Jucator varchar(50))
returns int as
begin
declare @nrJ int
set @nrJ = 0
select @nrJ = count(*) from Jucator
where Name = @Jucator
return @nrJ
end

print dbo.nrJuc('dizonauru')

create function nrSk(@Skin varchar(50))
returns int as
begin
declare @nrS int
set @nrS = 0
select @nrS = count(*) from Skin
where nume = @Skin
return @nrS
end

create function nrHa(@Harta varchar(50))
returns int as
begin
declare @nrHa int
set @nrH = 0
select @nrH = count(*) from Skin
where nume = @Harta
return @nrH
end

create function nrMdj(@ModDeJoc int)
returns int as
begin
declare @nrM int
set @nrM = 0
select @nrM = count(*) from ModDeJoc
where id_Mdj = @ModDeJoc
return @nrM
end

create procedure Proc3
@nume varchar(20), @scor int
as
begin
declare @id int
set @id=0
select @id = count(*) from Jucator
declare @a int
set @a = 0
select @a = count(*) from Jucator 
where @id = id_j
if @a != 0
raiserror ('jucatorul exista deja',10,1)
insert into Jucator values (@id+10,@nume,@scor)
end
go

create procedure Proc11   --Proc3
@nume varchar(20), @scor int
as
begin
declare @id int
set @id=0
select @id = dbo.nrJuc(@nume)  --select @id = count(*) from Jucator
declare @a int
set @a = 0
select @a = count(*) from Jucator 
where @id = id_j
if @a != 0
raiserror ('jucatorul exista deja',10,1)
insert into Jucator values (@id+10,@nume,@scor)
end
go

exec Proc11 'Regina',60

--exec Proc3 'printesa',60

create procedure Proc9
@nume varchar(20), @idj int
as
begin
declare @id int
set @id=0
select @id = count(*) from Skin
if @id > 0
insert into Skin values (@id+10,@nume,@idj)
else
raiserror('id ul nu este valid',10,2)
end
go

create procedure Proc13
@id_mM int
as
begin
declare @id int
set @id=0
select @id = dbo.nrMdj(@id_mM)  
declare @a int
set @a = 0
select @a = count(*) from ModDeJoc 
where @id = @id_mM
if @a != 0
raiserror ('modul de joc exista deja',10,1)
insert into ModDeJoc values (@id+10)
end
go

exec Proc13 3

create procedure Proc12      --Proc9
@nume varchar(20), @idj int
as
begin
declare @id int
set @id=0
select @id = dbo.nrSk(@nume)   --select @id = count(*) from Skin
if @id > 0
insert into Skin values (@id+10,@nume,@idj)
else
raiserror('id ul nu este valid',10,2)
end
go

exec Proc12 'usps-elite',4

exec Proc9 'usps-orion',1

create procedure Proc10
@nume varchar(20), @idj int, @idmdj int
as
begin
declare @a int
set @a = 0
select @a = count(*) from Jucator 
if @nume is not null and @a != 0
insert into Meniu values (@nume,@idj,@idmdj)
else
raiserror('trebuie sa dai un nume meniului sau nu sunt jucatori',10,2)
end
go

exec Proc10 'select game mode',4,1

create procedure Proc16
@nume varchar(20), @id_s int, @id_jf int
as
begin
declare @a int
set @a = 0
select @a = count(*) from Jucator
declare @b int
set @b = 0
select @b = count(*) from Skin
if @id_jf != @a and @id_s > @b 
insert into Skin values (@id_s,@nume,@id_jf)
else
raiserror('id urile nu sunt valide',10,2)
end
go

exec Proc16'awp_elite_build',20,1

--2
create view HartaView as
select h.nume, h.id_H, m.id_Mdj from Harta h
inner join ModDeJoc m on h.id_Mf = m.id_Mdj

select * from HartaView

create view MeniuView as
select h.nume, h.id_H, m.id_Mdj, M.nume from Harta h
select m.id_Mdj from ModDeJoc m
inner join Meniu M on M.ModJocId = m.id_Mdj
inner join ModDeJoc m on h.id_Mf = m.id_Mdj

select * from MeniuView

--3

create trigger triggerInsert1
on Skin
for insert
as
begin
print 'Tabela Skin: '
print 'Skin adaugat la ora: '
print getdate()
end


insert into Skin values (25,'deagle_pilot',1)

create trigger triggerDelete
on Skin
for delete
as
begin
print 'Tabela Skin: '
print 'Skin sters la ora: '
print getdate()
end

delete from Skin
where id_s = 20 or id_s = 25