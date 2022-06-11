--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auditoriums; Type: TABLE; Schema: public; Owner: webadmin
--

CREATE TABLE public.auditoriums (
    id bigint NOT NULL,
    name text,
    cinema_id text,
    no_seats bigint,
    rows bigint,
    columns bigint,
    created_at timestamp with time zone
);


ALTER TABLE public.auditoriums OWNER TO webadmin;

--
-- Name: auditoriums_id_seq; Type: SEQUENCE; Schema: public; Owner: webadmin
--

CREATE SEQUENCE public.auditoriums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auditoriums_id_seq OWNER TO webadmin;

--
-- Name: auditoriums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: webadmin
--

ALTER SEQUENCE public.auditoriums_id_seq OWNED BY public.auditoriums.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: webadmin
--

CREATE TABLE public.bookings (
    id bigint NOT NULL,
    transaction_id uuid DEFAULT public.uuid_generate_v4(),
    user_id text,
    seat_id bigint,
    auditorium_id bigint,
    screening_id bigint,
    status bigint,
    created_at timestamp with time zone
);


ALTER TABLE public.bookings OWNER TO webadmin;

--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: webadmin
--

CREATE SEQUENCE public.bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bookings_id_seq OWNER TO webadmin;

--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: webadmin
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: cinemas; Type: TABLE; Schema: public; Owner: webadmin
--

CREATE TABLE public.cinemas (
    id text NOT NULL,
    name text,
    address text,
    created_at timestamp with time zone
);


ALTER TABLE public.cinemas OWNER TO webadmin;

--
-- Name: logs; Type: TABLE; Schema: public; Owner: webadmin
--

CREATE TABLE public.logs (
    event_type text,
    email text,
    meta_data jsonb,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone
);


ALTER TABLE public.logs OWNER TO webadmin;

--
-- Name: movies; Type: TABLE; Schema: public; Owner: webadmin
--

CREATE TABLE public.movies (
    id text NOT NULL,
    name text,
    description text,
    banner text,
    trailer text,
    length bigint,
    release_date timestamp with time zone,
    created_at timestamp with time zone
);


ALTER TABLE public.movies OWNER TO webadmin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: webadmin
--

CREATE TABLE public.refresh_tokens (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    token text,
    revoked boolean DEFAULT false,
    user_agent text,
    ip text,
    user_id uuid
);


ALTER TABLE public.refresh_tokens OWNER TO webadmin;

--
-- Name: screenings; Type: TABLE; Schema: public; Owner: webadmin
--

CREATE TABLE public.screenings (
    id bigint NOT NULL,
    auditorium_id bigint,
    cinema_id text,
    movie_id text,
    created_at timestamp with time zone,
    start_time timestamp with time zone
);


ALTER TABLE public.screenings OWNER TO webadmin;

--
-- Name: screenings_id_seq; Type: SEQUENCE; Schema: public; Owner: webadmin
--

CREATE SEQUENCE public.screenings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.screenings_id_seq OWNER TO webadmin;

--
-- Name: screenings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: webadmin
--

ALTER SEQUENCE public.screenings_id_seq OWNED BY public.screenings.id;


--
-- Name: seats; Type: TABLE; Schema: public; Owner: webadmin
--

CREATE TABLE public.seats (
    id bigint NOT NULL,
    auditorium_id bigint,
    "row" bigint,
    number bigint,
    created_at timestamp with time zone,
    available boolean,
    price bigint,
    type text
);


ALTER TABLE public.seats OWNER TO webadmin;

--
-- Name: seats_id_seq; Type: SEQUENCE; Schema: public; Owner: webadmin
--

CREATE SEQUENCE public.seats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seats_id_seq OWNER TO webadmin;

--
-- Name: seats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: webadmin
--

ALTER SEQUENCE public.seats_id_seq OWNED BY public.seats.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: webadmin
--

CREATE TABLE public.transactions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id text,
    screening_id bigint,
    created_at timestamp with time zone,
    expires_at timestamp with time zone,
    payment_intent_id text,
    paid boolean,
    total_price bigint
);


ALTER TABLE public.transactions OWNER TO webadmin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: webadmin
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    name text,
    email text,
    password text,
    identity_type text DEFAULT 'email'::text,
    identities jsonb,
    password_reset_token text,
    password_reset_token_at timestamp with time zone,
    token text,
    token_sent_at timestamp with time zone,
    confirmation_token text,
    confirmation_token_at timestamp with time zone,
    confirmed boolean DEFAULT false,
    confirmed_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO webadmin;

