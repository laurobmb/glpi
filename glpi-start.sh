#!/bin/bash

SRC_GLPI=$(curl -s https://api.github.com/repos/glpi-project/glpi/releases/tags/${VERSION_GLPI} | jq .assets[0].browser_download_url | tr -d \")
TAR_GLPI=$(basename ${SRC_GLPI})
FOLDER_GLPI=glpi/
FOLDER_WEB=/var/www/html/

#export MYSQL_HOST="192.168.123.41"
#export MYSQL_USER="admin"
#export MYSQL_PASSWORD="ohShohN9jie4XaerieToo8wauvo3ka"
#export MYSQL_DATABASE="glpitest"

export GLPI_DB_CONF_FILE=${GLPI_DB_CONF_FILE:-"/var/www/html/glpi/config/config_db.php"}

cat > /tmp/config_db.tmp << EOF
<?php
 class DB extends DBmysql {
  var \$dbhost = '${MYSQL_HOST}';
  var \$dbuser = '${MYSQL_USER}';
  var \$dbpassword = '${MYSQL_PASSWORD}';
  var \$dbdefault = '${MYSQL_DATABASE}';
 }
?>
EOF

chown www-data /tmp/config_db.tmp

############################# IMPORTANTE #################################
# Remover comentários apenas em casos em que o GLPI já esteja instalado, #
# pois ele vai usar iniciar o container com o usuário e senha configurado#
# acima apagando o arquivo de inicialização do GLPI. Caso venha a        #         
# executar este container com as linhas comentadas ele vai iniciar uma   # 
# nova instalação do GLPI                                                #
#
#
if [ $AMBIENT == "PROD" ]; then
    runuser -u www-data cp /tmp/config_db.tmp $GLPI_DB_CONF_FILE
    rm "/var/www/html/glpi/install/install.php"
    echo "Ambiente produtivo"
elif [ $AMBIENT == "NEW"  ]; then
    #runuser -u www-data cp /tmp/config_db.tmp $GLPI_DB_CONF_FILE
    #rm "/var/www/html/glpi/install/install.php"
    echo "Ambiente novo"
else
    echo "Erro ao selecionar ambiente"    
fi
#
#
############################# IMPORTANTE #################################


echo "*/2 * * * * www-data /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" >> /etc/cron.d/glpi

service cron start
a2enmod rewrite && service apache2 restart && service apache2 stop
/usr/sbin/apache2ctl -D FOREGROUND
