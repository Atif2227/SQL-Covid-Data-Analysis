/* Creating Corona Death Table*/
CREATE Table coviddeaths(
iso_code VARCHAR(50),
continent VARCHAR(50),
location VARCHAR(50),
date DATE,
population NUMERIC(20),
total_cases NUMERIC(20),
new_cases NUMERIC (20),
new_cases_smoothed DECIMAL(20),
total_deaths NUMERIC(20),
new_deaths NUMERIC(20),
new_deaths_smoothed DECIMAL(20),
total_cases_per_million DECIMAL(20),
new_cases_per_million DECIMAL(20),
new_cases_smoothed_per_million DECIMAL(20),
total_deaths_per_million DECIMAL(20),
new_deaths_per_million DECIMAL(20),
new_deaths_smoothed_per_million DECIMAL(20),
reproduction_rate DECIMAL(20),
icu_patients DECIMAL(20),
icu_patients_per_million DECIMAL(20),
hosp_patients NUMERIC(20),
hosp_patients_per_million DECIMAL(20),
weekly_icu_admissions NUMERIC(20),
weekly_icu_admissions_per_million DECIMAL(20),
weekly_hosp_admissions NUMERIC(20),
weekly_hosp_admissions_per_million DECIMAL(20)

);

/* Now import the data into the table using import vizard*/


/* Creating Corona Vaccination Table*/
CREATE TABLE covidvaccinations(
iso_code VARCHAR(50),
continent VARCHAR(50),
location VARCHAR(50),
date DATE,
total_tests NUMERIC (20),
new_tests NUMERIC (20),
total_tests_per_thousand DECIMAL (20),
new_tests_per_thousand DECIMAL (20),
new_tests_smoothed DECIMAL (20),
new_tests_smoothed_per_thousand DECIMAL (20),
positive_rate DECIMAL (20),
tests_per_case DECIMAL (20),
tests_units VARCHAR (50),
total_vaccinations NUMERIC(20),
people_vaccinated NUMERIC(20),
people_fully_vaccinated NUMERIC(20),
total_boosters NUMERIC(20),
new_vaccinations NUMERIC(20),
new_vaccinations_smoothed NUMERIC(20),
total_vaccinations_per_hundred DECIMAL(20),
people_vaccinated_per_hundred DECIMAL(20),
people_fully_vaccinated_per_hundred DECIMAL(20),
total_boosters_per_hundred DECIMAL(20),
new_vaccinations_smoothed_per_million NUMERIC(20),
new_people_vaccinated_smoothed NUMERIC(20),
new_people_vaccinated_smoothed_per_hundred DECIMAL(20),
stringency_index DECIMAL(20),
population_density DECIMAL(20),
median_age DECIMAL(20),
aged_65_older DECIMAL(20),
aged_70_older DECIMAL(20),
gdp_per_capita DECIMAL(20),
extreme_poverty DECIMAL(20),
cardiovasc_death_rate DECIMAL(20),
diabetes_prevalence DECIMAL(20),
female_smokers DECIMAL(20),
male_smokers DECIMAL(20),
handwashing_facilities DECIMAL(20),
hospital_beds_per_thousand DECIMAL(20),
life_expectancy DECIMAL(20),
human_development_index DECIMAL(20),
excess_mortality_cumulative_absolute DECIMAL(20),
excess_mortality_cumulative DECIMAL(20),
excess_mortality DECIMAL(20),
excess_mortality_cumulative_per_million DECIMAL(20)
);

/* Now import the data into the table using import vizard*/

/* Checkinng the table content*/
SELECT * FROM covidvaccinations;
SELECT * FROM coviddeaths;


/* Data Analysis*/

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY iso_code, date;

/* Total cases vs total deaths*/
SELECT location, date, total_cases, total_deaths, 
(total_deaths/total_cases)*100 as Death_Percentage
FROM coviddeaths
WHERE location LIKE '%States%'
ORDER BY iso_code, date;


-- Total cases vs deaths
SELECT location, date, total_cases, population, 
(total_cases/population)*100 as Death_Percentage
FROM coviddeaths
WHERE location LIKE '%States%'
ORDER BY iso_code, date;

-- Countries with highest infecton rate compared with population
SELECT location, population, MAX(total_cases) as Highest_Infection_Count, 
MAX((total_cases/population))*100 as Percent_Population_Infected
FROM coviddeaths
WHERE (total_cases/population)*100 > 0
GROUP BY location, population
ORDER BY Percent_Population_Infected DESC; 


--Countries with Highest Death Count per Population
SELECT location, MAX(total_deaths) as total_death_count
FROM coviddeaths
WHERE continent is NOT NULL AND total_deaths>0
GROUP BY location
ORDER BY total_death_count DESC;

-- Contintents with the highest death count per Population
SELECT continent,MAX(total_deaths) as total_death_count
FROM coviddeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- Global Numbers
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,
SUM(new_deaths)/SUM(New_Cases)*100 as death_percentage
from coviddeaths
where continent is NOT NULL;

-- Total population vs vaccinated
SELECT dth.continent, dth.location, dth.date, dth.population,vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dth.location ORDER BY dth.location,dth.date) as rolling_vaccination_sum 
FROM coviddeaths dth
JOIN covidvaccinations vac
ON dth.location = vac.location
AND dth.date = vac.date
WHERE dth.continent is NOT NULL
ORDER BY 2,3
;