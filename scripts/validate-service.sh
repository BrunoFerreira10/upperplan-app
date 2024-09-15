#!/bin/bash

# Verificar se o serviço responde na porta correta
echo "Validando o serviço no ECS..."

# Verificar se a aplicação está acessível
curl -f http://localhost:80 || { 
    echo "Validação falhou! O serviço não está respondendo corretamente."; 
    exit 1; 
}

echo "Validação concluída com sucesso."
