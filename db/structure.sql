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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: scheduled_trainings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scheduled_trainings (
    id bigint NOT NULL,
    uid uuid DEFAULT gen_random_uuid() NOT NULL,
    instructor_name character varying(256) NOT NULL,
    course_name character varying(256) NOT NULL,
    start_at timestamp without time zone NOT NULL,
    duration_minutes integer DEFAULT 30 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: scheduled_trainings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scheduled_trainings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheduled_trainings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scheduled_trainings_id_seq OWNED BY public.scheduled_trainings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: scheduled_trainings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_trainings ALTER COLUMN id SET DEFAULT nextval('public.scheduled_trainings_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: scheduled_trainings scheduled_trainings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_trainings
    ADD CONSTRAINT scheduled_trainings_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_scheduled_trainings_on_course_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_scheduled_trainings_on_course_name ON public.scheduled_trainings USING btree (course_name);


--
-- Name: index_scheduled_trainings_on_instructor_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scheduled_trainings_on_instructor_name ON public.scheduled_trainings USING btree (instructor_name);


--
-- Name: index_scheduled_trainings_on_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_scheduled_trainings_on_uid ON public.scheduled_trainings USING btree (uid);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210208210247');


