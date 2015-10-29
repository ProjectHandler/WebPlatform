-- Generation Time: Sep 10, 2015
-- Server version: 5.6.17
-- PHP Version: 5.5.12

-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb2+deb7u1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 27, 2015 at 12:48 AM
-- Server version: 5.5.38
-- PHP Version: 5.4.4-14+deb7u14

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
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
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `password`, `email`, `address`, `phone`, `mobile_phone`, `user_role`, `account_status`, `civility_id`, `work_day`, `daily_hour`, `avatar_file_name`) VALUES
(2, 'Guillard', 'Arthur', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'arthur.guillard@example.com', NULL, '0123456789', '0123456789', 1, 0, 1, 'tttttff', '09:00 AM - 05:00 PM', '2_4a2a6d25-9637-4d93-a81c-134382c0e502.png'),
(3, 'Cyril', 'Fillatre', '$2a$10$/i5TEbxZmgODzVJOmodsH.VWCH.isLvHM7/hEsl.DPQrDUY89zUAy', 'cyril.fillatre@example.com', NULL, '0123456789', '0123456789', 1, 1, 1, 'ttttttf', '09:00 AM - 05:00 PM', '3_ef03093e-deed-4243-97ed-f7d150e80281.jpg'),
(4, 'Lukas', 'Fauser', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'lukas.fauser@example.com', NULL, '0123456789', '0123456789', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '4_27f215c6-9c92-40ee-9065-3f9fb831ff52.png'),
(5, 'Guillaume', 'Roncari', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'guillaume.roncari@example.com', NULL, '0101020304', '0102030405', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '5_5bd1238d-3b04-4886-9129-64873e2e7a8e.png'),
(6, 'Paul', 'Peyrefitte', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'paul.peyrefitte@example.com', NULL, '0101020304', '0102030405', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '6_e5cb6525-d2f8-4a10-bc21-c84107c3f5a5.png'),
(7, 'Cortex', 'CORTEX', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'cortex@example.com', NULL, '0123456789', '0123456789', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '7_5f1aa936-fee2-4a14-ab8c-a8ea99134b74.jpg'),
(8, 'Minus', 'MINUS', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'minus@example.com', NULL, '0123456789', '0123456789', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', '8_8fb621b5-872c-4ab9-b9ab-1bc37ef18415.jpg'),
(51, 'test', 'test', '$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG', 'test@test.com', NULL, '0101020304', '0102030405', 1, 1, 1, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(52, NULL, NULL, NULL, 'test2@example.com', NULL, NULL, NULL, 1, 0, NULL, 'tttttff', '09:00 AM - 05:00 PM', NULL),
(53, NULL, NULL, NULL, 'test3@example.com', NULL, NULL, NULL, 1, 2, NULL, 'tttttff', '09:00 AM - 05:00 PM', NULL);


-- --------------------------------------------------------

--
-- Dumping data for table `event`
--

INSERT INTO `event` (`id`, `title`, `description`, `starting_date`, `ending_date`, `status`) VALUES
(3, 'Reunion après dej.', 'Steering Commitee', '2015-10-13 13:00:00', '2015-10-13 15:00:00', NULL);

-- --------------------------------------------------------

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`id`, `name`) VALUES
(1, 'group test'),
(2, 'Développeur'),
(3, 'Minus et Cortex');

-- --------------------------------------------------------

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`id`, `name`, `progress`, `description`, `duration`, `date_begin`, `date_end`, `status`) VALUES
(5, 'Project Handler', 60, 'Solution logicielle collaborative, open source et gratuite, visant les petites structure (PME, ...) .\n', 546, '2014-09-01', '2016-10-19', 'STATUS_ACTIVE'),
(6, 'Site vitrine', 100, 'Site vitrine de Project Handler', 72, '2015-02-02', '2015-05-13', 'STATUS_ACTIVE'),
(7, 'Tenter de conquérir le monde !', 0, 'Minus et Cortex veulent conquérir le monde !', 203, '2015-09-04', '2016-03-25', 'STATUS_ACTIVE'),
(26, 'Application Android', 0, 'Application android native de Project Handler', 184, '2015-07-20', '2016-04-05', 'STATUS_ACTIVE'),
(27, 'Application Windows Phone', 0, 'Application Windows Phone native de Project Handler', 105, '2015-09-18', '2016-01-01', 'STATUS_ACTIVE'),
(34, '<b>LOLINTERNET</b>', 0, 'test <a href="http://www.google.fr"> ceci est un lien</a>', 1, '2015-10-22', '2015-10-23', 'STATUS_ACTIVE');


