# COVID-19 Data Analysis Project

## Overview

This project involves analyzing COVID-19 data, focusing on deaths and vaccinations across various continents and countries. The goal is to derive insights regarding the infection rates, vaccination coverage, and overall trends in the pandemic.

## Tables Used

- `PortfolioProject..Covid_Deaths`: Contains data on COVID-19 deaths, including location, date, total cases, and population.
- `PortfolioProject..Covid_Vaccinated`: Contains data on COVID-19 vaccinations, including the number of people fully vaccinated and new vaccinations.

## SQL Queries

### Data Retrieval and Cleaning

1. Retrieve all data from the `Covid_Deaths` table, ordered by date and location:
    ```sql
    SELECT *
    FROM 
        PortfolioProject..Covid_Deaths
    ORDER BY
        3, 4;
    ```

2. Retrieve COVID-19 death data for locations where the continent is known:
    ```sql
    SELECT
        location, date, total_cases, new_cases, total_deaths, population
    FROM
        PortfolioProject..Covid_Deaths
    WHERE
        continent IS NOT NULL
    ORDER BY 
        1, 2;
    ```

3. Update the `Covid_Deaths` table to replace zero values with NULL:
    ```sql
    UPDATE PortfolioProject..Covid_Deaths
    SET 
        total_deaths = NULLIF(total_deaths, 0),
        total_cases = NULLIF(total_cases, 0),
        new_cases = NULLIF(new_cases, 0);
    ```

### Calculating Percentages

4. Calculate the death percentage for Turkey:
    ```sql
    SELECT 
        location, 
        date, 
        total_cases, 
        total_deaths, 
        CAST((total_deaths / total_cases) * 100 AS DECIMAL(20, 10)) AS death_percentage
    FROM 
        PortfolioProject..Covid_Deaths
    WHERE 
        location LIKE 'turkey' AND continent IS NOT NULL
    ORDER BY 
        1, 2;
    ```

5. Calculate the infected percentage for Turkey:
    ```sql
    SELECT 
        location, 
        date, 
        population, 
        total_cases, 
        CONVERT(DECIMAL(20, 10), (total_cases / population) * 100) AS infected_percentage
    FROM 
        PortfolioProject..Covid_Deaths
    WHERE 
        location LIKE 'turkey' AND continent IS NOT NULL
    ORDER BY 
        1, 2;
    ```

### Aggregated Data

6. Get the highest infection count and percentage for each location:
    ```sql
    SELECT 
        location, 
        population, 
        MAX(total_cases) AS Highest_Infection_Count, 
        CONVERT(DECIMAL(20, 10), MAX((total_cases / population)) * 100) AS infected_percentage
    FROM 
        PortfolioProject..Covid_Deaths
    WHERE 
        continent IS NOT NULL
    GROUP BY
        location, population
    ORDER BY 
        4 DESC;
    ```

7. Retrieve total deaths by location:
    ```sql
    SELECT
        location, MAX(CAST(total_deaths AS INT)) AS Total_Deaths
    FROM
        PortfolioProject..Covid_Deaths
    WHERE 
        continent IS NOT NULL
    GROUP BY
        location
    ORDER BY
        Total_Deaths DESC;
    ```

### Vaccination Data Analysis

8. Calculate the total vaccinations per location:
    ```sql
    SELECT
        dea.location, dea.population, MAX(vac.people_fully_vaccinated) AS Total_Vaccinated
    FROM
        PortfolioProject..Covid_Vaccinated vac
    JOIN 
        PortfolioProject..Covid_Deaths dea ON vac.location = dea.location AND vac.date = dea.date
    WHERE 
        dea.continent IS NOT NULL AND vac.continent IS NOT NULL
    GROUP BY 
        dea.location, dea.population
    ORDER BY 
        1, 2 DESC;
    ```

### Creating Views

9. Create a view for the population vaccinated:
    ```sql
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
        ON dea.location = vac.location AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL;
    ```

## Conclusion

This project aims to provide insights into the COVID-19 pandemic by analyzing and visualizing the data related to deaths and vaccinations. The queries above can be further extended to generate visual representations and deeper analyses as needed.
