# Utilizar a imagem base gerada pelo primeiro Dockerfile
FROM 339712924273.dkr.ecr.us-east-1.amazonaws.com/upperplan-glpi/container:latest

# Criar e definir o diretório de trabalho
RUN mkdir -p /var/www/glpi
WORKDIR /var/www/glpi

## ---------------------------------------------------------------------------------------------------------------------
## Configuração do Apache
## ---------------------------------------------------------------------------------------------------------------------

# Limpar configurações padrão do Apache
RUN rm /etc/apache2/sites-available/*
RUN rm /etc/apache2/sites-enabled/*

# Copiar a pasta server/etc do diretório local para /etc no container
COPY app_installation/server/etc/ /etc/

# Habilitar o site do GLPI
RUN ln -s /etc/apache2/sites-available/glpi.conf /etc/apache2/sites-enabled/glpi.conf

## ---------------------------------------------------------------------------------------------------------------------
## Instalação do GLPI
## ---------------------------------------------------------------------------------------------------------------------

# Baixar e preparar a última versão do GLPI
RUN wget https://github.com/glpi-project/glpi/releases/download/10.0.16/glpi-10.0.16.tgz
RUN tar -xzf glpi-10.0.16.tgz --strip-components=1
RUN rm glpi-10.0.16.tgz

# Configurar permissões da aplicação
RUN chown -R www-data:www-data /var/www/glpi

# Argumentos de entrada do Docker file.
# Recebe dados do banco de dados
ARG DB_HOST
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD

# Instalação do GLPI
# RUN php bin/console db:install --no-interaction \
#   --db-host=$DB_HOST --db-name=$DB_NAME --db-user=$DB_USER --db-password=$DB_PASSWORD -r || true

# Verificar a instalação
# RUN php bin/console system:check_requirements

## ---------------------------------------------------------------------------------------------------------------------
## Configuração das pasta compartilhadas
## ---------------------------------------------------------------------------------------------------------------------

# Arquivo downstream.php para mudar a pasta config de lugar.
COPY app_installation/downstream.php inc/

# Move pastas 'compartilhadas' do GLPI para diretorios montados no EFS
# Primeiro verifica se elas já existem
RUN [ ! -d /etc/glpi ] && \
mv config /etc/glpi && \
chown -R www-data:www-data /etc/glpi && \
chmod -R 775 /etc/glpi && \
echo 'Configurado /etc/glpi'

RUN [ ! -d /var/lib/glpi ] && \
mv files /var/lib/glpi && \
chown -R www-data:www-data /var/lib/glpi && \
chmod -R 775 /var/lib/glpi && \
echo 'Configurado /var/lib/glpi'

RUN [ ! -d /var/log/glpi ] && \
mkdir /var/log/glpi && \
chown -R www-data:www-data /var/log/glpi && \
chmod -R 775 /var/log/glpi && \
echo 'Configurado /var/log/glpi'

# Remover pastas 'config' e 'files' do diretorio publico de qualquer forma
RUN [ ! -d config ] && rm -rf config
RUN [ ! -d files ] && rm -rf files

## ---------------------------------------------------------------------------------------------------------------------
## Incialização do Apache
## ---------------------------------------------------------------------------------------------------------------------

# Expor a porta 80 (o ELB vai redirecionar para HTTPS)
EXPOSE 80

# Verificar depois a limpeza de credenciais
# https://docs.docker.com/engine/reference/commandline/login/#credentials-store

# Comando de inicialização do Apache
CMD ["apachectl", "-D", "FOREGROUND"]

## ---------------------------------------------------------------------------------------------------------------------