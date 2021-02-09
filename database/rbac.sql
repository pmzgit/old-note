drop database if exists test;

CREATE DATABASE test DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;


CREATE TABLE `user` (
 `id` VARCHAR(32) NOT NULL ,
	`code` varchar(100) DEFAULT NULL COMMENT 'openid',
	`person_type` varchar(64) DEFAULT NULL COMMENT '人员类型\n 1全职公益人 \n 2志愿者',
	`name` varchar(100) DEFAULT NULL,
	`pwd` varchar(32) DEFAULT NULL COMMENT '密码',
  `nickname` varchar(100) DEFAULT NULL COMMENT '用户昵称',
	`headimgurl` varchar(2000) DEFAULT NULL,
	`phn1` VARCHAR(90) DEFAULT NULL,
	`phn2` VARCHAR(90) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL COMMENT '邮箱|登录帐号',
	`id_card` varchar(100) DEFAULT NULL COMMENT '身份证',
	`province` varchar(32) DEFAULT NULL COMMENT '省份',
	`city` varchar(255) DEFAULT NULL COMMENT '城市',
	`country` varchar(32) DEFAULT NULL COMMENT '县',
	`age` int(11) DEFAULT NULL COMMENT '年龄',
	`sex` int(11) DEFAULT NULL COMMENT '性别',
  `ref_id` varchar(100) DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` TINYINT(1) DEFAULT '0' COMMENT '0:未删除，1:已删除',
  `disable` TINYINT(1) DEFAULT '0' COMMENT '0:有效，1:禁止登录',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `identity` (
  `id` VARCHAR(32) NOT NULL ,
	`code` VARCHAR(32) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL COMMENT '身份名称',
	`desc` varchar(10000) DEFAULT NULL COMMENT '身份描述',
  `status` TINYINT(1) DEFAULT '0' COMMENT '0:有效，1:无效',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_identity` (
	`id` VARCHAR(32) NOT NULL ,
  `uid` VARCHAR(32) DEFAULT NULL COMMENT '用户ID',
  `rid` VARCHAR(32) DEFAULT NULL COMMENT '身份ID',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;





CREATE TABLE `permission` 	(
  `id` VARCHAR(32) NOT NULL,
	`name` varchar(2000) DEFAULT NULL COMMENT 'url描述',
  `url` varchar(10000) DEFAULT NULL COMMENT 'url地址',
	`navigation` INT(10) DEFAULT NULL COMMENT '是否是导航节点',
	`leaf` INT(10) DEFAULT NULL COMMENT '是否是叶子节点',
	`sortNo` INT(10) DEFAULT NULL,
	`permission_type` INT(10) DEFAULT 1 COMMENT '权限类型 1，菜单，2，页面元素，3, 数据文件',
	`menu_type` INT(10) DEFAULT 1 COMMENT ' 1，前台，2，后台，3, 共用',
	`parentId` INT(10) DEFAULT NULL COMMENT '父',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;




CREATE TABLE `identity_permission` (
	`id` VARCHAR(32) NOT NULL,
	`principal_type` VARCHAR(256) DEFAULT 'R'  COMMENT '主体标识，R，角色，U，用户',
  `rid` bigint(20) DEFAULT NULL COMMENT '角色ID',
  `pid` bigint(20) DEFAULT NULL COMMENT '权限ID',
	`auth_direct` TINYINT(1) DEFAULT 1 NOT NULL COMMENT '1，正向授权，0，负向授权',
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
