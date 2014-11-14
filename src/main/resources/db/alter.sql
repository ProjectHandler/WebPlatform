--
-- Table token 
-- 26/10/2014

CREATE TABLE IF NOT EXISTS `tokens` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`token` varchar(50) CHARACTER SET utf8 NOT NULL,
	`time_stamp` bigint(20) NOT NULL DEFAULT '0',
	`user_id` bigint(20) DEFAULT NULL,
	PRIMARY KEY (`id`),
	KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- Add field 'civility' in user table 
-- 02/11/2014
ALTER TABLE `users` ADD `civility` int(4) DEFAULT NULL;

--
-- Table structure for table `users`
-- 02/11/2014

ALTER TABLE `users` CHANGE `first_name` `first_name` VARCHAR(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL;
ALTER TABLE `users` CHANGE `last_name` `last_name` VARCHAR(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL;
ALTER TABLE `users` CHANGE `password` `password` VARCHAR(70) CHARACTER SET utf8 COLLATE utf8_general_ci NULL;


-- Table structure for table `users_groups`
-- 14/11/2014

CREATE TABLE IF NOT EXISTS `users_groups` (
  `users_id` bigint(20) NOT NULL,
  `groups_id` bigint(20) NOT NULL,
  PRIMARY KEY (`users_id`,`groups_id`),
  KEY `users_groups_ibfk_2` (`groups_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `users_groups`
  ADD CONSTRAINT `users_groups_ibfk_2` FOREIGN KEY (`groups_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `users_groups_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
