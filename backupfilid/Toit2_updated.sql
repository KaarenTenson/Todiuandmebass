--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Postgres.app)
-- Dumped by pg_dump version 16.2 (Postgres.app)

-- Started on 2024-05-05 10:29:29 EEST

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 3681 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16801)
-- Name: poed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poed (
    id integer NOT NULL,
    nimi character varying(100) NOT NULL,
    telefoni_number character varying(10),
    "päritolu" character varying(100) NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 16804)
-- Name: poed_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.poed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3682 (class 0 OID 0)
-- Dependencies: 216
-- Name: poed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.poed_id_seq OWNED BY public.poed.id;


--
-- TOC entry 217 (class 1259 OID 16805)
-- Name: poed_toodevahetabel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poed_toodevahetabel (
    toode integer NOT NULL,
    pood integer NOT NULL,
    aeg timestamp without time zone NOT NULL,
    hind double precision NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 16808)
-- Name: riigid; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.riigid (
    id integer NOT NULL,
    nimi character varying(100) NOT NULL,
    skp double precision NOT NULL,
    inflatsioon double precision NOT NULL,
    aeg timestamp without time zone NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 16811)
-- Name: riigid_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.riigid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3683 (class 0 OID 0)
-- Dependencies: 219
-- Name: riigid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.riigid_id_seq OWNED BY public.riigid.id;


--
-- TOC entry 220 (class 1259 OID 16812)
-- Name: toode; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.toode (
    id integer NOT NULL,
    kogus_kaal double precision NOT NULL,
    nimi character varying(100) NOT NULL,
    "kogus_või_kaal" boolean NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16815)
-- Name: toode_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.toode_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3684 (class 0 OID 0)
-- Dependencies: 221
-- Name: toode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.toode_id_seq OWNED BY public.toode.id;


--
-- TOC entry 222 (class 1259 OID 16816)
-- Name: toode_ja_tootja_vahetabel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.toode_ja_tootja_vahetabel (
    toode integer NOT NULL,
    tootja integer NOT NULL,
    maht double precision NOT NULL,
    aeg timestamp without time zone NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 16819)
-- Name: tootja_ja_riik; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tootja_ja_riik (
    tootja integer NOT NULL,
    riik integer NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 16822)
-- Name: tootjad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tootjad (
    id integer NOT NULL,
    nimi character varying(100) NOT NULL,
    "päritolu" character varying(100) NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 16825)
-- Name: tootjad_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tootjad_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3685 (class 0 OID 0)
-- Dependencies: 225
-- Name: tootjad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tootjad_id_seq OWNED BY public.tootjad.id;


--
-- TOC entry 3492 (class 2604 OID 16826)
-- Name: poed id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed ALTER COLUMN id SET DEFAULT nextval('public.poed_id_seq'::regclass);


--
-- TOC entry 3493 (class 2604 OID 16827)
-- Name: riigid id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid ALTER COLUMN id SET DEFAULT nextval('public.riigid_id_seq'::regclass);


--
-- TOC entry 3494 (class 2604 OID 16828)
-- Name: toode id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode ALTER COLUMN id SET DEFAULT nextval('public.toode_id_seq'::regclass);


--
-- TOC entry 3495 (class 2604 OID 16829)
-- Name: tootjad id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad ALTER COLUMN id SET DEFAULT nextval('public.tootjad_id_seq'::regclass);


