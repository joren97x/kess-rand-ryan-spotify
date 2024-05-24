-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 24, 2024 at 06:30 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `spotify-chat`
--

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `message` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `user_id`, `type`, `message`, `created_at`, `deleted_at`) VALUES
(1, 9, 0, 'wsg chat', '2024-05-10 08:11:13', NULL),
(2, 10, 0, 'yauuur chatt', '2024-05-10 08:11:30', NULL),
(3, 10, 1, 'hahaha', '2024-05-10 08:11:39', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `password`) VALUES
(9, 'joren', 'joren', '$2b$10$/efcTvRCRewWPDLkntDM0eBwDZalVa2yCuma2jX3enyFXqOAxM.mW'),
(10, 'chaewon', 'chaewon', '$2b$10$dxfgA0qyW6q5q8iF4fMVQefFkzlf2EupWe01m1BPpQ9YHC4mspu7S'),
(11, 'Daniel Caesar', 'daniel97x', '$2b$10$itaZwqHoVjZGBJJPI3e3dO2kZHvhxnwl9xr3A2v23rOadZoQnCjra'),
(12, 'illit', 'illit', '$2b$10$xeg6fIdy7IwaS8fnS44nOuGp59OqrYTBwapCzo03CBwBRCcSnGQJO'),
(13, 'sir ken', 'ken', '$2b$10$o6Y7vCckdClP.lZk2MyNhOse0WFBD7ZFLA.3fT48AJfA15/D9IeCG'),
(14, 'lysa', 'lysa', '$2b$10$ph97Q86RLZFLOd2/6UWbCuQODEswY655VYpDut/vVCkq.E4QtmX.W'),
(15, 'lysa', 'lysa', '$2b$10$dn698AjIoOEQM5P2QKs1NeXkeM1EhCmBqK72garawZM0ogADSTnM2'),
(16, 'sorry', 'sorry', '$2b$10$ChZI0hKL6zRAPBgdLat1H.aB3FEkazrUlR/bQQDV86JYqu78oaP9q'),
(17, 'sorry', 'sorry', '$2b$10$ovPVExiB0BvOVJEtU0/mEOLEsSvKth.UYOVjVjfnxjJGGfFDqXPLq');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
