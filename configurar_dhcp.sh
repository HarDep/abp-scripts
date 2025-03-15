#!/bin/bash

# Verificar que tenga permisos de superusuario
if [ "$EUID" -ne 0 ]; then
    echo "El script debe ser ejecutado con permisos de superusuario."
    exit 1
fi

# Verificar que se hayan pasado todos los argumentos necesarios
if [ "$#" -ne 7 ]; then
    echo "Se deb ejecutar de la siguiente manera: $0 <direccion_red> <mascara> <rango_inicio> <rango_final> <gateway> <dns1> <dns2>"
    exit 1
fi

# Asignar los argumentos a variables
NETWORK=$1
NETMASK=$2
RANGE_START=$3
RANGE_END=$4
GATEWAY=$5
DNS1=$6
DNS2=$7

# Paso 1: Actualizar e instalar el servidor DHCP
echo "Actualizando e instalando el servidor DHCP..."
apt update && apt install -y isc-dhcp-server

# Paso 2: Configurar el archivo /etc/dhcp/dhcpd.conf
echo "Configurando /etc/dhcp/dhcpd.conf..."
bash -c "cat > /etc/dhcp/dhcpd.conf <<EOF
subnet $NETWORK netmask $NETMASK {
  range $RANGE_START $RANGE_END;
  option routers $GATEWAY;
  option domain-name-servers $DNS1, $DNS2;
}
EOF"

# Paso 3: Configurar la interfaz en /etc/default/isc-dhcp-server
echo "Configurando /etc/default/isc-dhcp-server..."
INTERFACE=$(ip -o -4 route show to default | awk '{print $5}')
sed -i "s/^INTERFACESv4=\".*\"/INTERFACESv4=\"$INTERFACE\"/" /etc/default/isc-dhcp-server

# Paso 4: Reiniciar el servicio DHCP
echo "Reiniciando el servicio DHCP..."
systemctl restart isc-dhcp-server.service

echo "Servidor DHCP configurado y reiniciado correctamente."