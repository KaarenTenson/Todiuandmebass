--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-05-05 13:35:10

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
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 234 (class 1255 OID 41674)
-- Name: f_hinna_vordlus(character varying, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.f_hinna_vordlus(tootenimi character varying, aeg1 timestamp without time zone) RETURNS TABLE(poenimi character varying, hind double precision)
    LANGUAGE sql
    AS $$ select p.nimi,avg(hind) from poed_toodevahetabel pt 
right join poed p on pt.pood=p.id where pt.toode=(select id from toode where tootenimi=toode.nimi) and 
pt.aeg>=aeg1 group by p.nimi;
$$;


--
-- TOC entry 230 (class 1255 OID 41681)
-- Name: f_min_hind(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.f_min_hind(tootenimi character varying) RETURNS double precision
    LANGUAGE sql
    AS $$ select min(hind) from poed_toodevahetabel pt 
where pt.toode=(select id from toode where tootenimi=toode.nimi) and 
pt.aeg=(select min(aeg) from poed_toodevahetabel);
$$;


--
-- TOC entry 231 (class 1255 OID 41686)
-- Name: f_sisestatihind(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.f_sisestatihind() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
 	IF NEW.hind<0 then
 	raise exception 'hind on negatiivne';
 	END IF;
 RETURN NEW;
END;
$$;


--
-- TOC entry 232 (class 1255 OID 41696)
-- Name: f_sisestatikogus(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.f_sisestatikogus() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
 	IF NEW.hind<0 then
 	raise exception 'hind on negatiivne';
 	END IF;
 RETURN NEW;
END;
$$;


--
-- TOC entry 233 (class 1255 OID 41698)
-- Name: f_sisestatitoode(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.f_sisestatitoode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
 	IF NEW.nimi in (select nimi from toode)
 	then raise exception 'Toode eksisteerib juba';
 	END IF;
 RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 41595)
-- Name: poed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poed (
    id integer NOT NULL,
    nimi character varying(100) NOT NULL,
    telefoni_number character varying(10),
    "päritolu" character varying(100) NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 41599)
-- Name: poed_toodevahetabel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poed_toodevahetabel (
    toode integer NOT NULL,
    pood integer NOT NULL,
    aeg timestamp without time zone NOT NULL,
    hind double precision NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 41675)
-- Name: keskmine_hind; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.keskmine_hind AS
 SELECT avg(pt.hind) AS avg,
    p.nimi
   FROM (public.poed_toodevahetabel pt
     RIGHT JOIN public.poed p ON ((pt.pood = p.id)))
  GROUP BY p.nimi;


--
-- TOC entry 216 (class 1259 OID 41598)
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
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 216
-- Name: poed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.poed_id_seq OWNED BY public.poed.id;


--
-- TOC entry 218 (class 1259 OID 41602)
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
-- TOC entry 219 (class 1259 OID 41605)
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
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 219
-- Name: riigid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.riigid_id_seq OWNED BY public.riigid.id;


--
-- TOC entry 220 (class 1259 OID 41606)
-- Name: toode; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.toode (
    id integer NOT NULL,
    kogus_kaal double precision NOT NULL,
    nimi character varying(100) NOT NULL,
    "kogus_või_kaal" boolean NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 41609)
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
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 221
-- Name: toode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.toode_id_seq OWNED BY public.toode.id;


--
-- TOC entry 222 (class 1259 OID 41610)
-- Name: toode_ja_tootja_vahetabel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.toode_ja_tootja_vahetabel (
    toode integer NOT NULL,
    tootja integer NOT NULL,
    maht double precision NOT NULL,
    aeg timestamp without time zone NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 41613)
-- Name: tootja_ja_riik; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tootja_ja_riik (
    tootja integer NOT NULL,
    riik integer NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 41616)
-- Name: tootjad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tootjad (
    id integer NOT NULL,
    nimi character varying(100) NOT NULL,
    "päritolu" character varying(100) NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 41619)
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
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 225
-- Name: tootjad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tootjad_id_seq OWNED BY public.tootjad.id;


--
-- TOC entry 227 (class 1259 OID 41682)
-- Name: v_keskmine_hind; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_keskmine_hind AS
 SELECT avg(pt.hind) AS avg,
    p.nimi
   FROM (public.poed_toodevahetabel pt
     RIGHT JOIN public.poed p ON ((pt.pood = p.id)))
  GROUP BY p.nimi;


--
-- TOC entry 229 (class 1259 OID 41692)
-- Name: v_min_hinnad; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_min_hinnad AS
 SELECT nimi,
    kogus_kaal,
    "kogus_või_kaal",
    public.f_min_hind(nimi) AS parim_hind
   FROM public.toode;


--
-- TOC entry 228 (class 1259 OID 41688)
-- Name: v_toode_tootja; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_toode_tootja AS
 SELECT toode.nimi AS toode,
    t.nimi AS tootja,
    sum(tjtv.maht) AS maht
   FROM ((public.toode_ja_tootja_vahetabel tjtv
     LEFT JOIN public.tootjad t ON ((t.id = tjtv.tootja)))
     LEFT JOIN public.toode ON ((tjtv.toode = toode.id)))
  GROUP BY toode.nimi, t.nimi;


--
-- TOC entry 4736 (class 2604 OID 41620)
-- Name: poed id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed ALTER COLUMN id SET DEFAULT nextval('public.poed_id_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 41621)
-- Name: riigid id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid ALTER COLUMN id SET DEFAULT nextval('public.riigid_id_seq'::regclass);


--
-- TOC entry 4738 (class 2604 OID 41622)
-- Name: toode id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode ALTER COLUMN id SET DEFAULT nextval('public.toode_id_seq'::regclass);


--
-- TOC entry 4739 (class 2604 OID 41623)
-- Name: tootjad id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad ALTER COLUMN id SET DEFAULT nextval('public.tootjad_id_seq'::regclass);


--
-- TOC entry 4916 (class 0 OID 41595)
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
-- TOC entry 4918 (class 0 OID 41599)
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
-- TOC entry 4919 (class 0 OID 41602)
-- Dependencies: 218
-- Data for Name: riigid; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.riigid VALUES (1, 'Eesti', 36011.14, 19.2, '2022-12-31 00:00:00');
INSERT INTO public.riigid VALUES (3, 'Costa Rica', 69242.16, 8.3, '2022-12-25 00:00:00');
INSERT INTO public.riigid VALUES (4, 'USA', 21439162.1, 1.81, '2019-12-25 00:00:00');
INSERT INTO public.riigid VALUES (6, 'Rootsi', 591251.52, 8.4, '2022-12-24 00:00:00');


--
-- TOC entry 4921 (class 0 OID 41606)
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
-- TOC entry 4923 (class 0 OID 41610)
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
-- TOC entry 4924 (class 0 OID 41613)
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
-- TOC entry 4925 (class 0 OID 41616)
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
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 216
-- Name: poed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.poed_id_seq', 11, true);


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 219
-- Name: riigid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.riigid_id_seq', 6, true);


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 221
-- Name: toode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.toode_id_seq', 6, true);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 225
-- Name: tootjad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tootjad_id_seq', 6, true);


--
-- TOC entry 4741 (class 2606 OID 41625)
-- Name: poed poed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed
    ADD CONSTRAINT poed_pkey PRIMARY KEY (id);


--
-- TOC entry 4743 (class 2606 OID 41627)
-- Name: poed_toodevahetabel poed_toodevahetabel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_pkey PRIMARY KEY (toode, pood, aeg);


--
-- TOC entry 4745 (class 2606 OID 41629)
-- Name: riigid riigid_aeg_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_aeg_key UNIQUE (aeg);


--
-- TOC entry 4747 (class 2606 OID 41631)
-- Name: riigid riigid_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_pk PRIMARY KEY (id, aeg);


--
-- TOC entry 4749 (class 2606 OID 41633)
-- Name: riigid riigid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_unique UNIQUE (id);


--
-- TOC entry 4753 (class 2606 OID 41635)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_pkey PRIMARY KEY (toode, tootja, aeg);


--
-- TOC entry 4751 (class 2606 OID 41637)
-- Name: toode toode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode
    ADD CONSTRAINT toode_pkey PRIMARY KEY (id);


--
-- TOC entry 4755 (class 2606 OID 41639)
-- Name: tootja_ja_riik tootja_ja_riik_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_pkey PRIMARY KEY (tootja, riik);


--
-- TOC entry 4757 (class 2606 OID 41641)
-- Name: tootjad tootjad_nimi_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad
    ADD CONSTRAINT tootjad_nimi_key UNIQUE (nimi);


--
-- TOC entry 4759 (class 2606 OID 41643)
-- Name: tootjad tootjad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad
    ADD CONSTRAINT tootjad_pkey PRIMARY KEY (id);


--
-- TOC entry 4766 (class 2620 OID 41687)
-- Name: poed_toodevahetabel tg_poed_toodevahetabel; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_poed_toodevahetabel BEFORE INSERT OR UPDATE ON public.poed_toodevahetabel FOR EACH ROW EXECUTE FUNCTION public.f_sisestatihind();


--
-- TOC entry 4767 (class 2620 OID 41699)
-- Name: toode tg_toode; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_toode BEFORE INSERT ON public.toode FOR EACH ROW EXECUTE FUNCTION public.f_sisestatitoode();


--
-- TOC entry 4768 (class 2620 OID 41697)
-- Name: toode_ja_tootja_vahetabel tg_toode_tootjavahetabel; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_toode_tootjavahetabel BEFORE INSERT OR UPDATE ON public.toode_ja_tootja_vahetabel FOR EACH ROW EXECUTE FUNCTION public.f_sisestatikogus();


--
-- TOC entry 4760 (class 2606 OID 41644)
-- Name: poed_toodevahetabel poed_toodevahetabel_fk0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_fk0 FOREIGN KEY (toode) REFERENCES public.toode(id);


--
-- TOC entry 4761 (class 2606 OID 41649)
-- Name: poed_toodevahetabel poed_toodevahetabel_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_fk1 FOREIGN KEY (pood) REFERENCES public.poed(id);


--
-- TOC entry 4762 (class 2606 OID 41654)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_fk0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_fk0 FOREIGN KEY (toode) REFERENCES public.toode(id);


--
-- TOC entry 4763 (class 2606 OID 41659)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_fk1 FOREIGN KEY (tootja) REFERENCES public.tootjad(id);


--
-- TOC entry 4764 (class 2606 OID 41664)
-- Name: tootja_ja_riik tootja_ja_riik_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_fk1 FOREIGN KEY (riik) REFERENCES public.riigid(id);


--
-- TOC entry 4765 (class 2606 OID 41669)
-- Name: tootja_ja_riik tootja_ja_riik_fk2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_fk2 FOREIGN KEY (tootja) REFERENCES public.tootjad(id);


-- Completed on 2024-05-05 13:35:10

--
-- PostgreSQL database dump complete
--

