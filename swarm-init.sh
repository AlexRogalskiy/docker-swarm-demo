#This script assumes that both rpi devices hostnames are already set to $slave1 and -2 respectively - This environment might be difficult to replicate 
docker swarm init --advertise-addr $manager
#RPI has no internal clock, we need to set its date, we are not connected to deb time servers
sshpass -p hypriot ssh pirate@$slave1 "sudo date --set \"$(LC_TIME="en_US.UTF-8" && date -u)\""
sshpass -p hypriot ssh pirate@$slave2 "sudo date --set \"$(LC_TIME="en_US.UTF-8" && date -u)\""
#Find all devices on private network nmap -sn 192.168.1.0/24
#Uncomment in order to use a local registry docker service create --name registry --publish published=5000,target=5000 registry:2
token1=$(docker swarm join-token worker --rotate -q)
sshpass -p hypriot ssh pirate@$slave1 docker swarm join --token $token1 $manager
token2=$(docker swarm join-token worker --rotate -q)
sshpass -p hypriot ssh pirate@$slave2 docker swarm join --token $token2 $manager
docker node update --label-add arch=arm $(sshpass -p hypriot ssh pirate@$slave1 hostname)
docker node update --label-add arch=arm $(sshpass -p hypriot ssh pirate@$slave2 hostname)
docker node update --label-add arch=x86 $(hostname)
#For simplicity in demo environment we won't use a registry here, DEI networks are extremely picky regarding ports, and we might not have internet on the RPI's
#So we will be building the demo directly on slave and tag it localhost:5000/swarm:demo_v1 | This takes a while and assumes base image , in fact image will be built at demo time
#Copy the contents to rpi previously created demo folder
sshpass -p hypriot scp -r demo pirate@$slave1:/home/pirate
sshpass -p hypriot scp -r demo pirate@$slave2:/home/pirate
#Build the image, this requires internet service on the RPI's - as stated previously will be built at demo time for simplicity
sshpass -p hypriot ssh pirate@$slave1 "cd demo && docker build -t localhost:5000/swarm:demo_v1 --file /home/pirate/demo/Dockerfile ."
sshpass -p hypriot ssh pirate@$slave2 "cd demo && docker build -t localhost:5000/swarm:demo_v1 --file /home/pirate/demo/Dockerfile ."
#Launch the services tagged accordingly to the architecture 
docker stack deploy --compose-file docker-compose.yml demosei