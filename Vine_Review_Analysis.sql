SELECT
    * INTO filtered_by_votes_table
FROM
    vine_table
WHERE
    total_votes >= 20;

SELECT
    * INTO helpful_votes_table
FROM
    filtered_by_votes_table
WHERE
    CAST(helpful_votes AS FLOAT) / CAST(total_votes AS FLOAT) >= 0.5;

SELECT
    * INTO vine_reviews_table
FROM
    helpful_votes_table
WHERE
    vine = 'Y';

SELECT
    * INTO non_vine_reviews_table
FROM
    helpful_votes_table
WHERE
    vine = 'N';

SELECT
    count(*) INTO total_number_vine_reviews
FROM
    vine_reviews_table;

SELECT
    count(*) INTO total_number_non_vine_reviews
FROM
    non_vine_reviews_table;

SELECT
    COUNT(vine) AS "Count",
    (
        SELECT
            COUNT(star_rating)
        FROM
            vine_reviews_table
        WHERE
            star_rating = 5
    ) AS "five_star_count",
    (
        (
            SELECT
                COUNT(star_rating)
            FROM
                vine_reviews_table
            WHERE
                star_rating = 5
        ) / CAST(
            (
                SELECT
                    COUNT(vine)
                FROM
                    vine_reviews_table
            ) AS FLOAT
        )
    ) AS "five_star_percentage" INTO paid_vine_stats_table
FROM
    vine_reviews_table;

SELECT
    COUNT(vine) AS "Count",
    (
        SELECT
            COUNT(star_rating)
        FROM
            non_vine_reviews_table
        WHERE
            star_rating = 5
    ) AS "five_star_count",
    (
        (
            SELECT
                COUNT(star_rating)
            FROM
                non_vine_reviews_table
            WHERE
                star_rating = 5
        ) / CAST(
            (
                SELECT
                    COUNT(vine)
                FROM
                    non_vine_reviews_table
            ) AS FLOAT
        )
    ) AS "five_star_percentage" INTO unpaid_vine_stats_table
FROM
    non_vine_reviews_table;

SELECT
    COUNT(*) AS verified_purchase,
    (
        SELECT
            COUNT(*)
        FROM
            helpful_votes_table
        WHERE
            vine = 'Y'
    ) AS total_purchases
FROM
    helpful_votes_table
WHERE
    verified_purchase = 'Y'
    AND vine = 'Y';

SELECT
    COUNT(*) AS verified_purchase,
    (
        SELECT
            COUNT(*)
        FROM
            helpful_votes_table
        WHERE
            vine = 'N'
    ) AS total_purchases
FROM
    helpful_votes_table
WHERE
    verified_purchase = 'Y'
    AND vine = 'N';