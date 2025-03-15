#!/bin/bash

# Verificar que tenga permisos de superusuario
if [ "$EUID" -ne 0 ]; then
    echo "El script debe ser ejecutado con permisos de superusuario."
    exit 1
fi

# Paso 1: Actualizar e instalar Nginx
echo "Actualizando e instalando Nginx..."
apt update && apt install -y nginx

# Paso 2: Configurar Nginx para que escuche en el puerto 80
echo "Configurando Nginx..."
bash -c "cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF"

# Paso 3: Cambiar el contenido del archivo index.html a mostrar
echo "Editando el archivo index.html..."
bash -c "cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Servidor Web</title>
</head>
<body>
    <h1>Hola Mundo</h1>
</body>
</html>
EOF"

# Paso 4: Reiniciar el servicio Nginx
echo "Reiniciando el servicio Nginx..."
nginx -t
systemctl restart nginx

echo "Servidor web Nginx configurado y reiniciado correctamente."

# Paso 5: Configurar el firewall para permitir conexiones HTTP
echo "Configurando el firewall para permitir conexiones HTTP..."
ufw allow 'nginx full'
ufw reload

echo "Servidor web configurado para permitir conexiones HTTP."

# Obtener la dirección IP local del servidor
IP_LOCAL=$(hostname -I | awk '{print $1}')

echo "Puedes acceder al contenido de la página en http://$IP_LOCAL/"