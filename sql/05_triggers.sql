-- 1. Fonction d'immutabilité : Empêche la modification ou la suppression dans transactions (Grand Livre)
CREATE OR REPLACE FUNCTION core.prevent_tx_tampering()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        RAISE EXCEPTION 'Interdit : La table des transactions (grand livre) est immuable en modification.';
    ELSIF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Interdit : Suppression impossible dans le grand livre des transactions.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_immutable_transactions
BEFORE UPDATE OR DELETE ON core.transactions
FOR EACH ROW EXECUTE FUNCTION core.prevent_tx_tampering();

-- 2. Fonction de gestion de l'audit automatique des modifications sensibles
CREATE OR REPLACE FUNCTION audit.log_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit.audit_log (table_name, operation, old_data, new_data, db_user, changed_at)
    VALUES (
        TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME,
        TG_OP,
        row_to_json(OLD),
        row_to_json(NEW),
        current_user,
        NOW()
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_customers
AFTER INSERT OR UPDATE OR DELETE ON core.customers
FOR EACH ROW EXECUTE FUNCTION audit.log_changes();