-- --------------------------------------------------------

--
-- Dumping data for table `task`
--

INSERT INTO `task` (`id`, `name`, `progress`, `description`, `level`, `duration`, `starting_date`, `ending_date`, `status`, `project_id`, `row`, `task_priority_id`) VALUES
(75, 'Environnement de développement', 100, 'Installation de l''environnement de développement', 1, 13, '2014-09-01', '2014-09-17', 'STATUS_DONE', 5, 2, NULL),
(76, 'Configuration WAR', 100, 'Configuration pour la création de l''archive web', 1, 13, '2014-09-01', '2014-09-17', 'STATUS_DONE', 5, 3, NULL),
(77, 'Installation Tomcat ', 100, 'Installation Tomcat sur serveur', 1, 13, '2014-09-01', '2014-09-17', 'STATUS_DONE', 5, 4, NULL),
(93, 'v0.1', 100, 'Module de session des utilisateurs', 1, 16, '2014-10-10', '2014-10-31', 'STATUS_DONE', 5, 5, NULL),
(101, 'v0.2', 100, 'Module d''administration des utilisateurs', 1, 2, '2014-11-03', '2014-11-04', 'STATUS_DONE', 5, 6, NULL),
(109, 'v0.3', 100, 'Module sécurité', 1, 14, '2014-11-05', '2014-11-24', 'STATUS_DONE', 5, 7, NULL),
(113, 'v0.4', 100, 'Module de gestion des projets', 1, 150, '2014-11-25', '2015-06-30', 'STATUS_DONE', 5, 8, NULL),
(114, 'database', 100, '', 2, 1, '2014-11-25', '2014-11-25', 'STATUS_DONE', 5, 9, NULL),
(115, 'Model', 100, '', 2, 1, '2014-11-25', '2014-11-25', 'STATUS_DONE', 5, 10, NULL),
(116, 'DAO', 100, '', 2, 1, '2014-11-25', '2014-11-25', 'STATUS_DONE', 5, 11, NULL),
(118, 'Service', 100, '', 2, 1, '2014-11-25', '2014-11-25', 'STATUS_DONE', 5, 12, NULL),
(119, 'Controller', 0, '', 2, 1, '2014-11-25', '2014-11-25', 'STATUS_ACTIVE', 5, 13, NULL),
(120, 'View', 80, '', 2, 1, '2014-11-25', '2014-11-25', 'STATUS_DONE', 5, 14, NULL),
(121, 'Tests', 50, '', 2, 1, '2014-11-25', '2014-11-25', 'STATUS_ACTIVE', 5, 15, NULL),
(122, 'Calendrier de ProjectHandler.', 0, 'Module de gestion des ressources', 1, 151, '2015-06-01', '2015-12-31', 'STATUS_ACTIVE', 5, 16, NULL),
(129, 'Plan', 0, '', 1, 1, '2015-09-04', '2015-09-04', 'STATUS_ACTIVE', 7, 2, NULL),
(130, 'Task 3', 0, '', 1, 1, '2015-09-04', '2015-09-04', 'STATUS_ACTIVE', 7, 3, NULL),
(134, 'Configuration environnement', 100, '', 1, 3, '2015-07-20', '2015-07-22', 'STATUS_DONE', 26, 2, NULL),
(135, 'Authentification ', 100, '', 1, 14, '2015-07-23', '2015-08-11', 'STATUS_DONE', 26, 3, NULL),
(136, 'communication API REST', 100, '', 1, 20, '2015-07-23', '2015-08-19', 'STATUS_DONE', 26, 4, NULL),
(137, 'Project', 100, '', 1, 14, '2015-08-20', '2015-09-08', 'STATUS_DONE', 26, 5, NULL),
(138, 'Task', 100, '', 1, 14, '2015-09-09', '2015-09-28', 'STATUS_DONE', 26, 8, NULL),
(139, 'SubTask', 100, '', 1, 15, '2015-09-29', '2015-10-19', 'STATUS_DONE', 26, 11, NULL),
(140, 'Ticket', 40, '', 1, 30, '2015-10-12', '2015-11-20', 'STATUS_ACTIVE', 26, 15, NULL),
(141, 'Home', 0, '', 1, 14, '2015-11-23', '2015-12-11', 'STATUS_SUSPENDED', 26, 19, NULL),
(143, 'Integration de FullCalendar', 100, 'Fullcalendar plugin extern lisence MIT pour integrer un calendrier sur notre projet', 2, 22, '2015-06-01', '2015-07-01', 'STATUS_DONE', 5, 17, NULL),
(144, 'Création d''évènements', 100, '', 2, 23, '2015-07-02', '2015-08-03', 'STATUS_DONE', 5, 18, NULL),
(145, 'intégration modal jquery UI', 100, '', 2, 41, '2015-11-03', '2015-12-31', 'STATUS_SUSPENDED', 5, 20, NULL),
(146, 'migration évènements sur modal', 100, '', 2, 65, '2015-08-04', '2015-11-02', 'STATUS_ACTIVE', 5, 19, NULL),
(147, 'Liste des projets', 100, '', 2, 10, '2015-08-20', '2015-09-02', 'STATUS_DONE', 26, 6, NULL),
(148, 'Detail des projets', 100, '', 2, 4, '2015-09-03', '2015-09-08', 'STATUS_DONE', 26, 7, NULL),
(150, 'Liste des taches', 100, '', 2, 10, '2015-09-09', '2015-09-22', 'STATUS_DONE', 26, 9, NULL),
(151, 'Detail des taches', 100, '', 2, 4, '2015-09-23', '2015-09-28', 'STATUS_DONE', 26, 10, NULL),
(152, 'Liste des tickets', 100, '', 2, 6, '2015-10-12', '2015-10-19', 'STATUS_DONE', 26, 16, NULL),
(153, 'Detail des tickets', 60, '', 2, 5, '2015-10-20', '2015-10-26', 'STATUS_ACTIVE', 26, 17, NULL),
(154, 'Edition & creation', 0, '', 2, 19, '2015-10-27', '2015-11-20', 'STATUS_ACTIVE', 26, 18, NULL),
(155, 'Vues des pages', 0, '', 1, 70, '2015-06-01', '2015-09-07', 'STATUS_ACTIVE', 5, 21, NULL),
(156, 'Liste des sous taches', 100, '', 2, 4, '2015-09-29', '2015-10-02', 'STATUS_DONE', 26, 12, NULL),
(157, 'validation des taches', 100, '', 2, 6, '2015-10-12', '2015-10-19', 'STATUS_DONE', 26, 14, NULL),
(158, 'Detail des taches', 100, '', 2, 5, '2015-10-05', '2015-10-09', 'STATUS_DONE', 26, 13, NULL),
(159, 'Vue liste Projet', 100, '', 2, 20, '2015-06-03', '2015-06-30', 'STATUS_DONE', 5, 22, NULL),
(160, 'Vue projet', 100, '', 2, 23, '2015-07-01', '2015-07-31', 'STATUS_DONE', 5, 23, NULL),
(161, 'Vue liste de taches', 100, '', 2, 21, '2015-08-03', '2015-08-31', 'STATUS_DONE', 5, 24, NULL),
(162, 'Vue de taches', 50, '', 2, 5, '2015-09-01', '2015-09-07', 'STATUS_ACTIVE', 5, 25, NULL),
(163, 'Liste des users', 50, '', 2, 6, '2015-08-10', '2015-08-17', 'STATUS_ACTIVE', 5, 26, NULL),
(164, 'Activity', 0, '', 1, 79, '2015-09-10', '2015-12-31', 'STATUS_ACTIVE', 5, 27, NULL),
(165, 'recherche web socket', 0, '', 2, 11, '2015-09-10', '2015-09-24', 'STATUS_ACTIVE', 5, 28, NULL),
(166, 'task activity', 0, '', 2, 68, '2015-09-25', '2015-12-31', 'STATUS_ACTIVE', 5, 29, NULL),
(167, 'project activity', 0, '', 2, 68, '2015-09-25', '2015-12-31', 'STATUS_SUSPENDED', 5, 30, NULL),
(173, 'Design', 40, '', 1, 81, '2015-09-04', '2015-12-29', 'STATUS_ACTIVE', 26, 24, NULL),
(174, 'manger tous les enfans', 100, '', 2, 1, '2015-09-04', '2015-09-04', 'STATUS_DONE', 7, 4, NULL),
(175, 'TEST 2', 100, 'Ceci est un test', 2, 15, '2015-10-16', '2015-10-31', 'STATUS_DONE', 7, 4, NULL),
(176, 'Design de la page home', 0, '', 2, 11, '2015-11-23', '2015-12-07', 'STATUS_SUSPENDED', 26, 20, NULL),
(177, 'Module de configuration', 0, '', 1, 14, '2015-12-14', '2016-01-04', 'STATUS_SUSPENDED', 26, 22, NULL),
(178, 'configuration avant le login', 0, 'Aujourd''hui l''application Android est connectée au serveur fourni par Epitech. Pour rendre cette application utilisable sur n''importe quelle machine, nous devons ajouter un moyen de configurer l''adresse du serveur utilisé avant la connexion de l''utilisateur.configurer l''addresse du serveur avant le login de l''utilisateur.', 2, 14, '2015-12-14', '2016-01-04', 'STATUS_SUSPENDED', 26, 23, NULL),
(179, 'Design general de l''app', 0, '', 2, 81, '2015-09-04', '2015-12-29', 'STATUS_ACTIVE', 26, 25, NULL),
(184, 'Draft ?', 0, '', 2, 14, '2015-11-23', '2015-12-11', 'STATUS_SUSPENDED', 26, 21, NULL),
(185, 'SubTask_v2', 0, '', 1, 1, '2015-07-20', '2015-07-20', 'STATUS_SUSPENDED', 26, 26, NULL),
(186, 'Ajouter les messages ???', 0, '', 2, 1, '2015-07-20', '2015-07-20', 'STATUS_SUSPENDED', 26, 27, NULL),
(187, 'Draft', 0, '', 1, 47, '2015-09-25', '2015-11-30', 'STATUS_SUSPENDED', 5, 31, NULL),
(188, 'Ajout du système de draft', 0, 'Le draft doit être accessible depuis toute els pages du projet. C''est un champ de texte libre', 2, 16, '2015-09-25', '2015-10-16', 'STATUS_SUSPENDED', 5, 32, NULL),
(189, 'Framework css', 0, '', 1, 1, '2015-02-02', '2015-02-02', 'STATUS_DONE', 6, 2, NULL),
(190, 'Stucture principale', 0, '', 1, 1, '2015-02-02', '2015-02-02', 'STATUS_ACTIVE', 6, 3, NULL),
(191, 'header & navigation', 0, 'shrinking header with smoothy animations for allthe btn hover', 2, 1, '2015-02-02', '2015-02-02', 'STATUS_ACTIVE', 6, 4, NULL),
(192, 'sections main style', 0, '', 2, 1, '2015-02-02', '2015-02-02', 'STATUS_ACTIVE', 6, 5, NULL),
(193, 'Styling', 0, '', 1, 1, '2015-02-02', '2015-02-02', 'STATUS_SUSPENDED', 6, 6, NULL),
(194, 'section 1', 0, '', 2, 1, '2015-02-02', '2015-02-02', 'STATUS_SUSPENDED', 6, 7, NULL),
(195, 'Section 2', 0, '', 2, 1, '2015-02-02', '2015-02-02', 'STATUS_ACTIVE', 6, 8, NULL),
(196, 'API REST', 0, '', 1, 69, '2015-06-01', '2015-09-04', 'STATUS_ACTIVE', 5, 33, NULL),
(197, 'Authentification', 0, '', 2, 1, '2015-06-01', '2015-06-01', 'STATUS_ACTIVE', 5, 34, NULL),
(198, 'Accès (GET) au ressources', 0, '', 2, 1, '2015-06-01', '2015-06-01', 'STATUS_ACTIVE', 5, 35, NULL),
(200, 'Gestion des droits', 0, '', 2, 1, '2015-06-01', '2015-06-01', 'STATUS_ACTIVE', 5, 36, NULL);

