#cockpit
sudo apt install cockpit

#add user
 adduser kmadmin
 sudo usermod -aG sudo kmadmin

#podman
 sudo apt install podman
 sudo apt install cockpit-podman

#deploy:
 local -> ssh-keygen -t ed25519  
 ssh -i "$env:USERPROFILE\.ssh\id_ed25519" root@203.57.85.249

#dns
    sudo nano /etc/cockpit/cockpit.conf
    [WebService]
    Origins = https://aeroplanetaai.in:80 https://localhost:80 http://127.0.0.1:80

    sudo systemctl restart cockpit.socket
#ufw - allow network

    sudo ufw allow OpenSSH
    sudo ufw enable
    sudo ufw status
    sudo ufw allow 9090/tcp
    sudo ufw reload
