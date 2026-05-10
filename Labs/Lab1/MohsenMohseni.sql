-- MoonMissions

-- G
select 
    Spacecraft,
    [Launch date],
    [Carrier rocket],
    Operator,
    [Mission type] 
into SuccessfulMissions 
from MoonMissions 
where Outcome = 'Successful outcome';

GO

update SuccessfulMissions
set Operator = TRIM(Operator);

GO  

-- VG
update SuccessfulMissions
set Spacecraft = 
    LEFT(Spacecraft, CHARINDEX('(', Spacecraft) -2)
where Spacecraft like '%(%';

GO 

select 
    Operator,
    [Mission type],
    COUNT(*) as [Mission count]
from SuccessfulMissions
group by 
    Operator,
    [Mission type]
having COUNT(*) > 1
order by 
    Operator,
    [Mission type];

GO

--  Users

-- G
select 
    ID,
    UserName,
    [Password],
    FirstName,
    LastName,
    CONCAT(FirstName, ' ', LastName) as [Name],
    case 
        when CAST(SUBSTRING(ID, 10, 1) as int) % 2 = 0 then 'Female'
        else 'Male'
    end as Gender,
    Email,
    Phone
into NewUsers
from Users;

GO

select 
    UserName,
    COUNT(*) as DuplicateCount
from NewUsers
Group by UserName 
having COUNT(*) > 1;

GO  

alter table NewUsers
alter column UserName varchar(50);

with DuplicateUsers as 
(
    select 
        UserName,
        ROW_NUMBER() over 
        (
            partition by UserName 
            order by (select NULL)
        ) as RowNum 
    from NewUsers
)

update DuplicateUsers
set UserName = UserName + '_' + CAST(RowNum as varchar)
where RowNum > 1;

GO 

delete from NewUsers
where CAST(SUBSTRING(ID, 1, 1) as int) < 7 and Gender = 'Female';

GO  

insert into NewUsers (
    ID,
    UserName,
    [Password],
    FirstName,
    LastName,
    [Name],
    Gender,
    Email,
    Phone
)
values
(
    '900101-1234',
    'mohsenm',
    'a94a8fe5ccb19ba61c4c0873d391e987',
    'Mohsen',
    'Mohseni',
    'Mohsen Mohseni',
    'Male',
    'mohsenmohseni@gmail.com',
    '070-1234567'
);

GO

-- VG
select 
    Gender,
    AVG(
        DATEDIFF(
            YEAR,
            CAST('19' + 
                LEFT([id], 2) + '-' +
                SUBSTRING([id], 3, 2) + '-' +
                SUBSTRING([id], 5, 2) as Date),
            CAST(GETDATE() as Date)
        )
    ) as [Average age]
from NewUsers
group by Gender

GO

-- Company (Joins)

-- G
select 
    p.Id as Id,
    p.ProductName as Product,
    s.CompanyName as Supplier,
    c.CategoryName as Category
from company.products p  
inner join company.suppliers s
    on p.SupplierId = s.Id
inner join company.categories c 
    on p.CategoryId = c.Id
order by p.Id;

GO  

select 
    r.Id,
    r.RegionDescription,
    COUNT(e.EmployeeId) as NumberOfEmployees 
from company.regions r  
join company.territories t 
    on r.Id = t.RegionId
join company.employee_territory e  
    on t.Id = e.TerritoryId
group by r.Id, r.RegionDescription;

GO

-- VG
select 
    e.Id as Id,
    CONCAT(
        e.TitleOfCourtesy,
        ' ',
        e.FirstName,
        ' ',
        e.LastName
    ) as Name,

    ISNULL(
        CONCAT(
            m.TitleOfCourtesy,
            ' ',
            m.FirstName,
            ' ',
            m.LastName
        ),
        'Nobody!'
    ) as [Reports to]
from company.employees e  
left join company.Employees m 
    on e.ReportsTo = m.Id
order by e.Id;

GO