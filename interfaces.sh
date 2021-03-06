# <snippet-end interfaces.sh>
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
DEFAULT_GRUB=/etc/default/grub

echo "--- Using old style name (ethX) for interfaces"
#for key in GRUB_CMDLINE_LINUX
#do
#    sudo sed -i "s/^\($key\)=.*/\1=\"$(eval echo \${$key})\"/" $DEFAULT_GRUB
#done
sed  -r  's/^(GRUB_CMDLINE_LINUX=).*/\1\"net\.ifnames=0\ biosdevname=0\"/' /etc/default/grub | sudo tee /etc/default/grub > /dev/null

# install ifupdown since ubuntu 18.04
sudo apt-get update
sudo apt-get install -y ifupdown

# enable eth0
echo "--- Configuring eth0"

echo "# The primary network interface
auto eth0
iface eth0 inet dhcp" | sudo tee /etc/network/interfaces
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo update-grub  > /dev/null 2>&1
# <snippet-end interfaces.sh>
