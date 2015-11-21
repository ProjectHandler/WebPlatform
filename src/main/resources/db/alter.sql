-- Add draft message (guilla_e) (22/10/2015)
ALTER TABLE `users` ADD `draft_message` varchar(500) CHARACTER SET utf8 DEFAULT NULL;

-- use utf8_general_ci (14/11/2015)
ALTER TABLE `groups` CHANGE `name` `name` VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE `project` CHANGE `status` `status` VARCHAR(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;
ALTER TABLE `users` CHANGE `email` `email` VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, 
	CHANGE `phone` `phone` VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL, 
	CHANGE `mobile_phone` `mobile_phone` VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;

-- add ticket_tracker (19/11/2015)
INSERT INTO `ticket_tracker` (`id`, `name`) VALUES
(1, 'Feature'),
(2, 'Bug');

-- Change constaint
ALTER TABLE `users_projects` DROP FOREIGN KEY `users_projects_ibfk_1`;
ALTER TABLE `users_projects` ADD  CONSTRAINT `users_projects_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `project_handler`.`users`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `users_projects` DROP FOREIGN KEY `users_projects_ibfk_2`;
ALTER TABLE `users_projects` ADD  CONSTRAINT `users_projects_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `project_handler`.`project`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `task` DROP FOREIGN KEY `task_project_ibkf`; 
ALTER TABLE `task` ADD CONSTRAINT `task_project_ibkf` FOREIGN KEY (`project_id`) REFERENCES `project_handler`.`project`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `task_messages` DROP FOREIGN KEY `task_messages_ibfk_2`; 
ALTER TABLE `task_messages` ADD CONSTRAINT `task_messages_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `project_handler`.`task`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
	
ALTER TABLE `tokens` DROP FOREIGN KEY `tokens_ibfk_1`; 
ALTER TABLE `tokens` ADD CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `project_handler`.`users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
	
ALTER TABLE `users_projects` DROP FOREIGN KEY `users_projects_ibfk_1`; 
ALTER TABLE `users_projects` ADD CONSTRAINT `users_projects_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `project_handler`.`users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;	
	
ALTER TABLE `subtask` DROP FOREIGN KEY `subtask_ibfk_1`; 
ALTER TABLE `subtask` ADD CONSTRAINT `subtask_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `project_handler`.`task`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `users_tickets` DROP FOREIGN KEY `users_tickets_ibfk_1`; 
ALTER TABLE `users_tickets` ADD CONSTRAINT `users_tickets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `project_handler`.`users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE; 
ALTER TABLE `users_tickets` DROP FOREIGN KEY `users_tickets_ibfk_2`; 
ALTER TABLE `users_tickets` ADD CONSTRAINT `users_tickets_ibfk_2` FOREIGN KEY (`ticket_id`) REFERENCES `project_handler`.`tickets`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;


