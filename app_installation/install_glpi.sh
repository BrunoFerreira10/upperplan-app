#!/bin/bash

# Chaves do SSM
SSM_HOST="/upperplan-glpi/prod/app_vars/rds_1_db_host"
SSM_NAME="/upperplan-glpi/prod/github_vars/rds_1_db_name"
SSM_USER="/upperplan-glpi/prod/github_vars/rds_1_db_username"
SSM_PASSWORD="/upperplan-glpi/prod/github_secrets/rds_1_db_password"

# Trecho comum para as chamadas do AWS SSM
COMMON_SSM_ARGS="--region us-east-1 --query 'Parameter.Value' --output text"

# Dados do banco de dados
DB_HOST=$(aws ssm get-parameter --name $SSM_HOST $COMMON_SSM_ARGS)
DB_NAME=$(aws ssm get-parameter --name $SSM_NAME $COMMON_SSM_ARGS)
DB_USER=$(aws ssm get-parameter --name $SSM_USER $COMMON_SSM_ARGS)
DB_PASSWORD=$(aws ssm get-parameter --name $SSM_PASSWORD --with-decryption $COMMON_SSM_ARGS)

# Instalação do GLPI
php bin/console db:install --no-interaction \
    --db-host=$DB_HOST --db-name=$DB_NAME --db-user=$DB_USER --db-password=$DB_PASSWORD -r