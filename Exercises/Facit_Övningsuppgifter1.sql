-- a)
select top 5 * from GameOfThrones

select 
    Title,
    'S' + format(Season, '00') + 'E' + format(Episode, '00') as Episode
from 
    GameOfThrones;


-- b)
select *
into users2 
from users;

update users2
set Username = lower(left(FirstName, 2) + left(LastName, 2));

select 
    FirstName, LastName, Username 
from 
    users2;


-- c)
select top 5 * from Airports

select *
into Airports2 
from Airports;

update Airports2
set  
    Time = '-'
where Time is NULL;

update airports2 
set  
    DST = '-'
where DST is NULL;

select *
from Airports2;


-- d)
select *
into Elements2 
from Elements;

delete from Elements2
where Name in ('Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium')
    or Name like 'd%'
    or Name like 'k%'
    or Name like 'm%'
    or Name like 'o%'
    or Name like 'u%';

select *
from Elements2;


-- e)
select 
    Symbol,
    Name,
    case  
        when Name like Symbol + '%' then 'Yes'
        else 'No'
    end as StartsWithSymbol
into ElementsSymbolCheck
from Elements;

select *
from ElementsSymbolCheck;


-- f)
select 
    Name,
    Red,
    Green,
    Blue  
into Colors2
from Colors;

select 
    Name,
    Red,
    Green,
    Blue,
    format(Red, 'X2') + format(Green, 'X2') + format(Blue, 'X2') as Code 
from 
    Colors2;


-- g)
select top 5 * from Types

select 
    [Integer],
    [String] 
into Types2
from Types;

select 
    [Integer],
    cast([Integer] as Float) / 100 as Float,
    [String],

    dateadd(
        minute, [Integer],
        dateadd(day, [Integer] - 1, '2019-01-01 09:00:00')
    ) as DateTime,

    case 
        when [Integer] % 2 = 1 then 1
        else 0
    end as Bool
from 
    Types2;