-- Date Range by Company
SELECT company, ticker, date, close 
FROM Stock_Quotes
INNER JOIN Company
ON Stock_Quotes.company_id = company.id
WHERE company_id = 1 
AND date >= date('2019-01-01' ) AND date <= date('2019-12-31')
ORDER BY date DESC


-- Aggregates
SELECT 
	company, 
	ticker, 
	COUNT(close) AS 'close_count',
	AVG(close) AS 'close_avg',
	MIN(close) AS 'close_min',
	MAX(close) AS 'close_max'
FROM Stock_Quotes
INNER JOIN Company
ON Stock_Quotes.company_id = company.id
WHERE company_id = 1
AND date(date) >= date('2019-01-01' ) AND date(date) <= date('2019-12-31');





-- UNION
SELECT 
	company, 
	ticker,
	'Open',
	COUNT(open) AS 'Count',
	AVG(open) AS 'Avg',
	MIN(open) AS 'Min',
	MAX(open) AS 'Max'
FROM Stock_Quotes
INNER JOIN Company
ON Stock_Quotes.company_id = company.id
WHERE company_id = 1
--AND date(date) >= date('2019-01-01' ) AND date(date) <= date('2019-12-31')
UNION ALL
SELECT 
	company, 
	ticker,
	'High',
	COUNT(high) AS 'close_count',
	AVG(high) AS 'close_avg',
	MIN(high) AS 'close_min',
	MAX(high) AS 'close_max'
FROM Stock_Quotes
INNER JOIN Company
ON Stock_Quotes.company_id = company.id
WHERE company_id = 1
--AND date(date) >= date('2019-01-01' ) AND date(date) <= date('2019-12-31')
UNION ALL
SELECT 
	company, 
	ticker,
	'Low',
	COUNT(low) AS 'close_count',
	AVG(low) AS 'close_avg',
	MIN(low) AS 'close_min',
	MAX(low) AS 'close_max'
FROM Stock_Quotes
INNER JOIN Company
ON Stock_Quotes.company_id = company.id
WHERE company_id = 1
--AND date(date) >= date('2019-01-01' ) AND date(date) <= date('2019-12-31')
UNION ALL
SELECT 
	company, 
	ticker,
	'Close',
	COUNT(close) AS 'close_count',
	AVG(close) AS 'close_avg',
	MIN(close) AS 'close_min',
	MAX(close) AS 'close_max'
FROM Stock_Quotes
INNER JOIN Company
ON Stock_Quotes.company_id = company.id
WHERE company_id = 1
--AND date(date) >= date('2019-01-01' ) AND date(date) <= date('2019-12-31')




-- Find Duplicates
SELECT 
	company, 
	ticker, 
	date,
	open,
	high,
	low,
	close,
	adj_close,
	COUNT(date) AS date_ct
FROM Stock_Quotes
INNER JOIN Company
ON company.id = Stock_Quotes.company_id
WHERE company_id = 1
GROUP BY date
HAVING date_ct > 1
ORDER BY date_ct DESC

SELECT * from Stock_Quotes WHERE date = '2021-12-10'

-- SELECT date(date) from Stock_Quotes limit 10




-- NTile
SELECT
close,
NTILE(10) OVER (
	ORDER BY close
)  LengthOfBucket
FROM Stock_Quotes
WHERE company_id = 1;
----
----
SELECT
close,
NTILE(4) OVER (
	PARTITION BY company_id
	ORDER BY close
)  LengthOfBucket
FROM Stock_Quotes
WHERE company_id = 1;



-- % Percentage
-- https://stackoverflow.com/questions/1123576/how-to-find-nth-percentile-with-sqlite
SELECT close AS '25% of close price' 
FROM Stock_Quotes 
WHERE company_id = 1
ORDER BY close ASC
LIMIT 1
OFFSET (
	SELECT COUNT(close) FROM Stock_Quotes  WHERE company_id = 1
) * 2.5 / 10 - 1
----
----
-- percent_rank
-- https://www.sqlitetutorial.net/sqlite-window-functions/sqlite-percent_rank
SELECT date, close,
	PERCENT_RANK() OVER (
		ORDER BY close
	) LengthPercentRank
FROM Stock_Quotes
WHERE company_id = 1
AND date >= date('2020-01-01') AND date(date) < date('2020-02-01') 
ORDER BY LengthPercentRank
