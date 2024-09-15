#!/bin/bash

# Comando para iniciar o serviço ECS ou qualquer outra ação de ativação
echo "Iniciando o serviço ECS..."

# Exemplo de comando para rodar uma nova task
aws ecs update-service --cluster "cluster-${SHORTNAME}" --service "service-${SHORTNAME}" --desired-count 1

echo "Serviço iniciado com sucesso."
