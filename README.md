
# Project ABP scripts

Scripts for configuring DHCP and Web servers on ubuntu server


## Run Locally

Clone the project

```bash
  git clone https://github.com/HarDep/abp-scripts.git
```

Go to the project

```bash
  cd abp-scripts
```

Give permissions to the scripts

```bash
  chmod +x configurar_dhcp.sh
  chmod +x configurar_web_nginx.sh
```

Run DHCP server configuration script (the arguments are: net-address, mask-address, first-address, last-address, gateway-address, DNS-server1-address, DNS-server2-address)

```bash
  sudo ./configurar_dhcp.sh 192.168.1.0 255.255.255.0 192.168.1.10 192.168.1.100 192.168.1.1 8.8.8.8 8.8.4.4
```

