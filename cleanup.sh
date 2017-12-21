sshpass -p hypriot ssh pirate@$slave1 docker swarm leave
sshpass -p hypriot ssh pirate@$slave2 docker swarm leave
docker swarm leave --force
