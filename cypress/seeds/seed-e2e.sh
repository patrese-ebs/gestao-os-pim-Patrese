#!/bin/bash
set -e

echo "Aguardando banco de dados..."
until docker compose -f docker-compose.e2e.yml exec -T postgres pg_isready -U postgres -d servicopim_e2e; do
  sleep 2
done

echo "Aguardando API..."
until curl -sf http://localhost:9090/health > /dev/null 2>&1; do
  sleep 3
done

echo "Criando usuário admin de teste..."
docker compose -f docker-compose.e2e.yml exec -T postgres psql -U postgres -d servicopim_e2e -c "
INSERT INTO usuario (id, nome, email, matricula, senha_hash, perfil, setor, ativo, created_at)
VALUES (
  gen_random_uuid(),
  'Admin E2E',
  'admin@pim.com',
  'ADM001',
  '\$2b\$08\$YZ2o/wwmJveMVH0jDFE2T.FmG4PS50oE3ubIFtsxjHaNVv3dXSbly',
  'SUPERVISOR',
  'TI',
  true,
  NOW()
) ON CONFLICT (email) DO NOTHING;
"

echo "Seed concluído!"
