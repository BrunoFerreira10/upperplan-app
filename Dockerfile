# Utilizar a imagem base gerada pelo primeiro Dockerfile - Recebida com argumento
ARG BASE_REPOSITORY_URI
FROM $BASE_REPOSITORY_URI

# Criar e definir o diretório de trabalho
RUN mkdir -p /var/www/glpi
WORKDIR /var/www/glpi

# Limpar configurações padrão do Apache
RUN rm /etc/apache2/sites-available/* /etc/apache2/sites-enabled/*

# Copiar a pasta server/etc do diretório local para /etc no container
COPY app_installation/server/etc/ /etc/

# Habilitar o site do GLPI
RUN ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled/glpi.conf

# Configurar PHP-FPM no Apache
RUN a2enmod proxy_fcgi setenvif && a2enconf php7.4-fpm

# Baixar e preparar a última versão do GLPI
RUN wget -nv https://github.com/glpi-project/glpi/releases/download/10.0.16/glpi-10.0.16.tgz \
    && tar -xzf glpi-10.0.16.tgz --strip-components=1 && rm glpi-10.0.16.tgz

# Configurar permissões da aplicação
RUN chown -R www-data:www-data /var/www/glpi

# Criar pastas compartilhadas (preparar para o EFS)
RUN mkdir -p /mnt/efs_glpi

# Copiar o arquivo de configuração do banco de dados
COPY app_installation/local_define.php /tmp
COPY app_installation/config_db.php /tmp

# Arquivos adicionais
COPY app_installation/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Recebe dados do banco de dados
ARG DB_HOST
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD

# Configurar o banco de dados no GLPI
RUN sed -i "s/YOUR_DB_HOST/$DB_HOST/g" /tmp/config_db.php && \
    sed -i "s/YOUR_DB_USER/$DB_USER/g" /tmp/config_db.php && \
    sed -i "s/YOUR_DB_PASSWORD/$DB_PASSWORD/g" /tmp/config_db.php && \
    sed -i "s/YOUR_DB_NAME/$DB_NAME/g" /tmp/config_db.php

# Expor a porta 80 (o ELB vai redirecionar para HTTPS)
EXPOSE 80

# Definir o entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
