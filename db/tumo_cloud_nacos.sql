DROP DATABASE IF EXISTS `tumo_cloud_nacos`;
CREATE DATABASE `tumo_cloud_nacos` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

USE `tumo_cloud_nacos`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for config_info
-- ----------------------------
DROP TABLE IF EXISTS `config_info`;
CREATE TABLE `config_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `content` longtext COLLATE utf8_bin NOT NULL COMMENT 'content',
  `md5` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COLLATE utf8_bin COMMENT 'source user',
  `src_ip` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `c_use` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `effect` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `type` varchar(64) COLLATE utf8_bin DEFAULT NULL,
  `c_schema` text COLLATE utf8_bin,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfo_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info';

-- ----------------------------
-- Records of config_info
-- ----------------------------
BEGIN;
INSERT INTO `config_info` VALUES (3, 'application-dev.yml', 'DEFAULT_GROUP', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upms/oss/put\n    # Oss配置\n    file:\n      remote-path: http://127.0.0.1:80/upload\n      # 生产环境下，文件上传的地址应该是Web容器映射的可访问的地址\n      upload-path: /usr/local/var/www/upload\n\n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  \n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml\n  global-config:\n    banner: false', '5416cf262b31c217e62313ce9c2b08c8', '2021-03-24 06:50:23', '2021-08-08 08:25:52', NULL, '127.0.0.1', '', '', '基础配置', '', '', 'yaml', '');
INSERT INTO `config_info` VALUES (4, 'tumo-cloud-auth-dev.yml', 'DEFAULT_GROUP', 'spring:\n  datasource:\n    username: root\n    password: root\n    url: jdbc:mysql://tumo-cloud-mysql:3306/tumo_cloud?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=Asia/Shanghai\n  redis:\n    port: 6379\n    host: tumo-cloud-redis', '7db7a02bcc9924e1a7d3f1eea74370be', '2021-03-24 06:51:03', '2021-03-24 06:51:03', NULL, '127.0.0.1', '', '', 'Tumo-Cloud Auth模块配置', NULL, NULL, 'yaml', NULL);
INSERT INTO `config_info` VALUES (5, 'tumo-cloud-gateway-dev.yml', 'DEFAULT_GROUP', 'spring:\n  cloud:\n    gateway:\n      discovery:\n        locator:\n          enabled: true\n      # 路由规则\n      routes:\n        # Auth服务路由\n        - id: tumo-cloud-auth\n          uri: lb://tumo-cloud-auth\n          predicates:\n            - Path=/tumo-cloud/auth/**\n          filters:\n            - StripPrefix=2\n        # Upms服务路由\n        - id: tumo-cloud-upms\n          uri: lb://tumo-cloud-upms\n          predicates:\n            - Path=/tumo-cloud/upms/**\n          filters:\n            - StripPrefix=2\n        # Demo服务\n        - id: tumo-cloud-demo\n          uri: lb://tumo-cloud-demo\n          predicates:\n            - Path=/tumo-cloud/demo/**\n          filters:\n            - StripPrefix=2\n', 'd662a0ccc22f5b3bcdde5673658f13bd', '2021-03-24 06:51:40', '2021-04-16 09:17:44', NULL, '127.0.0.1', '', '', 'Tumo-Cloud Gateway模块', '', '', 'yaml', '');
INSERT INTO `config_info` VALUES (6, 'tumo-cloud-upms-dev.yml', 'DEFAULT_GROUP', 'spring:\n  datasource:\n    username: root\n    password: root\n    url: jdbc:mysql://tumo-cloud-mysql:3306/tumo_cloud?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=Asia/Shanghai\n  redis:\n    port: 6379\n    host: tumo-cloud-redis', '7db7a02bcc9924e1a7d3f1eea74370be', '2021-03-24 06:52:24', '2021-07-24 08:02:17', NULL, '0:0:0:0:0:0:0:1', '', '', 'Tumo-Cloud Upms模块', '', '', 'yaml', '');
COMMIT;

-- ----------------------------
-- Table structure for config_info_aggr
-- ----------------------------
DROP TABLE IF EXISTS `config_info_aggr`;
CREATE TABLE `config_info_aggr` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `datum_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'datum_id',
  `content` longtext COLLATE utf8_bin NOT NULL COMMENT '内容',
  `gmt_modified` datetime NOT NULL COMMENT '修改时间',
  `app_name` varchar(128) COLLATE utf8_bin DEFAULT NULL,
  `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfoaggr_datagrouptenantdatum` (`data_id`,`group_id`,`tenant_id`,`datum_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='增加租户字段';

-- ----------------------------
-- Records of config_info_aggr
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for config_info_beta
-- ----------------------------
DROP TABLE IF EXISTS `config_info_beta`;
CREATE TABLE `config_info_beta` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `app_name` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT 'app_name',
  `content` longtext COLLATE utf8_bin NOT NULL COMMENT 'content',
  `beta_ips` varchar(1024) COLLATE utf8_bin DEFAULT NULL COMMENT 'betaIps',
  `md5` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COLLATE utf8_bin COMMENT 'source user',
  `src_ip` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT 'source ip',
  `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfobeta_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_beta';

-- ----------------------------
-- Records of config_info_beta
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for config_info_tag
-- ----------------------------
DROP TABLE IF EXISTS `config_info_tag`;
CREATE TABLE `config_info_tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT 'tenant_id',
  `tag_id` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'tag_id',
  `app_name` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT 'app_name',
  `content` longtext COLLATE utf8_bin NOT NULL COMMENT 'content',
  `md5` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COLLATE utf8_bin COMMENT 'source user',
  `src_ip` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT 'source ip',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfotag_datagrouptenanttag` (`data_id`,`group_id`,`tenant_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_tag';

-- ----------------------------
-- Records of config_info_tag
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for config_tags_relation
-- ----------------------------
DROP TABLE IF EXISTS `config_tags_relation`;
CREATE TABLE `config_tags_relation` (
  `id` bigint(20) NOT NULL COMMENT 'id',
  `tag_name` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'tag_name',
  `tag_type` varchar(64) COLLATE utf8_bin DEFAULT NULL COMMENT 'tag_type',
  `data_id` varchar(255) COLLATE utf8_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT 'tenant_id',
  `nid` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`nid`),
  UNIQUE KEY `uk_configtagrelation_configidtag` (`id`,`tag_name`,`tag_type`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_tag_relation';

-- ----------------------------
-- Records of config_tags_relation
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for group_capacity
-- ----------------------------
DROP TABLE IF EXISTS `group_capacity`;
CREATE TABLE `group_capacity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` varchar(128) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
  `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数，，0表示使用默认值',
  `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='集群、各Group容量信息表';

-- ----------------------------
-- Records of group_capacity
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for his_config_info
-- ----------------------------
DROP TABLE IF EXISTS `his_config_info`;
CREATE TABLE `his_config_info` (
  `id` bigint(64) unsigned NOT NULL,
  `nid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `data_id` varchar(255) COLLATE utf8_bin NOT NULL,
  `group_id` varchar(128) COLLATE utf8_bin NOT NULL,
  `app_name` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT 'app_name',
  `content` longtext COLLATE utf8_bin NOT NULL,
  `md5` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `src_user` text COLLATE utf8_bin,
  `src_ip` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `op_type` char(10) COLLATE utf8_bin DEFAULT NULL,
  `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`nid`),
  KEY `idx_gmt_create` (`gmt_create`),
  KEY `idx_gmt_modified` (`gmt_modified`),
  KEY `idx_did` (`data_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='多租户改造';

-- ----------------------------
-- Records of his_config_info
-- ----------------------------
BEGIN;
INSERT INTO `his_config_info` VALUES (6, 2, 'tumo-cloud-upms-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    username: root\n    password: root\n    url: jdbc:mysql://tumo-cloud-mysql:3306/tumo_cloud?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=Asia/Shanghai\n', '7e226116e33b0edede982961765ea85e', '2021-07-24 08:02:35', '2021-07-24 08:02:17', NULL, '0:0:0:0:0:0:0:1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 3, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n  \n  # Security配置\n  auth:\n    # 匿名访问端口\n    skip-url: \n      - /demo/anon\n      - /demo/feign\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml\n  configuration:\n    jdbc-type-for-null: null\n  global-config:\n    banner: false', '70f5af448c0570eee58458a918d920b5', '2021-07-24 08:08:42', '2021-07-24 08:08:24', NULL, '0:0:0:0:0:0:0:1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 4, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upload/**\n      - /tumo-boot/auth/logout\n      - /tumo-boot/auth/captcha\n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n  \n  # Security配置\n  auth:\n    # 匿名访问端口\n    skip-url: \n      - /demo/anon\n      - /demo/feign\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml\n  configuration:\n    jdbc-type-for-null: null\n  global-config:\n    banner: false', '68d8b7cc19fa035c927cf67f4fa5ee66', '2021-07-24 08:11:59', '2021-07-24 08:11:41', NULL, '0:0:0:0:0:0:0:1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 5, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upload/**\n      - /tumo-cloud/auth/logout\n      - /tumo-cloud/auth/captcha\n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n  \n  # Security配置\n  auth:\n    # 匿名访问端口\n    skip-url: \n      - /demo/anon\n      - /demo/feign\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml\n  configuration:\n    jdbc-type-for-null: null\n  global-config:\n    banner: false', 'd60fbd63585cb0365f1213ced9bc0dca', '2021-07-24 08:36:57', '2021-07-24 08:36:39', NULL, '0:0:0:0:0:0:0:1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 6, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upload/**\n      - /tumo-cloud/auth/logout\n      - /tumo-cloud/auth/captcha\n  \n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  \n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  \n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n  \n  # Security配置\n  auth:\n    # 匿名访问端口\n    skip-url: \n      - /demo/anon\n      - /demo/feign\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml\n  configuration:\n    jdbc-type-for-null: null\n  global-config:\n    banner: false', '7bf04531d7dc1bb84f62c3679eceaf67', '2021-07-24 08:47:26', '2021-07-24 08:47:09', NULL, '0:0:0:0:0:0:0:1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 7, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upload/**\n      - /tumo-cloud/auth/logout\n      - /tumo-cloud/auth/captcha\n  \n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  \n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  \n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml', '85707b0cdd077bd52f579cb2ead8001e', '2021-07-24 09:13:33', '2021-07-24 09:13:16', NULL, '0:0:0:0:0:0:0:1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 8, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upload/**\n      - /token/logout\n      - /token/captcha\n  \n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  \n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  \n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml', 'b9d04c53d800da08d4939eb32470c994', '2021-07-24 09:15:20', '2021-07-24 09:15:02', NULL, '0:0:0:0:0:0:0:1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 9, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upload/**\n      - /token/login\n      - /token/logout\n      - /token/captcha\n  \n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  \n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  \n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml', '773be2427a1a20275ba4fd84d2fc8a00', '2021-07-30 15:03:09', '2021-07-30 07:03:10', NULL, '127.0.0.1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 10, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upload/**\n      - /token/**\n  \n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  \n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  \n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml', 'd1fda9e2e8a2a898521a41439ff35fc5', '2021-07-30 15:33:28', '2021-07-30 07:33:29', NULL, '127.0.0.1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 11, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upload/**\n  \n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  \n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  \n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml', '182039a843b29e04586cf66d610f8caa', '2021-08-01 20:56:42', '2021-08-01 12:56:42', NULL, '127.0.0.1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 12, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upload/**\n  \n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  \n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  \n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml\n  global-config:\n    banner: false', '38e8bfc230a693dfcad7243a430c2080', '2021-08-08 16:23:52', '2021-08-08 08:23:52', NULL, '127.0.0.1', 'U', '');
INSERT INTO `his_config_info` VALUES (3, 13, 'application-dev.yml', 'DEFAULT_GROUP', '', 'spring:\n  datasource:\n    type: com.zaxxer.hikari.HikariDataSource\n    driver-class-name: com.mysql.cj.jdbc.Driver\n\n  cloud:\n    sentinel:\n      eager: true\n      transport:\n        dashboard: tumo-cloud-sentinel:5002\n\n# 暴露监控端点\nmanagement:\n  endpoints:\n    web:\n      exposure:\n        include: \"*\"\n\n# 自定义配置\ntumo-cloud:\n  # 权限配置\n  auth:\n    # 是否开启演示环境\n    is-demo-env: true\n    # 默认忽略拦截的URL\n    skip-url:\n      - /favicon.ico\n      - /upload/**\n    # Oss配置\n    file:\n      remote-path: http://127.0.0.1:80/upload\n      # 生产环境下，文件上传的地址应该是Web容器映射的可访问的地址\n      upload-path: /usr/local/var/www/upload\n\n  # 日志配置\n  log:\n    # 是否开始日志打印\n    enable: false\n  # Mybatis 配置\n  mybatis:\n    # 是否开启SQL打印\n    enable: false\n  \n  # Swagger配置\n  swagger:\n    authorization-scope-list:\n      - scope: \'app\'\n        description: \'default scope\'\n    title: Tumo-Cloud 微服务项目\n    description: 基于SpringBoot2.4.x & SpringCloud2020.x 的RBAC微服务项目\n    author: tycoding\n    url: http://tycoding.cn\n    email: tycoding@sina.com\n    version: 1.0.0\n\nmybatis-plus:\n  type-aliases-package: cn.tycoding.cloud.**.entity\n  mapper-locations: classpath:mapper/**/*.xml\n  global-config:\n    banner: false', '1b80a2c2d6e4123a196a18fd77a74544', '2021-08-08 16:25:52', '2021-08-08 08:25:52', NULL, '127.0.0.1', 'U', '');
COMMIT;

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `role` varchar(50) NOT NULL,
  `resource` varchar(255) NOT NULL,
  `action` varchar(8) NOT NULL,
  UNIQUE KEY `uk_role_permission` (`role`,`resource`,`action`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of permissions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `username` varchar(50) NOT NULL,
  `role` varchar(50) NOT NULL,
  UNIQUE KEY `idx_user_role` (`username`,`role`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of roles
-- ----------------------------
BEGIN;
INSERT INTO `roles` VALUES ('nacos', 'ROLE_ADMIN');
COMMIT;

-- ----------------------------
-- Table structure for tenant_capacity
-- ----------------------------
DROP TABLE IF EXISTS `tenant_capacity`;
CREATE TABLE `tenant_capacity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` varchar(128) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Tenant ID',
  `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
  `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='租户容量信息表';

-- ----------------------------
-- Records of tenant_capacity
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for tenant_info
-- ----------------------------
DROP TABLE IF EXISTS `tenant_info`;
CREATE TABLE `tenant_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `kp` varchar(128) COLLATE utf8_bin NOT NULL COMMENT 'kp',
  `tenant_id` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT 'tenant_id',
  `tenant_name` varchar(128) COLLATE utf8_bin DEFAULT '' COMMENT 'tenant_name',
  `tenant_desc` varchar(256) COLLATE utf8_bin DEFAULT NULL COMMENT 'tenant_desc',
  `create_source` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT 'create_source',
  `gmt_create` bigint(20) NOT NULL COMMENT '创建时间',
  `gmt_modified` bigint(20) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_info_kptenantid` (`kp`,`tenant_id`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='tenant_info';

-- ----------------------------
-- Records of tenant_info
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `username` varchar(50) NOT NULL,
  `password` varchar(500) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` VALUES ('Tumo-Cloud', '$2a$10$zH8A4Zj5SyVZtJ9MICf7KuY402xS3LAHEyCOg18jSsXwU96HxTSii', 1);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
