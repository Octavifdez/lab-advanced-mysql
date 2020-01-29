USE publications;

SELECT * FROM sales;
# Challenge 1:
# Step 1:

SELECT 
titleauthor.title_id, 
titleauthor.au_id, 
(titles.advance * titleauthor.royaltyper / 100) AS advance,
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
FROM titleauthor
LEFT JOIN titles ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON titleauthor.title_id = sales.title_id
order by title_id, au_id
;

# Step 2:

SELECT
title_id, 
au_id,
SUM(sales_royalty) as sum_royalty
FROM
(
	SELECT 
	titleauthor.title_id AS title_id, 
	titleauthor.au_id AS au_id,
	(titles.advance * titleauthor.royaltyper / 100) AS advance,
	(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
	FROM titleauthor
	LEFT JOIN titles ON titleauthor.title_id = titles.title_id
	LEFT JOIN sales ON titleauthor.title_id = sales.title_id
) AS query1
GROUP BY title_id, au_id
ORDER BY sum_royalty DESC
; 
   
# Step 3:

SELECT
au_id,
(sum_advance + sum_royalty) AS profit
FROM
	(SELECT
	title_id, 
	au_id,
	SUM(advance) AS sum_advance,
	SUM(sales_royalty) AS sum_royalty
	FROM
	(
		SELECT 
		titleauthor.title_id AS title_id, 
		titleauthor.au_id AS au_id,
		(titles.advance * titleauthor.royaltyper / 100) AS advance,
		(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
		FROM titleauthor
		LEFT JOIN titles ON titleauthor.title_id = titles.title_id
		LEFT JOIN sales ON titleauthor.title_id = sales.title_id
	) AS query1
	GROUP BY title_id, au_id
	ORDER BY sum_royalty DESC
) AS query2
GROUP BY au_id, profit
ORDER BY profit DESC
;

# Challenge 2:
CREATE TEMPORARY TABLE table1
(
SELECT 
titleauthor.title_id, 
titleauthor.au_id, 
(titles.advance * titleauthor.royaltyper / 100) AS advance,
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
FROM titleauthor
LEFT JOIN titles ON titleauthor.title_id = titles.title_id
LEFT JOIN sales ON titleauthor.title_id = sales.title_id
order by title_id, au_id
)
;

SELECT
title_id, 
au_id,
SUM(sales_royalty) as sum_royalty
FROM
table1
GROUP BY title_id, au_id
ORDER BY sum_royalty DESC
; 

# Challenge 3:
CREATE TABLE table2
(
SELECT
au_id,
(sum_advance + sum_royalty) AS profit
FROM
	(
    SELECT
	title_id, 
	au_id,
	SUM(advance) AS sum_advance,
	SUM(sales_royalty) AS sum_royalty
	FROM
	(
		SELECT 
		titleauthor.title_id AS title_id, 
		titleauthor.au_id AS au_id,
		(titles.advance * titleauthor.royaltyper / 100) AS advance,
		(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS sales_royalty
		FROM titleauthor
		LEFT JOIN titles ON titleauthor.title_id = titles.title_id
		LEFT JOIN sales ON titleauthor.title_id = sales.title_id
	) AS query1
	GROUP BY title_id, au_id
	ORDER BY sum_royalty DESC
) AS query2
GROUP BY au_id, profit
ORDER BY profit DESC
)
;