-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 14, 2015 at 04:41 PM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `project_handler`
-- ////////////////////////////////////////////////////////////////////
-- NB : tous les mots de passes des users sont les mêmes. (mpd: 000000aA)
-- ////////////////////////////////////////////////////////////////////
--
USE project_handler;
--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `password`, `email`, `address`, `phone`, `mobile_phone`, `user_role`, `account_status`, `civility_id`) VALUES
(12, 'Guillard', 'Arthur', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'arthur.guillard@example.com', NULL, '0101020304', '0102030405', 3, 1, 1),
(20, 'Jean', 'Patoche', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'jean.patoche@example.com', NULL, '01000001', '06000001', 1, 1, 1),
(21, 'Lucie', 'Roblochon', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'lucie_peace@margoulette.com', NULL, '0133449978', '0612546879', 1, 1, 2),
(22, 'Maria', 'Mandzukic', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'mandzu.maria@zlatan.com', NULL, '0198877665', '0698877665', 1, 1, 3),
(23, 'Vladimir', 'Machine', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'vlad-exp@coldmail.com', NULL, '07888888', '06888888', 1, 1, 1),
(50, 'Platane', 'Inactive', '$2a$10$BchMTgOEN5OaRG/B2Bx2IuNkpjFsE.KzfP4sLu8M8769ciRbNuSdW', 'inactif@lol.com', NULL, '1111111111', '6666666666', 1, 0, 2);

--
-- Dumping data for table `address`
--
INSERT INTO `address` (`id`, `street_number`, `street_name`, `city`, `zipcode`, `country`, `user_id`) VALUES
(2, '31', 'Herberton Park', 'Dublin', '8', 'Ireland', 12),
(3, '48', 'Rue polisson', 'Meûtière-en-Veuhlu', '789', 'Luxembourg', 11);

UPDATE `project_handler`.`users` SET `address` = '2' WHERE `users`.`id` = 12;
UPDATE `project_handler`.`users` SET `address` = '3' WHERE `users`.`id` = 20;
UPDATE `project_handler`.`users` SET `address` = '3' WHERE `users`.`id` = 21;
UPDATE `project_handler`.`users` SET `address` = '2' WHERE `users`.`id` = 22;
UPDATE `project_handler`.`users` SET `address` = '2' WHERE `users`.`id` = 23;
UPDATE `project_handler`.`users` SET `address` = '3' WHERE `users`.`id` = 50;

--
-- Dumping data for table `civility`
--

