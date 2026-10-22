\c bankdb;

-- Insertion de clients de test
INSERT INTO clients (firstname, lastname, email) VALUES
('Alice', 'Dupont', 'alice.dupont@novabank.fr'),
('Bob', 'Martin', 'bob.martin@novabank.fr'),
('Claire', 'Bernard', 'claire.bernard@novabank.fr');

-- Insertion de comptes associés
INSERT INTO accounts (client_id, account_type, balance) VALUES
(1, 'checking', 1500.00),
(1, 'savings', 5000.00),
(2, 'checking', 250.50),
(3, 'business', 12300.00);

-- Insertion de transactions initiales
INSERT INTO transactions (account_id, amount, transaction_type) VALUES
(1, 200.00, 'credit'),
(1, 50.00, 'debit'),
(2, 1000.00, 'credit'),
(3, 450.00, 'debit');