-- --------------------------------------------------------

--
-- Dumping data for table `subtask`
--

INSERT INTO `subtask` (`id`, `description`, `task_id`, `user_id`, `validated`, `taken`, `starting_date`, `ending_date`) VALUES
(1, 'toto', 136, 1, 0, 0, NULL, NULL),
(2, 'plop', 136, 1, 0, 0, NULL, NULL),
(3, 'titi\n', 136, 2, 0, 0, NULL, NULL),
(5, 'sous tache', 118, 1, 1, 0, NULL, NULL),
(7, 'Développement back', 159, 2, 1, 0, NULL, NULL),
(8, 'Développement front', 159, 5, 1, 0, NULL, NULL),
(9, 'Développement front', 160, 5, 1, 0, NULL, NULL),
(10, 'Développement back', 160, 2, 1, 0, NULL, NULL),
(11, 'Développement front', 161, 5, 1, 0, NULL, NULL),
(12, 'Développement back', 161, 2, 1, 0, NULL, NULL),
(13, 'Développement front', 162, 5, 0, 1, NULL, NULL),
(14, 'Développement back', 162, 2, 1, 0, NULL, NULL),
(15, 'Développement front', 163, 5, 1, 0, NULL, NULL),
(16, 'Développement back', 163, 2, 1, 0, NULL, NULL),
(17, 'Regarder comment intégrer spring websocket', 165, 2, 0, 0, NULL, NULL),
(18, 'azerty', 146, 4, 0, 1, NULL, NULL),
(19, 'coucouc', 161, 1, 1, 0, NULL, NULL),
(24, 'metre de la moutarde', 174, 1, 1, 0, NULL, NULL),
(25, 'faire cuire', 174, 1, 1, 0, NULL, NULL),
(26, 'configuration de l''ip', 178, 1, 0, 0, NULL, NULL),
(27, 'Design du system de reply', 154, 1, 0, 0, NULL, NULL),
(28, 'communication serveur pour enregistrer les tickets', 154, 1, 0, 0, NULL, NULL),
(29, 'subtask 1', 114, 1, 1, 0, NULL, NULL),
(31, 'task', 175, 1, 1, 0, NULL, NULL),
(32, 'task 2', 175, 1, 1, 0, NULL, NULL),
(33, 'task 3', 175, 1, 1, 0, NULL, NULL),
(34, 'sous tache', 121, 1, 1, 0, NULL, NULL),
(37, 'header structure', 191, 1, 0, 1, '2015-10-13 09:00:00', '2015-10-13 11:00:00'),
(38, 'header shrinking animation', 191, 1, 0, 1, NULL, NULL),
(39, 'subtask 1', 192, 1, 0, 0, NULL, NULL),
(40, 'subtask 2', 192, 1, 0, 0, NULL, NULL),
(41, 'menu structure', 191, 1, 0, 0, NULL, NULL),
(42, 'btn hover effects', 191, 1, 0, 0, NULL, NULL),
(43, 'test 1', 195, 1, 0, 0, NULL, NULL),
(44, 'test 2', 195, 1, 0, 0, NULL, NULL),
(45, 'test 3', 195, 1, 0, 0, NULL, NULL),
(46, 'Header HTTP Content-Type: application/json ', 198, 6, 0, 0, NULL, NULL),
(48, 'Créer un RestPrecondition\ncf http://www.baeldung.com/2011/10/25/building-a-restful-web-service-with-spring-3-1-and-java-based-configuration-part-2/', 198, 6, 0, 0, NULL, NULL),
(49, 'Return des DTO et pas des strings', 198, 6, 0, 0, NULL, NULL),
(50, 'Renommer les MobileDTO en ApiDTO', 198, 6, 0, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Dumping data for table `task_messages`
--

INSERT INTO `task_messages` (`id`, `user_id`, `update_date`, `task_id`, `content`) VALUES
(1, 1, '2015-09-17 22:44:33', 119, 'lololololoolol'),
(2, 2, '2015-09-17 22:53:49', 121, 'Lukas aime bien manger'),
(3, 1, '2015-10-01 14:38:47', 161, 'fzfzef'),
(4, 1, '2015-10-16 00:52:09', 175, 'Ce soir c''est bon je pense'),
(5, 1, '2015-10-16 00:53:15', 174, 'mais moi j''aime que le ketchup'),
(6, 1, '2015-10-16 10:37:47', 114, 'mon nouveau comm'),
(7, 1, '2015-10-16 10:53:41', 175, 'comm'),
(8, 1, '2015-10-16 14:11:35', 114, 'qsdqd'),
(9, 1, '2015-10-17 15:08:23', 191, 'pb de collision de framework ! j ai ouvert un ticket'),
(10, 1, '2015-10-17 15:09:31', 191, 'attention aux pluggins externes');

-- --------------------------------------------------------

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `title`, `text`, `ticket_status`, `user_id`, `project_id`, `ticket_priority_id`, `ticket_tracker_id`, `created_at`, `updated_at`) VALUES
(14, 'Problème sur css [Vue tâches]', 'Il y a un soucis sur le layout des sous-tache un fois qu''elle sont sauvegarder.\r\nQuand tu ajoute un tâches l espace entre les boutons disparait. \r\n\r\nT''as une idée ?', 1, 2, 5, 5, NULL, '2015-09-18 11:39:01', '2015-09-18 11:39:01'),
(15, 'Bug API Rest', 'Il y a un probleme entre la lib Jackson et Gson ! ', 1, 1, 26, 5, NULL, '2015-10-17 18:04:09', '2015-10-16 12:08:47'),
(16, 'collision de framework', 'pb entre mon framework et bootstap', 1, 1, 6, 6, NULL, '2015-10-16 22:38:44', '2015-10-16 22:38:44'),
(17, 'affichage des images', 'afficher les image en base64 semble poser des soucis', 1, 1, 6, 4, NULL, '2015-10-16 22:39:44', '2015-10-16 22:39:44');

