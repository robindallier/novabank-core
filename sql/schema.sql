CREATE DATABASE bankdb;
\c bankdb;

CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(client_id) ON DELETE CASCADE,
    account_type VARCHAR(20) CHECK (account_type IN ('checking', 'savings', 'business')),
    balance NUMERIC(12, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transactions (
    transaction_id BIGSERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id) ON DELETE CASCADE,
    amount NUMERIC(12, 2) NOT NULL,
    transaction_type VARCHAR(10) CHECK (transaction_type IN ('credit', 'debit')),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
