SELECT *
FROM 
	PortfolioProject..Covid_Deaths
ORDER BY
	3,4

--select * from PortfolioProject..Covid_Vaccinations order by 3,4

SELECT
	location, date, total_cases, new_cases, total_deaths, population
FROM
	PortfolioProject..Covid_Deaths
WHERE
	continent is not null
ORDER BY
	1,2


UPDATE PortfolioProject..Covid_Deaths
SET 
    total_deaths = NULLIF(total_deaths, 0),
    total_cases = NULLIF(total_cases, 0),
	new_cases = NULLIF(new_cases, 0);




SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    CAST((total_deaths / total_cases) * 100 AS DECIMAL(20, 10)) AS death_percentage
FROM 
    PortfolioProject..Covid_Deaths
WHERE 
    location LIKE 'turkey' and  continent is not null
ORDER BY 
    1, 2;


SELECT 
    location, 
    date, 
    population, 
    total_cases, 
    CONVERT(DECIMAL(20, 10), (total_cases / population) * 100) as infected_percentage
FROM 
    PortfolioProject..Covid_Deaths
WHERE 
    location LIKE 'turkey' and continent is not null
ORDER BY 
    1, 2;


SELECT 
    location, 
    population, 
    MAX(total_cases) as Highest_Infection_Count, 
    CONVERT(DECIMAL(20, 10), MAX((total_cases / population)) * 100) as infected_percentage
FROM 
    PortfolioProject..Covid_Deaths
WHERE 
	continent is not null
GROUP BY
	location,population
ORDER BY 
   4 desc;



SELECT
	location ,max(cast(total_deaths as int)) as Total_Deaths
FROM
	PortfolioProject..Covid_Deaths
WHERE 
		continent is not null
GROUP BY
	location
ORDER BY 
	Total_Deaths desc



SELECT
	location ,max(cast(total_deaths as int)) as Total_Deaths
FROM
	PortfolioProject..Covid_Deaths
WHERE 
		continent is null 
		AND (location LIKE '%countries%' OR location LIKE '%union%')
GROUP BY
	location
ORDER BY 
	Total_Deaths,location desc



SELECT
	continent ,max(total_deaths) as Total_Deaths
FROM
	PortfolioProject..Covid_Deaths
WHERE 
		continent is not null 		
GROUP BY
	continent
ORDER BY 
	Total_Deaths desc





SELECT
	date, SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths,
	SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM
	PortfolioProject..Covid_Deaths		
	where continent is not null
GROUP BY
	date
ORDER BY 
	1,2



SELECT
	SUM(new_cases) as total_new_cases, SUM(new_deaths) as total_new_deaths,
	SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM
	PortfolioProject..Covid_Deaths		
	where continent is not null
ORDER BY 
	1,2

	

select
	dea.location,dea.population,MAX(vac.people_fully_vaccinated) AS Total_Vaccinated
from
	PortfolioProject..Covid_Vaccinated vac
JOIN 
    PortfolioProject..Covid_Deaths dea ON vac.location = dea.location and vac.date = dea.date
WHERE 
    dea.continent is not null and
	vac.continent is not null
GROUP BY 
    dea.location,dea.population
ORDER BY 
    1,2 DESC;


SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    COALESCE(vac.new_vaccinations, 0) AS new_vaccinations,
    SUM(COALESCE(CAST(vac.new_vaccinations AS BIGINT), 0)) OVER
        (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM
    PortfolioProject..Covid_Deaths dea
JOIN
    PortfolioProject..Covid_Vaccinated vac
    ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
ORDER BY
    dea.location, dea.date;



With PopvsVac (Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
	 SUM(CAST(vac.new_vaccinations AS DECIMAL(20, 2))) OVER
        (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM
    PortfolioProject..Covid_Deaths dea
JOIN
    PortfolioProject..Covid_Vaccinated vac
    ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
)
select *, CAST(RollingPeopleVaccinated/Population AS DECIMAL(20, 10))*100  as PercentageVaccinated from PopvsVac



DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(COALESCE(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM
    PortfolioProject..Covid_Deaths dea
JOIN
    PortfolioProject..Covid_Vaccinated vac
    ON dea.location = vac.location AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL;

SELECT *,
    (RollingPeopleVaccinated/Population) * 100 AS PercentageVaccinated
FROM #PercentPopulationVaccinated;




CREATE VIEW PercentPopulationVaccinated AS 
SELECT
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM
    PortfolioProject..Covid_Deaths dea
JOIN
    PortfolioProject..Covid_Vaccinated vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL;


select * from PercentPopulationVaccinated


