-- --------------------------------------------------------

--
-- Dumping data for table `ticket_messages`
--

INSERT INTO `ticket_messages` (`id`, `ticket_id`, `user_id`, `created_at`, `updated_at`, `text`) VALUES
(28, 14, 5, '2015-09-18 11:40:22', '2015-09-18 11:40:22', 'ok, je pense que c un pb de positioning. je vais check.'),
(30, 15, 3, '2015-10-17 18:06:01', '2015-10-17 18:06:01', 'Les 2 libs ne sont pas compatible :/, il faut choisir entre jackson et gson.'),
(31, 15, 6, '2015-10-17 18:08:09', '2015-10-17 18:08:09', 'Gson est largement utilisé dans le projet. Il est préférable de tout passer en Gson.');


-- --------------------------------------------------------

--
-- Dumping data for table `tokens`
--

INSERT INTO `tokens` (`id`, `token`, `time_stamp`, `user_id`) VALUES
(4, '402445ca-2650-46ee-be9d-a906dab09c63', 1435935436351, 51),
(7, 'f1b6672d-e9e5-409f-8954-dc2e992a2d1a', 1444950094012, 52),
(8, '2ddd41c9-a073-479f-82a8-d98dcdffbeb8', 1444998561660, 53);

-- --------------------------------------------------------

