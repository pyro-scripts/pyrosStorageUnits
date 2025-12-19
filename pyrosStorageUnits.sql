--                             ______                         __  __     _ __    
--     ___  __ _________  ___ / __/ /____  _______ ____ ____ / / / /__  (_) /____
--    / _ \/ // / __/ _ \(_-<_\ \/ __/ _ \/ __/ _ `/ _ `/ -_) /_/ / _ \/ / __(_-<
--   / .__/\_, /_/  \___/___/___/\__/\___/_/  \_,_/\_, /\__/\____/_//_/_/\__/___/
--  /_/   /___/                                   /___/                          

CREATE TABLE IF NOT EXISTS `storage_units` (
    `id` INT AUTO_INCREMENT,
    `citizenid` VARCHAR(50),
    `facility` VARCHAR(50),
    `unit_name` VARCHAR(50),
    `stash_id` VARCHAR(100),
    `coords` TEXT,
    `rent_expires` INT,
    `last_reminder` INT DEFAULT 0,
    `max_wright` INT NOT NULL,
    PRIMARY KEY (`id`)
);