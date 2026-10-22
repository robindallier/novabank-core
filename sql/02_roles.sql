-- 1. Création des rôles / utilisateurs avec mot de passe
CREATE ROLE novabank_analyst WITH LOGIN PASSWORD 'SecureAnalyst2026!';
CREATE ROLE novabank_support WITH LOGIN PASSWORD 'SecureSupport2026!';
CREATE ROLE novabank_app WITH LOGIN PASSWORD 'SecureApp2026!';
CREATE ROLE novabank_auditor WITH LOGIN PASSWORD 'SecureAuditor2026!';

-- 2. Révocation des droits par défaut sur le schéma public
REVOKE ALL ON DATABASE bankdb FROM PUBLIC;
REVOKE ALL ON SCHEMA core, audit FROM PUBLIC;

-- 3. Droits pour l'APPLICATION (lecture/écriture sur les tables opérationnelles)
GRANT USAGE ON SCHEMA core TO novabank_app;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA core TO novabank_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA core TO novabank_app;

-- 4. Droits pour l'ANALYSTE (lecture seule sur les tables autorisées, sans données sensibles)
GRANT USAGE ON SCHEMA core TO novabank_analyst;
GRANT SELECT ON core.accounts, core.transactions TO novabank_analyst;

-- 5. Droits pour le SUPPORT (lecture/modification limitée des clients et comptes)
GRANT USAGE ON SCHEMA core TO novabank_support;
GRANT SELECT, UPDATE ON core.customers, core.accounts TO novabank_support;

-- 6. Droits pour l'AUDITEUR (lecture seule stricte sur l'audit et les alertes de fraude)
GRANT USAGE ON SCHEMA audit, core TO novabank_auditor;
GRANT SELECT ON ALL TABLES IN SCHEMA audit TO novabank_auditor;
GRANT SELECT ON core.fraud_alerts TO novabank_auditor;
