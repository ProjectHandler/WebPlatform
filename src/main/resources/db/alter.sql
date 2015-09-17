-- 04/09/2015 table for subtasks

CREATE TABLE IF NOT EXISTS `subtask` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `task_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `validated` BOOLEAN NOT NULL DEFAULT FALSE,
  `taken` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- 11/09/2015 table for task messages
CREATE TABLE IF NOT EXISTS `task_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `update_date` date NOT NULL,
  `task_id` bigint(20) NOT NULL,
  `content` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

-- Update to have date + time in task_messages table
ALTER TABLE `task_messages` CHANGE `update_date` `update_date` DATETIME NOT NULL;