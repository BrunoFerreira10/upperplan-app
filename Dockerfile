# Estender a imagem base gerada pelo primeiro Dockerfile
FROM 339712924273.dkr.ecr.us-east-1.amazonaws.com/upperplan-glpi/container:latest

# Definir o diretório de trabalho
WORKDIR /var/www/html

# Baixar e preparar a última versão do GLPI
RUN wget https://github.com/glpi-project/glpi/releases/download/10.0.16/glpi-10.0.16.tgz \
    && tar -xzf glpi-10.0.16.tgz --strip-components=1 \
    && rm glpi-10.0.16.tgz

# Certificar que as pastas 'files' e 'config' são graváveis para o GLPI
RUN chown -R www-data:www-data /var/www/html/files /var/www/html/config

# Expor a porta 80 (o ELB vai redirecionar para HTTPS)
EXPOSE 80

# Comando de inicialização do Apache
CMD ["apachectl", "-D", "FOREGROUND"]
