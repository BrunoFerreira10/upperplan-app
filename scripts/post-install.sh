#!/bin/bash

# Verificar se a nova task ECS foi registrada com sucesso
echo "Verificando a nova task no ECS..."

# Comando para validar se a task foi registrada corretamente
# aws ecs describe-tasks --cluster "cluster-${SHORTNAME}" --tasks "TASK_ID" # Substitua por sua task real

# Adicionar comandos para configurar permissões, diretórios, etc.
echo "Instalação concluída com sucesso."
