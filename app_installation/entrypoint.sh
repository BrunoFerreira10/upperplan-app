#!/bin/bash

## - move para aplicação -----------------------------------------------------------------------------------------------
cd /var/www/glpi

## ---------------------------------------------------------------------------------------------------------------------
## Configuração das pasta compartilhadas
## ---------------------------------------------------------------------------------------------------------------------
# Verificar se está vazio e mover os arquivos se necessário
if [ ! -d /mnt/efs_glpi/config ]; then
  echo "Configurando pasta config"
  mv /var/www/glpi/config /mnt/efs_glpi/
  # chown -R www-data:www-data /etc/glpi
  # chmod -R 775 /etc/glpi
fi

if [ ! -d /mnt/efs_glpi/files ]; then
  echo "Configurando palsta files"
  mv /var/www/glpi/files /mnt/efs_glpi/
  chown -R www-data:www-data /mnt/efs_glpi/files
  chmod -R 775 /mnt/efs_glpi/files
fi

if [ ! -d /mnt/efs_glpi/logs ]; then
  echo "Configurando pasta logs"
  mkdir -p /mnt/efs_glpi/logs
  chown -R www-data:www-data /mnt/efs_glpi/logs
  chmod -R 775 /mnt/efs_glpi/logs
fi

# Copiar local_define.php de qualquer forma
cp -f /tmp/local_define.php /mnt/efs_glpi/config/local_define.php

## ---------------------------------------------------------------------------------------------------------------------
## Configuração do banco de dados
## ---------------------------------------------------------------------------------------------------------------------
echo "Configurando o banco de dados"

# Copiar config_db.php de qualquer forma
cp -f /tmp/config_db.php /mnt/efs_glpi/config/config_db.php

# Configurar banco de dados dinamicamente
# sed -i "s/YOUR_DB_HOST/$DB_HOST/g" /etc/glpi/config_db.php
# sed -i "s/YOUR_DB_USER/$DB_USER/g" /etc/glpi/config_db.php
# sed -i "s/YOUR_DB_PASSWORD/$DB_PASSWORD/g" /etc/glpi/config_db.php
# sed -i "s/YOUR_DB_NAME/$DB_NAME/g" /etc/glpi/config_db.php

# Remover pastas 'config' e 'files' do diretorio publico de qualquer forma
rm -rf config
rm -rf files

# Remover arquivos temporarios de qualquer forma
rm /tmp/local_define.php
rm /tmp/config_db.php

## ---------------------------------------------------------------------------------------------------------------------
## Configurações adicionais do GLPI
## ---------------------------------------------------------------------------------------------------------------------
rm -f /var/www/glpi/install/install.php

## ---------------------------------------------------------------------------------------------------------------------
## Inicialização do Apache
## ---------------------------------------------------------------------------------------------------------------------
exec apachectl -D FOREGROUND

## ---------------------------------------------------------------------------------------------------------------------