--
-- Name: auditoriums id; Type: DEFAULT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.auditoriums ALTER COLUMN id SET DEFAULT nextval('public.auditoriums_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: screenings id; Type: DEFAULT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.screenings ALTER COLUMN id SET DEFAULT nextval('public.screenings_id_seq'::regclass);


--
-- Name: seats id; Type: DEFAULT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.seats ALTER COLUMN id SET DEFAULT nextval('public.seats_id_seq'::regclass);


--
-- Data for Name: auditoriums; Type: TABLE DATA; Schema: public; Owner: webadmin
--

COPY public.auditoriums (id, name, cinema_id, no_seats, rows, columns, created_at) FROM stdin;
2	Audi 2	af367117-be73-40e3-bdbd-1161a4b60eda	45	9	8	2022-05-28 08:23:38+00
3	Audi 1	d6fbf6b2-2090-4580-b2b5-3bb8d710d396	60	10	9	2022-05-28 08:23:53+00
1	Audi 1	af367117-be73-40e3-bdbd-1161a4b60eda	50	11	10	2022-05-28 08:23:25+00
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: webadmin
--

COPY public.bookings (id, transaction_id, user_id, seat_id, auditorium_id, screening_id, status, created_at) FROM stdin;
110	47fa16fd-834a-4935-bc54-02cabcb5a13d	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	344	1	46	2	2022-06-11 10:19:00.504084+00
111	47fa16fd-834a-4935-bc54-02cabcb5a13d	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	345	1	46	2	2022-06-11 10:19:18.567469+00
112	47fa16fd-834a-4935-bc54-02cabcb5a13d	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	346	1	46	2	2022-06-11 10:19:55.525806+00
113	47fa16fd-834a-4935-bc54-02cabcb5a13d	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	347	1	46	2	2022-06-11 10:19:58.455789+00
114	47fa16fd-834a-4935-bc54-02cabcb5a13d	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	348	1	46	2	2022-06-11 10:20:04.124298+00
116	47fa16fd-834a-4935-bc54-02cabcb5a13d	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	349	1	46	2	2022-06-11 10:20:16.895005+00
117	47fa16fd-834a-4935-bc54-02cabcb5a13d	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	343	1	46	2	2022-06-11 10:22:05.097564+00
118	15d4a4da-188b-47ba-9158-1c73522e8d09	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	344	1	45	2	2022-06-11 10:26:09.236709+00
119	15d4a4da-188b-47ba-9158-1c73522e8d09	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	345	1	45	2	2022-06-11 10:26:13.418147+00
120	15d4a4da-188b-47ba-9158-1c73522e8d09	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	346	1	45	2	2022-06-11 10:26:23.069882+00
121	15d4a4da-188b-47ba-9158-1c73522e8d09	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	347	1	45	2	2022-06-11 10:26:26.150197+00
122	15d4a4da-188b-47ba-9158-1c73522e8d09	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	348	1	45	2	2022-06-11 10:26:30.774195+00
123	21097397-747c-473f-ac42-e01c141023e1	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	349	1	1	2	2022-06-11 10:26:34.137205+00
124	21097397-747c-473f-ac42-e01c141023e1	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	350	1	1	2	2022-06-11 10:26:39.009342+00
125	15d4a4da-188b-47ba-9158-1c73522e8d09	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	343	1	45	2	2022-06-11 10:27:10.182161+00
126	65d7bb4f-e4f3-4975-97b0-7374cc4f76ca	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	345	1	1	2	2022-06-11 10:41:17.54482+00
127	65d7bb4f-e4f3-4975-97b0-7374cc4f76ca	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	346	1	1	2	2022-06-11 10:41:26.266823+00
128	dbe0fdbf-6afd-4d39-9654-cd42f35e6508	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	355	1	45	2	2022-06-11 11:16:58.183884+00
129	dbe0fdbf-6afd-4d39-9654-cd42f35e6508	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	344	1	45	2	2022-06-11 11:17:03.058541+00
\.


--
-- Data for Name: cinemas; Type: TABLE DATA; Schema: public; Owner: webadmin
--

COPY public.cinemas (id, name, address, created_at) FROM stdin;
af367117-be73-40e3-bdbd-1161a4b60eda	QFT Labim Mall	Pulchowk, Lalitpur	2022-05-28 08:20:09+00
d6fbf6b2-2090-4580-b2b5-3bb8d710d396	QFT Bhaktapur	Bhaktapur, Bagmati	2022-05-28 08:20:41+00
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: webadmin
--

COPY public.logs (event_type, email, meta_data, id, created_at, updated_at, deleted_at) FROM stdin;
SIGNUP	overlord.damygod@gmail.com	\N	62b0eac6-c3a0-4731-912e-e0c795ba2aa5	2022-06-10 15:03:14.727003+00	2022-06-10 15:03:14.727003+00	\N
SIGNIN_EMAIL	overlord.damygod@gmail.com	\N	6784da6c-a551-41d0-b984-d7fa29a6c659	2022-06-10 15:03:36.347616+00	2022-06-10 15:03:36.347616+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	50fb0de7-ab75-44b5-8e74-972aea6164d5	2022-06-10 15:04:02.227837+00	2022-06-10 15:04:02.227837+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	26b81c98-ba3d-447c-8aa8-1ff27a47de6d	2022-06-10 15:04:29.940412+00	2022-06-10 15:04:29.940412+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	9fc4f93c-d238-4672-be3c-5595c41559ff	2022-06-10 15:05:11.484977+00	2022-06-10 15:05:11.484977+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	a94dbeae-4628-40f8-9d03-fca099a0bec7	2022-06-10 15:05:33.7286+00	2022-06-10 15:05:33.7286+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	948f6a5e-82f1-4806-a776-2380862c43a8	2022-06-10 15:05:45.302148+00	2022-06-10 15:05:45.302148+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	b9022d0a-56a9-4b53-bbdd-5d14b45b4358	2022-06-10 15:06:16.660614+00	2022-06-10 15:06:16.660614+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	962d8a7f-b038-4565-b52c-7c0b7218e1ce	2022-06-10 15:10:06.176749+00	2022-06-10 15:10:06.176749+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	a204822f-34b3-4b7f-9592-c93e661eeec5	2022-06-10 15:10:24.907847+00	2022-06-10 15:10:24.907847+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	da92e41c-c046-457e-90ff-c8b75a28c9ef	2022-06-10 15:12:36.13746+00	2022-06-10 15:12:36.13746+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	f8a58a25-5955-4fcc-8e43-65b501447f54	2022-06-10 15:13:33.27731+00	2022-06-10 15:13:33.27731+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	1bfe9dd1-86e9-4df0-839e-dafd83d74065	2022-06-10 15:14:08.353899+00	2022-06-10 15:14:08.353899+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	dfb820d4-60f6-4ac4-b7bf-c0631f2f04e6	2022-06-10 15:14:41.625869+00	2022-06-10 15:14:41.625869+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	1166e713-7f76-4ff1-9f77-5bdb37c26b2c	2022-06-10 15:15:19.771321+00	2022-06-10 15:15:19.771321+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	2ba4f285-513f-43bf-a8a4-7223873a7d3c	2022-06-10 15:15:56.645294+00	2022-06-10 15:15:56.645294+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	1c0a1784-fe98-40f9-a27d-7fa4aedf5da9	2022-06-10 15:15:59.684965+00	2022-06-10 15:15:59.684965+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	2e2288ea-3dd8-425d-8895-2e6b5098743c	2022-06-10 15:16:08.766127+00	2022-06-10 15:16:08.766127+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	d09a46eb-5581-4307-9364-3259150201da	2022-06-10 15:16:15.505334+00	2022-06-10 15:16:15.505334+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	acc83ea3-1e5f-42ca-aa1f-52e624699edf	2022-06-10 15:16:40.721181+00	2022-06-10 15:16:40.721181+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	d647adbc-9ea1-4443-96c5-db2f52b954ca	2022-06-10 15:28:44.415478+00	2022-06-10 15:28:44.415478+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	367e7293-cfdc-4805-a8c0-bdf05f2132ba	2022-06-10 15:29:57.95734+00	2022-06-10 15:29:57.95734+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	5c68a0e6-5398-4835-b8ad-39a4195e4de9	2022-06-10 15:30:38.961872+00	2022-06-10 15:30:38.961872+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	7211d8b0-9711-450b-b2fa-fe68f191ceea	2022-06-10 15:31:48.268864+00	2022-06-10 15:31:48.268864+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	88378d26-9970-4d86-9af1-df11ac197c68	2022-06-10 15:31:50.731489+00	2022-06-10 15:31:50.731489+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	a6ece2b4-f390-41e2-92a5-70130280f599	2022-06-10 15:32:11.932029+00	2022-06-10 15:32:11.932029+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	9b7233a8-9361-42d6-8f96-e4776961cde3	2022-06-10 15:32:21.164+00	2022-06-10 15:32:21.164+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	dee6733a-a8e4-463c-a848-f703f9b242b4	2022-06-10 15:33:17.080385+00	2022-06-10 15:33:17.080385+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	7e7d611f-750f-411a-b045-4c5c8492d3f1	2022-06-11 06:35:57.656089+00	2022-06-11 06:35:57.656089+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	682699a2-c40b-41d6-8fdd-6c41f5ba2dd8	2022-06-11 06:36:08.182137+00	2022-06-11 06:36:08.182137+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	0183ee22-92b1-4ef7-9958-f8f696b3ec26	2022-06-11 06:36:16.005249+00	2022-06-11 06:36:16.005249+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	4ec934ad-aa9b-4e66-840c-b5ae4061200f	2022-06-11 06:38:06.604099+00	2022-06-11 06:38:06.604099+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	8bac4eaf-07c7-43fb-9ef1-bdb4b6b6c39d	2022-06-11 06:38:12.986751+00	2022-06-11 06:38:12.986751+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	a8536259-067c-40c9-ac7b-690ab1ac094f	2022-06-11 06:38:28.396966+00	2022-06-11 06:38:28.396966+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	1c24a33b-30f2-416e-b465-7d021cc074c8	2022-06-11 06:39:51.674336+00	2022-06-11 06:39:51.674336+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	d2fc4c9e-bcf7-433b-9c2c-e7daf246ce61	2022-06-11 06:40:14.73686+00	2022-06-11 06:40:14.73686+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	2537e2fc-a7ea-46a4-b004-f26998690090	2022-06-11 06:45:06.67118+00	2022-06-11 06:45:06.67118+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	d56d4e1a-625c-41a4-b2f1-3a4535342dae	2022-06-11 06:47:25.040557+00	2022-06-11 06:47:25.040557+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	6afd6967-9e88-4240-b111-925e3a7cd472	2022-06-11 06:48:40.099887+00	2022-06-11 06:48:40.099887+00	\N
SIGNOUT	overlord.damygod@gmail.com	\N	9a5a85df-bdbc-44d0-9624-a6b710c1a9be	2022-06-11 06:48:50.69141+00	2022-06-11 06:48:50.69141+00	\N
SIGNIN_EMAIL	overlord.damygod@gmail.com	\N	ab36a2f3-81fa-4de3-b81b-8457e8d2d09a	2022-06-11 06:52:27.629809+00	2022-06-11 06:52:27.629809+00	\N
SIGNOUT	overlord.damygod@gmail.com	\N	a9393b40-2672-4818-929a-aa70e619d4e3	2022-06-11 06:52:32.434779+00	2022-06-11 06:52:32.434779+00	\N
SIGNIN_EMAIL	overlord.damygod@gmail.com	\N	2cf8b2b4-948d-4e07-929d-7d6a1ce4120f	2022-06-11 06:53:03.538797+00	2022-06-11 06:53:03.538797+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	249194df-6090-4404-86f0-aa7c29d02fbf	2022-06-11 06:55:00.719598+00	2022-06-11 06:55:00.719598+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	bcc10a40-a435-4904-9164-cb4a3bfc5962	2022-06-11 06:55:10.095059+00	2022-06-11 06:55:10.095059+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	8f946831-97a8-43ed-8fa9-072fe2b3885e	2022-06-11 06:58:35.527552+00	2022-06-11 06:58:35.527552+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	982430b8-851d-44f3-a901-d8cbd6614457	2022-06-11 06:59:03.167113+00	2022-06-11 06:59:03.167113+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	996576ae-1d32-4f02-ac83-58ab36e47bab	2022-06-11 07:01:27.024696+00	2022-06-11 07:01:27.024696+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	52ea6c8c-17af-4d98-b33b-6fd6cef8e65e	2022-06-11 07:04:46.315072+00	2022-06-11 07:04:46.315072+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	3ec90152-e839-49e9-8d33-6708d99fa6fc	2022-06-11 07:07:21.652162+00	2022-06-11 07:07:21.652162+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	7895f284-7c32-4931-9a08-5d9353be1472	2022-06-11 07:13:16.216196+00	2022-06-11 07:13:16.216196+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	0edc945d-8926-45eb-a04f-0ac7192fb5f3	2022-06-11 07:32:41.82396+00	2022-06-11 07:32:41.82396+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	b2603d68-4549-4cc7-a5a5-635632e2bc03	2022-06-11 07:32:50.935583+00	2022-06-11 07:32:50.935583+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	71ed4cb7-67ab-4a10-bdcb-b94e94447f42	2022-06-11 07:37:28.029978+00	2022-06-11 07:37:28.029978+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	aa9d6646-9377-4829-9291-f990bbb94b9f	2022-06-11 08:13:16.695912+00	2022-06-11 08:13:16.695912+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	22b35386-ac11-49cc-a23b-8486dff249ec	2022-06-11 08:18:07.96328+00	2022-06-11 08:18:07.96328+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	e202b8e9-603b-44c8-80e5-85e401b00088	2022-06-11 08:23:52.443537+00	2022-06-11 08:23:52.443537+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	e355319d-f649-4603-8a9b-466e3d671ed7	2022-06-11 08:24:13.339932+00	2022-06-11 08:24:13.339932+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	9ccefc27-d0a8-4491-b69d-cef9fffa6037	2022-06-11 08:24:29.317227+00	2022-06-11 08:24:29.317227+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	71aad710-ac81-4694-b035-6eef95d07096	2022-06-11 08:24:30.37056+00	2022-06-11 08:24:30.37056+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	de32507c-5573-4af6-bca2-971adfc7dbaa	2022-06-11 08:24:46.249932+00	2022-06-11 08:24:46.249932+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	ec4652a9-01de-4813-879a-887bf2a7b51f	2022-06-11 08:24:52.285482+00	2022-06-11 08:24:52.285482+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	38a8809c-8431-4848-b0a2-0bfdd9b97068	2022-06-11 08:24:57.813943+00	2022-06-11 08:24:57.813943+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	38616b67-21fe-4627-8c86-99b00ea78a6a	2022-06-11 08:26:54.829328+00	2022-06-11 08:26:54.829328+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	b1d26a9f-5315-4051-ac0d-602ab28fe345	2022-06-11 08:27:03.873133+00	2022-06-11 08:27:03.873133+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	a74f6d80-000d-45c9-ac81-ae4f0a24518f	2022-06-11 08:28:09.310809+00	2022-06-11 08:28:09.310809+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	79a51747-756f-4186-b15f-684164f3af43	2022-06-11 08:34:29.590621+00	2022-06-11 08:34:29.590621+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	9d4718d3-5c92-4f82-a006-570526b5d0f9	2022-06-11 08:40:15.870654+00	2022-06-11 08:40:15.870654+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	3ee8e31e-f2d5-4a2c-8810-846b67f66bbc	2022-06-11 08:49:30.798872+00	2022-06-11 08:49:30.798872+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	0e9a41f5-a429-4eee-acc7-354a0ac34c3c	2022-06-11 08:49:47.272648+00	2022-06-11 08:49:47.272648+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	1c2e9bd3-7ec0-4ed9-8392-ae826f6ad708	2022-06-11 09:02:28.230318+00	2022-06-11 09:02:28.230318+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	cfff1b60-4516-45b4-bed6-e8c669efc32b	2022-06-11 09:02:47.396036+00	2022-06-11 09:02:47.396036+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	dc052af4-ff19-46af-9f16-c9d2e9bc15ec	2022-06-11 09:16:53.30384+00	2022-06-11 09:16:53.30384+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	5f35595a-f4fa-4aa5-bcf8-296924832e24	2022-06-11 09:48:50.877274+00	2022-06-11 09:48:50.877274+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	b7a979ed-a2ee-4f6e-9a8c-79e8444f4898	2022-06-11 09:49:38.693858+00	2022-06-11 09:49:38.693858+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	35010889-4281-406f-ba6b-829eebcb74ce	2022-06-11 09:50:59.891364+00	2022-06-11 09:50:59.891364+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	b9d7da66-6a4e-4685-ad45-beb3ce18d41e	2022-06-11 09:51:29.805867+00	2022-06-11 09:51:29.805867+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	01bd9a73-0c9f-43a9-af19-d7905ebf2549	2022-06-11 09:54:56.265045+00	2022-06-11 09:54:56.265045+00	\N
SIGNIN_EMAIL	overlord.damygod@gmail.com	\N	2ecd09d4-571b-43b9-8220-6b242e74775f	2022-06-11 09:57:06.865199+00	2022-06-11 09:57:06.865199+00	\N
SIGNIN_EMAIL	overlord.damygod@gmail.com	\N	cc69774b-452a-441d-a957-a3b6ce90293c	2022-06-11 10:00:43.343296+00	2022-06-11 10:00:43.343296+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	e0e3a712-0925-4f53-a1e7-c4ecdd89cc16	2022-06-11 10:01:30.621987+00	2022-06-11 10:01:30.621987+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	ab469abb-69fe-422a-b581-937a68c966fa	2022-06-11 10:02:00.376656+00	2022-06-11 10:02:00.376656+00	\N
SIGNOUT	overlord.damygod@gmail.com	\N	f1023215-85b2-4ad5-a336-f66c570a6cd3	2022-06-11 09:56:36.019392+00	2022-06-11 09:56:36.019392+00	\N
SIGNOUT	overlord.damygod@gmail.com	\N	b51a5c63-a77d-44f0-94da-901cde5853ec	2022-06-11 09:57:12.303888+00	2022-06-11 09:57:12.303888+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	78d7f5fe-b6a8-4b25-8a70-953dbb3251e8	2022-06-11 10:11:31.234997+00	2022-06-11 10:11:31.234997+00	\N
SIGNIN_EMAIL	overlord.damygod@gmail.com	\N	91af6ae0-001a-4bb5-a8ff-415a0325a7b6	2022-06-11 10:11:35.621539+00	2022-06-11 10:11:35.621539+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	72e132e4-ab63-4b90-9d59-15fb953e0b51	2022-06-11 10:11:40.718412+00	2022-06-11 10:11:40.718412+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	b6ba45d4-c14c-421b-a046-0c8313e1e927	2022-06-11 10:14:00.740201+00	2022-06-11 10:14:00.740201+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	082f21e7-71df-43ef-a7a8-61f168671bb7	2022-06-11 10:17:21.932482+00	2022-06-11 10:17:21.932482+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	c05564ac-42ff-4cd1-8ca0-fb19af0cc748	2022-06-11 10:17:23.756798+00	2022-06-11 10:17:23.756798+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	5dd330cb-7563-4ad1-9c8b-5e6610343b25	2022-06-11 10:17:25.54077+00	2022-06-11 10:17:25.54077+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	6059545a-18c7-4538-be12-2d280d814772	2022-06-11 10:18:27.723717+00	2022-06-11 10:18:27.723717+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	f74eb5e1-a230-45c9-b21b-bf00d2d5f120	2022-06-11 10:25:53.227783+00	2022-06-11 10:25:53.227783+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	8294d4a6-2e19-47ca-9d52-f749cf3175fe	2022-06-11 10:25:58.278625+00	2022-06-11 10:25:58.278625+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	f3bbdfd1-8cb3-486e-acd3-1cf0aa93906c	2022-06-11 10:26:51.105374+00	2022-06-11 10:26:51.105374+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	d5cba625-ba8b-4577-918d-3165e70a2dab	2022-06-11 10:33:20.640042+00	2022-06-11 10:33:20.640042+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	8ad6a7b3-3de2-4dd5-ae40-1d908551de7e	2022-06-11 10:33:21.837537+00	2022-06-11 10:33:21.837537+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	8b415236-2e70-4d61-aadb-f7ec9073d535	2022-06-11 10:33:25.287788+00	2022-06-11 10:33:25.287788+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	a0b37114-c8f0-48ed-a225-4ca982213280	2022-06-11 10:36:05.414623+00	2022-06-11 10:36:05.414623+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	42f2557a-e244-4160-80af-657613ab2d60	2022-06-11 10:41:09.443151+00	2022-06-11 10:41:09.443151+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	e0c66349-6425-4932-bfe3-8f8f91f7b68d	2022-06-11 10:46:17.358319+00	2022-06-11 10:46:17.358319+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	e93c661b-423b-449f-98a3-900508d013ba	2022-06-11 10:46:22.015585+00	2022-06-11 10:46:22.015585+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	20eb7500-2829-4e26-ab2a-42028025546e	2022-06-11 10:46:34.301703+00	2022-06-11 10:46:34.301703+00	\N
TOKEN_REFRESH	overlord.damygod@gmail.com	\N	4d415806-6380-457e-a2c6-775c4c6f9d0c	2022-06-11 11:05:27.429824+00	2022-06-11 11:05:27.429824+00	\N
SIGNUP	overlord.damy1111god@gmail.com	\N	ea41ece9-9c00-4eda-8f55-8336de6ef4aa	2022-06-11 11:08:15.106042+00	2022-06-11 11:08:15.106042+00	\N
SIGNIN_EMAIL	overlord.damygod@gmail.com	\N	1ac32db0-0c4f-4477-9769-db7226ca0b3a	2022-06-11 11:16:38.387739+00	2022-06-11 11:16:38.387739+00	\N
\.


--
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: webadmin
--

COPY public.movies (id, name, description, banner, trailer, length, release_date, created_at) FROM stdin;
03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b	Bhool Bhulaiyaa 2	A sequel to the original movie Bhool Bhulaiyaa.	https://i.imgur.com/ZTT1Jzy.jpg	\N	143	2022-05-20 14:21:33+00	2022-05-28 08:36:33+00
d031b248-41d5-49dc-8c3f-9af5203e8931	Doctor Strange In the Multiverse of Madness	Dr. Stephen Strange casts a forbidden spell that opens the doorway to the multiverse, including alternate versions of himself, whose threat to humanity is too great for the combined forces of Strange, Wong, and Wanda Maximoff.	https://i.imgur.com/kgp10GN.jpg	https://www.youtube.com/watch?v=aWzlQ2N6qqg	126	2022-05-06 14:19:59+00	2022-05-28 08:34:59+00
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: webadmin
--

COPY public.refresh_tokens (id, created_at, updated_at, deleted_at, token, revoked, user_agent, ip, user_id) FROM stdin;
8789276a-7a31-4657-bba2-a877d9c2f273	2022-06-10 15:03:36.318657+00	2022-06-10 15:03:36.318657+00	2022-06-11 06:48:50.651678+00	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiMWNkMjRjN2EtNmNhMS00MmQ1LThhYzctZWFiMzEyOTEzNWM5IiwiZW1haWwiOiJvdmVybG9yZC5kYW15Z29kQGdtYWlsLmNvbSIsImV4cCI6MTY1NDk1OTgxNn0.9myZTQx_MCjOAdoZs98FBuiScVeqd5JJg4_3mr-2bJE	f	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0	127.0.0.1	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9
08f1fc37-2696-4ba3-9565-d236b67bb9e5	2022-06-11 06:52:27.426171+00	2022-06-11 06:52:27.426171+00	2022-06-11 06:52:32.409192+00	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiMWNkMjRjN2EtNmNhMS00MmQ1LThhYzctZWFiMzEyOTEzNWM5IiwiZW1haWwiOiJvdmVybG9yZC5kYW15Z29kQGdtYWlsLmNvbSIsImV4cCI6MTY1NTAxNjc0N30.RE50bKv_bv1oHErI0nYzlX7wR6WsVs5MTn74jUaVDN4	f	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0	127.0.0.1	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9
2bd290d5-1ff0-4117-94eb-91e7eb3762e7	2022-06-11 06:53:03.51414+00	2022-06-11 06:53:03.51414+00	2022-06-11 09:56:35.983452+00	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiMWNkMjRjN2EtNmNhMS00MmQ1LThhYzctZWFiMzEyOTEzNWM5IiwiZW1haWwiOiJvdmVybG9yZC5kYW15Z29kQGdtYWlsLmNvbSIsImV4cCI6MTY1NTAxNjc4M30.fYE_n_Jxx1eleJoKTfFda-IZuwIqWNrCRFkGMGaEXJM	f	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0	127.0.0.1	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9
e086a1c0-b4e7-4462-9be7-2f8b1ef1d232	2022-06-11 09:57:06.638221+00	2022-06-11 09:57:06.638221+00	2022-06-11 09:57:12.266698+00	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiMWNkMjRjN2EtNmNhMS00MmQ1LThhYzctZWFiMzEyOTEzNWM5IiwiZW1haWwiOiJvdmVybG9yZC5kYW15Z29kQGdtYWlsLmNvbSIsImV4cCI6MTY1NTAyNzgyNn0.eM23C5Dyq99LHH-jUmdzbc-K6kb1TBff_t5xwUBQbF8	f	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0	127.0.0.1	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9
7235d7f3-2665-4752-80d4-5f9183679969	2022-06-11 10:00:43.180181+00	2022-06-11 10:00:43.180181+00	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiMWNkMjRjN2EtNmNhMS00MmQ1LThhYzctZWFiMzEyOTEzNWM5IiwiZW1haWwiOiJvdmVybG9yZC5kYW15Z29kQGdtYWlsLmNvbSIsImV4cCI6MTY1NTAyODA0M30.bLtxwf88tiTxfQ7LCPgeXESvWy7fK7CqqUIBsr6IpiI	f	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0	127.0.0.1	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9
6e14acad-8902-4883-86d8-8e97c5b56a20	2022-06-11 10:11:35.011426+00	2022-06-11 10:11:35.011426+00	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiMWNkMjRjN2EtNmNhMS00MmQ1LThhYzctZWFiMzEyOTEzNWM5IiwiZW1haWwiOiJvdmVybG9yZC5kYW15Z29kQGdtYWlsLmNvbSIsImV4cCI6MTY1NTAyODY5NH0.2Hc4hR4dCmVQVfaXb80fx_ISGNUa7o5VSbZ4TzOJAOM	f	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0	127.0.0.1	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9
4b0d0a2a-9407-48b9-a171-5a6e68be1d1e	2022-06-11 11:16:37.718016+00	2022-06-11 11:16:37.718016+00	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiMWNkMjRjN2EtNmNhMS00MmQ1LThhYzctZWFiMzEyOTEzNWM5IiwiZW1haWwiOiJvdmVybG9yZC5kYW15Z29kQGdtYWlsLmNvbSIsImV4cCI6MTY1NTAzMjU5N30.eiT9av_Z_8tCYgfR3-patAK5Fj958bi4AY-kra_Mk5o	f	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0	172.19.0.1	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9
\.


--
-- Data for Name: screenings; Type: TABLE DATA; Schema: public; Owner: webadmin
--

COPY public.screenings (id, auditorium_id, cinema_id, movie_id, created_at, start_time) FROM stdin;
35	1	af367117-be73-40e3-bdbd-1161a4b60eda	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-08 12:05:28.629594+00	2022-06-08 17:15:00+00
36	2	af367117-be73-40e3-bdbd-1161a4b60eda	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-09 08:24:23.202361+00	2022-06-09 12:15:00+00
37	2	af367117-be73-40e3-bdbd-1161a4b60eda	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-09 08:50:24.198283+00	2022-06-01 14:15:00+00
38	1	af367117-be73-40e3-bdbd-1161a4b60eda	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-09 08:52:39.79983+00	2022-06-09 14:15:00+00
39	2	af367117-be73-40e3-bdbd-1161a4b60eda	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-09 08:52:45.96363+00	2022-06-09 12:15:00+00
40	2	af367117-be73-40e3-bdbd-1161a4b60eda	03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b	2022-06-09 08:53:40.890616+00	2022-06-10 12:15:00+00
41	3	d6fbf6b2-2090-4580-b2b5-3bb8d710d396	03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b	2022-06-09 08:53:48.14095+00	2022-06-10 09:15:00+00
42	3	d6fbf6b2-2090-4580-b2b5-3bb8d710d396	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-09 08:53:54.827124+00	2022-06-10 10:15:00+00
43	3	d6fbf6b2-2090-4580-b2b5-3bb8d710d396	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-09 08:54:05.066404+00	2022-06-09 15:15:00+00
44	1	af367117-be73-40e3-bdbd-1161a4b60eda	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-10 12:42:05.897828+00	2022-06-11 08:15:00+00
45	1	af367117-be73-40e3-bdbd-1161a4b60eda	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-11 08:18:19.437785+00	2022-06-13 08:15:00+00
46	1	af367117-be73-40e3-bdbd-1161a4b60eda	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-11 08:18:32.280362+00	2022-06-12 07:15:00+00
47	2	af367117-be73-40e3-bdbd-1161a4b60eda	03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b	2022-06-11 08:18:40.139608+00	2022-06-12 07:15:00+00
48	3	d6fbf6b2-2090-4580-b2b5-3bb8d710d396	03aedbb8-19a3-4ace-bb0c-86cf3f1bf40b	2022-06-11 08:18:50.376922+00	2022-06-12 11:15:00+00
49	3	d6fbf6b2-2090-4580-b2b5-3bb8d710d396	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-11 08:18:54.403942+00	2022-06-12 10:15:00+00
1	1	af367117-be73-40e3-bdbd-1161a4b60eda	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-11 09:14:03.685464+00	2022-06-14 13:30:00+00
4	2	af367117-be73-40e3-bdbd-1161a4b60eda	d031b248-41d5-49dc-8c3f-9af5203e8931	2022-06-11 09:17:37.785722+00	2022-06-14 10:00:00+00
\.


--
-- Data for Name: seats; Type: TABLE DATA; Schema: public; Owner: webadmin
--

COPY public.seats (id, auditorium_id, "row", number, created_at, available, price, type) FROM stdin;
181	2	1	1	2022-06-11 09:53:34.279067+00	t	550	deluxe
182	2	1	2	2022-06-11 09:53:34.279067+00	t	550	deluxe
183	2	1	3	2022-06-11 09:53:34.279067+00	t	550	deluxe
184	2	1	4	2022-06-11 09:53:34.279067+00	t	550	deluxe
185	2	1	5	2022-06-11 09:53:34.279067+00	t	550	deluxe
186	2	1	6	2022-06-11 09:53:34.279067+00	t	550	deluxe
187	2	1	7	2022-06-11 09:53:34.279067+00	t	550	deluxe
188	2	1	8	2022-06-11 09:53:34.279067+00	t	550	deluxe
189	2	2	1	2022-06-11 09:53:34.279067+00	t	550	deluxe
190	2	2	2	2022-06-11 09:53:34.279067+00	t	550	deluxe
191	2	2	3	2022-06-11 09:53:34.279067+00	t	550	deluxe
192	2	2	4	2022-06-11 09:53:34.279067+00	t	550	deluxe
193	2	2	5	2022-06-11 09:53:34.279067+00	t	550	deluxe
194	2	2	6	2022-06-11 09:53:34.279067+00	t	550	deluxe
195	2	2	7	2022-06-11 09:53:34.279067+00	t	550	deluxe
196	2	2	8	2022-06-11 09:53:34.279067+00	t	550	deluxe
197	2	3	1	2022-06-11 09:53:34.279067+00	t	550	deluxe
198	2	3	2	2022-06-11 09:53:34.279067+00	t	550	deluxe
199	2	3	3	2022-06-11 09:53:34.279067+00	t	550	deluxe
200	2	3	4	2022-06-11 09:53:34.279067+00	f	550	deluxe
201	2	3	5	2022-06-11 09:53:34.279067+00	f	550	deluxe
202	2	3	6	2022-06-11 09:53:34.279067+00	t	550	deluxe
203	2	3	7	2022-06-11 09:53:34.279067+00	t	550	deluxe
204	2	3	8	2022-06-11 09:53:34.279067+00	t	550	deluxe
205	2	4	1	2022-06-11 09:53:34.279067+00	t	300	normal
206	2	4	2	2022-06-11 09:53:34.279067+00	t	300	normal
207	2	4	3	2022-06-11 09:53:34.279067+00	f	300	normal
208	2	4	4	2022-06-11 09:53:34.279067+00	f	300	normal
209	2	4	5	2022-06-11 09:53:34.279067+00	f	300	normal
210	2	4	6	2022-06-11 09:53:34.279067+00	f	300	normal
211	2	4	7	2022-06-11 09:53:34.279067+00	t	300	normal
212	2	4	8	2022-06-11 09:53:34.279067+00	t	300	normal
213	2	5	1	2022-06-11 09:53:34.279067+00	t	300	normal
214	2	5	2	2022-06-11 09:53:34.279067+00	t	300	normal
215	2	5	3	2022-06-11 09:53:34.279067+00	t	300	normal
216	2	5	4	2022-06-11 09:53:34.279067+00	t	300	normal
217	2	5	5	2022-06-11 09:53:34.279067+00	t	300	normal
218	2	5	6	2022-06-11 09:53:34.279067+00	t	300	normal
219	2	5	7	2022-06-11 09:53:34.279067+00	t	300	normal
220	2	5	8	2022-06-11 09:53:34.279067+00	t	300	normal
221	2	6	1	2022-06-11 09:53:34.279067+00	t	300	normal
222	2	6	2	2022-06-11 09:53:34.279067+00	t	300	normal
223	2	6	3	2022-06-11 09:53:34.279067+00	t	300	normal
224	2	6	4	2022-06-11 09:53:34.279067+00	t	300	normal
225	2	6	5	2022-06-11 09:53:34.279067+00	t	300	normal
226	2	6	6	2022-06-11 09:53:34.279067+00	t	300	normal
227	2	6	7	2022-06-11 09:53:34.279067+00	t	300	normal
228	2	6	8	2022-06-11 09:53:34.279067+00	t	300	normal
229	2	7	1	2022-06-11 09:53:34.279067+00	t	300	normal
230	2	7	2	2022-06-11 09:53:34.279067+00	t	300	normal
231	2	7	3	2022-06-11 09:53:34.279067+00	t	300	normal
232	2	7	4	2022-06-11 09:53:34.279067+00	t	300	normal
233	2	7	5	2022-06-11 09:53:34.279067+00	t	300	normal
234	2	7	6	2022-06-11 09:53:34.279067+00	t	300	normal
235	2	7	7	2022-06-11 09:53:34.279067+00	t	300	normal
236	2	7	8	2022-06-11 09:53:34.279067+00	t	300	normal
237	2	8	1	2022-06-11 09:53:34.279067+00	t	300	normal
238	2	8	2	2022-06-11 09:53:34.279067+00	t	300	normal
239	2	8	3	2022-06-11 09:53:34.279067+00	t	300	normal
240	2	8	4	2022-06-11 09:53:34.279067+00	t	300	normal
241	2	8	5	2022-06-11 09:53:34.279067+00	t	300	normal
242	2	8	6	2022-06-11 09:53:34.279067+00	t	300	normal
243	2	8	7	2022-06-11 09:53:34.279067+00	t	300	normal
244	2	8	8	2022-06-11 09:53:34.279067+00	t	300	normal
245	2	9	1	2022-06-11 09:53:34.279067+00	t	300	normal
246	2	9	2	2022-06-11 09:53:34.279067+00	t	300	normal
247	2	9	3	2022-06-11 09:53:34.279067+00	t	300	normal
248	2	9	4	2022-06-11 09:53:34.279067+00	t	300	normal
249	2	9	5	2022-06-11 09:53:34.279067+00	t	300	normal
250	2	9	6	2022-06-11 09:53:34.279067+00	t	300	normal
251	2	9	7	2022-06-11 09:53:34.279067+00	t	300	normal
252	2	9	8	2022-06-11 09:53:34.279067+00	t	300	normal
253	3	1	1	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
254	3	1	2	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
255	3	1	3	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
256	3	1	4	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
257	3	1	5	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
258	3	1	6	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
259	3	1	7	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
260	3	1	8	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
261	3	1	9	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
262	3	2	1	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
263	3	2	2	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
264	3	2	3	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
265	3	2	4	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
266	3	2	5	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
267	3	2	6	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
268	3	2	7	2022-06-11 09:54:13.736142+00	t	750	super-deluxe
269	3	2	8	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
270	3	2	9	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
271	3	3	1	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
272	3	3	2	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
273	3	3	3	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
274	3	3	4	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
275	3	3	5	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
276	3	3	6	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
277	3	3	7	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
278	3	3	8	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
279	3	3	9	2022-06-11 09:54:13.736142+00	f	750	super-deluxe
280	3	4	1	2022-06-11 09:54:13.736142+00	t	550	deluxe
281	3	4	2	2022-06-11 09:54:13.736142+00	t	550	deluxe
282	3	4	3	2022-06-11 09:54:13.736142+00	t	550	deluxe
283	3	4	4	2022-06-11 09:54:13.736142+00	t	550	deluxe
284	3	4	5	2022-06-11 09:54:13.736142+00	t	550	deluxe
285	3	4	6	2022-06-11 09:54:13.736142+00	t	550	deluxe
286	3	4	7	2022-06-11 09:54:13.736142+00	t	550	deluxe
287	3	4	8	2022-06-11 09:54:13.736142+00	t	550	deluxe
288	3	4	9	2022-06-11 09:54:13.736142+00	t	550	deluxe
289	3	5	1	2022-06-11 09:54:13.736142+00	t	550	deluxe
290	3	5	2	2022-06-11 09:54:13.736142+00	t	550	deluxe
291	3	5	3	2022-06-11 09:54:13.736142+00	t	550	deluxe
292	3	5	4	2022-06-11 09:54:13.736142+00	t	550	deluxe
293	3	5	5	2022-06-11 09:54:13.736142+00	t	550	deluxe
294	3	5	6	2022-06-11 09:54:13.736142+00	t	550	deluxe
295	3	5	7	2022-06-11 09:54:13.736142+00	t	550	deluxe
296	3	5	8	2022-06-11 09:54:13.736142+00	t	550	deluxe
297	3	5	9	2022-06-11 09:54:13.736142+00	t	550	deluxe
298	3	6	1	2022-06-11 09:54:13.736142+00	t	550	deluxe
299	3	6	2	2022-06-11 09:54:13.736142+00	t	550	deluxe
300	3	6	3	2022-06-11 09:54:13.736142+00	t	550	deluxe
301	3	6	4	2022-06-11 09:54:13.736142+00	t	550	deluxe
302	3	6	5	2022-06-11 09:54:13.736142+00	t	550	deluxe
303	3	6	6	2022-06-11 09:54:13.736142+00	t	550	deluxe
304	3	6	7	2022-06-11 09:54:13.736142+00	t	550	deluxe
305	3	6	8	2022-06-11 09:54:13.736142+00	t	550	deluxe
306	3	6	9	2022-06-11 09:54:13.736142+00	t	550	deluxe
307	3	7	1	2022-06-11 09:54:13.736142+00	t	550	deluxe
308	3	7	2	2022-06-11 09:54:13.736142+00	t	550	deluxe
309	3	7	3	2022-06-11 09:54:13.736142+00	t	550	deluxe
310	3	7	4	2022-06-11 09:54:13.736142+00	t	550	deluxe
311	3	7	5	2022-06-11 09:54:13.736142+00	t	550	deluxe
312	3	7	6	2022-06-11 09:54:13.736142+00	t	550	deluxe
313	3	7	7	2022-06-11 09:54:13.736142+00	t	550	deluxe
314	3	7	8	2022-06-11 09:54:13.736142+00	t	550	deluxe
315	3	7	9	2022-06-11 09:54:13.736142+00	t	550	deluxe
316	3	8	1	2022-06-11 09:54:13.736142+00	t	300	normal
317	3	8	2	2022-06-11 09:54:13.736142+00	t	300	normal
318	3	8	3	2022-06-11 09:54:13.736142+00	t	300	normal
319	3	8	4	2022-06-11 09:54:13.736142+00	t	300	normal
320	3	8	5	2022-06-11 09:54:13.736142+00	t	300	normal
321	3	8	6	2022-06-11 09:54:13.736142+00	t	300	normal
322	3	8	7	2022-06-11 09:54:13.736142+00	t	300	normal
323	3	8	8	2022-06-11 09:54:13.736142+00	t	300	normal
324	3	8	9	2022-06-11 09:54:13.736142+00	t	300	normal
325	3	9	1	2022-06-11 09:54:13.736142+00	t	300	normal
326	3	9	2	2022-06-11 09:54:13.736142+00	t	300	normal
327	3	9	3	2022-06-11 09:54:13.736142+00	t	300	normal
328	3	9	4	2022-06-11 09:54:13.736142+00	t	300	normal
329	3	9	5	2022-06-11 09:54:13.736142+00	t	300	normal
330	3	9	6	2022-06-11 09:54:13.736142+00	t	300	normal
331	3	9	7	2022-06-11 09:54:13.736142+00	t	300	normal
332	3	9	8	2022-06-11 09:54:13.736142+00	t	300	normal
333	3	9	9	2022-06-11 09:54:13.736142+00	t	300	normal
334	3	10	1	2022-06-11 09:54:13.736142+00	t	300	normal
335	3	10	2	2022-06-11 09:54:13.736142+00	t	300	normal
336	3	10	3	2022-06-11 09:54:13.736142+00	t	300	normal
337	3	10	4	2022-06-11 09:54:13.736142+00	t	300	normal
338	3	10	5	2022-06-11 09:54:13.736142+00	t	300	normal
339	3	10	6	2022-06-11 09:54:13.736142+00	t	300	normal
340	3	10	7	2022-06-11 09:54:13.736142+00	t	300	normal
341	3	10	8	2022-06-11 09:54:13.736142+00	t	300	normal
342	3	10	9	2022-06-11 09:54:13.736142+00	t	300	normal
343	1	1	1	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
344	1	1	2	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
345	1	1	3	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
346	1	1	4	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
347	1	1	5	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
348	1	1	6	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
349	1	1	7	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
350	1	1	8	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
351	1	1	9	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
352	1	1	10	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
353	1	2	1	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
354	1	2	2	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
355	1	2	3	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
356	1	2	4	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
357	1	2	5	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
358	1	2	6	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
359	1	2	7	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
360	1	2	8	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
361	1	2	9	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
362	1	2	10	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
363	1	3	1	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
364	1	3	2	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
365	1	3	3	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
366	1	3	4	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
367	1	3	5	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
368	1	3	6	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
369	1	3	7	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
370	1	3	8	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
371	1	3	9	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
372	1	3	10	2022-06-11 10:15:50.552151+00	t	750	super-deluxe
373	1	4	1	2022-06-11 10:15:50.552151+00	f	750	super-deluxe
374	1	4	2	2022-06-11 10:15:50.552151+00	f	750	super-deluxe
375	1	4	3	2022-06-11 10:15:50.552151+00	f	750	super-deluxe
376	1	4	4	2022-06-11 10:15:50.552151+00	f	750	super-deluxe
377	1	4	5	2022-06-11 10:15:50.552151+00	f	750	super-deluxe
378	1	4	6	2022-06-11 10:15:50.552151+00	f	750	super-deluxe
379	1	4	7	2022-06-11 10:15:50.552151+00	f	750	super-deluxe
380	1	4	8	2022-06-11 10:15:50.552151+00	f	750	super-deluxe
381	1	4	9	2022-06-11 10:15:50.552151+00	f	750	super-deluxe
382	1	4	10	2022-06-11 10:15:50.552151+00	f	750	super-deluxe
383	1	5	1	2022-06-11 10:15:50.552151+00	t	550	deluxe
384	1	5	2	2022-06-11 10:15:50.552151+00	t	550	deluxe
385	1	5	3	2022-06-11 10:15:50.552151+00	t	550	deluxe
386	1	5	4	2022-06-11 10:15:50.552151+00	t	550	deluxe
387	1	5	5	2022-06-11 10:15:50.552151+00	f	550	deluxe
388	1	5	6	2022-06-11 10:15:50.552151+00	f	550	deluxe
389	1	5	7	2022-06-11 10:15:50.552151+00	t	550	deluxe
390	1	5	8	2022-06-11 10:15:50.552151+00	t	550	deluxe
391	1	5	9	2022-06-11 10:15:50.552151+00	t	550	deluxe
392	1	5	10	2022-06-11 10:15:50.552151+00	t	550	deluxe
393	1	6	1	2022-06-11 10:15:50.552151+00	t	550	deluxe
394	1	6	2	2022-06-11 10:15:50.552151+00	t	550	deluxe
395	1	6	3	2022-06-11 10:15:50.552151+00	t	550	deluxe
396	1	6	4	2022-06-11 10:15:50.552151+00	t	550	deluxe
397	1	6	5	2022-06-11 10:15:50.552151+00	t	550	deluxe
398	1	6	6	2022-06-11 10:15:50.552151+00	t	550	deluxe
399	1	6	7	2022-06-11 10:15:50.552151+00	t	550	deluxe
400	1	6	8	2022-06-11 10:15:50.552151+00	t	550	deluxe
401	1	6	9	2022-06-11 10:15:50.552151+00	t	550	deluxe
402	1	6	10	2022-06-11 10:15:50.552151+00	t	550	deluxe
403	1	7	1	2022-06-11 10:15:50.552151+00	t	550	deluxe
404	1	7	2	2022-06-11 10:15:50.552151+00	t	550	deluxe
405	1	7	3	2022-06-11 10:15:50.552151+00	t	550	deluxe
406	1	7	4	2022-06-11 10:15:50.552151+00	t	550	deluxe
407	1	7	5	2022-06-11 10:15:50.552151+00	t	550	deluxe
408	1	7	6	2022-06-11 10:15:50.552151+00	t	550	deluxe
409	1	7	7	2022-06-11 10:15:50.552151+00	t	550	deluxe
410	1	7	8	2022-06-11 10:15:50.552151+00	t	550	deluxe
411	1	7	9	2022-06-11 10:15:50.552151+00	t	550	deluxe
412	1	7	10	2022-06-11 10:15:50.552151+00	t	550	deluxe
413	1	8	1	2022-06-11 10:15:50.552151+00	t	550	deluxe
414	1	8	2	2022-06-11 10:15:50.552151+00	t	550	deluxe
415	1	8	3	2022-06-11 10:15:50.552151+00	t	550	deluxe
416	1	8	4	2022-06-11 10:15:50.552151+00	f	550	deluxe
417	1	8	5	2022-06-11 10:15:50.552151+00	f	550	deluxe
418	1	8	6	2022-06-11 10:15:50.552151+00	f	550	deluxe
419	1	8	7	2022-06-11 10:15:50.552151+00	f	550	deluxe
420	1	8	8	2022-06-11 10:15:50.552151+00	t	550	deluxe
421	1	8	9	2022-06-11 10:15:50.552151+00	t	550	deluxe
422	1	8	10	2022-06-11 10:15:50.552151+00	t	550	deluxe
423	1	9	1	2022-06-11 10:15:50.552151+00	t	300	normal
424	1	9	2	2022-06-11 10:15:50.552151+00	t	300	normal
425	1	9	3	2022-06-11 10:15:50.552151+00	t	300	normal
426	1	9	4	2022-06-11 10:15:50.552151+00	f	300	normal
427	1	9	5	2022-06-11 10:15:50.552151+00	f	300	normal
428	1	9	6	2022-06-11 10:15:50.552151+00	f	300	normal
429	1	9	7	2022-06-11 10:15:50.552151+00	f	300	normal
430	1	9	8	2022-06-11 10:15:50.552151+00	t	300	normal
431	1	9	9	2022-06-11 10:15:50.552151+00	t	300	normal
432	1	9	10	2022-06-11 10:15:50.552151+00	t	300	normal
433	1	10	1	2022-06-11 10:15:50.552151+00	t	300	normal
434	1	10	2	2022-06-11 10:15:50.552151+00	t	300	normal
435	1	10	3	2022-06-11 10:15:50.552151+00	t	300	normal
436	1	10	4	2022-06-11 10:15:50.552151+00	t	300	normal
437	1	10	5	2022-06-11 10:15:50.552151+00	t	300	normal
438	1	10	6	2022-06-11 10:15:50.552151+00	t	300	normal
439	1	10	7	2022-06-11 10:15:50.552151+00	t	300	normal
440	1	10	8	2022-06-11 10:15:50.552151+00	t	300	normal
441	1	10	9	2022-06-11 10:15:50.552151+00	t	300	normal
442	1	10	10	2022-06-11 10:15:50.552151+00	t	300	normal
443	1	11	1	2022-06-11 10:15:50.552151+00	t	300	normal
444	1	11	2	2022-06-11 10:15:50.552151+00	t	300	normal
445	1	11	3	2022-06-11 10:15:50.552151+00	t	300	normal
446	1	11	4	2022-06-11 10:15:50.552151+00	t	300	normal
447	1	11	5	2022-06-11 10:15:50.552151+00	t	300	normal
448	1	11	6	2022-06-11 10:15:50.552151+00	t	300	normal
449	1	11	7	2022-06-11 10:15:50.552151+00	t	300	normal
450	1	11	8	2022-06-11 10:15:50.552151+00	t	300	normal
451	1	11	9	2022-06-11 10:15:50.552151+00	t	300	normal
452	1	11	10	2022-06-11 10:15:50.552151+00	t	300	normal
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: webadmin
--

COPY public.transactions (id, user_id, screening_id, created_at, expires_at, payment_intent_id, paid, total_price) FROM stdin;
15d4a4da-188b-47ba-9158-1c73522e8d09	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	45	2022-06-11 10:16:04.603587+00	2022-06-11 10:31:04.603587+00		f	0
47fa16fd-834a-4935-bc54-02cabcb5a13d	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	46	2022-06-11 10:16:08.842494+00	2022-06-11 10:31:08.842494+00		f	0
21097397-747c-473f-ac42-e01c141023e1	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	1	2022-06-11 10:26:02.320026+00	2022-06-11 10:41:02.320026+00		f	0
65d7bb4f-e4f3-4975-97b0-7374cc4f76ca	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	1	2022-06-11 10:41:10.263761+00	2022-06-11 10:56:10.263761+00		f	0
dbe0fdbf-6afd-4d39-9654-cd42f35e6508	1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	45	2022-06-11 11:16:51.665229+00	2022-06-11 11:31:51.665229+00		f	0
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: webadmin
--

COPY public.users (id, created_at, updated_at, deleted_at, name, email, password, identity_type, identities, password_reset_token, password_reset_token_at, token, token_sent_at, confirmation_token, confirmation_token_at, confirmed, confirmed_at) FROM stdin;
1cd24c7a-6ca1-42d5-8ac7-eab3129135c9	2022-06-10 15:03:14.695068+00	2022-06-10 15:03:14.695068+00	\N	overlord	overlord.damygod@gmail.com	$2a$10$7Yu6WQ/frp9URnSvxgVBzuh.DGu1P0jsYkdB3sPN3uHcl5fzsuiu6	email	\N		0001-01-01 00:00:00+00		0001-01-01 00:00:00+00		0001-01-01 00:00:00+00	t	2022-06-10 15:03:14.695036+00
9dcfab76-d8e2-4ace-83b0-61eabcf4e322	2022-06-11 11:08:14.374213+00	2022-06-11 11:08:14.374213+00	\N	Overlord Damygod	overlord.damy1111god@gmail.com	$2a$10$82tBs6ZsM9X18BdZtq4bFew1Sg/41JkI7GKesJkxj6UUOyqCZNtWy	email	\N		0001-01-01 00:00:00+00		0001-01-01 00:00:00+00		0001-01-01 00:00:00+00	t	2022-06-11 11:08:14.372987+00
\.


--
-- Name: auditoriums_id_seq; Type: SEQUENCE SET; Schema: public; Owner: webadmin
--

SELECT pg_catalog.setval('public.auditoriums_id_seq', 1, false);


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: webadmin
--

SELECT pg_catalog.setval('public.bookings_id_seq', 129, true);


--
-- Name: screenings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: webadmin
--

SELECT pg_catalog.setval('public.screenings_id_seq', 4, true);


--
-- Name: seats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: webadmin
--

SELECT pg_catalog.setval('public.seats_id_seq', 452, true);


--
-- Name: auditoriums auditoriums_pkey; Type: CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.auditoriums
    ADD CONSTRAINT auditoriums_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: cinemas cinemas_pkey; Type: CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.cinemas
    ADD CONSTRAINT cinemas_pkey PRIMARY KEY (id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: screenings screenings_pkey; Type: CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.screenings
    ADD CONSTRAINT screenings_pkey PRIMARY KEY (id);


--
-- Name: seats seats_pkey; Type: CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: email; Type: INDEX; Schema: public; Owner: webadmin
--

CREATE UNIQUE INDEX email ON public.users USING btree (email);


--
-- Name: idx_logs_deleted_at; Type: INDEX; Schema: public; Owner: webadmin
--

CREATE INDEX idx_logs_deleted_at ON public.logs USING btree (deleted_at);


--
-- Name: idx_refresh_tokens_deleted_at; Type: INDEX; Schema: public; Owner: webadmin
--

CREATE INDEX idx_refresh_tokens_deleted_at ON public.refresh_tokens USING btree (deleted_at);


--
-- Name: idx_users_deleted_at; Type: INDEX; Schema: public; Owner: webadmin
--

CREATE INDEX idx_users_deleted_at ON public.users USING btree (deleted_at);


--
-- Name: seats fk_auditoriums_seats; Type: FK CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT fk_auditoriums_seats FOREIGN KEY (auditorium_id) REFERENCES public.auditoriums(id);


--
-- Name: seats fk_auditoriums_selected_seats; Type: FK CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT fk_auditoriums_selected_seats FOREIGN KEY (auditorium_id) REFERENCES public.auditoriums(id);


--
-- Name: bookings fk_bookings_seat; Type: FK CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_bookings_seat FOREIGN KEY (seat_id) REFERENCES public.seats(id);


--
-- Name: auditoriums fk_cinemas_auditoriums; Type: FK CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.auditoriums
    ADD CONSTRAINT fk_cinemas_auditoriums FOREIGN KEY (cinema_id) REFERENCES public.cinemas(id);


--
-- Name: screenings fk_screenings_auditorium; Type: FK CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.screenings
    ADD CONSTRAINT fk_screenings_auditorium FOREIGN KEY (auditorium_id) REFERENCES public.auditoriums(id);


--
-- Name: screenings fk_screenings_cinema; Type: FK CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.screenings
    ADD CONSTRAINT fk_screenings_cinema FOREIGN KEY (cinema_id) REFERENCES public.cinemas(id);


--
-- Name: screenings fk_screenings_movie; Type: FK CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.screenings
    ADD CONSTRAINT fk_screenings_movie FOREIGN KEY (movie_id) REFERENCES public.movies(id);


--
-- Name: bookings fk_transactions_bookings; Type: FK CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_transactions_bookings FOREIGN KEY (transaction_id) REFERENCES public.transactions(id);


--
-- Name: transactions fk_transactions_screening; Type: FK CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_screening FOREIGN KEY (screening_id) REFERENCES public.screenings(id);


--
-- Name: refresh_tokens fk_users_refresh_token; Type: FK CONSTRAINT; Schema: public; Owner: webadmin
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT fk_users_refresh_token FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

