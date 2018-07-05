class Orderbook < ApplicationRecord
  self.abstract_class     = true
  self.inheritance_column = :none

  class << self
    def [](ask_unit, bid_unit)
      "::Orderbook::#{ask_unit.upcase}#{bid_unit.upcase}".safe_constantize || \
        (create_table(ask_unit, bid_unit) && create_model(ask_unit, bid_unit))
    end

    def create_table(ask_unit, bid_unit)
      connection.execute <<-SQL
        CREATE TABLE IF NOT EXISTS `orderbook_#{ask_unit.downcase}_#{bid_unit.downcase}` (
          `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
          `uid` CHAR(12) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
          `price` DECIMAL(32,16) UNSIGNED NULL DEFAULT NULL,
          `volume` DECIMAL(32,16) UNSIGNED NOT NULL,
          `volume_left` DECIMAL(32,16) UNSIGNED NOT NULL,
          `fee` DECIMAL(32,16) UNSIGNED NOT NULL DEFAULT '0',
          `type` ENUM('ask','bid') CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
          `created_at` DATETIME NOT NULL ,
          `updated_at` DATETIME NOT NULL ,
          PRIMARY KEY (`id`)
        ) ENGINE = InnoDB;
      SQL
      true
    end

    def create_model(ask_unit, bid_unit)
      model = "::Orderbook::#{ask_unit.upcase}#{bid_unit.upcase}"
      instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        class #{model} < ::Orderbook
          self.table_name = "orderbook_#{ask_unit.downcase}_#{bid_unit.downcase}"

          class << self
            def ask_unit
              "#{ask_unit}"
            end

            def bid_unit
              "#{bid_unit}"
            end
          end
        end
        #{model}
      RUBY
    end
  end
end
