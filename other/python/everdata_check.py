#!/usr/bin/python
#coding:utf8
import sys
import re
import os
import subprocess


def close_swap_set():
    '''
    close swap
    '''
    print "closeing swap, please wait.."
    '''
    os.system("swapoff -a -v")
    '''

def sysctl_set():
    '''
    修改/etc/sysctl.conf文件，添加如下配置
    '''
    print "setting sysctl.conf"
    os.system("sed -i -r '/vm.overcommit_memory.*/d' /etc/sysctl.conf")
    os.system("sed -i -r '/vm.swappiness.*/d' /etc/sysctl.conf")
    os.system("sed -i -r '/vm.max_map_count.*/d' /etc/sysctl.conf")
    os.system("echo \"vm.overcommit_memory=1\" >> /etc/sysctl.conf")
    os.system("echo \"vm.swappiness=0\" >> /etc/sysctl.conf")
    os.system("echo \"vm.max_map_count=262144\" >> /etc/sysctl.conf")
    os.system("sysctl -q -e -p /etc/sysctl.conf")


def limits_set():
    print "setting limits.conf"
    f = os.popen("ulimit -n")
    line = f.readline()
    size = int(line)
    if size >= 655350:
        return
    os.system("sed -i -r '/soft nofile.*/d' /etc/security/limits.conf")
    os.system("sed -i -r '/hard nofile.*/d' /etc/security/limits.conf")
    os.system("sed -i -r '/soft nproc.*/d' /etc/security/limits.conf")
    os.system("sed -i -r '/hard nproc.*/d' /etc/security/limits.conf")
    os.system("echo \"root soft nofile 655350\" >> /etc/security/limits.conf")
    os.system("echo \"root hard nofile 655350\" >> /etc/security/limits.conf")
    os.system("echo \"root soft nproc unlimited\" >> /etc/security/limits.conf")
    os.system("echo \"root hard nproc unlimited\" >> /etc/security/limits.conf")
    print "Setup completed, but it need re-login to take effort. please enter Logout later!!!!!!"

def java_version_check():
    '''
    检查java版本信息，规定：java version "1.7.0_55"
    '''
    try:
        sp = subprocess.Popen(["java", "-version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        jversion = sp.communicate()[1]
        regex = re.compile(r"\"([\d \. _]+)\"", re.S)
        m = re.search(regex, jversion)
        if m:
            if m.group(1) != "1.7.0_55":
                print "warning java version not equal 1.7.0_55."
            else:
                print "java enviroment is 1.7.0_55."
    except:
        print "warning java isn't installed or JAVA_HOME is null."


def file_system_check():
    '''
    检查文件系统是否为ext4
    '''
    f = os.popen("mount |grep /dev/|grep -v tmpfs |grep -v devpts")
    try:
        for line in f.readlines():
            l = re.sub('\s+', '|', line)
            arr = l.split('|')
            # print arr
            path = arr[0]
            type = arr[4]
            if type != "ext4":
                print "warning %s is %s format! please use ext4." % (path, type)
            else:
                print "%s file system is ext4." % path
    except:
        pass
    finally:
        f.close()


def disk_writespeed_test():
    try:
        flag = raw_input('do you test hard disk speed? [y/n]')
        if flag == "y":
            path = raw_input('disk write speed test, please entry test file path:')
            f = os.popen("dd bs=2G count=1 oflag=direct if=/dev/zero of=" + path)
            for line in f.readlines():
                print line
            os.remove(path)
        else:
            return
    except:
        pass


def check():
    '''
    Syntax: [everdata_setup check]
    check java env:
        java -version
    check file system format:
        mount
    '''
    java_version_check()
    file_system_check()


def set():
    '''
    Syntax: [everdata_setup set]
    set /etc/sysctl.conf:
        vm.overcommit_memory=1
        vm.swappiness=0
        vm.max_map_count=262144
    close swap:
        swapoff -a -v
    set /etc/security/limits.conf:
        root soft nofile 655350
        root hard nofile 655350
        root soft nproc unlimited
        root hard nproc unlimited
    '''
    close_swap_set()
    sysctl_set()
    limits_set()


def test():
    '''
    Syntax: [everdata_setup test]
    disk write speed test, please entry dev path: [path/fielname]
    '''
    disk_writespeed_test()


def all():
    '''
    Syntax: [everdata_setup all]
    run all phase of "check","set","test"
    '''
    check()
    set()
    test()


def print_usage(command=None):
    """print one help message or list of available commands"""
    if command != None:
        if COMMANDS.has_key(command):
            print (COMMANDS[command].__doc__ or
                   "No documentation provided for <%s>" % command)
        else:
            print "<%s> is not a valid command" % command
    else:
        print_commands()


def print_commands():
    """print all command"""
    print "Commands:\n\t", "\n\t".join(sorted(COMMANDS.keys()))
    print "\nHelp:", "\n\thelp", "\n\thelp <command>"


COMMANDS = {"check": check, "set": set, "test": test, "all": all, "help": print_usage}


def parse_config_opts(args):
    curr = args[:]
    curr.reverse()
    args_list = []
    while len(curr) > 0:
        token = curr.pop()
        args_list.append(token)
    return args_list


def unknown_command(*args):
    print "Unknown command: [everdata_setup %s]" % ' '.join(sys.argv[1:])


if __name__ == "__main__":
    if len(sys.argv) == 1:
        all()
    else:
        args = parse_config_opts(sys.argv[1:])
        COMMAND = args[0]
        ARGS = args[1:]
        (COMMANDS.get(COMMAND, unknown_command))(*ARGS)