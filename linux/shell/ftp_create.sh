#!/bin/bash

create_path()
{
    #create path
    mkdir /data/ftpdir/
}

vsftpd_conf_sed(){
    # edit vsftpd config
    echo "vsftpd config will be setting"
    file="/etc/vsftpd/vsftpd.conf"
    if [ ! -f ${file} ]; then
        echo "ftp server is not installed..."
        exit;
    fi

    # chown_uploads
    sed -i '/^chown_uploads/d' ${file}
    sed -i '/tcp_wrappers=YES/a\chown_uploads=YES' ${file}
    #anon_other_write_enable
    sed -i '/^anon_other_write_enable/d' ${file}
    sed -i '/tcp_wrappers=YES/a\anon_other_write_enable=YES' ${file}
    #anon_world_readable_only
    sed -i '/^anon_world_readable_only/d' ${file}
    sed -i '/tcp_wrappers=YES/a\anon_world_readable_only=NO' ${file}
    #anon_mkdir_write_enable
    sed -i '/^anon_mkdir_write_enable/d' ${file}
    sed -i '/tcp_wrappers=YES/a\anon_mkdir_write_enable=YES' ${file}
    #anon_upload_enable
    sed -i '/^anon_upload_enable/d' ${file}
    sed -i '/tcp_wrappers=YES/a\anon_upload_enable=YES' ${file}
    #use_localtime
    sed -i '/^use_localtime/d' ${file}
    sed -i '/tcp_wrappers=YES/a\use_localtime=YES' ${file}
    #anonymous_enable
    sed -i '/^anonymous_enable/d' ${file}
    sed -i '/tcp_wrappers=YES/a\anonymous_enable=NO' ${file}
    echo "success to setting vsftpd config "
}

sebool_set()
{
  echo "system sebool set start..."
  setsebool -P allow_ftpd_anon_write on
  setsebool -P allow_ftpd_full_access on
  setsebool -P allow_ftpd_use_cifs on 
  setsebool -P allow_ftpd_use_nfs on
  setsebool -P ftp_home_dir on
  setsebool -P ftpd_connect_db on 
  setsebool -P ftpd_use_passive_mode on 
  echo "success to set system sebool"
}

disable_iptables()
{
    echo "system iptable set start..."
    service iptables stop
    file="/etc/selinux/config"
        sed -i '/^SELINUX=enforcing/d' ${file}
        sed -i '/loaded./a\SELINUX=disable' ${file}
    chkconfig iptables --level 0123456 off
    echo "success to set system iptable"
}

create_ftp_user()
{


    ftp_home_dir=/home/upload
    ftp_user=ftpuser1
    ftp_group=gxftpuser
    #create ftp user
    service vsftpd stop

    #delete exist user//
    userdel $ftp_user

    #delete group
    groupdel $ftp_group

    #create group
    groupadd $ftp_group

    mkdir -p $ftp_home_dir
    chmod 777 $ftp_home_dir
    #create fdr user
    useradd -s /sbin/nologin -g $ftp_group -d $ftp_home_dir  -M $ftp_user
    chown $ftp_user $ftp_home_dir
    echo 123456 | passwd $ftp_user --stdin
    echo "User '$ftp_user' created success..."

    #create end
    service vsftpd start

    chkconfig vsftpd --level 2345 on
}

vsftpd_conf_sed
sebool_set
disable_iptables
#create_path
create_ftp_user
