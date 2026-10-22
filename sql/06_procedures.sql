CREATE OR REPLACE PROCEDURE core.sp_execute_transfer(
    p_from_account INT,
    p_to_account INT,
    p_amount NUMERIC,
    p_label VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_balance NUMERIC;
    v_transfer_id INT;
BEGIN
    -- 1. Vérifier que le montant est positif
    IF p_amount <= 0 THEN
        RAISE EXCEPTION 'Le montant du virement doit être strictement positif.';
    END IF;

    -- 2. Vérifier que les comptes sont différents
    IF p_from_account = p_to_account THEN
        RAISE EXCEPTION 'Impossible de faire un virement vers le même compte.';
    END IF;

    -- 3. Vérifier le solde du compte émetteur (avec verrouillage FOR UPDATE)
    SELECT balance INTO v_current_balance
    FROM core.accounts
    WHERE account_id = p_from_account
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Compte émetteur introuvable.';
    END IF;

    IF v_current_balance < p_amount THEN
        RAISE EXCEPTION 'Solde insuffisant : virement annulé (Solde actuel: %, Montant: %).', v_current_balance, p_amount;
    END IF;

    -- 4. Insérer le virement dans la table transfers
    INSERT INTO core.transfers (from_account_id, to_account_id, amount, label)
    VALUES (p_from_account, p_to_account, p_amount, p_label)
    RETURNING transfer_id INTO v_transfer_id;

    -- 5. Mettre à jour les soldes des comptes
    UPDATE core.accounts 
    SET balance = balance - p_amount 
    WHERE account_id = p_from_account;

    UPDATE core.accounts 
    SET balance = balance + p_amount 
    WHERE account_id = p_to_account;

    -- 6. Créer les 2 écritures comptables associées (Grand Livre)
    INSERT INTO core.transactions (account_id, tx_type, amount, balance_after, transfer_id)
    VALUES 
    (p_from_account, 'debit', p_amount, (SELECT balance FROM core.accounts WHERE account_id = p_from_account), v_transfer_id),
    (p_to_account, 'credit', p_amount, (SELECT balance FROM core.accounts WHERE account_id = p_to_account), v_transfer_id);

    COMMIT;
    RAISE NOTICE 'Virement % exécuté avec succès.', v_transfer_id;
    
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
$$;
