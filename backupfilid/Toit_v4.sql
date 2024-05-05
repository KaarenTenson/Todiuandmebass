--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Postgres.app)
-- Dumped by pg_dump version 16.2 (Postgres.app)

-- Started on 2024-05-05 20:02:26 EEST

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
-- TOC entry 5 (class 2615 OID 16976)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 230 (class 1255 OID 16977)
-- Name: f_hinna_vordlus(character varying, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.f_hinna_vordlus(tootenimi character varying, aeg1 timestamp without time zone) RETURNS TABLE(poenimi character varying, hind double precision)
    LANGUAGE sql
    AS $$ select p.nimi,avg(hind) from poed_toodevahetabel pt 
right join poed p on pt.pood=p.id where pt.toode=(select id from toode where tootenimi=toode.nimi) and 
pt.aeg>=aeg1 group by p.nimi;
$$;


--
-- TOC entry 231 (class 1255 OID 16978)
-- Name: f_min_hind(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.f_min_hind(tootenimi character varying) RETURNS double precision
    LANGUAGE sql
    AS $$ select min(hind) from poed_toodevahetabel pt 
where pt.toode=(select id from toode where tootenimi=toode.nimi) and 
pt.aeg=(select min(aeg) from poed_toodevahetabel);
$$;


--
-- TOC entry 232 (class 1255 OID 16979)
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
-- TOC entry 233 (class 1255 OID 16980)
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
-- TOC entry 234 (class 1255 OID 16981)
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


--
-- TOC entry 245 (class 1255 OID 17091)
-- Name: insert_tootja_ja_riik(integer, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.insert_tootja_ja_riik(IN p_tootja_id integer, IN p_riik_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM tootja_ja_riik
        WHERE tootja = p_tootja_id
        AND riik = p_riik_id
    ) THEN
        NULL; 
    ELSE
        INSERT INTO tootja_ja_riik (tootja, riik)
        VALUES (p_tootja_id, p_riik_id);
    END IF;
END;
$$;


--
-- TOC entry 235 (class 1255 OID 17084)
-- Name: kustuta_pood(integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.kustuta_pood(IN p_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM poed WHERE id = p_id;
END;
$$;


--
-- TOC entry 247 (class 1255 OID 17092)
-- Name: kustuta_riik(character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.kustuta_riik(IN p_riigi_nimi character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    DELETE FROM riigid
    WHERE nimi = p_riigi_nimi;

    
    IF EXISTS (
        SELECT 1
        FROM tootja_ja_riik tjr
        JOIN riigid r ON tjr.riik = r.id
        WHERE r.nimi = p_riigi_nimi
    ) THEN
        DELETE FROM tootja_ja_riik
        WHERE riik = (SELECT id FROM riigid WHERE nimi = p_riigi_nimi);
    END IF;
END;
$$;


--
-- TOC entry 246 (class 1255 OID 17089)
-- Name: kustuta_riik(character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.kustuta_riik(IN p_riigi_nimi character varying, IN p_asukoht character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    DELETE FROM riigid
    WHERE nimi = p_riigi_nimi;

    
    IF EXISTS (
        SELECT 1
        FROM tootja_ja_riik tjr
        JOIN riigid r ON tjr.riik = r.id
        WHERE r.nimi = p_riigi_nimi
    ) THEN
        DELETE FROM tootja_ja_riik
        WHERE riik = (SELECT id FROM riigid WHERE nimi = p_riigi_nimi);
    END IF;
END;
$$;


--
-- TOC entry 243 (class 1255 OID 17085)
-- Name: kustuta_toode(integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.kustuta_toode(IN p_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM toode WHERE id = p_id;
END;
$$;


--
-- TOC entry 244 (class 1255 OID 17090)
-- Name: kustuta_tootja(integer, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.kustuta_tootja(IN p_tootja_nimi integer, IN p_asukoht character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM tootjad
    WHERE nimi = p_tootja_nimi
   	and "päritolu" = p_asukoht;
END;
$$;


--
-- TOC entry 248 (class 1255 OID 17093)
-- Name: kustuta_tootja(character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.kustuta_tootja(IN p_tootja_nimi character varying, IN p_asukoht character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    
    DELETE FROM tootjad
    WHERE nimi = p_tootja_nimi
    AND "päritolu" = p_asukoht;

    
    IF (SELECT EXISTS (
        SELECT 1
        FROM tootja_ja_riik tjr
        JOIN tootjad tj ON tjr.tootja = tj.id
        WHERE tj.nimi = p_tootja_nimi
    )) THEN
        DELETE FROM tootja_ja_riik
        WHERE tootja = (SELECT id FROM tootjad WHERE nimi = p_tootja_nimi);
    END IF;
END;
$$;


--
-- TOC entry 238 (class 1255 OID 17086)
-- Name: sisesta_hind_aasta(integer, integer, integer, double precision); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.sisesta_hind_aasta(IN p_toode_id integer, IN p_pood_id integer, IN p_year integer, IN p_price double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM poed_toodevahetabel
        WHERE toode = p_toode_id
        AND pood = p_pood_id
        AND EXTRACT(YEAR FROM aeg) = p_year
    )
    then null;
    ELSE
        INSERT INTO poed_toodevahetabel (toode, pood, aeg, hind)
        VALUES (p_toode_id, p_pood_id, p_year || '-01-01'::date, p_price);
    END IF;
END;
$$;


--
-- TOC entry 239 (class 1255 OID 17081)
-- Name: sisesta_toode(double precision, character varying, boolean); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.sisesta_toode(IN p_kogus_kaal double precision, IN p_nimi character varying, IN p_kogus_voi_kaal boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO toode (kogus_kaal, nimi, "kogus_või_kaal")
    VALUES (p_kogus_kaal, p_nimi, p_kogus_voi_kaal);
END;
$$;


--
-- TOC entry 242 (class 1255 OID 17080)
-- Name: tekkita_pood(character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.tekkita_pood(IN p_nimi character varying, IN p_telefoni_number character varying, IN p_paritolu character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO poed (nimi, telefoni_number, "päritolu")
    VALUES (p_nimi, p_telefoni_number, p_paritolu);
END;
$$;


--
-- TOC entry 236 (class 1255 OID 17087)
-- Name: tekkita_uus_riik(character varying, double precision, double precision, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.tekkita_uus_riik(IN p_riigi_nimi character varying, IN p_skp double precision, IN p_inflatsioon double precision, IN p_year integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM riigid
        WHERE nimi = p_riigi_nimi
    ) THEN
        NULL;
    ELSE
        INSERT INTO riigid (nimi, skp, inflatsioon, aeg)
        VALUES (p_riigi_nimi, p_skp, p_inflatsioon, p_year || '-01-01'::date);
    END IF;
END;
$$;


--
-- TOC entry 237 (class 1255 OID 17088)
-- Name: tekkita_uus_tootja(character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.tekkita_uus_tootja(IN p_tootja_nimi character varying, IN p_paritolu character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM tootjad
        WHERE nimi = p_tootja_nimi
        AND "päritolu" = p_paritolu
    ) THEN
        NULL;
    ELSE
        INSERT INTO tootjad (nimi, "päritolu")
        VALUES (p_tootja_nimi, p_paritolu);
    END IF;
END;
$$;


--
-- TOC entry 240 (class 1255 OID 17082)
-- Name: uuenda_pood(integer, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.uuenda_pood(IN p_id integer, IN p_nimi character varying, IN p_telefoni_number character varying, IN p_paritolu character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE poed
    SET nimi = p_nimi,
        telefoni_number = p_telefoni_number,
        "päritolu" = p_paritolu
    WHERE id = p_id;
END;
$$;


--
-- TOC entry 241 (class 1255 OID 17083)
-- Name: uuenda_toode(integer, double precision, character varying, boolean); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.uuenda_toode(IN p_id integer, IN p_kogus_kaal double precision, IN p_nimi character varying, IN p_kogus_voi_kaal boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE toode
    SET kogus_kaal = p_kogus_kaal,
        nimi = p_nimi,
        "kogus_või_kaal" = p_kogus_voi_kaal
    WHERE id = p_id;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16982)
-- Name: poed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poed (
    id integer NOT NULL,
    nimi character varying(100) NOT NULL,
    telefoni_number character varying(10),
    "päritolu" character varying(100) NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 16985)
-- Name: poed_toodevahetabel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poed_toodevahetabel (
    toode integer NOT NULL,
    pood integer NOT NULL,
    aeg timestamp without time zone NOT NULL,
    hind double precision NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 16988)
-- Name: keskmine_hind; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.keskmine_hind AS
 SELECT avg(pt.hind) AS avg,
    p.nimi
   FROM (public.poed_toodevahetabel pt
     RIGHT JOIN public.poed p ON ((pt.pood = p.id)))
  GROUP BY p.nimi;


--
-- TOC entry 218 (class 1259 OID 16992)
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
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 218
-- Name: poed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.poed_id_seq OWNED BY public.poed.id;


--
-- TOC entry 219 (class 1259 OID 16993)
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
-- TOC entry 220 (class 1259 OID 16996)
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
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 220
-- Name: riigid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.riigid_id_seq OWNED BY public.riigid.id;


--
-- TOC entry 221 (class 1259 OID 16997)
-- Name: toode; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.toode (
    id integer NOT NULL,
    kogus_kaal double precision NOT NULL,
    nimi character varying(100) NOT NULL,
    "kogus_või_kaal" boolean NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 17000)
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
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 222
-- Name: toode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.toode_id_seq OWNED BY public.toode.id;


--
-- TOC entry 223 (class 1259 OID 17001)
-- Name: toode_ja_tootja_vahetabel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.toode_ja_tootja_vahetabel (
    toode integer NOT NULL,
    tootja integer NOT NULL,
    maht double precision NOT NULL,
    aeg timestamp without time zone NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 17004)
-- Name: tootja_ja_riik; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tootja_ja_riik (
    tootja integer NOT NULL,
    riik integer NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 17007)
-- Name: tootjad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tootjad (
    id integer NOT NULL,
    nimi character varying(100) NOT NULL,
    "päritolu" character varying(100) NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 17010)
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
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 226
-- Name: tootjad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tootjad_id_seq OWNED BY public.tootjad.id;


--
-- TOC entry 227 (class 1259 OID 17011)
-- Name: v_keskmine_hind; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_keskmine_hind AS
 SELECT avg(pt.hind) AS avg,
    p.nimi
   FROM (public.poed_toodevahetabel pt
     RIGHT JOIN public.poed p ON ((pt.pood = p.id)))
  GROUP BY p.nimi;


--
-- TOC entry 228 (class 1259 OID 17015)
-- Name: v_min_hinnad; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_min_hinnad AS
 SELECT nimi,
    kogus_kaal,
    "kogus_või_kaal",
    public.f_min_hind(nimi) AS parim_hind
   FROM public.toode;


--
-- TOC entry 229 (class 1259 OID 17019)
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
-- TOC entry 3527 (class 2604 OID 17023)
-- Name: poed id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed ALTER COLUMN id SET DEFAULT nextval('public.poed_id_seq'::regclass);


--
-- TOC entry 3528 (class 2604 OID 17024)
-- Name: riigid id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid ALTER COLUMN id SET DEFAULT nextval('public.riigid_id_seq'::regclass);


--
-- TOC entry 3529 (class 2604 OID 17025)
-- Name: toode id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode ALTER COLUMN id SET DEFAULT nextval('public.toode_id_seq'::regclass);


--
-- TOC entry 3530 (class 2604 OID 17026)
-- Name: tootjad id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad ALTER COLUMN id SET DEFAULT nextval('public.tootjad_id_seq'::regclass);


--
-- TOC entry 3707 (class 0 OID 16982)
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
-- TOC entry 3708 (class 0 OID 16985)
-- Dependencies: 216
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
-- TOC entry 3710 (class 0 OID 16993)
-- Dependencies: 219
-- Data for Name: riigid; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.riigid VALUES (1, 'Eesti', 36011.14, 19.2, '2022-12-31 00:00:00');
INSERT INTO public.riigid VALUES (3, 'Costa Rica', 69242.16, 8.3, '2022-12-25 00:00:00');
INSERT INTO public.riigid VALUES (4, 'USA', 21439162.1, 1.81, '2019-12-25 00:00:00');
INSERT INTO public.riigid VALUES (6, 'Rootsi', 591251.52, 8.4, '2022-12-24 00:00:00');


--
-- TOC entry 3712 (class 0 OID 16997)
-- Dependencies: 221
-- Data for Name: toode; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.toode VALUES (3, 10, 'Munad M-suurus', true);
INSERT INTO public.toode VALUES (4, 475, 'Tallinna Peenleib', false);
INSERT INTO public.toode VALUES (2, 1000, 'Piim TERE 2,5%', true);
INSERT INTO public.toode VALUES (5, 2000, 'Coca-Cola', true);
INSERT INTO public.toode VALUES (6, 1000, 'Sool', false);
INSERT INTO public.toode VALUES (1, 1000, 'Banaan', true);


--
-- TOC entry 3714 (class 0 OID 17001)
-- Dependencies: 223
-- Data for Name: toode_ja_tootja_vahetabel; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.toode_ja_tootja_vahetabel VALUES (1, 2, 1000, '2023-04-24 00:00:00');
INSERT INTO public.toode_ja_tootja_vahetabel VALUES (2, 1, 1000, '2023-04-24 00:00:00');
INSERT INTO public.toode_ja_tootja_vahetabel VALUES (3, 3, 10, '2023-04-24 00:00:00');
INSERT INTO public.toode_ja_tootja_vahetabel VALUES (4, 4, 475, '2023-04-24 00:00:00');
INSERT INTO public.toode_ja_tootja_vahetabel VALUES (5, 5, 2000, '2023-04-24 00:00:00');
INSERT INTO public.toode_ja_tootja_vahetabel VALUES (6, 6, 1000, '2023-04-24 00:00:00');


--
-- TOC entry 3715 (class 0 OID 17004)
-- Dependencies: 224
-- Data for Name: tootja_ja_riik; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tootja_ja_riik VALUES (1, 1);
INSERT INTO public.tootja_ja_riik VALUES (2, 3);
INSERT INTO public.tootja_ja_riik VALUES (3, 1);
INSERT INTO public.tootja_ja_riik VALUES (4, 1);
INSERT INTO public.tootja_ja_riik VALUES (5, 4);
INSERT INTO public.tootja_ja_riik VALUES (6, 6);


--
-- TOC entry 3716 (class 0 OID 17007)
-- Dependencies: 225
-- Data for Name: tootjad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tootjad VALUES (1, 'Tere AS', 'Eesti');
INSERT INTO public.tootjad VALUES (2, 'Chiquita', 'Costa Rica');
INSERT INTO public.tootjad VALUES (3, 'Eggo', 'Eesti');
INSERT INTO public.tootjad VALUES (4, 'Leibur', 'Eesti');
INSERT INTO public.tootjad VALUES (5, 'Coca-Cola Company', 'USA');
INSERT INTO public.tootjad VALUES (6, 'Santa Maria', 'Rootsi');


--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 218
-- Name: poed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.poed_id_seq', 11, true);


--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 220
-- Name: riigid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.riigid_id_seq', 6, true);


--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 222
-- Name: toode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.toode_id_seq', 6, true);


--
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 226
-- Name: tootjad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tootjad_id_seq', 6, true);


--
-- TOC entry 3532 (class 2606 OID 17028)
-- Name: poed poed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed
    ADD CONSTRAINT poed_pkey PRIMARY KEY (id);


--
-- TOC entry 3534 (class 2606 OID 17030)
-- Name: poed_toodevahetabel poed_toodevahetabel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_pkey PRIMARY KEY (toode, pood, aeg);


--
-- TOC entry 3536 (class 2606 OID 17032)
-- Name: riigid riigid_aeg_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_aeg_key UNIQUE (aeg);


--
-- TOC entry 3538 (class 2606 OID 17034)
-- Name: riigid riigid_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_pk PRIMARY KEY (id, aeg);


--
-- TOC entry 3540 (class 2606 OID 17036)
-- Name: riigid riigid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riigid
    ADD CONSTRAINT riigid_unique UNIQUE (id);


--
-- TOC entry 3544 (class 2606 OID 17038)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_pkey PRIMARY KEY (toode, tootja, aeg);


--
-- TOC entry 3542 (class 2606 OID 17040)
-- Name: toode toode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode
    ADD CONSTRAINT toode_pkey PRIMARY KEY (id);


--
-- TOC entry 3546 (class 2606 OID 17042)
-- Name: tootja_ja_riik tootja_ja_riik_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_pkey PRIMARY KEY (tootja, riik);


--
-- TOC entry 3548 (class 2606 OID 17044)
-- Name: tootjad tootjad_nimi_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad
    ADD CONSTRAINT tootjad_nimi_key UNIQUE (nimi);


--
-- TOC entry 3550 (class 2606 OID 17046)
-- Name: tootjad tootjad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootjad
    ADD CONSTRAINT tootjad_pkey PRIMARY KEY (id);


--
-- TOC entry 3557 (class 2620 OID 17047)
-- Name: poed_toodevahetabel tg_poed_toodevahetabel; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_poed_toodevahetabel BEFORE INSERT OR UPDATE ON public.poed_toodevahetabel FOR EACH ROW EXECUTE FUNCTION public.f_sisestatihind();


--
-- TOC entry 3558 (class 2620 OID 17048)
-- Name: toode tg_toode; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_toode BEFORE INSERT ON public.toode FOR EACH ROW EXECUTE FUNCTION public.f_sisestatitoode();


--
-- TOC entry 3559 (class 2620 OID 17049)
-- Name: toode_ja_tootja_vahetabel tg_toode_tootjavahetabel; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_toode_tootjavahetabel BEFORE INSERT OR UPDATE ON public.toode_ja_tootja_vahetabel FOR EACH ROW EXECUTE FUNCTION public.f_sisestatikogus();


--
-- TOC entry 3551 (class 2606 OID 17050)
-- Name: poed_toodevahetabel poed_toodevahetabel_fk0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_fk0 FOREIGN KEY (toode) REFERENCES public.toode(id);


--
-- TOC entry 3552 (class 2606 OID 17055)
-- Name: poed_toodevahetabel poed_toodevahetabel_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_fk1 FOREIGN KEY (pood) REFERENCES public.poed(id);


--
-- TOC entry 3553 (class 2606 OID 17060)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_fk0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_fk0 FOREIGN KEY (toode) REFERENCES public.toode(id);


--
-- TOC entry 3554 (class 2606 OID 17065)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_fk1 FOREIGN KEY (tootja) REFERENCES public.tootjad(id);


--
-- TOC entry 3555 (class 2606 OID 17070)
-- Name: tootja_ja_riik tootja_ja_riik_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_fk1 FOREIGN KEY (riik) REFERENCES public.riigid(id);


--
-- TOC entry 3556 (class 2606 OID 17075)
-- Name: tootja_ja_riik tootja_ja_riik_fk2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tootja_ja_riik
    ADD CONSTRAINT tootja_ja_riik_fk2 FOREIGN KEY (tootja) REFERENCES public.tootjad(id);


-- Completed on 2024-05-05 20:02:26 EEST

--
-- PostgreSQL database dump complete
--

