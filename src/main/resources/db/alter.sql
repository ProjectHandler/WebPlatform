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
