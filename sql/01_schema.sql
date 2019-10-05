use `isutrain`;

DROP TABLE IF EXISTS `distance_fare_master`;
CREATE TABLE `distance_fare_master` (
  `distance` double NOT NULL,
  `fare` int unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `fare_master`;
CREATE TABLE `fare_master` (
  `train_class` varchar(100) NOT NULL,
  `seat_class` enum('premium', 'reserved', 'non-reserved') NOT NULL,
  `start_date` datetime NOT NULL,
  `fare_multiplier` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `reservations`;
CREATE TABLE `reservations` (
  `reservation_id` bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` bigint NOT NULL,
  `date` datetime NOT NULL,
  `train_class` varchar(100) NOT NULL,
  `train_name` varchar(100) NOT NULL,
  `departure` varchar(100) NOT NULL,
  `arrival` varchar(100) NOT NULL,
  `status` enum('requesting', 'done', 'rejected') NOT NULL,
  `payment_id` varchar(100) NOT NULL,
  `adult` int NOT NULL,
  `child` int NOT NULL,
  `amount` bigint NOT NULL,
  KEY `user_id` (`user_id`),
  KEY `seats` (`date`, `train_class`, `train_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `seat_master`;
CREATE TABLE `seat_master` (
  `train_class` varchar(100) NOT NULL,
  `car_number` int(11) NOT NULL,
  `seat_column` enum('A', 'B', 'C', 'D', 'E') NOT NULL,
  `seat_row` int(11) NOT NULL,
  `seat_class` enum('premium', 'reserved', 'non-reserved') NOT NULL,
  `is_smoking_seat` tinyint(1) NOT NULL,
  KEY `seats` (`train_class`, `car_number`, `seat_row`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `seat_reservations`;
CREATE TABLE `seat_reservations` (
  `reservation_id` bigint NOT NULL,
  `car_number` int unsigned NOT NULL,
  `seat_row` int unsigned NOT NULL,
  `seat_column` varchar(100) NOT NULL,
   KEY `reserv` (`reservation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `station_master`;
CREATE TABLE `station_master` (
  `id` bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `distance` double NOT NULL,
  `name` varchar(100) NOT NULL UNIQUE,
  `is_stop_express` tinyint(1) NOT NULL,
  `is_stop_semi_express` tinyint(1) NOT NULL,
  `is_stop_local` tinyint(1) NOT NULL,
  KEY `search1` (`distance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `train_master`;
CREATE TABLE `train_master` (
  `date` date NOT NULL,
  `departure_at` time NOT NULL,
  `train_class` varchar(100) NOT NULL,
  `train_name` varchar(100) NOT NULL,
  `start_station` varchar(100) NOT NULL,
  `last_station` varchar(100) NOT NULL,
  `is_nobori` tinyint(1) NOT NULL,
  PRIMARY KEY (`train_name`,`date`),
  KEY `search1` (`date`,`train_class`, `train_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `train_timetable_master`;
CREATE TABLE `train_timetable_master` (
  `date` date NOT NULL,
  `train_class` varchar(100) NOT NULL,
  `train_name` varchar(100) NOT NULL,
  `station` varchar(100) NOT NULL,
  `departure` time NOT NULL,
  `arrival` time NOT NULL,
  KEY `timetable` (`date`,`train_class`,`train_name`,`station`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `email` varchar(300) NOT NULL UNIQUE,
  `salt` varbinary(1024) NOT NULL,
  `super_secure_password` varbinary(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


create unique index train_timetable_master_uniqu
	on train_timetable_master (date, train_class, train_name, station);

create index seat_master3
	on isutrain.seat_master (seat_row, seat_column, train_class, car_number, seat_class, is_smoking_seat);

create index seat_master4
	on isutrain.seat_master (train_class, car_number, seat_column, seat_row, seat_class);

create index seat_master_train_class_car_number_seat_class_index
	on isutrain.seat_master (train_class, car_number, seat_class);

create index seat_reservations_car_number_reservation_id_index
	on isutrain.seat_reservations (car_number, seat_row, seat_column);