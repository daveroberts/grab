require './app/database/database.rb'

module DBMigrations
  # Adds scrapes to DB
  class Scrapes
    def self.up
      db = DB.raw_connection
      sql = "CREATE TABLE `scrapes` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `name` VARCHAR(255) NOT NULL,
        `created_at` DATETIME NOT NULL,
        UNIQUE KEY `id` (`id`),
        INDEX `id_index` (`id`),
        UNIQUE KEY `name` (`name`),
        INDEX `name_index` (`name`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
      sql = "CREATE TABLE `images` (
        `auto_id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `id` VARCHAR(255) NOT NULL,
        `data` LONGBLOB NOT NULL,
        `summary` VARCHAR(255) NOT NULL,
        `full_image_id` VARCHAR(255),
        `x_resolution` INT NOT NULL,
        `y_resolution` INT NOT NULL,
        `created_at` DATETIME NOT NULL,
        INDEX `id_index` (`id`),
        INDEX `full_image_id_index` (`full_image_id`),
        INDEX `summary_index` (`summary`),
        INDEX `resolution_index` (`x_resolution`, `y_resolution`),
        INDEX `created_at_index` (`created_at`)
      )"
      db.query(sql)
    end
  end
end
