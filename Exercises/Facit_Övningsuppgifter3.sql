select name, schema_name(schema_id) as schema_name  
from sys.tables 
where schema_name(schema_id) = 'company';

select top 5 * from company.orders;
select top 5 * from company.order_details;
select top 5 * from company.products;

-- 1)
select 
    count(distinct od.ProductId) as ProductsToLondon,

    format(
        count(distinct od.ProductId) / 77.0,
        'p'
    ) as Percentage 

from 
    company.orders o
join 
    company.order_details od on o.Id = od.OrderId

where o.ShipCity = 'London';  


-- 2)
select 
    o.ShipCity,
    count(distinct od.ProductId) as UniqueProducts
from 
    company.orders o  
join 
    company.order_details od  
    on o.Id = od.OrderId
group by 
    o.ShipCity
order by 
    UniqueProducts desc;


-- 3)
select 
    sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) as TotalSoldToGermany
from 
    company.products p  
join 
    company.order_details od  
    on p.Id = od.ProductId
join 
    company.orders o  
    on od.OrderId = o.Id
where 
    p.Discontinued = 1 and o.ShipCountry = 'Germany';


-- 4)
select 
    c.CategoryName,
    sum(p.UnitPrice * p.UnitsInStock) as InventoryValue
from 
    company.products p   
join 
    company.categories c  
    on p.CategoryId = c.Id 
group by 
    c.CategoryName 
order by 
    InventoryValue desc; 


-- 5)
select 
    s.CompanyName as Supplier,
    sum(od.Quantity) as TotalSold 
from 
    company.suppliers s  
join 
    company.products p  
    on s.Id = p.SupplierId
join 
    company.order_details od  
    on p.Id = od.ProductId
join 
    company.orders o  
    on od.OrderId = o.Id
where 
    o.OrderDate >= '2013-06-01' and o.OrderDate < '2013-09-01'
group by 
    s.CompanyName 
order by 
    TotalSold desc;


-- secend part of exercise
select name, schema_name(schema_id) as schema_name  
from sys.tables
where schema_name(schema_id) = 'music';

select top 5 * from music.tracks
select top 5 * from music.albums
select top 5 * from music.artists
select top 5 * from music.media_types;

-- 1)
select 
    ar.Name,
    sum(t.Milliseconds) as TotalMilliseconds
from 
    music.tracks t 
join 
    music.albums al  
    on t.AlbumId = al.AlbumId
join 
    music.artists ar 
    on al.ArtistId = ar.ArtistId 
join 
    music.media_types mt 
    on t.MediaTypeId = mt.MediaTypeId
where 
    mt.Name like '%audio%'
group by 
    ar.Name
order by 
    TotalMilliseconds desc;


-- 2)
with TopArtist as (
    select top 1
        ar.ArtistId
    from 
        music.tracks t 
    join 
        music.albums al 
        on t.AlbumId = al.AlbumId
    join 
        music.artists ar 
        on al.ArtistId = ar.ArtistId
    join 
        music.media_types mt 
        on t.MediaTypeId = mt.MediaTypeId
    where mt.Name Like '%audio%'
    group by 
        ar.ArtistId
    order by 
        sum(t.Milliseconds) desc 
)

select 
    ar.Name as Artist,
    avg(t.Milliseconds) as AverageMilliseconds
from 
    music.tracks t 
join 
    music.albums al 
    on t.AlbumId = al.AlbumId
join 
    music.artists ar 
    on al.ArtistId = ar.ArtistId
join 
    TopArtist ta 
    on ar.ArtistId = ta.ArtistId
join 
    music.media_types mt 
    on t.MediaTypeId = mt.MediaTypeId
where 
    mt.Name like '%audio%'
group by 
    ar.Name;


-- 3)
select 
    sum(cast(t.Bytes as bigint)) as TotalVideoBytes,
    format(sum(cast(t.Bytes as bigint)) / 1024.0 / 1024.0, 'N1') + 'MiB' as TotalVideoSize
from 
    music.tracks t 
join 
    music.media_types mt 
    on t.MediaTypeId = mt.MediaTypeId
where 
    mt.Name like '%video%';


-- 4)
select 
    p.Name as Playlist,
    count(distinct ar.ArtistId) as NumberOfArtists
from 
    music.playlists p  

join 
    music.playlist_track pt  
    on p.PlaylistId = pt.PlaylistId
join 
    music.tracks t 
    on pt.TrackId = t.TrackId
join 
    music.albums al 
    on t.AlbumId = al.AlbumId
join 
    music.artists ar 
    on al.ArtistId = ar.ArtistId

group by 
    p.Name 
order by 
    NumberOfArtists desc;


-- 5)
select 
    avg(cast(NumberOfArtists as float)) as AverageArtistsPerPlaylist
from(
    select 
        p.PlaylistId,
        count(distinct ar.ArtistId) as NumberOfArtists
    from 
        music.playlists p  
    join 
        music.playlist_track pt  
        on p.PlaylistId = pt.PlaylistId
    join 
        music.tracks t 
        on pt.TrackId = t.TrackId 
    join 
        music.albums al 
        on t.AlbumId = al.ArtistId
    join 
        music.artists ar 
        on al.ArtistId = ar.ArtistId
    group by 
        p.PlaylistId
) x;
