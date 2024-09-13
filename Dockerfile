# Usando a imagem oficial do PHP-FPM no Amazon ECR Public
FROM public.ecr.aws/docker/library/php:fpm-alpine

# Instalar Nginx e outros pacotes necessários
RUN apk add --no-cache nginx wget tar supervisor

# Diretório de trabalho dentro do contêiner
WORKDIR /var/www/html

# Baixar e descompactar a aplicação GLPI diretamente no contêiner
RUN wget https://github.com/glpi-project/glpi/releases/download/10.0.16/glpi-10.0.16.tgz \
    && tar -xzf glpi-10.0.16.tgz --strip-components=1 \
    && rm glpi-10.0.16.tgz

# Copiar o arquivo de configuração do Nginx e PHP-FPM
COPY ./nginx.conf /etc/nginx/nginx.conf
#COPY ./php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# Configurar o Supervisor para gerenciar Nginx e PHP-FPM
COPY ./supervisord.conf /etc/supervisord.conf

# Expor as portas do Nginx e PHP-FPM
EXPOSE 80

# Inicializar o Supervisor, que gerencia o Nginx e o PHP-FPM
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
