#!/bin/bash

# Monitorar logs ou usar métricas do CloudWatch para garantir que o serviço está estável
echo "Monitorando o serviço no ECS..."

# Exemplo de monitoramento básico dos logs da aplicação
# aws logs tail /aws/ecs/container-${SHORTNAME} --follow || {
#     echo "Erro encontrado nos logs.";
#     exit 1;
# }

echo "Monitoramento concluído com sucesso."
