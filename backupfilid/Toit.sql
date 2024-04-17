--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-04-17 15:16:32

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
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 33117)
-- Name: Poed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Poed" (
    id integer NOT NULL,
    "Nimi" character varying(255) NOT NULL,
    telefoni_number character varying(255),
    "päritolu" character varying(255) NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 33155)
-- Name: Riigid; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Riigid" (
    id integer NOT NULL,
    nimi character varying(255) NOT NULL,
    skp double precision NOT NULL,
    inflatsioon double precision NOT NULL,
    aeg timestamp without time zone NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 33101)
-- Name: Toode; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Toode" (
    id integer NOT NULL,
    "kogus/kaal" double precision NOT NULL,
    nimi character varying(255) NOT NULL,
    "kogus_või_kaal" boolean NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 33110)
-- Name: Tootjad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Tootjad" (
    id integer NOT NULL,
    nimi character varying(255) NOT NULL,
    "päritolu" integer NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 33140)
-- Name: poed_toodevahetabel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.poed_toodevahetabel (
    toode integer NOT NULL,
    pood integer NOT NULL,
    aeg timestamp without time zone NOT NULL,
    hind double precision[] NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 33126)
-- Name: toode_ja_tootja_vahetabel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.toode_ja_tootja_vahetabel (
    toode integer NOT NULL,
    tootja integer NOT NULL,
    maht double precision NOT NULL,
    aeg timestamp without time zone NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 33135)
-- Name: vahetabel(tootja->riik); Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."vahetabel(tootja->riik)" (
    tootja integer NOT NULL,
    riik integer NOT NULL
);


--
-- TOC entry 4892 (class 0 OID 33117)
-- Dependencies: 217
-- Data for Name: Poed; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4896 (class 0 OID 33155)
-- Dependencies: 221
-- Data for Name: Riigid; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4890 (class 0 OID 33101)
-- Dependencies: 215
-- Data for Name: Toode; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4891 (class 0 OID 33110)
-- Dependencies: 216
-- Data for Name: Tootjad; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4895 (class 0 OID 33140)
-- Dependencies: 220
-- Data for Name: poed_toodevahetabel; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4893 (class 0 OID 33126)
-- Dependencies: 218
-- Data for Name: toode_ja_tootja_vahetabel; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4894 (class 0 OID 33135)
-- Dependencies: 219
-- Data for Name: vahetabel(tootja->riik); Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 4720 (class 2606 OID 33125)
-- Name: Poed Poed_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Poed"
    ADD CONSTRAINT "Poed_id_key" UNIQUE (id);


--
-- TOC entry 4734 (class 2606 OID 33163)
-- Name: Riigid Riigid_aeg_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Riigid"
    ADD CONSTRAINT "Riigid_aeg_key" UNIQUE (aeg);


--
-- TOC entry 4736 (class 2606 OID 33161)
-- Name: Riigid Riigid_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Riigid"
    ADD CONSTRAINT "Riigid_id_key" UNIQUE (id);


--
-- TOC entry 4738 (class 2606 OID 33184)
-- Name: Riigid Riigid_nimi_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Riigid"
    ADD CONSTRAINT "Riigid_nimi_key" UNIQUE (nimi);


--
-- TOC entry 4712 (class 2606 OID 33107)
-- Name: Toode Toode_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Toode"
    ADD CONSTRAINT "Toode_id_key" UNIQUE (id);


--
-- TOC entry 4716 (class 2606 OID 33116)
-- Name: Tootjad Tootjad_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Tootjad"
    ADD CONSTRAINT "Tootjad_id_key" UNIQUE (id);


--
-- TOC entry 4722 (class 2606 OID 33211)
-- Name: Poed poed_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Poed"
    ADD CONSTRAINT poed_pk PRIMARY KEY (id);


--
-- TOC entry 4732 (class 2606 OID 33203)
-- Name: poed_toodevahetabel poed_toodevahetabel_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_pk PRIMARY KEY (toode, pood, aeg);


--
-- TOC entry 4740 (class 2606 OID 33205)
-- Name: Riigid riigid_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Riigid"
    ADD CONSTRAINT riigid_pk PRIMARY KEY (id, aeg);


--
-- TOC entry 4724 (class 2606 OID 33134)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_aeg_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_aeg_key UNIQUE (aeg);


--
-- TOC entry 4726 (class 2606 OID 33130)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_pkey PRIMARY KEY (toode, tootja, aeg);


--
-- TOC entry 4728 (class 2606 OID 33132)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_toode_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_toode_key UNIQUE (toode);


--
-- TOC entry 4714 (class 2606 OID 33207)
-- Name: Toode toode_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Toode"
    ADD CONSTRAINT toode_pk PRIMARY KEY (id);


--
-- TOC entry 4718 (class 2606 OID 33209)
-- Name: Tootjad tootjad_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Tootjad"
    ADD CONSTRAINT tootjad_pk PRIMARY KEY (id);


--
-- TOC entry 4730 (class 2606 OID 33223)
-- Name: vahetabel(tootja->riik) vahetabel_tootja_riik__pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."vahetabel(tootja->riik)"
    ADD CONSTRAINT vahetabel_tootja_riik__pk PRIMARY KEY (tootja, riik);


--
-- TOC entry 4745 (class 2606 OID 33190)
-- Name: poed_toodevahetabel Toode_fk0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT "Toode_fk0" FOREIGN KEY (toode) REFERENCES public."Toode"(id);


--
-- TOC entry 4746 (class 2606 OID 33166)
-- Name: poed_toodevahetabel poed_toodevahetabel_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.poed_toodevahetabel
    ADD CONSTRAINT poed_toodevahetabel_fk1 FOREIGN KEY (pood) REFERENCES public."Poed"(id);


--
-- TOC entry 4741 (class 2606 OID 33195)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_fk1 FOREIGN KEY (toode) REFERENCES public."Toode"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4742 (class 2606 OID 33212)
-- Name: toode_ja_tootja_vahetabel toode_ja_tootja_vahetabel_fk2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.toode_ja_tootja_vahetabel
    ADD CONSTRAINT toode_ja_tootja_vahetabel_fk2 FOREIGN KEY (tootja) REFERENCES public."Tootjad"(id);


--
-- TOC entry 4743 (class 2606 OID 33224)
-- Name: vahetabel(tootja->riik) vahetabel(tootja->riik)_fk1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."vahetabel(tootja->riik)"
    ADD CONSTRAINT "vahetabel(tootja->riik)_fk1" FOREIGN KEY (tootja) REFERENCES public."Tootjad"(id);


--
-- TOC entry 4744 (class 2606 OID 33217)
-- Name: vahetabel(tootja->riik) vahetabel(tootja->riik)_fk2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."vahetabel(tootja->riik)"
    ADD CONSTRAINT "vahetabel(tootja->riik)_fk2" FOREIGN KEY (riik) REFERENCES public."Riigid"(id);


-- Completed on 2024-04-17 15:16:32

--
-- PostgreSQL database dump complete
--