--
-- Dumping data for table `users_events`
--

INSERT INTO `users_events` (`users_id`, `events_id`) VALUES
(1, 3);

-- --------------------------------------------------------

--
-- Dumping data for table `users_groups`
--

INSERT INTO `users_groups` (`users_id`, `groups_id`) VALUES
(1, 1),
(2, 2),
(3, 2),
(4, 2),
(5, 2),
(6, 2),
(52, 2),
(7, 3),
(8, 3);

-- --------------------------------------------------------

--
-- Dumping data for table `users_projects`
--

INSERT INTO `users_projects` (`user_id`, `project_id`) VALUES
(1, 5),
(2, 5),
(3, 5),
(4, 5),
(5, 5),
(6, 5),
(1, 6),
(5, 6),
(1, 7),
(7, 7),
(8, 7),
(1, 26),
(3, 26),
(6, 26),
(1, 27),
(6, 27),
(1, 34),
(3, 34),
(4, 34),
(6, 34);

-- --------------------------------------------------------

--
-- Dumping data for table `users_tasks`
--

INSERT INTO `users_tasks` (`users_id`, `tasks_id`) VALUES
(2, 118),
(4, 122),
(3, 134),
(3, 135),
(3, 136),
(6, 136),
(3, 137),
(3, 138),
(6, 138),
(3, 139),
(3, 140),
(3, 141),
(4, 143),
(4, 144),
(4, 145),
(4, 146),
(3, 147),
(3, 148),
(3, 150),
(6, 150),
(3, 151),
(3, 152),
(3, 153),
(3, 154),
(6, 154),
(3, 156),
(3, 157),
(3, 158),
(2, 159),
(5, 159),
(2, 160),
(5, 160),
(2, 161),
(5, 161),
(2, 162),
(2, 163),
(2, 165),
(2, 166),
(2, 167),
(3, 173),
(1, 175),
(7, 175),
(8, 175),
(3, 176),
(3, 177),
(3, 178),
(3, 179),
(1, 188),
(2, 188),
(3, 188),
(4, 188),
(5, 188),
(6, 188);

-- --------------------------------------------------------

--
-- Dumping data for table `users_tickets`
--

INSERT INTO `users_tickets` (`user_id`, `ticket_id`) VALUES
(2, 14),
(5, 14),
(5, 16),
(5, 17);

-- --------------------------------------------------------

--
-- Dumping data for table `depend_tasks`
--

INSERT INTO `depend_tasks` (`task_id1`, `task_id2`) VALUES
(135, 134),
(136, 134),
(137, 135),
(137, 136),
(138, 137),
(139, 138),
(141, 139),
(141, 140),
(177, 141),
(144, 143),
(146, 144),
(145, 146),
(148, 147),
(151, 150),
(153, 152),
(154, 153),
(158, 156),
(157, 158),
(160, 159),
(161, 160),
(162, 161),
(166, 165),
(167, 165);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
