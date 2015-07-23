
-- insert event table (01/05/2015)
CREATE TABLE IF NOT EXISTS `event` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(30) CHARACTER SET utf8 NOT NULL,
  `description` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `starting_date` datetime NOT NULL,
  `ending_date` datetime NOT NULL,
  `status` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

CREATE TABLE IF NOT EXISTS `users_events` (
  `users_id` bigint(20) NOT NULL,
  `events_id` bigint(20) NOT NULL,
  PRIMARY KEY (`users_id`,`events_id`),
  KEY `users_id` (`users_id`),
  KEY `events_id` (`events_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `users_events`
  ADD CONSTRAINT `users_events_ibfk_2` FOREIGN KEY (`events_id`) REFERENCES `event` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `users_events_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- delete attribute for civility enum (04/06/2015)
ALTER TABLE `users` DROP `civility`;

DELETE FROM civility;
INSERT INTO `civility` (`id`, `name`) VALUES
(1, 'projecthandler.civility.mister'),
(2, 'projecthandler.civility.mrs'),
(3, 'projecthandler.civility.miss');
 
-- Constraints for table `users_projects` (05/06/2015)
ALTER TABLE `users_projects`
	ADD CONSTRAINT `users_projects_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
 	ADD CONSTRAINT `users_projects_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`);

-- ADD 2 field for table 'users' (17/06/2015)	
ALTER TABLE `users` ADD `work_day` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'tttttff' ;
ALTER TABLE `users` ADD `daily_hour` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '09:00 AM - 05:00 PM';

-- ADD avatar field for table 'users' (18/06/2015)
ALTER TABLE `users` ADD `avatar_file_name` VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ;
ALTER TABLE `users` ADD `avatar_base_64` LONGTEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ;

-- Change rule for level in task (09/07/2015)
UPDATE `task` SET `level` = `level` + 1;

-- ADD row column for in task (09/07/2015)
ALTER TABLE `task` ADD `row` bigint(20) DEFAULT NULL;

-- drop row in users (10/07/2015)
ALTER TABLE `users` DROP `avatar_base_64`;

-- DEPLOYMENT ON PRODUCTION 22/07/2015 --

