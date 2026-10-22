# NovaBank - Core Database Architecture

Projet de mise en place, sécurisation et optimisation d'une base de données relationnelle bancaire haute performance sous PostgreSQL (Machine Virtuelle Debian).

---

## 🚀 1. Présentation du projet
NovaBank est un prototype de système bancaire en ligne. Ce projet répond à 3 problématiques majeures de sécurité et de performance :
- **Sécurité et moindre privilège :** Isolation stricte des accès via des rôles dédiés (Analyste, Support, Application, Auditeur).
- **Intégrité financière absolue :** Garantie d'un solde toujours positif ($\ge 0$), immutabilité du grand livre comptable et atomicité des virements (double écriture en une seule transaction).
- **Performance à grande échelle :** Temps d'exécution immédiat (< 500 ms) sur un volume de plus de **1 000 000 de transactions**.

---

## 🛠️ 2. Environnement technique
- **Infrastructure :** Machine Virtuelle Debian (VirtualBox) sans Docker.
- **IDE :** VS Code via l'extension Remote-SSH.
- **SGBD :** PostgreSQL (PL/pgSQL, requêtes analytiques, indexation, triggers, procédures stockées).
- **Outils :** Bash, UFW, Git.

---

## 📂 3. Structure du dépôt
```text
novabank-core/
├── README.md                  # Documentation du projet
├── scripts/
│   └── install_server.sh      # Étape 1 : Installation et configuration pare-feu/PostgreSQL
├── sql/
│   ├── schema.sql             # Étape 2 : Création des tables, contraintes (CHECK, UNIQUE)
│   ├── 02_roles.sql           # Étape 3 : Gestion des rôles et des droits (GRANT/REVOKE)
│   ├── 03_views.sql           # Étape 4 : Vues (masquée, modifiable, matérialisée)
│   ├── 04_indexes.sql         # Étape 5 : Index et requêtes d'optimisation (EXPLAIN ANALYZE)
│   ├── 05_triggers.sql        # Étape 6 : Triggers (immutabilité, audit automatique)
│   ├── 06_procedures.sql      # Étape 7 : Procédure stockée de virement sécurisé
│   ├── populate.sql           # Jeu de données initial
│   └── generate_million.sql   # Génération de masse (1 000 000 de transactions)
└── screenshots/               # Preuves visuelles du projet
    ├── 01_vm_ssh.png
    ├── 02_1m_rows.png
    └── 03_explain_analyze.png