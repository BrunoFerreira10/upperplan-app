# Usando a imagem oficial do Nginx como base
FROM nginx:latest

# Diretório de trabalho dentro do contêiner
WORKDIR /var/www/html

# Baixar e descompactar a aplicação GLPI diretamente no contêiner
RUN apt-get update && apt-get install -y wget tar \
    && wget https://github.com/glpi-project/glpi/releases/download/10.0.16/glpi-10.0.16.tgz \
    && tar -xzf glpi-10.0.16.tgz --strip-components=1 \
    && rm glpi-10.0.16.tgz

# Copiar o arquivo de configuração do Nginx, se necessário
# COPY ./nginx.conf /etc/nginx/nginx.conf

# Definir o comando de inicialização do Nginx
CMD ["nginx", "-g", "daemon off;"]
