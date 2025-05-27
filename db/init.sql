-- Cria roles
CREATE ROLE admin_role WITH LOGIN PASSWORD 'admin123' SUPERUSER CREATEDB CREATEROLE NOINHERIT;
CREATE ROLE player_role WITH LOGIN PASSWORD 'player123' NOINHERIT;

-- Cria schemas
CREATE SCHEMA IF NOT EXISTS game AUTHORIZATION admin_role;
CREATE SCHEMA IF NOT EXISTS player AUTHORIZATION admin_role;

-- Ajusta permissões
GRANT ALL ON SCHEMA game TO admin_role;
GRANT ALL ON SCHEMA player TO admin_role;

GRANT USAGE ON SCHEMA player TO player_role;
-- As tabelas do schema player ainda não existem, então para garantir permissões futuras:
ALTER DEFAULT PRIVILEGES IN SCHEMA player GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO player_role;
