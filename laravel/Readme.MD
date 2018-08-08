docker build -t li97as1/php7:v2 .
docker run --name laravel -p 8000:80 -v rootPath:/var/www/html/app -d li97as1/php7:v2