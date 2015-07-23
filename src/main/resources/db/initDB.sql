-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 13, 2015 at 09:49 PM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

DROP DATABASE IF EXISTS project_handler;

CREATE DATABASE project_handler;

USE project_handler;


SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `project_handler`
--

-- --------------------------------------------------------

--
-- Table structure for table `address`
--
-- Creation: Apr 13, 2015 at 07:39 PM
--

CREATE TABLE IF NOT EXISTS `address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `street_number` varchar(10) CHARACTER SET utf8 NOT NULL,
  `street_name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `city` varchar(30) CHARACTER SET utf8 NOT NULL,
  `zipcode` varchar(5) CHARACTER SET utf8 NOT NULL,
  `country` varchar(30) CHARACTER SET utf8 NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `civility`
--
-- Creation: Apr 13, 2015 at 07:40 PM
--

CREATE TABLE IF NOT EXISTS `civility` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `depend_tasks`
--
-- Creation: Apr 13, 2015 at 07:40 PM
--

CREATE TABLE IF NOT EXISTS `depend_tasks` (
  `task_id1` bigint(20) NOT NULL,
  `task_id2` bigint(20) NOT NULL,
  PRIMARY KEY (`task_id1`,`task_id2`),
  KEY `task_id2` (`task_id2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--
-- Creation: Apr 13, 2015 at 07:39 PM
--

CREATE TABLE IF NOT EXISTS `groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `project`
--
-- Creation: Apr 13, 2015 at 07:40 PM
--

CREATE TABLE IF NOT EXISTS `project` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `progress` bigint(20) NOT NULL,
  `description` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `duration` bigint(20) NOT NULL,
  `date_begin` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `task`
--
-- Creation: Apr 13, 2015 at 07:40 PM
--

CREATE TABLE IF NOT EXISTS `task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `progress` bigint(20) NOT NULL,
  `description` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `level` bigint(20) NOT NULL,
  `duration` bigint(20) NOT NULL DEFAULT '1',
  `starting_date` date DEFAULT NULL,
  `ending_date` date DEFAULT NULL,
  `status` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `project_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--
-- Creation: Apr 13, 2015 at 07:40 PM
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
  KEY `ticket_priority_id` (`ticket_priority_id`),
  KEY `ticket_tracker_id` (`ticket_tracker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_messages`
--
-- Creation: Apr 13, 2015 at 07:40 PM
--

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_priority`
--
-- Creation: Apr 13, 2015 at 07:40 PM
--

CREATE TABLE IF NOT EXISTS `ticket_priority` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `value` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_tracker`
--
-- Creation: Apr 13, 2015 at 07:40 PM
--

CREATE TABLE IF NOT EXISTS `ticket_tracker` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `tokens`
--
-- Creation: Apr 13, 2015 at 07:39 PM
--

CREATE TABLE IF NOT EXISTS `tokens` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `token` varchar(50) CHARACTER SET utf8 NOT NULL,
  `time_stamp` bigint(20) NOT NULL DEFAULT '0',
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `tokens`
--

INSERT INTO `tokens` (`id`, `token`, `time_stamp`, `user_id`) VALUES
(3, '186ddfb9-a465-4417-9ce8-baf1d8c01b8e', 1416049588886, 10);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--
-- Creation: Apr 13, 2015 at 07:39 PM
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `last_name` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `password` varchar(70) CHARACTER SET utf8 DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `address` bigint(20) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `mobile_phone` varchar(10) DEFAULT NULL,
  `user_role` int(11) NOT NULL DEFAULT '1',
  `account_status` int(11) NOT NULL DEFAULT '0',
  `civility_id` bigint(20) DEFAULT NULL,
  `civility` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `address` (`address`),
  KEY `civility_ibfk` (`civility_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `password`, `email`, `address`, `phone`, `mobile_phone`, `user_role`, `account_status`, `civility_id`, `civility`) VALUES
(1, 'Admin', 'Admin', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'admin@admin.com', NULL, '0123456789', '', 0, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users_groups`
--
-- Creation: Apr 13, 2015 at 07:39 PM
--

CREATE TABLE IF NOT EXISTS `users_groups` (
  `users_id` bigint(20) NOT NULL,
  `groups_id` bigint(20) NOT NULL,
  PRIMARY KEY (`users_id`,`groups_id`),
  KEY `users_groups_ibfk_2` (`groups_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_projects`
--
-- Creation: Apr 13, 2015 at 07:40 PM
--

CREATE TABLE IF NOT EXISTS `users_projects` (
  `user_id` bigint(20) NOT NULL,
  `project_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`project_id`),
  KEY `users_projects_ibfk_2` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_tasks`
--
-- Creation: Apr 13, 2015 at 07:40 PM
--

CREATE TABLE IF NOT EXISTS `users_tasks` (
  `users_id` bigint(20) NOT NULL,
  `tasks_id` bigint(20) NOT NULL,
  PRIMARY KEY (`users_id`,`tasks_id`),
  KEY `users_tasks_ibfk_2` (`tasks_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users_tickets`
--
-- Creation: Apr 13, 2015 at 07:40 PM
--

CREATE TABLE IF NOT EXISTS `users_tickets` (
  `user_id` bigint(20) NOT NULL,
  `ticket_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`ticket_id`),
  KEY `users_tickets_ibfk_2` (`ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `address`
--
ALTER TABLE `address`
  ADD CONSTRAINT `address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `depend_tasks`
--
ALTER TABLE `depend_tasks`
  ADD CONSTRAINT `depend_tasks_ibfk_1` FOREIGN KEY (`task_id1`) REFERENCES `task` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `depend_tasks_ibfk_2` FOREIGN KEY (`task_id2`) REFERENCES `task` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `ticket_tracker_ibfk` FOREIGN KEY (`ticket_tracker_id`) REFERENCES `ticket_tracker` (`id`),
  ADD CONSTRAINT `fk_ticket_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ticket_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ticket_priority_ibkf` FOREIGN KEY (`ticket_priority_id`) REFERENCES `ticket_priority` (`id`);

--
-- Constraints for table `ticket_messages`
--
ALTER TABLE `ticket_messages`
  ADD CONSTRAINT `fk_ticketmessage_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ticketmessage_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `civility_ibfk` FOREIGN KEY (`civility_id`) REFERENCES `civility` (`id`),
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`address`) REFERENCES `address` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users_groups`
--
ALTER TABLE `users_groups`
  ADD CONSTRAINT `users_groups_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `users_groups_ibfk_2` FOREIGN KEY (`groups_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users_tasks`
--
ALTER TABLE `users_tasks`
  ADD CONSTRAINT `users_tasks_ibfk_2` FOREIGN KEY (`tasks_id`) REFERENCES `task` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `users_tasks_ibfk_1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users_tickets`
--
ALTER TABLE `users_tickets`
  ADD CONSTRAINT `users_tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `users_tickets_ibfk_2` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
