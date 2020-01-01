#!/bin/bash
set -e 
function checkSudo (){
	if [ $UID -ne 0 ];then
        	echo -e 'it must be root!'
		echo -e 'usage ./docker.sh {run|restart|rm|logs}'
        	exit 1
	fi
}



sys_inint(){
# 关闭selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux  

# 关闭防火墙
systemctl stop firewalld && systemctl disable firewalld

(cat << EOF
vm.overcommit_memory=1
vm.swappiness=0
net.core.somaxconn = 8192
EOF
) > /etc/sysctl.conf
(cat << EOF
*  soft  nproc           65535
*  hard  nproc           65535
*  soft  nofile          65535
*  hard  nofile          65535
EOF
) > /etc/security/limits.conf
(cat << EOF
nameserver 119.29.29.29
nameserver 223.5.5.5
EOF
) > /etc/resolv.conf
sysctl -p
}

mysql_install(){
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7.repo 
yum clean all  
yum makecache 

yum -y install make gcc-c++ cmake bison-devel ncurses-devellibaio libaio-devel

#编译安装
groupadd mysql  && useradd mysql -g mysql

mkdir -p /data/mysql


tar -xf  /tmp/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz -C /usr/local/
ln -s  /usr/local/mysql-5.7.22-linux-glibc2.12-x86_64  /usr/local/mysql
chown -R mysql:mysql /usr/local/mysql
chown -R mysql:mysql  /data/mysql
chmod -R 755 /data/mysql
# 写入数据库配置文件
(cat << EOF
[client]
port=3306
socket=/var/run/mysql.sock
default_character_set=utf8

[mysql]
no_auto_rehash
default_character_set=utf8

[mysqld]
skip-name-resolve
back_log=1000
skip-ssl
character_set_server=utf8
lower_case_table_names=1
transaction_isolation=READ-COMMITTED
interactive_timeout=600
wait_timeout=600
event_scheduler=ON
skip_name_resolve=ON
skip_external_locking=ON
max_connections=2500
server_id=1
port=3306
basedir=/usr/local/mysql
datadir=/data/mysql/data
log_error=/data/mysql/data/error.log

innodb_buffer_pool_size=500M
innodb_data_file_path=ibdata1:200M:autoextend
innodb_flush_method=O_DIRECT
innodb_log_buffer_size=8M
innodb_log_file_size=1024M
innodb_open_files=1000
innodb_stats_on_metadata=OFF
innodb_file_per_table=ON
innodb_support_xa=ON
innodb_lock_wait_timeout=50
innodb_use_native_aio=ON
innodb_buffer_pool_instances=8
#sas
#innodb_io_capacity=200
#innodb_io_capacity_max=2000
#ssd
innodb_io_capacity=2000
innodb_io_capacity_max=4000

log_bin=mysql-bin
binlog_format=row
max_binlog_size=1024M
expire_logs_days=7
log_bin_trust_function_creators=ON

slow_query_log=1
log_slow_admin_statements=ON
#log_slow_slave_statements=ON
log_timestamps=SYSTEM
long_query_time=1
log_output=TABLE

key_buffer_size=8M
sort_buffer_size=800K
table_open_cache=2000
table_definition_cache=2000
thread_cache_size=100
tmp_table_size=2M
read_buffer_size=800K
read_rnd_buffer_size=256k
max_connect_errors=100000
max_allowed_packet=1024M

max_write_lock_count=102400
myisam_sort_buffer_size=8M
net_buffer_length=16K
open_files_limit=28192

#gtid
gtid_mode=on
enforce_gtid_consistency=ON
#slave_parallel_type=LOGICAL_CLOCK
#slave-parallel-workers=16
#master_info_repository=TABLE
#relay_log_info_repository=TABLE
#relay_log_recovery=ON
#skip_slave_start=1

#log_slave_updates=ON
#sync_master_info=1
query_cache_size=0
#query_cache_type=OFF
binlog_cache_size = 2M

log_warnings=1
[mysqldump]
quick
max_allowed_packet=50M

[myisamchk]
key_buffer_size=100M
sort_buffer_size=100M
read_buffer=2M
write_buffer=2M

[mysqlhotcopy]
interactive_timeout

[mysqld_safe]
open-files-limit=28192
EOF
) > /etc/my.cnf

/usr/local/mysql/bin/mysqld --initialize --user=mysql --datadir=/data/mysql/data --basedir=/usr/local/mysql
#passwd =` /usr/local/mysql/bin/mysqld --initialize --user=mysql --datadir=/data/mysql/data --basedir=/usr/local/mysql | awk '/localhost\:/{print $NF}' `
ln -s /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
ln -s /usr/local/mysql/bin/mysql /usr/bin
service mysql start 
#mysqladmin -u root -p${passwd} password 'Xa88215985!@#'
}
read -p " Do you want to install mysql-5.7:Y/N " REDISCONFIRM
if [ "$REDISCONFIRM" = "Y" ] || [ "$REDISCONFIRM" = "y" ]
then
    checkSudo
    sys_inint
    mysql_install
    echo "==============================================="
    echo "Initialization completed"
    echo "==============================================="
else
    echo "=================== install the next thing =============="
fi