--
-- TOC entry 3665 (class 0 OID 16801)
-- Dependencies: 215
-- Data for Name: poed; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.poed VALUES (1, 'Gross', '3223560', 'Eesti');
INSERT INTO public.poed VALUES (2, 'Maxima', '8002121', 'Leedu');
INSERT INTO public.poed VALUES (3, 'Prisma', '6809600', 'Soome');
INSERT INTO public.poed VALUES (4, 'Selver', '6673800', 'Eesti');
INSERT INTO public.poed VALUES (5, 'Rimi', '6056333', 'Rootsi');
INSERT INTO public.poed VALUES (6, 'Coop', '6710500', 'Eesti');
INSERT INTO public.poed VALUES (7, 'Stockmann', '6339539', 'Soome');
INSERT INTO public.poed VALUES (8, 'Selver ABC', '6673800', 'Eesti');
INSERT INTO public.poed VALUES (9, 'Kaubamaja', '6673100', 'Eesti');
INSERT INTO public.poed VALUES (11, 'A1000 Market', '53059600', 'Eesti');
INSERT INTO public.poed VALUES (10, 'Keskturg', '58848014', 'Eesti');


--
-- TOC entry 3667 (class 0 OID 16805)
-- Dependencies: 217
-- Data for Name: poed_toodevahetabel; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.poed_toodevahetabel VALUES (1, 1, '2020-08-27 00:00:00', 0.74);
INSERT INTO public.poed_toodevahetabel VALUES (1, 2, '2020-08-27 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (1, 3, '2020-08-27 00:00:00', 1.08);
INSERT INTO public.poed_toodevahetabel VALUES (1, 4, '2020-08-27 00:00:00', 1.19);
INSERT INTO public.poed_toodevahetabel VALUES (1, 5, '2020-08-27 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (1, 6, '2020-08-27 00:00:00', 1.15);
INSERT INTO public.poed_toodevahetabel VALUES (1, 7, '2020-08-27 00:00:00', 1.8);
INSERT INTO public.poed_toodevahetabel VALUES (1, 8, '2020-08-27 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (1, 9, '2020-08-27 00:00:00', 1.9);
INSERT INTO public.poed_toodevahetabel VALUES (1, 10, '2020-08-27 00:00:00', 0.8);
INSERT INTO public.poed_toodevahetabel VALUES (1, 11, '2020-08-27 00:00:00', 1.05);
INSERT INTO public.poed_toodevahetabel VALUES (2, 10, '2020-08-27 00:00:00', 0.6);
INSERT INTO public.poed_toodevahetabel VALUES (2, 2, '2020-08-27 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (2, 1, '2020-08-27 00:00:00', 0.84);
INSERT INTO public.poed_toodevahetabel VALUES (2, 3, '2020-08-27 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (2, 4, '2020-08-27 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (2, 5, '2020-08-27 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (2, 6, '2020-08-27 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (2, 7, '2020-08-27 00:00:00', 0.85);
INSERT INTO public.poed_toodevahetabel VALUES (2, 8, '2020-08-27 00:00:00', 0.59);
INSERT INTO public.poed_toodevahetabel VALUES (2, 9, '2020-08-27 00:00:00', 0.9);
INSERT INTO public.poed_toodevahetabel VALUES (3, 1, '2020-08-27 00:00:00', 1.08);
INSERT INTO public.poed_toodevahetabel VALUES (3, 2, '2020-08-27 00:00:00', 0.95);
INSERT INTO public.poed_toodevahetabel VALUES (3, 3, '2020-08-27 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (3, 4, '2020-08-27 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (3, 5, '2020-08-27 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (3, 6, '2020-08-27 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (3, 7, '2020-08-27 00:00:00', 2.3);
INSERT INTO public.poed_toodevahetabel VALUES (3, 8, '2020-08-27 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (3, 9, '2020-08-27 00:00:00', 1.6);
INSERT INTO public.poed_toodevahetabel VALUES (3, 10, '2020-08-27 00:00:00', 1.2);
INSERT INTO public.poed_toodevahetabel VALUES (3, 11, '2020-08-27 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (4, 11, '2022-08-08 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (4, 1, '2020-08-27 00:00:00', 0.8);
INSERT INTO public.poed_toodevahetabel VALUES (4, 2, '2020-08-27 00:00:00', 0.82);
INSERT INTO public.poed_toodevahetabel VALUES (4, 3, '2020-08-27 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (4, 4, '2020-08-27 00:00:00', 0.89);
INSERT INTO public.poed_toodevahetabel VALUES (4, 5, '2020-08-27 00:00:00', 0.85);
INSERT INTO public.poed_toodevahetabel VALUES (4, 6, '2020-08-27 00:00:00', 0.81);
INSERT INTO public.poed_toodevahetabel VALUES (4, 7, '2020-08-27 00:00:00', 1.15);
INSERT INTO public.poed_toodevahetabel VALUES (4, 8, '2020-08-27 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (4, 9, '2020-08-27 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (4, 10, '2020-08-27 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (4, 11, '2020-08-27 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (4, 1, '2021-07-26 00:00:00', 0.54);
INSERT INTO public.poed_toodevahetabel VALUES (4, 2, '2021-07-26 00:00:00', 0.81);
INSERT INTO public.poed_toodevahetabel VALUES (4, 3, '2021-07-26 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (4, 4, '2021-07-26 00:00:00', 0.89);
INSERT INTO public.poed_toodevahetabel VALUES (4, 5, '2021-07-26 00:00:00', 0.82);
INSERT INTO public.poed_toodevahetabel VALUES (4, 6, '2021-07-26 00:00:00', 0.81);
INSERT INTO public.poed_toodevahetabel VALUES (4, 7, '2021-07-26 00:00:00', 1.15);
INSERT INTO public.poed_toodevahetabel VALUES (4, 8, '2021-07-26 00:00:00', 0.89);
INSERT INTO public.poed_toodevahetabel VALUES (4, 9, '2021-07-26 00:00:00', 0.89);
INSERT INTO public.poed_toodevahetabel VALUES (4, 10, '2021-07-26 00:00:00', 0.89);
INSERT INTO public.poed_toodevahetabel VALUES (4, 11, '2021-07-26 00:00:00', 0.9);
INSERT INTO public.poed_toodevahetabel VALUES (4, 1, '2022-08-08 00:00:00', 0.98);
INSERT INTO public.poed_toodevahetabel VALUES (4, 2, '2022-08-08 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (4, 3, '2022-08-08 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (4, 4, '2022-08-08 00:00:00', 0.59);
INSERT INTO public.poed_toodevahetabel VALUES (4, 5, '2022-08-08 00:00:00', 1);
INSERT INTO public.poed_toodevahetabel VALUES (4, 6, '2022-08-08 00:00:00', 1);
INSERT INTO public.poed_toodevahetabel VALUES (4, 7, '2022-08-08 00:00:00', 1.4);
INSERT INTO public.poed_toodevahetabel VALUES (4, 8, '2022-08-08 00:00:00', 1.05);
INSERT INTO public.poed_toodevahetabel VALUES (4, 9, '2022-08-08 00:00:00', 0.89);
INSERT INTO public.poed_toodevahetabel VALUES (4, 10, '2022-08-08 00:00:00', 1.1);
INSERT INTO public.poed_toodevahetabel VALUES (5, 1, '2020-08-27 00:00:00', 1.68);
INSERT INTO public.poed_toodevahetabel VALUES (5, 2, '2020-08-27 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 3, '2020-08-27 00:00:00', 1.75);
INSERT INTO public.poed_toodevahetabel VALUES (5, 4, '2020-08-27 00:00:00', 1.99);
INSERT INTO public.poed_toodevahetabel VALUES (5, 5, '2020-08-27 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 6, '2020-08-27 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 7, '2020-08-27 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 8, '2020-08-27 00:00:00', 1.99);
INSERT INTO public.poed_toodevahetabel VALUES (5, 9, '2020-08-27 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 10, '2020-08-27 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 11, '2020-08-27 00:00:00', 1.69);
INSERT INTO public.poed_toodevahetabel VALUES (5, 1, '2021-07-26 00:00:00', 1.88);
INSERT INTO public.poed_toodevahetabel VALUES (5, 2, '2021-07-26 00:00:00', 1.79);
INSERT INTO public.poed_toodevahetabel VALUES (5, 3, '2021-07-26 00:00:00', 1.75);
INSERT INTO public.poed_toodevahetabel VALUES (5, 4, '2021-07-26 00:00:00', 1.25);
INSERT INTO public.poed_toodevahetabel VALUES (5, 5, '2021-07-26 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 6, '2021-07-26 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 7, '2021-07-26 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 8, '2021-07-26 00:00:00', 1.25);
INSERT INTO public.poed_toodevahetabel VALUES (5, 9, '2021-07-26 00:00:00', 1.79);
INSERT INTO public.poed_toodevahetabel VALUES (5, 10, '2021-07-26 00:00:00', 1.69);
INSERT INTO public.poed_toodevahetabel VALUES (5, 11, '2021-07-26 00:00:00', 1.79);
INSERT INTO public.poed_toodevahetabel VALUES (5, 1, '2022-08-08 00:00:00', 1.94);
INSERT INTO public.poed_toodevahetabel VALUES (5, 2, '2022-08-08 00:00:00', 1.79);
INSERT INTO public.poed_toodevahetabel VALUES (5, 3, '2022-08-08 00:00:00', 2.19);
INSERT INTO public.poed_toodevahetabel VALUES (5, 4, '2022-08-08 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 5, '2022-08-08 00:00:00', 1.49);
INSERT INTO public.poed_toodevahetabel VALUES (5, 6, '2022-08-08 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 7, '2022-08-08 00:00:00', 1.9);
INSERT INTO public.poed_toodevahetabel VALUES (5, 8, '2022-08-08 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 9, '2022-08-08 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (5, 10, '2022-08-08 00:00:00', 1.69);
INSERT INTO public.poed_toodevahetabel VALUES (5, 11, '2022-08-08 00:00:00', 1.89);
INSERT INTO public.poed_toodevahetabel VALUES (6, 1, '2020-08-27 00:00:00', 0.21);
INSERT INTO public.poed_toodevahetabel VALUES (6, 2, '2020-08-27 00:00:00', 0.24);
INSERT INTO public.poed_toodevahetabel VALUES (6, 3, '2020-08-27 00:00:00', 0.24);
INSERT INTO public.poed_toodevahetabel VALUES (6, 4, '2020-08-27 00:00:00', 0.35);
INSERT INTO public.poed_toodevahetabel VALUES (6, 5, '2020-08-27 00:00:00', 0.24);
INSERT INTO public.poed_toodevahetabel VALUES (6, 6, '2020-08-27 00:00:00', 0.39);
INSERT INTO public.poed_toodevahetabel VALUES (6, 7, '2020-08-27 00:00:00', 0.4);
INSERT INTO public.poed_toodevahetabel VALUES (6, 8, '2020-08-27 00:00:00', 0.43);
INSERT INTO public.poed_toodevahetabel VALUES (6, 9, '2020-08-27 00:00:00', 1.1);
INSERT INTO public.poed_toodevahetabel VALUES (6, 10, '2020-08-27 00:00:00', 0.35);
INSERT INTO public.poed_toodevahetabel VALUES (6, 11, '2020-08-27 00:00:00', 0.29);
INSERT INTO public.poed_toodevahetabel VALUES (6, 1, '2021-07-26 00:00:00', 0.21);
INSERT INTO public.poed_toodevahetabel VALUES (6, 2, '2021-07-26 00:00:00', 0.21);
INSERT INTO public.poed_toodevahetabel VALUES (6, 3, '2021-07-26 00:00:00', 0.45);
INSERT INTO public.poed_toodevahetabel VALUES (6, 4, '2021-07-26 00:00:00', 0.39);
INSERT INTO public.poed_toodevahetabel VALUES (6, 5, '2021-07-26 00:00:00', 0.24);
INSERT INTO public.poed_toodevahetabel VALUES (6, 6, '2021-07-26 00:00:00', 0.39);
INSERT INTO public.poed_toodevahetabel VALUES (6, 7, '2021-07-26 00:00:00', 0.4);
INSERT INTO public.poed_toodevahetabel VALUES (6, 8, '2021-07-26 00:00:00', 0.39);
INSERT INTO public.poed_toodevahetabel VALUES (6, 9, '2021-07-26 00:00:00', 0.35);
INSERT INTO public.poed_toodevahetabel VALUES (6, 10, '2021-07-26 00:00:00', 0.29);
INSERT INTO public.poed_toodevahetabel VALUES (6, 11, '2021-07-26 00:00:00', 0.35);
INSERT INTO public.poed_toodevahetabel VALUES (6, 1, '2022-08-08 00:00:00', 0.44);
INSERT INTO public.poed_toodevahetabel VALUES (6, 2, '2022-08-08 00:00:00', 0.49);
INSERT INTO public.poed_toodevahetabel VALUES (6, 3, '2022-08-08 00:00:00', 0.45);
INSERT INTO public.poed_toodevahetabel VALUES (6, 4, '2022-08-08 00:00:00', 0.47);
INSERT INTO public.poed_toodevahetabel VALUES (6, 5, '2022-08-08 00:00:00', 0.45);
INSERT INTO public.poed_toodevahetabel VALUES (6, 6, '2022-08-08 00:00:00', 0.5);
INSERT INTO public.poed_toodevahetabel VALUES (6, 7, '2022-08-08 00:00:00', 0.4);
INSERT INTO public.poed_toodevahetabel VALUES (6, 8, '2022-08-08 00:00:00', 0.4);
INSERT INTO public.poed_toodevahetabel VALUES (6, 9, '2022-08-08 00:00:00', 1.25);
INSERT INTO public.poed_toodevahetabel VALUES (6, 10, '2022-08-08 00:00:00', 0.5);
INSERT INTO public.poed_toodevahetabel VALUES (6, 11, '2022-08-08 00:00:00', 0.4);
INSERT INTO public.poed_toodevahetabel VALUES (1, 1, '2021-07-21 00:00:00', 1.08);
INSERT INTO public.poed_toodevahetabel VALUES (1, 2, '2021-07-21 00:00:00', 0.89);
INSERT INTO public.poed_toodevahetabel VALUES (1, 3, '2021-07-21 00:00:00', 0.86);
INSERT INTO public.poed_toodevahetabel VALUES (1, 4, '2021-07-21 00:00:00', 1.19);
INSERT INTO public.poed_toodevahetabel VALUES (1, 5, '2021-07-21 00:00:00', 0.82);
INSERT INTO public.poed_toodevahetabel VALUES (1, 6, '2021-07-21 00:00:00', 1.19);
INSERT INTO public.poed_toodevahetabel VALUES (1, 7, '2021-07-21 00:00:00', 2.2);
INSERT INTO public.poed_toodevahetabel VALUES (1, 8, '2021-07-21 00:00:00', 1.19);
INSERT INTO public.poed_toodevahetabel VALUES (1, 9, '2021-07-21 00:00:00', 1.1);
INSERT INTO public.poed_toodevahetabel VALUES (1, 10, '2021-07-21 00:00:00', 1.1);
INSERT INTO public.poed_toodevahetabel VALUES (1, 11, '2021-07-21 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (1, 1, '2022-08-08 00:00:00', 1.12);
INSERT INTO public.poed_toodevahetabel VALUES (1, 2, '2022-08-08 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (1, 3, '2022-08-08 00:00:00', 1.19);
INSERT INTO public.poed_toodevahetabel VALUES (1, 4, '2022-08-08 00:00:00', 1.39);
INSERT INTO public.poed_toodevahetabel VALUES (1, 5, '2022-08-08 00:00:00', 1.25);
INSERT INTO public.poed_toodevahetabel VALUES (1, 6, '2022-08-08 00:00:00', 1.19);
INSERT INTO public.poed_toodevahetabel VALUES (1, 7, '2022-08-08 00:00:00', 2.2);
INSERT INTO public.poed_toodevahetabel VALUES (1, 8, '2022-08-08 00:00:00', 1.8);
INSERT INTO public.poed_toodevahetabel VALUES (1, 9, '2022-08-08 00:00:00', 1.19);
INSERT INTO public.poed_toodevahetabel VALUES (1, 10, '2022-08-08 00:00:00', 1.15);
INSERT INTO public.poed_toodevahetabel VALUES (1, 11, '2022-08-08 00:00:00', 1.15);
INSERT INTO public.poed_toodevahetabel VALUES (2, 10, '2022-08-08 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (2, 1, '2022-08-08 00:00:00', 0.98);
INSERT INTO public.poed_toodevahetabel VALUES (2, 2, '2022-08-08 00:00:00', 0.69);
INSERT INTO public.poed_toodevahetabel VALUES (2, 3, '2022-08-08 00:00:00', 1.05);
INSERT INTO public.poed_toodevahetabel VALUES (2, 4, '2022-08-08 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (2, 5, '2022-08-08 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (2, 6, '2022-08-08 00:00:00', 1.1);
INSERT INTO public.poed_toodevahetabel VALUES (2, 7, '2022-08-08 00:00:00', 1.1);
INSERT INTO public.poed_toodevahetabel VALUES (2, 8, '2022-08-08 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (2, 9, '2022-08-08 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (2, 11, '2022-08-08 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (2, 1, '2021-07-21 00:00:00', 0.78);
INSERT INTO public.poed_toodevahetabel VALUES (2, 2, '2021-07-21 00:00:00', 0.55);
INSERT INTO public.poed_toodevahetabel VALUES (2, 3, '2021-07-21 00:00:00', 0.75);
INSERT INTO public.poed_toodevahetabel VALUES (2, 4, '2021-07-21 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (2, 5, '2021-07-21 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (2, 6, '2021-07-21 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (2, 7, '2021-07-21 00:00:00', 0.75);
INSERT INTO public.poed_toodevahetabel VALUES (2, 8, '2021-07-21 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (2, 9, '2021-07-21 00:00:00', 0.7);
INSERT INTO public.poed_toodevahetabel VALUES (2, 10, '2021-07-21 00:00:00', 0.78);
INSERT INTO public.poed_toodevahetabel VALUES (2, 11, '2021-07-21 00:00:00', 0.7);
INSERT INTO public.poed_toodevahetabel VALUES (3, 1, '2021-07-21 00:00:00', 0.98);
INSERT INTO public.poed_toodevahetabel VALUES (3, 2, '2021-07-21 00:00:00', 0.79);
INSERT INTO public.poed_toodevahetabel VALUES (3, 3, '2021-07-21 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (3, 4, '2021-07-21 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (3, 5, '2021-07-21 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (3, 6, '2021-07-21 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (3, 7, '2021-07-21 00:00:00', 1.85);
INSERT INTO public.poed_toodevahetabel VALUES (3, 8, '2021-07-21 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (3, 9, '2021-07-21 00:00:00', 1);
INSERT INTO public.poed_toodevahetabel VALUES (3, 10, '2021-07-21 00:00:00', 1.09);
INSERT INTO public.poed_toodevahetabel VALUES (3, 11, '2021-07-21 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (3, 1, '2022-08-08 00:00:00', 1.58);
INSERT INTO public.poed_toodevahetabel VALUES (3, 3, '2022-08-08 00:00:00', 1.39);
INSERT INTO public.poed_toodevahetabel VALUES (3, 4, '2022-08-08 00:00:00', 1.59);
INSERT INTO public.poed_toodevahetabel VALUES (3, 5, '2022-08-08 00:00:00', 1.29);
INSERT INTO public.poed_toodevahetabel VALUES (3, 6, '2022-08-08 00:00:00', 0.99);
INSERT INTO public.poed_toodevahetabel VALUES (3, 7, '2022-08-08 00:00:00', 1.85);
INSERT INTO public.poed_toodevahetabel VALUES (3, 8, '2022-08-08 00:00:00', 1.29);
INSERT INTO public.poed_toodevahetabel VALUES (3, 9, '2022-08-08 00:00:00', 1.95);
INSERT INTO public.poed_toodevahetabel VALUES (3, 10, '2022-08-08 00:00:00', 1.39);
INSERT INTO public.poed_toodevahetabel VALUES (3, 11, '2022-08-08 00:00:00', 1.19);


--
-- TOC entry 3668 (class 0 OID 16808)
-- Dependencies: 218
-- Data for Name: riigid; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.riigid VALUES (1, 'Eesti', 36011.14, 19.2, '2022-12-31 00:00:00');
INSERT INTO public.riigid VALUES (3, 'Costa Rica', 69242.16, 8.3, '2022-12-25 00:00:00');
INSERT INTO public.riigid VALUES (4, 'USA', 21439162.1, 1.81, '2019-12-25 00:00:00');
INSERT INTO public.riigid VALUES (6, 'Rootsi', 591251.52, 8.4, '2022-12-24 00:00:00');


--
-- TOC entry 3670 (class 0 OID 16812)
-- Dependencies: 220
-- Data for Name: toode; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.toode VALUES (3, 10, 'Munad M-suurus', true);
INSERT INTO public.toode VALUES (4, 475, 'Tallinna Peenleib', false);
INSERT INTO public.toode VALUES (2, 1000, 'Piim TERE 2,5%', true);
INSERT INTO public.toode VALUES (5, 2000, 'Coca-Cola', true);
INSERT INTO public.toode VALUES (6, 1000, 'Sool', false);
INSERT INTO public.toode VALUES (1, 1000, 'Banaan', true);


--
-- TOC entry 3672 (class 0 OID 16816)
-- Dependencies: 222
-- Data for Name: toode_ja_tootja_vahetabel; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.toode_ja_tootja_vahetabel VALUES (1, 2, 1000, '2023-04-24 00:00:00');
INSERT INTO public.toode_ja_tootja_vahetabel VALUES (2, 1, 1000, '2023-04-24 00:00:00');
INSERT INTO public.toode_ja_tootja_vahetabel VALUES (3, 3, 10, '2023-04-24 00:00:00');
INSERT INTO public.toode_ja_tootja_vahetabel VALUES (4, 4, 475, '2023-04-24 00:00:00');
INSERT INTO public.toode_ja_tootja_vahetabel VALUES (5, 5, 2000, '2023-04-24 00:00:00');
INSERT INTO public.toode_ja_tootja_vahetabel VALUES (6, 6, 1000, '2023-04-24 00:00:00');


--
-- TOC entry 3673 (class 0 OID 16819)
-- Dependencies: 223
-- Data for Name: tootja_ja_riik; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tootja_ja_riik VALUES (1, 1);
INSERT INTO public.tootja_ja_riik VALUES (2, 3);
INSERT INTO public.tootja_ja_riik VALUES (3, 1);
INSERT INTO public.tootja_ja_riik VALUES (4, 1);
INSERT INTO public.tootja_ja_riik VALUES (5, 4);
INSERT INTO public.tootja_ja_riik VALUES (6, 6);


--
-- TOC entry 3674 (class 0 OID 16822)
-- Dependencies: 224
-- Data for Name: tootjad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tootjad VALUES (1, 'Tere AS', 'Eesti');
INSERT INTO public.tootjad VALUES (2, 'Chiquita', 'Costa Rica');
INSERT INTO public.tootjad VALUES (3, 'Eggo', 'Eesti');
INSERT INTO public.tootjad VALUES (4, 'Leibur', 'Eesti');
INSERT INTO public.tootjad VALUES (5, 'Coca-Cola Company', 'USA');
INSERT INTO public.tootjad VALUES (6, 'Santa Maria', 'Rootsi');


--
-- TOC entry 3686 (class 0 OID 0)
-- Dependencies: 216
-- Name: poed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.poed_id_seq', 11, true);


--
-- TOC entry 3687 (class 0 OID 0)
-- Dependencies: 219
-- Name: riigid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.riigid_id_seq', 6, true);


--
-- TOC entry 3688 (class 0 OID 0)
-- Dependencies: 221
-- Name: toode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.toode_id_seq', 6, true);


--
-- TOC entry 3689 (class 0 OID 0)
-- Dependencies: 225
-- Name: tootjad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tootjad_id_seq', 6, true);


--
-- TOC entry 3497 (class 2606 OID 16831)
-- Name: poed poed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed
    ADD CONSTRAINT poed_pkey PRIMARY KEY (id);


--
-- TOC entry 3499 (class 2606 OID 16881)
-- Name: poed_toodevahetabel poed_toodevahetabel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_pkey PRIMARY KEY (toode, pood, aeg);


--
-- TOC entry 3501 (class 2606 OID 16835)
-- Name: riigid riigid_aeg_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_aeg_key UNIQUE (aeg);


--
-- TOC entry 3503 (class 2606 OID 16837)
-- Name: riigid riigid_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_pk PRIMARY KEY (id, aeg);


--
-- TOC entry 3505 (class 2606 OID 16839)
-- Name: riigid riigid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_unique UNIQUE (id);


--
-- TOC entry 3509 (class 2606 OID 16841)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_pkey PRIMARY KEY (toode, tootja, aeg);


--
-- TOC entry 3507 (class 2606 OID 16843)
-- Name: toode toode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode
    ADD CONSTRAINT toode_pkey PRIMARY KEY (id);


--
-- TOC entry 3511 (class 2606 OID 16845)
-- Name: tootja_ja_riik tootja_ja_riik_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_pkey PRIMARY KEY (tootja, riik);


--
-- TOC entry 3513 (class 2606 OID 16847)
-- Name: tootjad tootjad_nimi_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad
    ADD CONSTRAINT tootjad_nimi_key UNIQUE (nimi);


--
-- TOC entry 3515 (class 2606 OID 16849)
-- Name: tootjad tootjad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad
    ADD CONSTRAINT tootjad_pkey PRIMARY KEY (id);


--
-- TOC entry 3516 (class 2606 OID 16850)
-- Name: poed_toodevahetabel poed_toodevahetabel_fk0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_fk0 FOREIGN KEY (toode) REFERENCES public.toode(id);


--
-- TOC entry 3517 (class 2606 OID 16855)
-- Name: poed_toodevahetabel poed_toodevahetabel_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_fk1 FOREIGN KEY (pood) REFERENCES public.poed(id);


--
-- TOC entry 3518 (class 2606 OID 16860)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_fk0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_fk0 FOREIGN KEY (toode) REFERENCES public.toode(id);


--
-- TOC entry 3519 (class 2606 OID 16865)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_fk1 FOREIGN KEY (tootja) REFERENCES public.tootjad(id);


--
-- TOC entry 3520 (class 2606 OID 16870)
-- Name: tootja_ja_riik tootja_ja_riik_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_fk1 FOREIGN KEY (riik) REFERENCES public.riigid(id);


--
-- TOC entry 3521 (class 2606 OID 16875)
-- Name: tootja_ja_riik tootja_ja_riik_fk2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_fk2 FOREIGN KEY (tootja) REFERENCES public.tootjad(id);


-- Completed on 2024-05-05 10:29:29 EEST

--
-- PostgreSQL database dump complete
--

