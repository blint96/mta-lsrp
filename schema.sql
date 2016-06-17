-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Czas generowania: 11 Sty 2016, 14:07
-- Wersja serwera: 5.5.46-0+deb7u1
-- Wersja PHP: 5.5.30-1~dotdeb+7.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `forum_mta`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `beta_bonus`
--

CREATE TABLE `beta_bonus` (
  `bonus_id` int(11) NOT NULL,
  `bonus_char` int(11) NOT NULL DEFAULT '0',
  `bonus_desc` varchar(128) COLLATE utf8_polish_ci NOT NULL DEFAULT 'brak'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `beta_tracker`
--

CREATE TABLE `beta_tracker` (
  `track_id` int(11) NOT NULL,
  `track_title` varchar(128) COLLATE utf8_polish_ci NOT NULL,
  `track_desc` text COLLATE utf8_polish_ci NOT NULL,
  `track_status` int(3) NOT NULL DEFAULT '0',
  `track_author` varchar(64) COLLATE utf8_polish_ci NOT NULL DEFAULT 'root'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ci_keys`
--

CREATE TABLE `ci_keys` (
  `key_id` int(11) NOT NULL,
  `key_text` varchar(128) COLLATE utf8_polish_ci NOT NULL,
  `key_time` int(20) NOT NULL,
  `key_used` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ci_likes`
--

CREATE TABLE `ci_likes` (
  `like_id` int(11) NOT NULL,
  `like_news` int(11) NOT NULL,
  `like_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ci_materials`
--

CREATE TABLE `ci_materials` (
  `mat_id` int(11) NOT NULL,
  `mat_author` int(11) NOT NULL,
  `mat_time` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ci_messages`
--

CREATE TABLE `ci_messages` (
  `msg_id` int(11) NOT NULL,
  `msg_author` int(11) NOT NULL,
  `msg_text` text COLLATE utf8_polish_ci NOT NULL,
  `msg_timestamp` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ci_online`
--

CREATE TABLE `ci_online` (
  `online_id` int(11) NOT NULL,
  `online_ip` varchar(128) COLLATE utf8_polish_ci NOT NULL,
  `online_timestamp` int(20) NOT NULL,
  `online_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ci_sessions`
--

CREATE TABLE `ci_sessions` (
  `id` varchar(40) COLLATE utf8_polish_ci NOT NULL,
  `ip_address` varchar(45) COLLATE utf8_polish_ci NOT NULL,
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `data` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ci_updates`
--

CREATE TABLE `ci_updates` (
  `up_id` int(11) NOT NULL,
  `up_author` int(11) NOT NULL,
  `up_time` int(20) NOT NULL,
  `up_title` varchar(256) COLLATE utf8_polish_ci NOT NULL,
  `up_content` text COLLATE utf8_polish_ci NOT NULL,
  `up_published` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_3dlabels`
--

CREATE TABLE `lsrp_3dlabels` (
  `label_uid` int(11) NOT NULL,
  `label_desc` varchar(128) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `label_color` decimal(10,0) NOT NULL,
  `label_posx` float NOT NULL,
  `label_posy` float NOT NULL,
  `label_posz` float NOT NULL,
  `label_drawdist` float NOT NULL,
  `label_world` mediumint(6) NOT NULL,
  `label_interior` smallint(3) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_abouts`
--

CREATE TABLE `lsrp_abouts` (
  `about_uid` int(10) NOT NULL,
  `about_owner` int(10) NOT NULL DEFAULT '0',
  `about_content` varchar(128) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT 'Error',
  `about_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT 'Error'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_access`
--

CREATE TABLE `lsrp_access` (
  `access_uid` int(11) NOT NULL,
  `access_model` mediumint(6) NOT NULL,
  `access_bone` tinyint(2) NOT NULL,
  `access_posx` float NOT NULL,
  `access_posy` float NOT NULL,
  `access_posz` float NOT NULL,
  `access_rotx` float NOT NULL,
  `access_roty` float NOT NULL,
  `access_rotz` float NOT NULL,
  `access_scalex` float NOT NULL,
  `access_scaley` float NOT NULL,
  `access_scalez` float NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_anim`
--

CREATE TABLE `lsrp_anim` (
  `anim_uid` smallint(5) UNSIGNED NOT NULL,
  `anim_command` varchar(12) COLLATE utf8_unicode_ci NOT NULL DEFAULT '.none',
  `anim_lib` varchar(16) COLLATE utf8_unicode_ci NOT NULL,
  `anim_name` varchar(24) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'none',
  `anim_speed` float NOT NULL,
  `anim_loop` tinyint(1) NOT NULL DEFAULT '0',
  `anim_position` tinyint(1) NOT NULL DEFAULT '0',
  `anim_edit` int(1) NOT NULL DEFAULT '0' COMMENT 'Tymczasowa tabela, to tylko do ewidencji animacji',
  `anim_freeze` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_busstops`
--

CREATE TABLE `lsrp_busstops` (
  `busstop_uid` int(11) NOT NULL,
  `busstop_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `busstop_posx` float NOT NULL,
  `busstop_posy` float NOT NULL,
  `busstop_posz` float NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_cars`
--

CREATE TABLE `lsrp_cars` (
  `car_uid` int(11) NOT NULL,
  `car_model` smallint(3) NOT NULL,
  `car_name` varchar(24) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT 'BRAK',
  `car_posx` float NOT NULL,
  `car_posy` float NOT NULL,
  `car_posz` float NOT NULL,
  `car_posa` float NOT NULL,
  `car_interior` int(11) NOT NULL DEFAULT '0',
  `car_world` int(11) NOT NULL DEFAULT '0',
  `car_color1` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT '0,0,0',
  `car_color2` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT '0,0,0',
  `car_owner` int(11) NOT NULL,
  `car_ownertype` tinyint(2) NOT NULL,
  `car_health` float NOT NULL DEFAULT '1000',
  `car_visual` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT '0,0,0,0,0,0,0,0,0,0,0,0,0',
  `car_fuel` float NOT NULL,
  `car_fueltype` tinyint(1) NOT NULL DEFAULT '0',
  `car_mileage` float NOT NULL,
  `car_lock` tinyint(1) NOT NULL DEFAULT '0',
  `car_paintjob` tinyint(1) NOT NULL DEFAULT '3',
  `car_blockwheel` mediumint(6) NOT NULL DEFAULT '0',
  `car_access` tinyint(1) NOT NULL DEFAULT '0',
  `car_register` tinyint(1) NOT NULL DEFAULT '0',
  `car_blocked` int(9) NOT NULL DEFAULT '0',
  `car_carfax` float NOT NULL DEFAULT '0',
  `car_ebreak` tinyint(1) NOT NULL DEFAULT '0',
  `car_timeleft` int(24) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_characters`
--

CREATE TABLE `lsrp_characters` (
  `char_uid` int(11) NOT NULL,
  `char_gid` int(11) NOT NULL,
  `char_name` varchar(24) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `char_hours` mediumint(6) NOT NULL DEFAULT '0',
  `char_minutes` tinyint(2) NOT NULL DEFAULT '0',
  `char_skin` smallint(3) NOT NULL,
  `char_health` float NOT NULL DEFAULT '100',
  `char_sex` tinyint(1) NOT NULL,
  `char_birth` mediumint(4) NOT NULL,
  `char_cash` mediumint(6) NOT NULL DEFAULT '1200',
  `char_bankcash` mediumint(6) NOT NULL DEFAULT '0',
  `char_banknumb` int(9) NOT NULL DEFAULT '0',
  `char_warns` tinyint(1) NOT NULL DEFAULT '0',
  `char_int` mediumint(6) NOT NULL,
  `char_vw` mediumint(6) NOT NULL,
  `char_bw` mediumint(6) NOT NULL,
  `char_aj` mediumint(6) NOT NULL DEFAULT '0',
  `char_crash` tinyint(1) NOT NULL DEFAULT '0',
  `char_block` tinyint(1) NOT NULL DEFAULT '0',
  `char_posx` float NOT NULL,
  `char_posy` float NOT NULL,
  `char_posz` float NOT NULL,
  `char_hoteluid` int(11) NOT NULL,
  `char_pdp` tinyint(2) NOT NULL DEFAULT '0',
  `char_documents` smallint(3) NOT NULL DEFAULT '0',
  `char_shooting` float NOT NULL DEFAULT '0',
  `char_dependence` float NOT NULL DEFAULT '0',
  `char_lastpay` mediumint(6) NOT NULL DEFAULT '0',
  `char_job` tinyint(1) NOT NULL DEFAULT '0',
  `char_arrest` tinyint(1) NOT NULL DEFAULT '0',
  `char_arresttime` mediumint(6) NOT NULL DEFAULT '0',
  `char_spawnplace` tinyint(1) NOT NULL DEFAULT '0',
  `char_house` int(11) NOT NULL DEFAULT '0',
  `char_fightstyle` tinyint(2) NOT NULL DEFAULT '4',
  `char_walkanim` smallint(3) NOT NULL DEFAULT '0',
  `char_online` tinyint(1) NOT NULL DEFAULT '0',
  `char_hidden` tinyint(1) NOT NULL,
  `char_bhidden` tinyint(1) NOT NULL DEFAULT '0',
  `char_region` int(1) NOT NULL DEFAULT '1',
  `char_image` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_char_groups`
--

CREATE TABLE `lsrp_char_groups` (
  `uid` int(11) NOT NULL,
  `char_uid` int(11) NOT NULL,
  `group_uid` int(11) NOT NULL,
  `group_perm` mediumint(6) NOT NULL DEFAULT '0',
  `group_title` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT 'Brak',
  `group_payment` smallint(3) NOT NULL DEFAULT '0',
  `group_skin` smallint(3) NOT NULL DEFAULT '0',
  `group_dutytime` smallint(3) NOT NULL DEFAULT '0',
  `group_lastpayment` int(15) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_doors`
--

CREATE TABLE `lsrp_doors` (
  `door_uid` int(11) NOT NULL,
  `door_owner` int(11) NOT NULL DEFAULT '0',
  `door_ownertype` tinyint(2) NOT NULL DEFAULT '0',
  `door_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `door_enterx` float NOT NULL,
  `door_entery` float NOT NULL,
  `door_enterz` float NOT NULL,
  `door_entera` float NOT NULL,
  `door_enterint` int(11) NOT NULL,
  `door_entervw` int(11) NOT NULL,
  `door_exitx` float NOT NULL,
  `door_exity` float NOT NULL,
  `door_exitz` float NOT NULL,
  `door_exita` float NOT NULL,
  `door_exitint` int(11) NOT NULL,
  `door_exitvw` int(11) NOT NULL,
  `door_pickup` smallint(4) NOT NULL DEFAULT '1318',
  `door_lock` tinyint(1) NOT NULL DEFAULT '0',
  `door_audiourl` varchar(128) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `door_enterpay` mediumint(6) NOT NULL DEFAULT '0',
  `door_garage` tinyint(1) NOT NULL DEFAULT '0',
  `door_access` tinyint(1) NOT NULL DEFAULT '0',
  `door_burntime` mediumint(6) NOT NULL DEFAULT '0',
  `door_image` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `door_wood` int(5) NOT NULL DEFAULT '0',
  `door_rock` int(5) NOT NULL DEFAULT '0',
  `door_elock` int(1) NOT NULL DEFAULT '0',
  `door_time` int(5) NOT NULL DEFAULT '12',
  `door_blocked` int(1) NOT NULL DEFAULT '0',
  `door_limit` int(11) NOT NULL DEFAULT '25',
  `door_cost` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_door_defauls`
--

CREATE TABLE `lsrp_door_defauls` (
  `default_id` int(11) NOT NULL,
  `default_dooruid` int(11) NOT NULL DEFAULT '0',
  `default_doorcost` int(11) NOT NULL DEFAULT '100',
  `default_doorname` varchar(64) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT 'Remont',
  `default_checktime` int(32) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_duties`
--

CREATE TABLE `lsrp_duties` (
  `duty_uid` int(9) NOT NULL,
  `duty_type` smallint(2) NOT NULL,
  `duty_typeuid` mediumint(5) NOT NULL,
  `duty_owner` int(9) NOT NULL,
  `duty_start` int(15) NOT NULL,
  `duty_end` int(15) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_groups`
--

CREATE TABLE `lsrp_groups` (
  `group_uid` int(11) NOT NULL,
  `group_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `group_cash` int(11) NOT NULL DEFAULT '0',
  `group_type` smallint(3) NOT NULL DEFAULT '0',
  `group_owner` int(11) NOT NULL,
  `group_value1` int(11) NOT NULL DEFAULT '0',
  `group_value2` int(11) NOT NULL DEFAULT '0',
  `group_dotation` int(11) NOT NULL DEFAULT '0',
  `group_color` varchar(6) NOT NULL DEFAULT 'FFFFFF',
  `group_tag` varchar(4) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT 'NONE',
  `group_activity` int(11) NOT NULL DEFAULT '0',
  `group_image` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `group_lastpay` int(15) NOT NULL,
  `group_value3` int(9) NOT NULL,
  `weap_orders` int(2) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_ingame`
--

CREATE TABLE `lsrp_ingame` (
  `id` int(9) NOT NULL,
  `uid` int(9) NOT NULL,
  `gid` int(9) NOT NULL,
  `tin` int(15) NOT NULL DEFAULT '0',
  `tout` int(15) NOT NULL DEFAULT '0',
  `verbose` varchar(10) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT 'brak'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_items`
--

CREATE TABLE `lsrp_items` (
  `item_uid` int(11) NOT NULL,
  `item_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `item_value1` mediumint(6) NOT NULL,
  `item_value2` mediumint(6) NOT NULL,
  `item_type` tinyint(2) NOT NULL,
  `item_posx` float NOT NULL,
  `item_posy` float NOT NULL,
  `item_posz` float NOT NULL,
  `item_place` tinyint(2) NOT NULL,
  `item_owner` int(11) NOT NULL,
  `item_world` mediumint(6) NOT NULL,
  `item_used` tinyint(1) NOT NULL,
  `item_vehuid` int(11) NOT NULL,
  `item_weight` float NOT NULL DEFAULT '0',
  `item_desc` varchar(128) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL DEFAULT 'Brak Opisu'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_materials`
--

CREATE TABLE `lsrp_materials` (
  `mat_id` int(11) NOT NULL,
  `mat_objectuid` int(11) NOT NULL,
  `mat_texturename` varchar(128) COLLATE utf8_polish_ci NOT NULL,
  `mat_textureuid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_members`
--

CREATE TABLE `lsrp_members` (
  `user_id` int(11) NOT NULL,
  `user_login` varchar(32) COLLATE utf8_polish_ci NOT NULL,
  `user_name` varchar(32) COLLATE utf8_polish_ci NOT NULL,
  `user_mail` text COLLATE utf8_polish_ci NOT NULL,
  `user_salt` varchar(32) COLLATE utf8_polish_ci NOT NULL,
  `user_passhash` varchar(64) COLLATE utf8_polish_ci NOT NULL,
  `user_admin` int(3) NOT NULL DEFAULT '0',
  `user_premium` int(20) NOT NULL DEFAULT '0',
  `user_gamepoints` int(11) NOT NULL DEFAULT '0',
  `user_color` int(3) NOT NULL DEFAULT '0',
  `user_active` int(1) NOT NULL DEFAULT '0',
  `user_beta_access` int(3) NOT NULL DEFAULT '0',
  `user_desc` text COLLATE utf8_polish_ci NOT NULL,
  `user_showtags` int(2) NOT NULL DEFAULT '0' COMMENT 'JeÅ›li 1 to widzi wÅ‚asny nick, jeÅ›li 0 to nie widzi wÅ‚asnego nicku.',
  `user_shaders` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_objects`
--

CREATE TABLE `lsrp_objects` (
  `object_uid` int(11) NOT NULL,
  `object_model` mediumint(6) NOT NULL,
  `object_posx` float NOT NULL,
  `object_posy` float NOT NULL,
  `object_posz` float NOT NULL,
  `object_rotx` float NOT NULL,
  `object_roty` float NOT NULL,
  `object_rotz` float NOT NULL,
  `object_world` mediumint(6) NOT NULL,
  `object_interior` smallint(3) NOT NULL,
  `object_distance` float NOT NULL DEFAULT '200',
  `object_gatex` float NOT NULL DEFAULT '0',
  `object_gatey` float NOT NULL DEFAULT '0',
  `object_gatez` float NOT NULL DEFAULT '0',
  `object_gate` tinyint(1) NOT NULL DEFAULT '0',
  `object_group` varchar(50) COLLATE utf8_polish_ci NOT NULL,
  `object_gaterotx` float NOT NULL,
  `object_gateroty` float NOT NULL,
  `object_gaterotz` float NOT NULL,
  `object_owner` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_orders`
--

CREATE TABLE `lsrp_orders` (
  `order_uid` int(11) NOT NULL,
  `order_price` mediumint(6) NOT NULL,
  `order_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `order_type` smallint(2) NOT NULL,
  `order_ownertype` tinyint(1) NOT NULL DEFAULT '0',
  `order_owner` int(11) NOT NULL DEFAULT '0',
  `order_itemtype` tinyint(2) NOT NULL DEFAULT '0',
  `order_itemvalue1` mediumint(6) NOT NULL,
  `order_itemvalue2` mediumint(6) NOT NULL,
  `order_secured` tinyint(1) NOT NULL DEFAULT '0',
  `order_limited` int(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_orders_cat`
--

CREATE TABLE `lsrp_orders_cat` (
  `cat_uid` int(11) NOT NULL,
  `cat_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_packages`
--

CREATE TABLE `lsrp_packages` (
  `package_uid` int(11) NOT NULL,
  `package_dooruid` int(11) NOT NULL,
  `package_itemname` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `package_itemtype` tinyint(2) NOT NULL,
  `package_itemvalue1` mediumint(6) NOT NULL,
  `package_itemvalue2` mediumint(6) NOT NULL,
  `package_itemnumber` smallint(3) NOT NULL,
  `package_itemprice` mediumint(6) NOT NULL,
  `package_secured` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_phone_contacts`
--

CREATE TABLE `lsrp_phone_contacts` (
  `phone_index` int(11) NOT NULL,
  `phone_id` int(11) NOT NULL,
  `phone_desc` varchar(64) COLLATE utf8_polish_ci NOT NULL DEFAULT 'Nowy kontakt',
  `phone_numb` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_products`
--

CREATE TABLE `lsrp_products` (
  `product_uid` int(11) NOT NULL,
  `product_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `product_type` tinyint(2) NOT NULL,
  `product_value1` mediumint(6) NOT NULL,
  `product_value2` mediumint(6) NOT NULL,
  `product_price` mediumint(6) NOT NULL,
  `product_number` smallint(3) NOT NULL,
  `product_dooruid` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lsrp_punish`
--

CREATE TABLE `lsrp_punish` (
  `punish_id` int(11) NOT NULL,
  `punish_type` int(3) NOT NULL DEFAULT '0',
  `punish_owneruid` int(11) NOT NULL DEFAULT '0',
  `punish_giveruid` int(11) NOT NULL DEFAULT '0',
  `punish_reason` varchar(256) COLLATE utf8_polish_ci NOT NULL DEFAULT 'Brak',
  `punish_end` int(20) NOT NULL DEFAULT '0',
  `punish_date` int(20) NOT NULL DEFAULT '0',
  `punish_serial` varchar(128) COLLATE utf8_polish_ci NOT NULL,
  `punish_ip` varchar(64) COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `panel_changes`
--

CREATE TABLE `panel_changes` (
  `change_id` int(5) NOT NULL,
  `change_author` int(5) NOT NULL,
  `change_time` int(15) NOT NULL,
  `change_desc` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `panel_facebook`
--

CREATE TABLE `panel_facebook` (
  `id` int(11) NOT NULL,
  `text` text COLLATE utf8_polish_ci NOT NULL,
  `url` text COLLATE utf8_polish_ci NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `panel_news`
--

CREATE TABLE `panel_news` (
  `id` int(11) NOT NULL,
  `author` int(11) NOT NULL,
  `title` text COLLATE utf8_polish_ci NOT NULL,
  `text` text COLLATE utf8_polish_ci NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `publish` int(1) NOT NULL DEFAULT '0',
  `views` int(9) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `panel_news_comments`
--

CREATE TABLE `panel_news_comments` (
  `id` int(9) NOT NULL,
  `parent` int(9) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `text` text COLLATE utf8_polish_ci NOT NULL,
  `author` int(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `panel_youtube`
--

CREATE TABLE `panel_youtube` (
  `id` int(11) NOT NULL,
  `title` text COLLATE utf8_polish_ci NOT NULL,
  `thumbnail` text COLLATE utf8_polish_ci NOT NULL,
  `video_id` text COLLATE utf8_polish_ci NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `server_startup`
--

CREATE TABLE `server_startup` (
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indexes for table `beta_bonus`
--
ALTER TABLE `beta_bonus`
  ADD PRIMARY KEY (`bonus_id`);

--
-- Indexes for table `beta_tracker`
--
ALTER TABLE `beta_tracker`
  ADD PRIMARY KEY (`track_id`);

--
-- Indexes for table `ci_keys`
--
ALTER TABLE `ci_keys`
  ADD PRIMARY KEY (`key_id`);

--
-- Indexes for table `ci_likes`
--
ALTER TABLE `ci_likes`
  ADD PRIMARY KEY (`like_id`);

--
-- Indexes for table `ci_materials`
--
ALTER TABLE `ci_materials`
  ADD PRIMARY KEY (`mat_id`);

--
-- Indexes for table `ci_messages`
--
ALTER TABLE `ci_messages`
  ADD PRIMARY KEY (`msg_id`);

--
-- Indexes for table `ci_online`
--
ALTER TABLE `ci_online`
  ADD PRIMARY KEY (`online_id`);

--
-- Indexes for table `ci_sessions`
--
ALTER TABLE `ci_sessions`
  ADD KEY `ci_sessions_timestamp` (`timestamp`);

--
-- Indexes for table `ci_updates`
--
ALTER TABLE `ci_updates`
  ADD PRIMARY KEY (`up_id`);

--
-- Indexes for table `lsrp_3dlabels`
--
ALTER TABLE `lsrp_3dlabels`
  ADD PRIMARY KEY (`label_uid`);

--
-- Indexes for table `lsrp_abouts`
--
ALTER TABLE `lsrp_abouts`
  ADD PRIMARY KEY (`about_uid`);

--
-- Indexes for table `lsrp_access`
--
ALTER TABLE `lsrp_access`
  ADD PRIMARY KEY (`access_uid`);

--
-- Indexes for table `lsrp_anim`
--
ALTER TABLE `lsrp_anim`
  ADD PRIMARY KEY (`anim_uid`);

--
-- Indexes for table `lsrp_busstops`
--
ALTER TABLE `lsrp_busstops`
  ADD PRIMARY KEY (`busstop_uid`);

--
-- Indexes for table `lsrp_cars`
--
ALTER TABLE `lsrp_cars`
  ADD PRIMARY KEY (`car_uid`);

--
-- Indexes for table `lsrp_characters`
--
ALTER TABLE `lsrp_characters`
  ADD PRIMARY KEY (`char_uid`),
  ADD KEY `char_name` (`char_name`);

--
-- Indexes for table `lsrp_char_groups`
--
ALTER TABLE `lsrp_char_groups`
  ADD PRIMARY KEY (`uid`);

--
-- Indexes for table `lsrp_doors`
--
ALTER TABLE `lsrp_doors`
  ADD PRIMARY KEY (`door_uid`);

--
-- Indexes for table `lsrp_door_defauls`
--
ALTER TABLE `lsrp_door_defauls`
  ADD PRIMARY KEY (`default_id`);

--
-- Indexes for table `lsrp_duties`
--
ALTER TABLE `lsrp_duties`
  ADD PRIMARY KEY (`duty_uid`);

--
-- Indexes for table `lsrp_groups`
--
ALTER TABLE `lsrp_groups`
  ADD PRIMARY KEY (`group_uid`);

--
-- Indexes for table `lsrp_ingame`
--
ALTER TABLE `lsrp_ingame`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lsrp_items`
--
ALTER TABLE `lsrp_items`
  ADD PRIMARY KEY (`item_uid`),
  ADD KEY `owner_place_index` (`item_place`,`item_owner`);

--
-- Indexes for table `lsrp_materials`
--
ALTER TABLE `lsrp_materials`
  ADD PRIMARY KEY (`mat_id`);

--
-- Indexes for table `lsrp_members`
--
ALTER TABLE `lsrp_members`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `lsrp_objects`
--
ALTER TABLE `lsrp_objects`
  ADD PRIMARY KEY (`object_uid`),
  ADD KEY `object_world` (`object_world`);

--
-- Indexes for table `lsrp_orders`
--
ALTER TABLE `lsrp_orders`
  ADD PRIMARY KEY (`order_uid`);

--
-- Indexes for table `lsrp_orders_cat`
--
ALTER TABLE `lsrp_orders_cat`
  ADD PRIMARY KEY (`cat_uid`);

--
-- Indexes for table `lsrp_packages`
--
ALTER TABLE `lsrp_packages`
  ADD PRIMARY KEY (`package_uid`);

--
-- Indexes for table `lsrp_phone_contacts`
--
ALTER TABLE `lsrp_phone_contacts`
  ADD PRIMARY KEY (`phone_index`);

--
-- Indexes for table `lsrp_products`
--
ALTER TABLE `lsrp_products`
  ADD PRIMARY KEY (`product_uid`);

--
-- Indexes for table `lsrp_punish`
--
ALTER TABLE `lsrp_punish`
  ADD PRIMARY KEY (`punish_id`);

--
-- Indexes for table `panel_changes`
--
ALTER TABLE `panel_changes`
  ADD PRIMARY KEY (`change_id`);

--
-- Indexes for table `panel_facebook`
--
ALTER TABLE `panel_facebook`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `panel_news`
--
ALTER TABLE `panel_news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `panel_news_comments`
--
ALTER TABLE `panel_news_comments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `panel_youtube`
--
ALTER TABLE `panel_youtube`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `beta_bonus`
--
ALTER TABLE `beta_bonus`
  MODIFY `bonus_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;
--
-- AUTO_INCREMENT dla tabeli `beta_tracker`
--
ALTER TABLE `beta_tracker`
  MODIFY `track_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT dla tabeli `ci_keys`
--
ALTER TABLE `ci_keys`
  MODIFY `key_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=558;
--
-- AUTO_INCREMENT dla tabeli `ci_likes`
--
ALTER TABLE `ci_likes`
  MODIFY `like_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;
--
-- AUTO_INCREMENT dla tabeli `ci_materials`
--
ALTER TABLE `ci_materials`
  MODIFY `mat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT dla tabeli `ci_messages`
--
ALTER TABLE `ci_messages`
  MODIFY `msg_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=694;
--
-- AUTO_INCREMENT dla tabeli `ci_online`
--
ALTER TABLE `ci_online`
  MODIFY `online_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2747;
--
-- AUTO_INCREMENT dla tabeli `ci_updates`
--
ALTER TABLE `ci_updates`
  MODIFY `up_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT dla tabeli `lsrp_3dlabels`
--
ALTER TABLE `lsrp_3dlabels`
  MODIFY `label_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1793;
--
-- AUTO_INCREMENT dla tabeli `lsrp_abouts`
--
ALTER TABLE `lsrp_abouts`
  MODIFY `about_uid` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29805;
--
-- AUTO_INCREMENT dla tabeli `lsrp_access`
--
ALTER TABLE `lsrp_access`
  MODIFY `access_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51627;
--
-- AUTO_INCREMENT dla tabeli `lsrp_anim`
--
ALTER TABLE `lsrp_anim`
  MODIFY `anim_uid` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=466;
--
-- AUTO_INCREMENT dla tabeli `lsrp_busstops`
--
ALTER TABLE `lsrp_busstops`
  MODIFY `busstop_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;
--
-- AUTO_INCREMENT dla tabeli `lsrp_cars`
--
ALTER TABLE `lsrp_cars`
  MODIFY `car_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29366;
--
-- AUTO_INCREMENT dla tabeli `lsrp_characters`
--
ALTER TABLE `lsrp_characters`
  MODIFY `char_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27012;
--
-- AUTO_INCREMENT dla tabeli `lsrp_char_groups`
--
ALTER TABLE `lsrp_char_groups`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1842;
--
-- AUTO_INCREMENT dla tabeli `lsrp_doors`
--
ALTER TABLE `lsrp_doors`
  MODIFY `door_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7778;
--
-- AUTO_INCREMENT dla tabeli `lsrp_door_defauls`
--
ALTER TABLE `lsrp_door_defauls`
  MODIFY `default_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=771;
--
-- AUTO_INCREMENT dla tabeli `lsrp_duties`
--
ALTER TABLE `lsrp_duties`
  MODIFY `duty_uid` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
--
-- AUTO_INCREMENT dla tabeli `lsrp_groups`
--
ALTER TABLE `lsrp_groups`
  MODIFY `group_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1535;
--
-- AUTO_INCREMENT dla tabeli `lsrp_ingame`
--
ALTER TABLE `lsrp_ingame`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT dla tabeli `lsrp_items`
--
ALTER TABLE `lsrp_items`
  MODIFY `item_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=287568;
--
-- AUTO_INCREMENT dla tabeli `lsrp_materials`
--
ALTER TABLE `lsrp_materials`
  MODIFY `mat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT dla tabeli `lsrp_members`
--
ALTER TABLE `lsrp_members`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=143072;
--
-- AUTO_INCREMENT dla tabeli `lsrp_objects`
--
ALTER TABLE `lsrp_objects`
  MODIFY `object_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128202;
--
-- AUTO_INCREMENT dla tabeli `lsrp_orders`
--
ALTER TABLE `lsrp_orders`
  MODIFY `order_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=718;
--
-- AUTO_INCREMENT dla tabeli `lsrp_orders_cat`
--
ALTER TABLE `lsrp_orders_cat`
  MODIFY `cat_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;
--
-- AUTO_INCREMENT dla tabeli `lsrp_packages`
--
ALTER TABLE `lsrp_packages`
  MODIFY `package_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24466;
--
-- AUTO_INCREMENT dla tabeli `lsrp_phone_contacts`
--
ALTER TABLE `lsrp_phone_contacts`
  MODIFY `phone_index` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71284;
--
-- AUTO_INCREMENT dla tabeli `lsrp_products`
--
ALTER TABLE `lsrp_products`
  MODIFY `product_uid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=965;
--
-- AUTO_INCREMENT dla tabeli `lsrp_punish`
--
ALTER TABLE `lsrp_punish`
  MODIFY `punish_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57371;
--
-- AUTO_INCREMENT dla tabeli `panel_changes`
--
ALTER TABLE `panel_changes`
  MODIFY `change_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;
--
-- AUTO_INCREMENT dla tabeli `panel_facebook`
--
ALTER TABLE `panel_facebook`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT dla tabeli `panel_news`
--
ALTER TABLE `panel_news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT dla tabeli `panel_news_comments`
--
ALTER TABLE `panel_news_comments`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;
--
-- AUTO_INCREMENT dla tabeli `panel_youtube`
--
ALTER TABLE `panel_youtube`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
