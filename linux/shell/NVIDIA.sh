#获取NVIDIA显卡的BusID
NVIDIA_BusID=`lspci | grep '3D controller: NVIDIA' | cut -d ' ' -f 1 | sed -r 's/0?(.)/\1/' | sed -e 's/:0/:/g' -e 's/\./:/g'`

#写入Xorg配置文件
echo 'Section "Module"
	Load "modesetting"
EndSection
Section "Device"
	Identifier "nvidia"
	Driver "nvidia"
	BusID "PCI:'$NVIDIA_BusID'"      
	Option "AllowEmptyInitialConfiguration"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-nvidia.conf > /dev/null

#写入LightDM启动脚本
echo '#!/bin/sh
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
xrandr --dpi 96' | sudo tee /etc/lightdm/display_setup.sh > /dev/null

#为启动脚本赋予可执行权限
sudo chmod +x /etc/lightdm/display_setup.sh

#修改LightDM配置文件
sudo sed -i 's$#display-setup-script=$display-setup-script=/etc/lightdm/display_setup.sh$g' /etc/lightdm/lightdm.conf

#写入内核参数，防止撕裂问题
echo 'options nvidia-drm modeset=1' | sudo tee /etc/modprobe.d/nvidia-graphics-drivers.conf > /dev/null
