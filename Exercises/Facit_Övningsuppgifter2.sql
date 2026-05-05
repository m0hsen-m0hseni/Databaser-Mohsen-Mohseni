-- a)
select top 5 * from Elements;

select 
    Period,
    min(Number) as [from],
    max(Number) as [to],
    format(avg(cast(Stableisotopes as float)), 'N2') as [average isotopes],
    string_agg(Symbol, ', ') as symbols
from 
    Elements
group by 
    Period 
order by 
    Period;


-- b)
select top 5 * from company.customers;

select 
    Region,
    Country,
    City,
    count(*) as Customers 
from 
    company.customers
group by 
    Region,
    Country,
    City
having count(*) >= 2
order by 
    Customers desc;


-- c)
select top 5 * from GameOfThrones;

DECLARE @text VARCHAR(MAX);

select @text = string_agg(text, char(13) + char(10))
from (
    select
        'Säsong' + cast(Season as varchar) +
        ' sändes från ' + format(min([Original air date]), 'MMMM', 'sv') +
        ' till ' + format(max([Original air date]), 'MMMM yyyy', 'sv') +
        '. Totalt sändes ' + cast(count(*) as varchar) +
        ' avsnitt, som i genomsnitt sågs av ' +
        cast(round(avg(cast([U.S. viewers(millions)] as float)), 1) as varchar) + 
        ' miljoner människor i USA.' as text
    from 
        GameOfThrones
    group by 
        Season
) t;

print @text;


-- d)
select top 5 * from Users;

select 
    concat(FirstName, ' ', LastName) as Namn,

    floor(
        datediff(
            day,
            convert(date, left(ID, 6)),
            getdate()
        ) / 365.25
    ) as [Ålder],

    case  
        when substring(right(ID, 2), 1, 1) % 2 = 0 then 'Kvinna'
        else 'Man'
    end as [Kön]

from 
    Users 
order by 
    FirstName, LastName;


-- e)
select top 5 * from Countries;

select 
    Region,
    count(*) as NumberOfCountries,
    sum(cast(Population as float)) as TotalPopulation,
    sum(cast([Area (sq# mi#)] as float)) as TotalArea,

    format(
        sum(cast(Population as float)) * 1.0 /
        sum(cast([Area (sq# mi#)] as float)),
        'N2'
    ) as PopulationDensity,

    round(
        sum(
            cast(
                replace([Infant mortality (per 1000 births)], ',', '.')
                as float
            )
        ) * 100,
        0
    ) as InfantMortalityPer100k

from 
    Countries
group by 
    Region;


-- f)
select top 5 * from Airports;

select 
    right(
        rtrim([Location served]),
        charindex(',', reverse(rtrim([Location served]))) - 1
    ) as Country,
    count(IATA) as [number of airports],
    sum(case when ICAO is null then 1 else 0 end) as [number of ICAO nulls],
    format(
        sum(case when ICAO is null then 1 else 0 end) / cast(count(IATA) as float),
        'p'
    ) as Percentage 

from Airports
where [Location served] like '%,%'
group by
    right(
        rtrim([Location served]),
        charindex(',', reverse(rtrim([Location served]))) - 1
    );