
/*
NULL                       -> missing
IS NULL, IS NOT NULL       -> dont use "= NULL"
count(*)                   -> number of rows
count(columnName)          -> number of rows non-null
count(DISTINCT columnName) -> number of diferent non-null values
SELECT DISTINCT columnName -> distinct values including null
*/

-- Subtract the count of the non-NULL ticker values from the total number of rows; alias the difference as missing.
SELECT count(*) - count(ticker) AS missing
  FROM fortune500
;

-- Using the tag_type table, count the number of tags with each type. Order the results.
SELECT type, count(*) AS count
  FROM tag_type
  GROUP BY type
  ORDER BY count DESC
;

-- Select company.name, tag_type.tag, and tag_type.type.
SELECT company.name, tag_type.tag, tag_type.type
  FROM company
  	   -- Join to the tag_company table
       INNER JOIN tag_company 
       ON company.id = tag_company.company_id
       -- Join to the tag_type table
       INNER JOIN tag_type
       ON tag_company.tag = tag_type.tag
  -- Filter to most common type
  WHERE type='cloud';

/* The coalesce() function can be useful for specifying a default or backup value when a column contains NULL values. */
SELECT company_original.name, title, rank
  -- Start with original company information
  FROM company AS company_original
       -- Join to another copy of company with parent
       -- company information
	   LEFT JOIN company AS company_parent
       ON company_original.parent_id = company_parent.id 
       -- Join to fortune500, only keep rows that match
       INNER JOIN fortune500 
       -- Use parent ticker if there is one, 
       -- otherwise original ticker
       ON coalesce(company_parent.ticker, 
                   company_original.ticker) = 
             fortune500.ticker
 -- For clarity, order by rank
 ORDER BY rank; 

/* CASTING CAST() or :: change type of data
example : select CAST(x AS new_type) from table
example2 : select x::new_type from table */ 

-- Was 2017 a good or bad year for revenue of Fortune 500 companies? Examine how revenue changed from 2016 to 2017 by first looking at the distribution of revenues_change and then counting companies whose revenue increased.
SELECT revenues_change, count(revenues_change)
  FROM fortune500
  GROUP BY revenues_change
  ORDER BY revenues_change;

SELECT revenues_change::integer, count(*)
  FROM fortune500
  GROUP BY revenues_change::integer
  ORDER BY count(*) desc;

SELECT count(*)
  FROM fortune500
  WHERE revenues_change > 0;

  
