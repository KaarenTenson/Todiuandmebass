--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-04-17 18:57:28

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
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 33329)
-- Name: poed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poed (
    id integer NOT NULL,
    nimi character varying(100) NOT NULL,
    telefoni_number character varying(10),
    "päritolu" character varying(100) NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 33328)
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
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 221
-- Name: poed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.poed_id_seq OWNED BY public.poed.id;


--
-- TOC entry 225 (class 1259 OID 33344)
-- Name: poed_toodevahetabel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poed_toodevahetabel (
    toode integer NOT NULL,
    pood integer NOT NULL,
    aeg time without time zone NOT NULL,
    hind double precision NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 33336)
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
-- TOC entry 223 (class 1259 OID 33335)
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
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 223
-- Name: riigid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.riigid_id_seq OWNED BY public.riigid.id;


--
-- TOC entry 218 (class 1259 OID 33313)
-- Name: toode; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.toode (
    id integer NOT NULL,
    kogus_kaal double precision NOT NULL,
    nimi character varying(100) NOT NULL,
    "kogus_või_kaal" boolean NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 33312)
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
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 217
-- Name: toode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.toode_id_seq OWNED BY public.toode.id;


--
-- TOC entry 215 (class 1259 OID 33302)
-- Name: toode_ja_tootja_vahetabel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.toode_ja_tootja_vahetabel (
    toode integer NOT NULL,
    tootja integer NOT NULL,
    maht double precision NOT NULL,
    aeg timestamp without time zone NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 33307)
-- Name: tootja_ja_riik; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tootja_ja_riik (
    tootja integer NOT NULL,
    riik integer NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 33320)
-- Name: tootjad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tootjad (
    id integer NOT NULL,
    nimi character varying(100) NOT NULL,
    "päritolu" character varying(100) NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 33319)
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
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 219
-- Name: tootjad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tootjad_id_seq OWNED BY public.tootjad.id;


--
-- TOC entry 4717 (class 2604 OID 33332)
-- Name: poed id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed ALTER COLUMN id SET DEFAULT nextval('public.poed_id_seq'::regclass);


--
-- TOC entry 4718 (class 2604 OID 33339)
-- Name: riigid id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid ALTER COLUMN id SET DEFAULT nextval('public.riigid_id_seq'::regclass);


--
-- TOC entry 4715 (class 2604 OID 33316)
-- Name: toode id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode ALTER COLUMN id SET DEFAULT nextval('public.toode_id_seq'::regclass);


--
-- TOC entry 4716 (class 2604 OID 33323)
-- Name: tootjad id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad ALTER COLUMN id SET DEFAULT nextval('public.tootjad_id_seq'::regclass);


--
-- TOC entry 4895 (class 0 OID 33329)
-- Dependencies: 222
-- Data for Name: poed; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4898 (class 0 OID 33344)
-- Dependencies: 225
-- Data for Name: poed_toodevahetabel; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4897 (class 0 OID 33336)
-- Dependencies: 224
-- Data for Name: riigid; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4891 (class 0 OID 33313)
-- Dependencies: 218
-- Data for Name: toode; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.toode VALUES (1, 10, 'banaan', true);


--
-- TOC entry 4888 (class 0 OID 33302)
-- Dependencies: 215
-- Data for Name: toode_ja_tootja_vahetabel; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4889 (class 0 OID 33307)
-- Dependencies: 216
-- Data for Name: tootja_ja_riik; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4893 (class 0 OID 33320)
-- Dependencies: 220
-- Data for Name: tootjad; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 221
-- Name: poed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.poed_id_seq', 1, false);


--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 223
-- Name: riigid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.riigid_id_seq', 1, false);


--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 217
-- Name: toode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.toode_id_seq', 1, true);


--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 219
-- Name: tootjad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tootjad_id_seq', 1, false);


--
-- TOC entry 4730 (class 2606 OID 33334)
-- Name: poed poed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed
    ADD CONSTRAINT poed_pkey PRIMARY KEY (id);


--
-- TOC entry 4738 (class 2606 OID 33348)
-- Name: poed_toodevahetabel poed_toodevahetabel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_pkey PRIMARY KEY (toode, pood, aeg);


--
-- TOC entry 4732 (class 2606 OID 33343)
-- Name: riigid riigid_aeg_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_aeg_key UNIQUE (aeg);


--
-- TOC entry 4734 (class 2606 OID 33380)
-- Name: riigid riigid_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_pk PRIMARY KEY (id, aeg);


--
-- TOC entry 4736 (class 2606 OID 33382)
-- Name: riigid riigid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_unique UNIQUE (id);


--
-- TOC entry 4720 (class 2606 OID 33306)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_pkey PRIMARY KEY (toode, tootja, aeg);


--
-- TOC entry 4724 (class 2606 OID 33318)
-- Name: toode toode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode
    ADD CONSTRAINT toode_pkey PRIMARY KEY (id);


--
-- TOC entry 4722 (class 2606 OID 33311)
-- Name: tootja_ja_riik tootja_ja_riik_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_pkey PRIMARY KEY (tootja, riik);


--
-- TOC entry 4726 (class 2606 OID 33327)
-- Name: tootjad tootjad_nimi_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad
    ADD CONSTRAINT tootjad_nimi_key UNIQUE (nimi);


--
-- TOC entry 4728 (class 2606 OID 33325)
-- Name: tootjad tootjad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad
    ADD CONSTRAINT tootjad_pkey PRIMARY KEY (id);


--
-- TOC entry 4743 (class 2606 OID 33364)
-- Name: poed_toodevahetabel poed_toodevahetabel_fk0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_fk0 FOREIGN KEY (toode) REFERENCES public.toode(id);


--
-- TOC entry 4744 (class 2606 OID 33349)
-- Name: poed_toodevahetabel poed_toodevahetabel_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_fk1 FOREIGN KEY (pood) REFERENCES public.poed(id);


--
-- TOC entry 4739 (class 2606 OID 33354)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_fk0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_fk0 FOREIGN KEY (toode) REFERENCES public.toode(id);


--
-- TOC entry 4740 (class 2606 OID 33359)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_fk1 FOREIGN KEY (tootja) REFERENCES public.tootjad(id);


--
-- TOC entry 4741 (class 2606 OID 33383)
-- Name: tootja_ja_riik tootja_ja_riik_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_fk1 FOREIGN KEY (riik) REFERENCES public.riigid(id);


--
-- TOC entry 4742 (class 2606 OID 33374)
-- Name: tootja_ja_riik tootja_ja_riik_fk2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_fk2 FOREIGN KEY (tootja) REFERENCES public.tootjad(id);


-- Completed on 2024-04-17 18:57:28

--
-- PostgreSQL database dump complete
--

