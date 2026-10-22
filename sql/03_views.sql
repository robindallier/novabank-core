-- 1. Vue masquée (cache les données personnelles sensibles)
CREATE OR REPLACE VIEW core.v_customers_public AS
SELECT 
    customer_id,
    LEFT(first_name, 1) || '***' AS masked_first_name,
    LEFT(last_name, 1) || '***' AS masked_last_name,
    kyc_status,
    risk_level,
    created_at
FROM core.customers;

-- 2. Vue modifiable (avec option CHECK OPTION) des comptes actifs
CREATE OR REPLACE VIEW core.v_active_accounts AS
SELECT account_id, customer_id, iban, account_type, balance, status
FROM core.accounts
WHERE status = 'active'
WITH CHECK OPTION;

-- 3. Vue matérialisée pour les statistiques de transactions (performances)
CREATE MATERIALIZED VIEW core.mv_account_stats AS
SELECT 
    account_id,
    COUNT(*) as total_tx_count,
    SUM(amount) as total_amount_moved,
    MAX(created_at) as last_transaction_date
FROM core.transactions
GROUP BY account_id;
