# GLPI

sudo docker build -t glpi:latest . 

sudo docker run -it --rm --name glpi -e AMBIENT=NEW -p8080:80 glpi:latest

Após configurar o banco de dados, termine o container e inicie novamente com a variavivel AMBIENT com o valor PROD

sudo docker run -d --restart always --name glpi -e AMBIENT=PROD -p8080:80 glpi:latest

