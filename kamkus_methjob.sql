USE `your_datebase_name`;

ALTER TABLE `users`
ADD COLUMN `lvl` INT(11) NOT NULL DEFAULT '1' AFTER `phone_number`,
ADD COLUMN `xp` INT(11) NOT NULL DEFAULT '1' AFTER `phone_number`;

INSERT INTO `items` VALUES ('table','Portable Methlab',1,0,1);
INSERT INTO `items` VALUES ('meth','Meth',3,0,1);