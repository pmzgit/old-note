#删除配置文件
sudo rm /etc/X11/xorg.conf.d/20-nvidia.conf
sudo rm /etc/lightdm/display_setup.sh
sudo rm /etc/modprobe.d/nvidia-graphics-drivers.conf

#恢复LightDM配置文件
sudo sed -i 's$display-setup-script=/etc/lightdm/display_setup.sh$#display-setup-script=$g' /etc/lightdm/lightdm.conf
