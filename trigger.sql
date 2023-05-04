select * FROM album
select * from backup_album
create table backup_album  as select * from album


create function album_trg_func()
returns trigger
language 'plpgsql'
as $$
declare
begin

insert into backup_album
(album_id,title,artist_id)
values
(old.album_id,old.title,old.artist_id);
return new;

end;
$$;



create trigger ablum_trg
before delete or update
on
album
for each row
execute procedure album_trg_func();

update album set title = 'Broken Nights'
where 
album_id= '1'






