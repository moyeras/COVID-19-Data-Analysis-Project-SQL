COVID-19 Data Analysis Portfolio
This project involves performing SQL queries on two datasets: Covid_Deaths and Covid_Vaccinations. The goal is to analyze the impact of the pandemic across various locations, track vaccination efforts, and derive meaningful insights using SQL window functions, joins, aggregates, and more.

Project Overview
The analysis was conducted on two main datasets:

Covid_Deaths: Contains data on COVID-19 deaths, cases, and population information.
Covid_Vaccinations: Contains data on vaccination rates globally.
Key Features of the Analysis
Data Cleanup: Removing zeros from total_cases, total_deaths, and new_cases.
Calculation of Death Percentages: Deriving death rates based on cases per country.
Infection Rate Calculation: Finding the percentage of populations infected by COVID-19 in different locations.
Highest Infections and Deaths: Ranking locations by the highest infection counts and death tolls.
Vaccination Rates: Tracking cumulative vaccination rates by location and calculating the percentage of vaccinated people per population.
SQL Queries Included
Initial Data Selection and Ordering:

Selects data from Covid_Deaths for analysis, ordered by location and date.
Data Cleanup:

Replaces zeros in total_deaths, total_cases, and new_cases with NULL for more accurate analysis.
Death Percentage Calculation:

Calculates the percentage of deaths based on the total cases for a specific location (e.g., Turkey).
Infection Percentage:

Calculates the percentage of the population infected with COVID-19 by dividing total cases by the population.
Highest Infection Count by Location:

Identifies the highest number of infections in each location and calculates the infection percentage per population.
Total Deaths per Location:

Retrieves the total number of deaths for each location, ordered by the highest death counts.
Deaths for Specific Regions:

Focuses on unions or specific groups of countries that are not assigned a continent and ranks them by total deaths.
Total Deaths per Continent:

Aggregates total deaths across each continent.
Daily New Cases and Deaths:

Summarizes daily new cases and deaths for all regions combined, with death rates.
Vaccination Analysis:

Joins Covid_Vaccinated and Covid_Deaths tables to analyze the total number of people vaccinated per location and calculates the percentage of the population vaccinated.
Views and Temporary Tables
View Creation: PercentPopulationVaccinated is a view that shows the cumulative number of vaccinations per location and the percentage of the population vaccinated.

Temporary Table Creation: #PercentPopulationVaccinated is a temporary table used to store similar vaccination statistics with a rolling sum of vaccinated individuals.

Example SQL Queries
Death Percentage Calculation:

sql
Kodu kopyala
SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    CAST((total_deaths / total_cases) * 100 AS DECIMAL(20, 10)) AS death_percentage
FROM 
    PortfolioProject..Covid_Deaths
WHERE 
    location LIKE 'turkey' and continent is not null
ORDER BY 
    1, 2;
Infected Population Percentage:

sql
Kodu kopyala
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
Vaccination Percentage Calculation:

sql
Kodu kopyala
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
Getting Started
Clone the repository:
bash
Kodu kopyala
git clone https://github.com/yourusername/covid19-sql-analysis.git
Set up the database environment and import the datasets.
Run the SQL scripts in the order they appear to reproduce the analysis.
Tools and Technologies Used
SQL Server for database management.
SQL Window Functions for rolling calculations.
Joins and Aggregations to merge and summarize data.
Data Cleaning using NULLIF to handle missing or invalid values.
Dataset
The datasets used in this analysis come from the Our World in Data project, which provides publicly available COVID-19 statistics.

Contributing
If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.
