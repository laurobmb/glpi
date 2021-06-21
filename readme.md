# GLPI


podman run -it -e MYSQL_ROOT_PASSWORD=ohShohN9jie4XaerieToo8wauvo3ka -e MYSQL_HOST=172.1.34.207 -e MYSQL_DATABASE=glpi-1 -e MYSQL_USER=admin -e MYSQL_PASSWORD=ohShohN9jie4XaerieToo8wauvo3ka -p 8080:80 glpi:latest


use mysql;

ALTER USER 'root'@'localhost' IDENTIFIED BY 'ohShohN9jie4XaerieToo8wauvo3ka';

flush privileges;

quit


192.168.123.41


podman run -it -e MYSQL_ROOT_PASSWORD=ohShohN9jie4XaerieToo8wauvo3ka -e MYSQL_HOST=192.168.123.41 -e MYSQL_DATABASE=glpi-1 -e MYSQL_USER=glpi -e MYSQL_PASSWORD=ohShohN9jie4XaerieToo8wauvo3ka -p 8080:80 glpi:latest


CREATE DATABASE glpitest CHARACTER SET UTF8;
CREATE USER 'glpi'@'192.168.123.119';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'192.168.123.119' IDENTIFIED BY 'ohShohN9jie4XaerieToo8wauvo3ka';
FLUSH PRIVILEGES;

CREATE DATABASE glpitest CHARACTER SET UTF8;
CREATE USER 'admin'@'192.168.123.119' IDENTIFIED BY 'ohShohN9jie4XaerieToo8wauvo3ka';
GRANT ALL PRIVILEGES ON glpitest.* TO 'admin'@'192.168.123.119' IDENTIFIED BY 'ohShohN9jie4XaerieToo8wauvo3ka';
FLUSH PRIVILEGES;



CREATE DATABASE glpitest CHARACTER SET UTF8 COLLATE UTF8_BIN;
CREATE USER 'admin'@'192.168.123.119' IDENTIFIED BY 'ohShohN9jie4XaerieToo8wauvo3ka';
GRANT ALL PRIVILEGES ON glpitest.* TO 'admin'@'%';
FLUSH PRIVILEGES;

quit;

