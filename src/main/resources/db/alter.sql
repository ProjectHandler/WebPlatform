-- tables project & task (23/01/2015)
CREATE TABLE IF NOT EXISTS `project` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `description` varchar(500)  CHARACTER SET utf8 DEFAULT NULL,
  `date_begin` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `description` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `starting_date` date DEFAULT NULL,
  `ending_date` date DEFAULT NULL,
  `status` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `project_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- ALTER TABLE `task` ADD CONSTRAINT `projectKey` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE CASCADE ;

-- tables calendar (06/02/2014) ----------------------------- temp table
CREATE TABLE IF NOT EXISTS `calendar` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8 NOT NULL,
  `text` text CHARACTER SET utf8 NOT NULL,
  `start` datetime NOT NULL,
  `end` datetime NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE IF NOT EXISTS `tickets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `text` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `ticket_status` int(11) NOT NULL DEFAULT '1',
  `user_id` bigint(20) DEFAULT NULL,
  `project_id` bigint(20) NOT NULL,
  `ticket_priority_id` bigint(20) DEFAULT NULL,
  `ticket_tracker_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `project_id` (`project_id`),
  KEY `ticket_priority_id` (`ticket_priority_id`)
  KEY `ticket_tracker_id` (`ticket_tracker_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


--
-- Constraints for table `tickets`
--
-- TODO réfléchir s'il faut cascade ou pas pour user et task
ALTER TABLE `tickets`
  ADD CONSTRAINT `fk_ticket_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `tickets`
  ADD CONSTRAINT `fk_ticket_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE CASCADE;

ALTER TABLE `users` MODIFY `email` VARCHAR(50);

-- change in calendar start & end by start_date & end_date for PostgreSql (12/02/2015)
ALTER TABLE `calendar` CHANGE `start` `start_date` DATETIME NOT NULL, CHANGE `end` `end_date` DATETIME NOT NULL;

-- messages table (13/02/2015)
CREATE TABLE IF NOT EXISTS `ticket_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL,
  `updated_at` timestamp NOT NULL,
  `text` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_id` (`ticket_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ticket_messages`
  ADD CONSTRAINT `fk_ticketmessage_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE;
ALTER TABLE `ticket_messages`
  ADD CONSTRAINT `fk_ticketmessage_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

-- alter table `tickets` to make `project_id` not null (13/02/2015)
ALTER TABLE `tickets` CHANGE `project_id` `project_id` BIGINT(20) NOT NULL;

-- add ticket status to tickets (13/02/2015)
ALTER TABLE `tickets` ADD `ticket_status` int(11) NOT NULL DEFAULT '1';

-- --------------------------------------------------------

--
-- Table structure for table `users_projects`
--

CREATE TABLE IF NOT EXISTS `users_projects` (
  `user_id` bigint(20) NOT NULL,
  `project_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`project_id`),
  KEY `users_projects_ibfk_2` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_tickets` (22/02/2015)
--

CREATE TABLE IF NOT EXISTS `users_tickets` (
  `user_id` bigint(20) NOT NULL,
  `ticket_id` bigint(20) NOT NULL,
  CONSTRAINT users_tickets_pk PRIMARY KEY (`user_id`,`ticket_id`),
  CONSTRAINT users_tickets_ibfk_1
    FOREIGN KEY (user_id) REFERENCES users (id),
  CONSTRAINT users_tickets_ibfk_2
    FOREIGN KEY (ticket_id) REFERENCES tickets (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Table structure for table `ticket_priority` (22/02/2015)
--
CREATE TABLE IF NOT EXISTS `ticket_priority` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `value` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_tracker` (22/02/2015)
--
CREATE TABLE IF NOT EXISTS `ticket_tracker` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- new fields for table `tickets`
ALTER TABLE `tickets`
  ADD `ticket_priority_id` bigint(20) DEFAULT NULL;
ALTER TABLE `tickets`
  ADD `ticket_tracker_id` bigint(20) DEFAULT NULL;

-- new constraints for table `tickets` (22/02/2015)
ALTER TABLE `tickets`
  ADD CONSTRAINT `ticket_priority_ibkf` FOREIGN KEY (`ticket_priority_id`) REFERENCES `ticket_priority` (`id`);
ALTER TABLE `tickets`
  ADD CONSTRAINT `ticket_tracker_ibfk` FOREIGN KEY (`ticket_tracker_id`) REFERENCES `ticket_tracker` (`id`);
  
-- new columns duration and level in task (23/03/2015)
ALTER TABLE `task` ADD `duration` BIGINT(20) NOT NULL DEFAULT '1' AFTER `description`;
ALTER TABLE `task` ADD `level` BIGINT(20) NOT NULL AFTER `description`;
ALTER TABLE `task` ADD `progress` BIGINT(20) NOT NULL AFTER `name`;
ALTER TABLE `project` ADD `progress` BIGINT(20) NOT NULL AFTER `name`;
ALTER TABLE `project` ADD `duration` BIGINT(20) NOT NULL AFTER `description`;
ALTER TABLE `project` ADD `status` VARCHAR(30) NOT NULL AFTER `date_end`;