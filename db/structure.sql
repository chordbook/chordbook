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
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: albums; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.albums (
    id bigint NOT NULL,
    title character varying,
    metadata json,
    artist_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    released integer,
    score numeric(3,1),
    genre_id bigint
);


--
-- Name: albums_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.albums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: albums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.albums_id_seq OWNED BY public.albums.id;


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
-- Name: artist_works; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artist_works (
    id bigint NOT NULL,
    artist_id bigint NOT NULL,
    work_type character varying NOT NULL,
    work_id bigint NOT NULL,
    "order" integer
);


--
-- Name: artist_works_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.artist_works_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artist_works_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.artist_works_id_seq OWNED BY public.artist_works.id;


--
-- Name: artists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artists (
    id bigint NOT NULL,
    name character varying,
    metadata json,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    style character varying,
    genre_id bigint,
    verified boolean DEFAULT false
);


--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.artists_id_seq OWNED BY public.artists.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.genres (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    thumbnail character varying,
    listeners bigint
);


--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.genres_id_seq OWNED BY public.genres.id;


--
-- Name: good_job_processes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_processes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    state jsonb
);


--
-- Name: good_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    queue_name text,
    priority integer,
    serialized_params jsonb,
    scheduled_at timestamp without time zone,
    performed_at timestamp without time zone,
    finished_at timestamp without time zone,
    error text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active_job_id uuid,
    concurrency_key text,
    cron_key text,
    retried_good_job_id uuid,
    cron_at timestamp without time zone
);


