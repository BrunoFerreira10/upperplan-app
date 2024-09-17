#!/bin/bash

## - move para aplicação -----------------------------------------------------------------------------------------------
cd /var/www/glpi

## ---------------------------------------------------------------------------------------------------------------------
## Configuração das pasta compartilhadas
## ---------------------------------------------------------------------------------------------------------------------
# Verificar se está vazio e mover os arquivos se necessário
if [ ! -d /etc/glpi ]; then
  echo "Configurando /etc/glpi"
  mv /var/www/glpi/config /etc/glpi
  chown -R www-data:www-data /etc/glpi
  chmod -R 775 /etc/glpi
fi

if [ ! -d /var/lib/glpi ]; then
  echo "Configurando /var/lib/glpi"
  mv /var/www/glpi/files /var/lib/glpi
  chown -R www-data:www-data /var/lib/glpi
  chmod -R 775 /var/lib/glpi
fi

if [ ! -d /var/log/glpi ]; then
  echo "Configurando /var/log/glpi"
  mkdir -p /var/log/glpi
  chown -R www-data:www-data /var/log/glpi
  chmod -R 775 /var/log/glpi
fi

# Copiar local_define.php de qualquer forma
cp /tmp/local_define.php /etc/glpi/

## ---------------------------------------------------------------------------------------------------------------------
## Configuração do banco de dados
## ---------------------------------------------------------------------------------------------------------------------
echo "Configurando o banco de dados"

# Copiar config_db.php de qualquer forma
cp /tmp/config_db.php /etc/glpi/config_db.php

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
## Configurações adicionais do GPLI
## ---------------------------------------------------------------------------------------------------------------------
rm -f /var/www/glpi/install/install.php

## ---------------------------------------------------------------------------------------------------------------------
## Inicialização do Apache
## ---------------------------------------------------------------------------------------------------------------------
exec apachectl -D FOREGROUND

## ---------------------------------------------------------------------------------------------------------------------