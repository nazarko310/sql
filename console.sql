# 1.Вибрати усіх клієнтів, чиє ім`я має менше ніж 6 символів.

use `bank`;
select *
from client
where length(FirstName) < 6;

# 2.Вибрати львівські відділення банку.

select *
from department
where DepartmentCity = 'Lviv';

# 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.

select *
from client
where Education = 'high'
order by LastName;

# 4.Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.

select *
from application
order by idApplication desc
limit 5;

# 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.

select *
from client
where LastName like '%ov'
   or 'ova';


# 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.

select FirstName, LastName, City, DepartmentCity
from client
         join department on department.idDepartment = client.Department_idDepartment
where DepartmentCity = 'Kyiv';

# 7.Знайти унікальні імена клієнтів.


select distinct FirstName
from client;


# 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
select FirstName, LastName, Sum(Sum) as sum
from client
         join application on client.idClient = application.Client_idClient
where sum > 5000
group by application.Client_idClient;

# 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.

select COUNT(FirstName) as countOfClient
from client
         join department d on d.idDepartment = client.Department_idDepartment;

select COUNT(FirstName), DepartmentCity
from client
         join department d on d.idDepartment = client.Department_idDepartment
where DepartmentCity = 'Lviv'
group by DepartmentCity;


# 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.

select LastName, FirstName, MAX(Sum)
from client
         join application a on client.idClient = a.Client_idClient
group by LastName, FirstName;


# 11. Визначити кількість заявок на крдеит для кожного клієнта.


select LastName, FirstName, COUNT(a.Client_idClient) as aplication
from client
         join application a on client.idClient = a.Client_idClient
group by a.Client_idClient;

# 12. Визначити найбільший та найменший кредити.

select Max(Sum), MIN(Sum)
from application;

# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.

select FirstName, LastName, Count(idApplication) as aplication
from client
         join application a on client.idClient = a.Client_idClient
where Education = 'high'
group by FirstName, LastName;

# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select FirstName, LastName, AVG(Sum) as avg_sum
from client
         join application a on client.idClient = a.Client_idClient
         join department d on d.idDepartment = client.Department_idDepartment
group by idClient
order by avg_sum desc
limit 1;

# 15. Вивести відділення, яке видало в кредити найбільше грошей

select DepartmentCity, MAX(sum)
from (select DepartmentCity, Sum(Sum) as sum
      from client
               join application a on client.idClient = a.Client_idClient
               join department d on client.Department_idDepartment = d.idDepartment
      group by DepartmentCity) as x;


# 16. Вивести відділення, яке видало найбільший кредит.

select DepartmentCity, MAX(Sum)
from client
         join application a on client.idClient = a.Client_idClient
         join department d on client.Department_idDepartment = d.idDepartment;

# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
update application join client c on c.idClient = application.Client_idClient
set Sum='6000'
where Education = 'high';


# 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client JOIN application a on client.idClient = a.Client_idClient JOIN department d on d.idDepartment = client.Department_idDepartment
SET City='Kyiv'
where DepartmentCity = 'Kyiv';


# 19. Видалити усі кредити, які є повернені.
delete
from application
where CreditState = 'Returned';

# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.

delete application
from application
         join client c on c.idClient = application.Client_idClient
         join department d on d.idDepartment = c.Department_idDepartment
where LastName like '^.[aioeyu]%';


# 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000

SELECT department.*, Sum
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by Client_idClient, DepartmentCity
having Sum(Sum) > 5000
   and DepartmentCity = 'Lviv';


# 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000

Select FirstName, LastName
from client
         join department d on d.idDepartment = client.Department_idDepartment
         join application a on client.idClient = a.Client_idClient
group by Client_idClient, CreditState
having CreditState = 'Returned'
   and SUM(Sum) > 5000;


# 23.Знайти максимальний неповернений кредит.

select MAX(sum)
from (select SUM(Sum) as sum
      from application
      where CreditState = 'Not returned'
      group by Client_idClient) as x;

# 24.Знайти клієнта, сума кредиту якого найменша

select FirstName, LastName, SUM(Sum) as sum
from application
         join client c on c.idClient = application.Client_idClient
group by Client_idClient
order by sum
limit 1;

# 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів
select CreditState, Currency, SUM(Sum) as sum
from application
where sum > (select AVG(Sum) from application)
group by Client_idClient;

# 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів
select FirstName, LastName
from client
         join application a on client.idClient = a.Client_idClient
         join department d on d.idDepartment = client.Department_idDepartment
where City = (select City
              from client
                       join application a2 on client.idClient = a2.Client_idClient
              group by Client_idClient
              order by COUNT(SUM) desc
              limit 1
)
group by FirstName, LastName;


# 27. Місто клієнта з найбільшою кількістю кредитів
select City
from client
         join application a2 on client.idClient = a2.Client_idClient
group by Client_idClient
order by COUNT(SUM) desc
limit 1;






