\c bankdb;

-- 1. Afficher la taille actuelle de la table avec ses données
SELECT pg_size_pretty(pg_total_relation_size('transactions')) AS taille_totale_transactions;

-- 2. Création des index pour accélérer les recherches et les jointures
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);

-- 3. Analyser les performances d'une requête globale après indexation
EXPLAIN ANALYZE 
SELECT account_id, transaction_type, COUNT(*), SUM(amount) 
FROM transactions 
GROUP BY account_id, transaction_type;
