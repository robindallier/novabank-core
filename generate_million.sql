\c bankdb;

-- Insertion massive de transactions (1 million de lignes)
-- On répartit aléatoirement les montants et les types sur les comptes existants (IDs 1 à 4)
INSERT INTO transactions (account_id, amount, transaction_type, transaction_date)
SELECT 
    floor(random() * 4 + 1)::INT AS account_id,
    round((random() * 500 + 5)::numeric, 2) AS amount,
    CASE WHEN random() < 0.5 THEN 'credit' ELSE 'debit' END AS transaction_type,
    NOW() - (random() * interval '365 days') AS transaction_date
FROM generate_series(1, 1000000);

-- Afficher un petit message de confirmation et le nombre total de lignes
SELECT COUNT(*) AS total_transactions FROM transactions;
