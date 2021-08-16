use `bank`
#  найти самого старого клиента
select *
from client
order by Age desc
limit 1;

# посчитать количество кредитов каждой валюты

select Currency, COUNT(Currency)
from application
group by Currency;

# Найти клиентов которые проживают в том же городе что и отделение банка
select FirstName, LastName
from client
         join department d on d.idDepartment = client.Department_idDepartment
where City = DepartmentCity;


# Найти клиентов которые проживают в том же городе что и отделение банка
# но исключить из поиска Киев
select FirstName, LastName
from client
         join department d on d.idDepartment = client.Department_idDepartment
where City = DepartmentCity
  and City != 'Kyiv';


# найти із прошлого запроса, клиента с самый больший долларовым кредитом
select FirstName, LastName, SUM(Sum) as sum, Currency
from client
         join department d on d.idDepartment = client.Department_idDepartment
         join application a on client.idClient = a.Client_idClient
where City = DepartmentCity
  and City != 'Kyiv'
  and Currency = 'Dollar'
group by FirstName, LastName
order by MAX(sum) desc
limit 1;
