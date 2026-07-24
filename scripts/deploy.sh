#!/usr/bin/env bash
set -euo pipefail

# PQ-Crosschain Deployment Script
# Doel: Automatisch deployen van Anchor program, relayer, en monitoring stack

echo "🚀 Starten PQ-Crosschain deployment..."

# 1. Compile & Test
make build
make test

# 2. Deploy Anchor Program (devnet)
echo "📦 Deploying Anchor program to devnet..."
cd anchor && anchor deploy --provider.cluster devnet
cd ..

# 3. Start Infrastructure
echo "🐳 Starten relayer & monitoring stack..."
docker-compose up -d relayer prometheus

# 4. Verificatie
echo "✅ Deployment voltooid. Monitor via: http://localhost:9091"
echo "📊 Grafana dashboard: http://localhost:3000 (admin/admin)"

# 5. Hardening checklist
if [ -f ".env" ]; then
    echo "🔒 .env gevonden. Verifieer RPC_URLS, WS_URL, PROGRAM_ID."
else
    echo "⚠️  Geen .env bestand. Kopieer .env.example en vul credentials in."
fi