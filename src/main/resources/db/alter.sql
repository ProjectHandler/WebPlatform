--
-- Table token 
-- 26/10/14

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