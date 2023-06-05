-- Database export via SQLPro (https://www.sqlprostudio.com/allapps.html)
-- Exported by overlord at 22-06-2022 16:05.
-- WARNING: This file may contain descructive statements such as DROPs.
-- Please ensure that you are running the script at the proper location.
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

-- BEGIN TABLE public.auditoriums
DROP TABLE IF EXISTS public.auditoriums CASCADE;

CREATE SEQUENCE IF NOT EXISTS public.auditoriums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE IF NOT EXISTS public.auditoriums (
	id bigint DEFAULT nextval('auditoriums_id_seq'::regclass) NOT NULL,
	name text,
	cinema_id text,
	no_seats bigint,
	"rows" bigint,
	columns bigint,
	created_at timestamp with time zone,
	PRIMARY KEY(id)
);



-- Inserting 3 rows into public.auditoriums
-- Insert batch #1
INSERT INTO public.auditoriums (id, name, cinema_id, no_seats, "rows", columns, created_at) VALUES
(3, 'Audi 1', 'd6fbf6b2-2090-4580-b2b5-3bb8d710d396', 60, 10, 9, '2022-05-28 08:23:53+00'),
(1, 'Audi 1', 'af367117-be73-40e3-bdbd-1161a4b60eda', 50, 11, 10, '2022-05-28 08:23:25+00'),
(2, 'Audi 2', 'af367117-be73-40e3-bdbd-1161a4b60eda', 45, 8, 7, '2022-05-28 08:23:38+00');

-- END TABLE public.auditoriums

-- BEGIN TABLE public.bookings
DROP TABLE IF EXISTS public.bookings CASCADE;

CREATE SEQUENCE IF NOT EXISTS public.bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE IF NOT EXISTS public.bookings (
	id bigint DEFAULT nextval('bookings_id_seq'::regclass) NOT NULL,
	transaction_id uuid DEFAULT uuid_generate_v4(),
	user_id text,
	seat_id bigint,
	screening_id bigint,
	status bigint,
	created_at timestamp with time zone,
	PRIMARY KEY(id)
);

-- END TABLE public.bookings

-- BEGIN TABLE public.cinemas
DROP TABLE IF EXISTS public.cinemas CASCADE;


CREATE TABLE IF NOT EXISTS public.cinemas (
	id uuid DEFAULT uuid_generate_v4() NOT NULL,
	name text,
	address text,
	created_at timestamp with time zone,
	PRIMARY KEY(id)
);


-- Inserting 2 rows into public.cinemas
-- Insert batch #1
INSERT INTO public.cinemas (id, name, address, created_at) VALUES
('af367117-be73-40e3-bdbd-1161a4b60eda', 'QFT Labim Mall', 'Pulchowk, Lalitpur', '2022-05-28 08:20:09+00'),
('d6fbf6b2-2090-4580-b2b5-3bb8d710d396', 'QFT Bhaktapur', 'Bhaktapur, Bagmati', '2022-05-28 08:20:41+00');

-- END TABLE public.cinemas

-- BEGIN TABLE public.logs
DROP TABLE IF EXISTS public.logs CASCADE;


CREATE TABLE IF NOT EXISTS public.logs (
	event_type text,
	email text,
	meta_data jsonb,
	id uuid DEFAULT uuid_generate_v4() NOT NULL,
	created_at timestamp with time zone,
	updated_at timestamp with time zone,
	deleted_at timestamp with time zone
);
-- END TABLE public.logs

-- BEGIN TABLE public.movies
DROP TABLE IF EXISTS public.movies CASCADE;


CREATE TABLE IF NOT EXISTS public.movies (
	id uuid DEFAULT uuid_generate_v4() NOT NULL,
	name text,
	description text,
	banner text,
	trailer text,
	length bigint,
	release_date timestamp with time zone,
	created_at timestamp with time zone,
	PRIMARY KEY(id)
);


-- Inserting 3 rows into public.movies
-- Insert batch #1
INSERT INTO public.movies (id, name, description, banner, trailer, length, release_date, created_at) VALUES
('03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b', 'Bhool Bhulaiyaa 2', 'A sequel to the original movie Bhool Bhulaiyaa.', 'https://i.imgur.com/ZTT1Jzy.jpg', NULL, 143, '2022-05-20 14:21:33+00', '2022-05-28 08:36:33+00'),
('d031b248-41d5-49dc-8c3f-9af5203e8931', 'Doctor Strange In the Multiverse of Madness', 'Dr. Stephen Strange casts a forbidden spell that opens the doorway to the multiverse, including alternate versions of himself, whose threat to humanity is too great for the combined forces of Strange, Wong, and Wanda Maximoff.', 'https://i.imgur.com/kgp10GN.jpg', 'https://www.youtube.com/watch?v=aWzlQ2N6qqg', 126, '2022-05-06 14:19:59+00', '2022-05-28 08:34:59+00'),
('628b1d5b-b45f-484f-94c3-145972b0713b', 'Jurassic World Dominion', 'Four years after the destruction of Isla Nublar, dinosaurs now live--and hunt--alongside humans all over the world. This fragile balance will reshape the future and determine, once and for all, whether human beings are to remain the apex predators on a planet they now share with history''s most fearsome creatures in a new Era.', 'https://api.qfxcinemas.com/api/public/ThumbnailImage?eventId=7732', 'https://www.youtube.com/watch?v=fb5ELWi-ekk', 146, '2022-06-10 00:00:00+00', '2022-06-22 08:57:51.118347+00');

-- END TABLE public.movies

-- BEGIN TABLE public.refresh_tokens
DROP TABLE IF EXISTS public.refresh_tokens CASCADE;


CREATE TABLE IF NOT EXISTS public.refresh_tokens (
	id uuid DEFAULT uuid_generate_v4() NOT NULL,
	created_at timestamp with time zone,
	updated_at timestamp with time zone,
	deleted_at timestamp with time zone,
	token text,
	revoked boolean DEFAULT false,
	user_agent text,
	ip text,
	user_id uuid,
	PRIMARY KEY(id)
);

-- END TABLE public.refresh_tokens

-- BEGIN TABLE public.screenings
DROP TABLE IF EXISTS public.screenings CASCADE;

CREATE SEQUENCE IF NOT EXISTS public.screenings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE IF NOT EXISTS public.screenings (
	id bigint DEFAULT nextval('screenings_id_seq'::regclass) NOT NULL,
	auditorium_id bigint,
	cinema_id text,
	movie_id text,
	created_at timestamp with time zone,
	start_time timestamp with time zone,
	PRIMARY KEY(id)
);


-- Inserting 21 rows into public.screenings
-- Insert batch #1
INSERT INTO public.screenings (id, auditorium_id, cinema_id, movie_id, created_at, start_time) VALUES
(35, 1, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-08 12:05:28.629594+00', '2022-06-08 17:15:00+00'),
(36, 2, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-09 08:24:23.202361+00', '2022-06-09 12:15:00+00'),
(37, 2, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-09 08:50:24.198283+00', '2022-06-01 14:15:00+00'),
(38, 1, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-09 08:52:39.79983+00', '2022-06-09 14:15:00+00'),
(39, 2, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-09 08:52:45.96363+00', '2022-06-09 12:15:00+00'),
(40, 2, 'af367117-be73-40e3-bdbd-1161a4b60eda', '03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b', '2022-06-09 08:53:40.890616+00', '2022-06-10 12:15:00+00'),
(41, 3, 'd6fbf6b2-2090-4580-b2b5-3bb8d710d396', '03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b', '2022-06-09 08:53:48.14095+00', '2022-06-10 09:15:00+00'),
(42, 3, 'd6fbf6b2-2090-4580-b2b5-3bb8d710d396', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-09 08:53:54.827124+00', '2022-06-10 10:15:00+00'),
(43, 3, 'd6fbf6b2-2090-4580-b2b5-3bb8d710d396', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-09 08:54:05.066404+00', '2022-06-09 15:15:00+00'),
(44, 1, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-10 12:42:05.897828+00', '2022-06-11 08:15:00+00'),
(45, 1, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-11 08:18:19.437785+00', '2022-06-13 08:15:00+00'),
(46, 1, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-11 08:18:32.280362+00', '2022-06-12 07:15:00+00'),
(47, 2, 'af367117-be73-40e3-bdbd-1161a4b60eda', '03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b', '2022-06-11 08:18:40.139608+00', '2022-06-12 07:15:00+00'),
(48, 3, 'd6fbf6b2-2090-4580-b2b5-3bb8d710d396', '03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b', '2022-06-11 08:18:50.376922+00', '2022-06-12 11:15:00+00'),
(49, 3, 'd6fbf6b2-2090-4580-b2b5-3bb8d710d396', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-11 08:18:54.403942+00', '2022-06-12 10:15:00+00'),
(1, 1, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-11 09:14:03.685464+00', '2022-06-14 13:30:00+00'),
(4, 2, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-11 09:17:37.785722+00', '2022-06-14 10:00:00+00'),
(5, 1, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-22 09:07:53.28757+00', '2022-06-14 13:30:00+00'),
(6, 1, 'af367117-be73-40e3-bdbd-1161a4b60eda', 'd031b248-41d5-49dc-8c3f-9af5203e8931', '2022-06-22 09:08:11.409366+00', '2022-06-23 13:30:00+00'),
(7, 3, 'd6fbf6b2-2090-4580-b2b5-3bb8d710d396', '628b1d5b-b45f-484f-94c3-145972b0713b', '2022-06-22 09:41:41.354663+00', '2022-06-22 15:15:00+00'),
(8, 2, 'af367117-be73-40e3-bdbd-1161a4b60eda', '03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b', '2022-06-22 09:50:31.456651+00', '2022-06-22 12:15:00+00');

-- END TABLE public.screenings

-- BEGIN TABLE public.seats
DROP TABLE IF EXISTS public.seats CASCADE;

CREATE SEQUENCE IF NOT EXISTS public.seats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE IF NOT EXISTS public.seats (
	id bigint DEFAULT nextval('seats_id_seq'::regclass) NOT NULL,
	auditorium_id bigint,
	"row" bigint,
	number bigint,
	created_at timestamp with time zone,
	available boolean,
	price bigint,
	"type" text,
	PRIMARY KEY(id)
);


-- Inserting 256 rows into public.seats
-- Insert batch #1
INSERT INTO public.seats (id, auditorium_id, "row", number, created_at, available, price, "type") VALUES
(453, 2, 1, 1, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(454, 2, 1, 2, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(455, 2, 1, 3, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(456, 2, 1, 4, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(457, 2, 1, 5, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(458, 2, 1, 6, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(459, 2, 1, 7, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(460, 2, 2, 1, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(461, 2, 2, 2, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(462, 2, 2, 3, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(463, 2, 2, 4, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(464, 2, 2, 5, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(465, 2, 2, 6, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(466, 2, 2, 7, '2022-06-22 09:51:33.342305+00', 'True', 750, 'super-deluxe'),
(467, 2, 3, 1, '2022-06-22 09:51:33.342305+00', 'False', 550, 'deluxe'),
(468, 2, 3, 2, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(469, 2, 3, 3, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(470, 2, 3, 4, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(471, 2, 3, 5, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(472, 2, 3, 6, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(473, 2, 3, 7, '2022-06-22 09:51:33.342305+00', 'False', 550, 'deluxe'),
(474, 2, 4, 1, '2022-06-22 09:51:33.342305+00', 'False', 550, 'deluxe'),
(475, 2, 4, 2, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(476, 2, 4, 3, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(477, 2, 4, 4, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(478, 2, 4, 5, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(479, 2, 4, 6, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(480, 2, 4, 7, '2022-06-22 09:51:33.342305+00', 'False', 550, 'deluxe'),
(481, 2, 5, 1, '2022-06-22 09:51:33.342305+00', 'False', 550, 'deluxe'),
(482, 2, 5, 2, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(483, 2, 5, 3, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(484, 2, 5, 4, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(485, 2, 5, 5, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(486, 2, 5, 6, '2022-06-22 09:51:33.342305+00', 'True', 550, 'deluxe'),
(487, 2, 5, 7, '2022-06-22 09:51:33.342305+00', 'False', 550, 'deluxe'),
(488, 2, 6, 1, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(489, 2, 6, 2, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(490, 2, 6, 3, '2022-06-22 09:51:33.342305+00', 'False', 300, 'normal'),
(491, 2, 6, 4, '2022-06-22 09:51:33.342305+00', 'False', 300, 'normal'),
(492, 2, 6, 5, '2022-06-22 09:51:33.342305+00', 'False', 300, 'normal'),
(493, 2, 6, 6, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(494, 2, 6, 7, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(495, 2, 7, 1, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(496, 2, 7, 2, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(497, 2, 7, 3, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(498, 2, 7, 4, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(499, 2, 7, 5, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(500, 2, 7, 6, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(501, 2, 7, 7, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(502, 2, 8, 1, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(503, 2, 8, 2, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(504, 2, 8, 3, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(505, 2, 8, 4, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(506, 2, 8, 5, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(507, 2, 8, 6, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(508, 2, 8, 7, '2022-06-22 09:51:33.342305+00', 'True', 300, 'normal'),
(253, 3, 1, 1, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(254, 3, 1, 2, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(255, 3, 1, 3, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(256, 3, 1, 4, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(257, 3, 1, 5, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(258, 3, 1, 6, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(259, 3, 1, 7, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(260, 3, 1, 8, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(261, 3, 1, 9, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(262, 3, 2, 1, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(263, 3, 2, 2, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(264, 3, 2, 3, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(265, 3, 2, 4, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(266, 3, 2, 5, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(267, 3, 2, 6, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(268, 3, 2, 7, '2022-06-11 09:54:13.736142+00', 'True', 750, 'super-deluxe'),
(269, 3, 2, 8, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(270, 3, 2, 9, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(271, 3, 3, 1, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(272, 3, 3, 2, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(273, 3, 3, 3, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(274, 3, 3, 4, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(275, 3, 3, 5, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(276, 3, 3, 6, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(277, 3, 3, 7, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(278, 3, 3, 8, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(279, 3, 3, 9, '2022-06-11 09:54:13.736142+00', 'False', 750, 'super-deluxe'),
(280, 3, 4, 1, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(281, 3, 4, 2, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(282, 3, 4, 3, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(283, 3, 4, 4, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(284, 3, 4, 5, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(285, 3, 4, 6, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(286, 3, 4, 7, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(287, 3, 4, 8, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(288, 3, 4, 9, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(289, 3, 5, 1, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(290, 3, 5, 2, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(291, 3, 5, 3, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(292, 3, 5, 4, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(293, 3, 5, 5, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(294, 3, 5, 6, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(295, 3, 5, 7, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(296, 3, 5, 8, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(297, 3, 5, 9, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(298, 3, 6, 1, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(299, 3, 6, 2, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(300, 3, 6, 3, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(301, 3, 6, 4, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(302, 3, 6, 5, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(303, 3, 6, 6, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(304, 3, 6, 7, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(305, 3, 6, 8, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(306, 3, 6, 9, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(307, 3, 7, 1, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(308, 3, 7, 2, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(309, 3, 7, 3, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(310, 3, 7, 4, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(311, 3, 7, 5, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(312, 3, 7, 6, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(313, 3, 7, 7, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(314, 3, 7, 8, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(315, 3, 7, 9, '2022-06-11 09:54:13.736142+00', 'True', 550, 'deluxe'),
(316, 3, 8, 1, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(317, 3, 8, 2, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(318, 3, 8, 3, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(319, 3, 8, 4, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(320, 3, 8, 5, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(321, 3, 8, 6, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(322, 3, 8, 7, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(323, 3, 8, 8, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(324, 3, 8, 9, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(325, 3, 9, 1, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(326, 3, 9, 2, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(327, 3, 9, 3, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(328, 3, 9, 4, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(329, 3, 9, 5, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(330, 3, 9, 6, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(331, 3, 9, 7, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(332, 3, 9, 8, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(333, 3, 9, 9, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(334, 3, 10, 1, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(335, 3, 10, 2, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(336, 3, 10, 3, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(337, 3, 10, 4, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(338, 3, 10, 5, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(339, 3, 10, 6, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(340, 3, 10, 7, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(341, 3, 10, 8, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(342, 3, 10, 9, '2022-06-11 09:54:13.736142+00', 'True', 300, 'normal'),
(343, 1, 1, 1, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(344, 1, 1, 2, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(345, 1, 1, 3, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(346, 1, 1, 4, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(347, 1, 1, 5, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(348, 1, 1, 6, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(349, 1, 1, 7, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(350, 1, 1, 8, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(351, 1, 1, 9, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(352, 1, 1, 10, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(353, 1, 2, 1, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(354, 1, 2, 2, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(355, 1, 2, 3, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(356, 1, 2, 4, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(357, 1, 2, 5, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(358, 1, 2, 6, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(359, 1, 2, 7, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(360, 1, 2, 8, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(361, 1, 2, 9, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(362, 1, 2, 10, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(363, 1, 3, 1, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(364, 1, 3, 2, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(365, 1, 3, 3, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(366, 1, 3, 4, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(367, 1, 3, 5, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(368, 1, 3, 6, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(369, 1, 3, 7, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(370, 1, 3, 8, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(371, 1, 3, 9, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(372, 1, 3, 10, '2022-06-11 10:15:50.552151+00', 'True', 750, 'super-deluxe'),
(373, 1, 4, 1, '2022-06-11 10:15:50.552151+00', 'False', 750, 'super-deluxe'),
(374, 1, 4, 2, '2022-06-11 10:15:50.552151+00', 'False', 750, 'super-deluxe'),
(375, 1, 4, 3, '2022-06-11 10:15:50.552151+00', 'False', 750, 'super-deluxe'),
(376, 1, 4, 4, '2022-06-11 10:15:50.552151+00', 'False', 750, 'super-deluxe'),
(377, 1, 4, 5, '2022-06-11 10:15:50.552151+00', 'False', 750, 'super-deluxe'),
(378, 1, 4, 6, '2022-06-11 10:15:50.552151+00', 'False', 750, 'super-deluxe'),
(379, 1, 4, 7, '2022-06-11 10:15:50.552151+00', 'False', 750, 'super-deluxe'),
(380, 1, 4, 8, '2022-06-11 10:15:50.552151+00', 'False', 750, 'super-deluxe'),
(381, 1, 4, 9, '2022-06-11 10:15:50.552151+00', 'False', 750, 'super-deluxe'),
(382, 1, 4, 10, '2022-06-11 10:15:50.552151+00', 'False', 750, 'super-deluxe'),
(383, 1, 5, 1, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(384, 1, 5, 2, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(385, 1, 5, 3, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(386, 1, 5, 4, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(387, 1, 5, 5, '2022-06-11 10:15:50.552151+00', 'False', 550, 'deluxe'),
(388, 1, 5, 6, '2022-06-11 10:15:50.552151+00', 'False', 550, 'deluxe'),
(389, 1, 5, 7, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(390, 1, 5, 8, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(391, 1, 5, 9, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(392, 1, 5, 10, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(393, 1, 6, 1, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(394, 1, 6, 2, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(395, 1, 6, 3, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(396, 1, 6, 4, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(397, 1, 6, 5, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(398, 1, 6, 6, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(399, 1, 6, 7, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(400, 1, 6, 8, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(401, 1, 6, 9, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(402, 1, 6, 10, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(403, 1, 7, 1, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(404, 1, 7, 2, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(405, 1, 7, 3, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(406, 1, 7, 4, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(407, 1, 7, 5, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(408, 1, 7, 6, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(409, 1, 7, 7, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(410, 1, 7, 8, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(411, 1, 7, 9, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(412, 1, 7, 10, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(413, 1, 8, 1, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(414, 1, 8, 2, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(415, 1, 8, 3, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(416, 1, 8, 4, '2022-06-11 10:15:50.552151+00', 'False', 550, 'deluxe'),
(417, 1, 8, 5, '2022-06-11 10:15:50.552151+00', 'False', 550, 'deluxe'),
(418, 1, 8, 6, '2022-06-11 10:15:50.552151+00', 'False', 550, 'deluxe'),
(419, 1, 8, 7, '2022-06-11 10:15:50.552151+00', 'False', 550, 'deluxe'),
(420, 1, 8, 8, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(421, 1, 8, 9, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(422, 1, 8, 10, '2022-06-11 10:15:50.552151+00', 'True', 550, 'deluxe'),
(423, 1, 9, 1, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(424, 1, 9, 2, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(425, 1, 9, 3, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(426, 1, 9, 4, '2022-06-11 10:15:50.552151+00', 'False', 300, 'normal'),
(427, 1, 9, 5, '2022-06-11 10:15:50.552151+00', 'False', 300, 'normal'),
(428, 1, 9, 6, '2022-06-11 10:15:50.552151+00', 'False', 300, 'normal'),
(429, 1, 9, 7, '2022-06-11 10:15:50.552151+00', 'False', 300, 'normal'),
(430, 1, 9, 8, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(431, 1, 9, 9, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(432, 1, 9, 10, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(433, 1, 10, 1, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(434, 1, 10, 2, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(435, 1, 10, 3, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(436, 1, 10, 4, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(437, 1, 10, 5, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(438, 1, 10, 6, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(439, 1, 10, 7, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(440, 1, 10, 8, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(441, 1, 10, 9, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(442, 1, 10, 10, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(443, 1, 11, 1, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(444, 1, 11, 2, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(445, 1, 11, 3, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(446, 1, 11, 4, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(447, 1, 11, 5, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(448, 1, 11, 6, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(449, 1, 11, 7, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(450, 1, 11, 8, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(451, 1, 11, 9, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal'),
(452, 1, 11, 10, '2022-06-11 10:15:50.552151+00', 'True', 300, 'normal');

-- END TABLE public.seats

-- BEGIN TABLE public.transactions
DROP TABLE IF EXISTS public.transactions CASCADE;


CREATE TABLE IF NOT EXISTS public.transactions (
	id uuid DEFAULT uuid_generate_v4() NOT NULL,
	user_id uuid,
	screening_id bigint,
	created_at timestamp with time zone,
	expires_at timestamp with time zone,
	payment_intent_id text,
	paid boolean,
	total_price bigint,
	PRIMARY KEY(id)
);


-- Inserting 12 rows into public.transactions
-- Insert batch #1
INSERT INTO public.transactions (id, user_id, screening_id, created_at, expires_at, payment_intent_id, paid, total_price) VALUES
('15d4a4da-188b-47ba-9158-1c73522e8d09', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 45, '2022-06-11 10:16:04.603587+00', '2022-06-11 10:31:04.603587+00', '', 'False', 0),
('47fa16fd-834a-4935-bc54-02cabcb5a13d', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 46, '2022-06-11 10:16:08.842494+00', '2022-06-11 10:31:08.842494+00', '', 'False', 0),
('21097397-747c-473f-ac42-e01c141023e1', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 1, '2022-06-11 10:26:02.320026+00', '2022-06-11 10:41:02.320026+00', '', 'False', 0),
('65d7bb4f-e4f3-4975-97b0-7374cc4f76ca', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 1, '2022-06-11 10:41:10.263761+00', '2022-06-11 10:56:10.263761+00', '', 'False', 0),
('dbe0fdbf-6afd-4d39-9654-cd42f35e6508', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 45, '2022-06-11 11:16:51.665229+00', '2022-06-11 11:31:51.665229+00', '', 'False', 0),
('73bc8a14-be9f-4599-ab8c-89ec74c83824', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 6, '2022-06-22 09:08:51.776705+00', '2022-06-22 09:09:06.812711+00', 'pi_3LDPYZLq5jVwlbtc14SlEZNe', 'True', 3000),
('256250f1-9027-49e6-b420-7fca10351661', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 6, '2022-06-22 09:09:58.132291+00', '2022-06-22 09:10:14.07966+00', 'pi_3LDPZeLq5jVwlbtc0bMgHBo3', 'True', 1500),
('a143d5f3-5ec6-4cf1-81bf-ed866e58c94a', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 6, '2022-06-22 09:36:13.888794+00', '2022-06-22 09:36:31.505457+00', 'pi_3LDPz6Lq5jVwlbtc1QiXtsdv', 'True', 4400),
('acc285d8-4ff7-4602-8f86-355a32fdd7ec', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 7, '2022-06-22 09:41:48.627632+00', '2022-06-22 09:42:02.803373+00', 'pi_3LDQ4RLq5jVwlbtc1YWxVHa0', 'True', 2250),
('d2c9f414-98a8-4678-923a-feb0d20a6d73', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 6, '2022-06-22 09:49:44.079223+00', '2022-06-22 10:04:44.079223+00', '', 'False', 0),
('b51fc72a-73d5-463c-888d-e0258e747e0e', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 7, '2022-06-22 09:50:12.507307+00', '2022-06-22 10:05:12.507307+00', '', 'False', 0),
('b47310c0-766d-4f40-89eb-eafff7770693', '1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', 8, '2022-06-22 09:50:42.342966+00', '2022-06-22 10:05:42.342966+00', '', 'False', 0);

-- END TABLE public.transactions

-- BEGIN TABLE public.users
DROP TABLE IF EXISTS public.users CASCADE;


CREATE TABLE IF NOT EXISTS public.users (
	id uuid DEFAULT uuid_generate_v4() NOT NULL,
	created_at timestamp with time zone,
	updated_at timestamp with time zone,
	deleted_at timestamp with time zone,
	name text,
	email text UNIQUE,
	"password" text,
	identity_type text DEFAULT 'email'::text,
	identities jsonb,
	password_reset_token text,
	password_reset_token_at timestamp with time zone,
	token text,
	token_sent_at timestamp with time zone,
	confirmation_token text,
	confirmation_token_at timestamp with time zone,
	confirmed boolean DEFAULT false,
	confirmed_at timestamp with time zone,
	PRIMARY KEY(id)
);


-- Inserting 2 rows into public.users
-- Insert batch #1
INSERT INTO public.users (id, created_at, updated_at, deleted_at, name, email, "password", identity_type, identities, password_reset_token, password_reset_token_at, token, token_sent_at, confirmation_token, confirmation_token_at, confirmed, confirmed_at) VALUES
('1cd24c7a-6ca1-42d5-8ac7-eab3129135c9', '2022-06-10 15:03:14.695068+00', '2022-06-10 15:03:14.695068+00', NULL, 'overlord', 'overlord.damygod@gmail.com', '$2a$10$7Yu6WQ/frp9URnSvxgVBzuh.DGu1P0jsYkdB3sPN3uHcl5fzsuiu6', 'email', NULL, '', '0001-01-01 00:00:00+00', '', '0001-01-01 00:00:00+00', '', '0001-01-01 00:00:00+00', 'True', '2022-06-10 15:03:14.695036+00'),
('9dcfab76-d8e2-4ace-83b0-61eabcf4e322', '2022-06-11 11:08:14.374213+00', '2022-06-11 11:08:14.374213+00', NULL, 'Overlord Damygod', 'overlord.damy1111god@gmail.com', '$2a$10$82tBs6ZsM9X18BdZtq4bFew1Sg/41JkI7GKesJkxj6UUOyqCZNtWy', 'email', NULL, '', '0001-01-01 00:00:00+00', '', '0001-01-01 00:00:00+00', '', '0001-01-01 00:00:00+00', 'True', '2022-06-11 11:08:14.372987+00');

-- END TABLE public.users

ALTER TABLE IF EXISTS public.refresh_tokens
	ADD CONSTRAINT fk_users_refresh_token
	FOREIGN KEY (user_id)
	REFERENCES public.users (id)
	ON DELETE CASCADE;

CREATE INDEX index_movies_on_name ON movies USING gin(to_tsvector('simple', name));