INSERT INTO `civility` (`id`, `name`) VALUES
(1, 'projecthandler.civility.mister'),
(2, 'projecthandler.civility.mrs'),
(3, 'projecthandler.civility.miss');

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`id`, `name`) VALUES
(4, 'Développeur'),
(5, 'Manager'),
(6, 'Electricien'),
(7, 'Conférence');

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`id`, `name`, `progress`, `description`, `duration`, `date_begin`, `date_end`, `status`) VALUES
(1, 'Mk5 project', 0, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vel venenatis metus. Vivamus euismod suscipit nisi. Integer hendrerit, libero eu condimentum mollis, massa nunc porttitor arcu, ut semper diam sapien ac nunc. Sed blandit risus sed est iaculis commodo. Nullam tincidunt malesuada sollicitudin. Cum sociis natoque penatibus et volutpat.', 410, '2015-04-14', '2016-11-19', 'STATUS_ACTIVE'),
(2, 'Data Mining', 0, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed in rhoncus lacus, id imperdiet turpis. Duis efficitur pretium turpis, a ultricies elit rutrum ac. Maecenas placerat varius mi sed ultrices. Ut in laoreet erat. In lacinia dolor eget neque lobortis, eget vestibulum libero ullamcorper. Curabitur volutpat risus ut dui sollicitudin, non commodo urna convallis. Quisque volutpat nisl eu semper commodo. Nunc et orci elementum, malesuada metus eget, eleifend magna nullam.', 0, '2015-04-14', '2015-04-14', 'STATUS_ACTIVE'),
(3, 'Cheese''n roll', 0, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed in rhoncus lacus, id imperdiet turpis. Duis efficitur pretium turpis, a ultricies elit rutrum ac. Maecenas placerat varius mi sed ultrices. Ut in laoreet erat. In lacinia dolor eget neque lobortis, eget vestibulum libero ullamcorper. Curabitur volutpat risus ut dui sollicitudin, non commodo urna convallis. Quisque volutpat nisl eu semper commodo. Nunc et orci elementum, malesuada metus eget, eleifend magna nullam.', 793, '2014-12-09', '2017-02-09', 'STATUS_ACTIVE');

--
-- Dumping data for table `task`
--

INSERT INTO `task` (`id`, `name`, `progress`, `description`, `level`, `duration`, `starting_date`, `ending_date`, `status`, `project_id`) VALUES
(1, 'tache1', 0, '', 0, 1, '2015-04-14', '2015-04-15', 'STATUS_ACTIVE', 1),
(2, 'tache1', 0, '', 0, 1, '2015-04-14', '2015-04-15', 'STATUS_ACTIVE', 1);

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `title`, `text`, `ticket_status`, `user_id`, `project_id`, `ticket_priority_id`, `ticket_tracker_id`, `created_at`, `updated_at`) VALUES
(1, 'Le fromage?', 'Le Pouligny Saint Pierre est obtenu à partir de lait de quoi?', 1, 21, 3, NULL, NULL, '2015-04-14 14:00:16', '2015-04-14 14:00:16'),
(2, 'Problème facture!', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam varius libero dolor, non ornare nibh egestas nec. Integer tristique aliquet neque sed volutpat. Praesent sodales sem nunc, id feugiat tortor vestibulum nec massa nunc.', 1, 23, 3, NULL, NULL, '2015-04-14 14:11:37', '2015-04-14 14:11:37'),
(3, 'marge 2016', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam volutpat diam arcu. Ut at iaculis dui. Pellentesque finibus, mi eget dignissim semper, erat orci luctus magna, quis auctor erat magna ornare dui. Ut vel augue sed odio fermentum auctor commodo et felis. Maecenas feugiat risus vitae ex tristique aliquam. Donec auctor tincidunt egestas. Fusce mi risus, suscipit fermentum commodo at, auctor at mauris. Curabitur maximus vestibulum augue sit amet ultricies. Proin ac fermentum ante posuere.', 1, 21, 3, NULL, NULL, '2015-04-14 14:12:53', '2015-04-14 14:12:53'),
(4, 'Erreur données', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam volutpat diam arcu. Ut at iaculis dui. Pellentesque finibus, mi eget dignissim semper, erat orci luctus magna, quis auctor erat magna ornare dui. Ut vel augue sed odio fermentum auctor commodo et felis. Maecenas feugiat risus vitae ex tristique aliquam. Donec auctor tincidunt egestas. Fusce mi risus, suscipit fermentum commodo at, auctor at mauris. Curabitur maximus vestibulum augue sit amet ultricies. Proin ac fermentum ante posuere.', 0, 21, 3, NULL, NULL, '2015-04-14 14:16:34', '2015-04-14 14:16:34');

--
-- Dumping data for table `ticket_messages`
--

INSERT INTO `ticket_messages` (`id`, `ticket_id`, `user_id`, `created_at`, `updated_at`, `text`) VALUES
(1, 1, 23, '2015-04-14 14:04:05', '2015-04-14 14:04:05', 'C''est du lait de chèvre.'),
(2, 1, 22, '2015-04-14 14:06:29', '2015-04-14 14:06:29', 'Tu t''y connais vachement en fromage!'),
(3, 1, 23, '2015-04-14 14:07:19', '2015-04-14 14:07:19', 'Non, je m''y connais chèvrement...'),
(4, 1, 21, '2015-04-14 14:08:15', '2015-04-14 14:08:15', 'Vous êtes bourrés d''humour!\r\n\r\nMerci pour l''info!'),
(5, 3, 22, '2015-04-14 14:21:03', '2015-04-14 14:21:03', 'Lorem ipsum dolor sit amet, consectetur viverra fusce.'),
(6, 4, 22, '2015-04-14 14:21:19', '2015-04-14 14:21:19', 'sdf');


--
-- Dumping data for table `users_projects`
--

INSERT INTO `users_projects` (`user_id`, `project_id`) VALUES
(20, 1),
(20, 2),
(21, 3),
(22, 3),
(23, 3);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

--
-- Dumping data for table `ticket_priority`
--

INSERT INTO `ticket_priority` (`id`, `value`, `name`) VALUES (NULL, '10', 'low'), (NULL, '20', 'medium'), (NULL, '30', 'high');