--
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media (
    id bigint NOT NULL,
    record_type character varying,
    record_id bigint,
    uri character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pg_search_documents (
    id bigint NOT NULL,
    content text,
    data json,
    searchable_type character varying,
    searchable_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    weight double precision DEFAULT 1.0,
    content_tsv tsvector
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pg_search_documents_id_seq OWNED BY public.pg_search_documents.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: setlist_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.setlist_items (
    id bigint NOT NULL,
    setlist_id bigint,
    songsheet_id bigint,
    "position" bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: setlist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.setlist_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: setlist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.setlist_items_id_seq OWNED BY public.setlist_items.id;


--
-- Name: setlists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.setlists (
    id bigint NOT NULL,
    title character varying,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: setlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.setlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: setlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.setlists_id_seq OWNED BY public.setlists.id;


--
-- Name: songsheets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.songsheets (
    id bigint NOT NULL,
    source text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    metadata json,
    track_id bigint,
    title character varying,
    imported_from character varying
);


--
-- Name: songsheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.songsheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: songsheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.songsheets_id_seq OWNED BY public.songsheets.id;


--
-- Name: tracks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tracks (
    id bigint NOT NULL,
    title character varying,
    metadata json,
    artist_id bigint,
    album_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    number integer,
    duration integer,
    listeners bigint,
    genre_id bigint,
    songsheets_count integer DEFAULT 0
);


--
-- Name: tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tracks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tracks_id_seq OWNED BY public.tracks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id bigint NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object json,
    created_at timestamp(6) without time zone,
    object_changes json
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: albums id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums ALTER COLUMN id SET DEFAULT nextval('public.albums_id_seq'::regclass);


--
-- Name: artist_works id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_works ALTER COLUMN id SET DEFAULT nextval('public.artist_works_id_seq'::regclass);


--
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artists_id_seq'::regclass);


--
-- Name: genres id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genres ALTER COLUMN id SET DEFAULT nextval('public.genres_id_seq'::regclass);


--
-- Name: media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents ALTER COLUMN id SET DEFAULT nextval('public.pg_search_documents_id_seq'::regclass);


--
-- Name: setlist_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.setlist_items ALTER COLUMN id SET DEFAULT nextval('public.setlist_items_id_seq'::regclass);


--
-- Name: setlists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.setlists ALTER COLUMN id SET DEFAULT nextval('public.setlists_id_seq'::regclass);


--
-- Name: songsheets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songsheets ALTER COLUMN id SET DEFAULT nextval('public.songsheets_id_seq'::regclass);


--
-- Name: tracks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracks ALTER COLUMN id SET DEFAULT nextval('public.tracks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: artist_works artist_works_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_works
    ADD CONSTRAINT artist_works_pkey PRIMARY KEY (id);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: good_job_processes good_job_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_processes
    ADD CONSTRAINT good_job_processes_pkey PRIMARY KEY (id);


--
-- Name: good_jobs good_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_jobs
    ADD CONSTRAINT good_jobs_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: setlist_items setlist_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.setlist_items
    ADD CONSTRAINT setlist_items_pkey PRIMARY KEY (id);


--
-- Name: setlists setlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.setlists
    ADD CONSTRAINT setlists_pkey PRIMARY KEY (id);


--
-- Name: songsheets songsheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songsheets
    ADD CONSTRAINT songsheets_pkey PRIMARY KEY (id);


--
-- Name: tracks tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_albums_on_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_albums_on_artist_id ON public.albums USING btree (artist_id);


--
-- Name: index_albums_on_genre_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_albums_on_genre_id ON public.albums USING btree (genre_id);


--
-- Name: index_artist_works_on_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artist_works_on_artist_id ON public.artist_works USING btree (artist_id);


--
-- Name: index_artist_works_on_work; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artist_works_on_work ON public.artist_works USING btree (work_type, work_id);


--
-- Name: index_artists_on_genre_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artists_on_genre_id ON public.artists USING btree (genre_id);


--
-- Name: index_good_jobs_jobs_on_finished_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_finished_at ON public.good_jobs USING btree (finished_at) WHERE ((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL));


--
-- Name: index_good_jobs_on_active_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_active_job_id ON public.good_jobs USING btree (active_job_id);


--
-- Name: index_good_jobs_on_active_job_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_active_job_id_and_created_at ON public.good_jobs USING btree (active_job_id, created_at);


--
-- Name: index_good_jobs_on_concurrency_key_when_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_concurrency_key_when_unfinished ON public.good_jobs USING btree (concurrency_key) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_cron_key_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_cron_key_and_created_at ON public.good_jobs USING btree (cron_key, created_at);


--
-- Name: index_good_jobs_on_cron_key_and_cron_at; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_jobs_on_cron_key_and_cron_at ON public.good_jobs USING btree (cron_key, cron_at);


--
-- Name: index_good_jobs_on_queue_name_and_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name_and_scheduled_at ON public.good_jobs USING btree (queue_name, scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_scheduled_at ON public.good_jobs USING btree (scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_media_on_record; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_media_on_record ON public.media USING btree (record_type, record_id);


--
-- Name: index_pg_search_documents_on_content; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_content ON public.pg_search_documents USING gin (content public.gin_trgm_ops);


--
-- Name: index_pg_search_documents_on_content_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_content_tsv ON public.pg_search_documents USING gin (content_tsv);


--
-- Name: index_pg_search_documents_on_searchable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable ON public.pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_setlist_items_on_setlist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_setlist_items_on_setlist_id ON public.setlist_items USING btree (setlist_id);


--
-- Name: index_setlist_items_on_songsheet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_setlist_items_on_songsheet_id ON public.setlist_items USING btree (songsheet_id);


--
-- Name: index_songsheets_on_track_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songsheets_on_track_id ON public.songsheets USING btree (track_id);


--
-- Name: index_tracks_on_album_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tracks_on_album_id ON public.tracks USING btree (album_id);


--
-- Name: index_tracks_on_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tracks_on_artist_id ON public.tracks USING btree (artist_id);


--
-- Name: index_tracks_on_genre_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tracks_on_genre_id ON public.tracks USING btree (genre_id);


--
-- Name: index_tracks_on_genre_id_and_listeners; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tracks_on_genre_id_and_listeners ON public.tracks USING btree (genre_id, listeners);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: uniq_by_artist_and_work; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uniq_by_artist_and_work ON public.artist_works USING btree (artist_id, work_id, work_type, "order");


--
-- Name: pg_search_documents tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.pg_search_documents FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('content_tsv', 'pg_catalog.english', 'content');


--
-- Name: artists fk_rails_0e8756372a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT fk_rails_0e8756372a FOREIGN KEY (genre_id) REFERENCES public.genres(id);


--
-- Name: songsheets fk_rails_432ed80836; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songsheets
    ADD CONSTRAINT fk_rails_432ed80836 FOREIGN KEY (track_id) REFERENCES public.tracks(id);


--
-- Name: albums fk_rails_78dbff46af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT fk_rails_78dbff46af FOREIGN KEY (genre_id) REFERENCES public.genres(id);


--
-- Name: setlist_items fk_rails_ae61c4f448; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.setlist_items
    ADD CONSTRAINT fk_rails_ae61c4f448 FOREIGN KEY (setlist_id) REFERENCES public.setlists(id);


--
-- Name: setlist_items fk_rails_cbc7d4d039; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.setlist_items
    ADD CONSTRAINT fk_rails_cbc7d4d039 FOREIGN KEY (songsheet_id) REFERENCES public.songsheets(id);


--
-- Name: tracks fk_rails_e21e3bd01e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT fk_rails_e21e3bd01e FOREIGN KEY (genre_id) REFERENCES public.genres(id);


--
-- Name: artist_works fk_rails_ed895a06e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_works
    ADD CONSTRAINT fk_rails_ed895a06e9 FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20211004033052'),
('20211004150027'),
('20211008063715'),
('20211029193047'),
('20211209202539'),
('20211212214419'),
('20211213142622'),
('20211213180412'),
('20211213195640'),
('20211218204534'),
('20220101140421'),
('20220105203853'),
('20220106173432'),
('20220112030812'),
('20220112181445'),
('20220114165758'),
('20220115051449'),
('20220204151609'),
('20220205051917'),
('20220207123911'),
('20220210133540'),
('20220211173533'),
('20220513151136'),
('20220514222125'),
('20220514222126'),
('20220516172030');


