--select * from covid_deaths
--select * from covid_vaccinations

select location , date,total_cases ,new_cases ,total_deaths,population
from covid_deaths
order by 1,2

--looking for total cases vs deaths percentage in india

select location , date,total_cases,total_deaths,population,(total_deaths/total_cases ) *100 as death_percentage
from covid_deaths
where location like 'india'
order by 1,2

--looking for total cases vs population in india 

select location , date,total_cases,population,(total_cases/population ) *100 as cases_per_population
from covid_deaths
where location like 'india'
order by 1,2

--looking for the country with highest infection rate compared to population

select location,population,max(total_cases) as highest_infection_count ,max((total_cases/population ) *100 )as percentage_of_cases_per_population
from covid_deaths
group by location,population
order by percentage_of_cases_per_population desc


--looking for countries with highest death count per population

select location,max(cast(total_deaths as int ) )as highest_death_count 
from covid_deaths
group by location
order by highest_death_count desc 
-- getting continent also in place of location 

select location,max(cast(total_deaths as int ) )as highest_death_count 
from covid_deaths
where continent is not null   -- removing the continent
group by location
order by highest_death_count desc



-- showimg the continent with highest death count

select  * from covid_deaths
where continent is null
select continent,max(cast(total_deaths as int ) )as highest_death_count 
from covid_deaths
where continent is not null  
group by continent
order by highest_death_count desc


--Global numbers

select date ,sum(new_cases) as total_cases ,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases ) *100 as death_percentage
from covid_deaths
where continent is not null
group by  date
order by 1,2

-- total cases , deaths and death percentage

select sum(new_cases) as total_cases ,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases ) *100 as death_percentage
from covid_deaths
where continent is not null
order by 1,2


--  joing covid_deaths with covid_vaccination

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date ) as total_vac_by_day
from covid_deaths dea join covid_vaccinations vac 
on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null 
order by 2,3

-- creating cte table 

with vaccination  (continent,location,date,population,new_vacc,total_vacc_count)
  as (
 select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date ) as total_vac_by_day
from covid_deaths dea join covid_vaccinations vac 
on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null 
 )

 select location ,max((total_vacc_count/population)*100 ) as vacc_percentage 
 from vaccination


 -- Tempt table

 drop table if exists population_vacc
 create table population_vacc
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 total_vacc_count  numeric )


 insert into population_vacc

 select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date ) as total_vac_by_day
from covid_deaths dea join covid_vaccinations vac 
on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null 

 
 -- creating view to store data for later visualisation

 create view percent_pop_vacc as (

 select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date ) as total_vac_by_day
from covid_deaths dea join covid_vaccinations vac 
on dea.date = vac.date and dea.location = vac.location
where dea.continent is not null )

select * from percent_pop_vacc