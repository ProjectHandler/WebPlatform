--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: address; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE address (
    id bigint NOT NULL,
    street_number character varying(10) NOT NULL,
    street_name character varying(30) NOT NULL,
    city character varying(30) NOT NULL,
    zipcode character varying(5) NOT NULL,
    country character varying(30) NOT NULL,
    user_id bigint
);


ALTER TABLE address OWNER TO postgres;

--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE address_id_seq OWNER TO postgres;

--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE address_id_seq OWNED BY address.id;


--
-- Name: civility; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE civility (
    id bigint NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE civility OWNER TO postgres;

--
-- Name: civility_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE civility_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE civility_id_seq OWNER TO postgres;

--
-- Name: civility_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE civility_id_seq OWNED BY civility.id;


--
-- Name: depend_tasks; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE depend_tasks (
    task_id1 bigint NOT NULL,
    task_id2 bigint NOT NULL
);


ALTER TABLE depend_tasks OWNER TO postgres;

--
-- Name: event; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE event (
    id bigint NOT NULL,
    title character varying(30) NOT NULL,
    description character varying(500),
    starting_date timestamp without time zone NOT NULL,
    ending_date timestamp without time zone NOT NULL,
    status character varying(30)
);


ALTER TABLE event OWNER TO postgres;

--
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_id_seq OWNER TO postgres;

--
-- Name: event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE event_id_seq OWNED BY event.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE groups (
    id bigint NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE groups OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE groups_id_seq OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: project; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE project (
    id bigint NOT NULL,
    name character varying(30) NOT NULL,
    progress bigint NOT NULL,
    description character varying(500),
    duration bigint NOT NULL,
    date_begin date,
    date_end date,
    status character varying(30) NOT NULL
);


ALTER TABLE project OWNER TO postgres;

--
-- Name: project_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project_id_seq OWNER TO postgres;

--
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE project_id_seq OWNED BY project.id;


--
-- Name: subtask; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE subtask (
    id bigint NOT NULL,
    description character varying(200),
    task_id bigint NOT NULL,
    user_id bigint NOT NULL,
    validated boolean DEFAULT false NOT NULL,
    taken boolean DEFAULT false NOT NULL,
    starting_date timestamp without time zone,
    ending_date timestamp without time zone
);


ALTER TABLE subtask OWNER TO postgres;

--
-- Name: subtask_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE subtask_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE subtask_id_seq OWNER TO postgres;

--
-- Name: subtask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE subtask_id_seq OWNED BY subtask.id;


--
-- Name: task; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE task (
    id bigint NOT NULL,
    name character varying(30) NOT NULL,
    progress bigint NOT NULL,
    description character varying(500),
    level bigint NOT NULL,
    duration bigint DEFAULT 1::numeric NOT NULL,
    starting_date date,
    ending_date date,
    status character varying(30),
    project_id bigint NOT NULL,
    "row" bigint,
    task_priority_id bigint
);


ALTER TABLE task OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE task_id_seq OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE task_id_seq OWNED BY task.id;


--
-- Name: task_messages; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE task_messages (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    update_date timestamp without time zone NOT NULL,
    task_id bigint NOT NULL,
    content character varying(200)
);


ALTER TABLE task_messages OWNER TO postgres;

--
-- Name: task_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE task_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE task_messages_id_seq OWNER TO postgres;

--
-- Name: task_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE task_messages_id_seq OWNED BY task_messages.id;


--
-- Name: task_priority; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE task_priority (
    id bigint NOT NULL,
    value integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE task_priority OWNER TO postgres;

--
-- Name: task_priority_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE task_priority_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE task_priority_id_seq OWNER TO postgres;

--
-- Name: task_priority_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE task_priority_id_seq OWNED BY task_priority.id;


--
-- Name: ticket_messages; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ticket_messages (
    id bigint NOT NULL,
    ticket_id bigint NOT NULL,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    text character varying(500)
);


ALTER TABLE ticket_messages OWNER TO postgres;

--
-- Name: ticket_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ticket_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ticket_messages_id_seq OWNER TO postgres;

--
-- Name: ticket_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ticket_messages_id_seq OWNED BY ticket_messages.id;


--
-- Name: ticket_priority; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ticket_priority (
    id bigint NOT NULL,
    value integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE ticket_priority OWNER TO postgres;

--
-- Name: ticket_priority_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ticket_priority_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ticket_priority_id_seq OWNER TO postgres;

--
-- Name: ticket_priority_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ticket_priority_id_seq OWNED BY ticket_priority.id;


--
-- Name: ticket_tracker; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ticket_tracker (
    id bigint NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE ticket_tracker OWNER TO postgres;

--
-- Name: ticket_tracker_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ticket_tracker_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ticket_tracker_id_seq OWNER TO postgres;

--
-- Name: ticket_tracker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ticket_tracker_id_seq OWNED BY ticket_tracker.id;


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tickets (
    id bigint NOT NULL,
    title character varying(100),
    text character varying(500),
    ticket_status integer DEFAULT 1::numeric NOT NULL,
    user_id bigint,
    project_id bigint NOT NULL,
    ticket_priority_id bigint,
    ticket_tracker_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE tickets OWNER TO postgres;

--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tickets_id_seq OWNER TO postgres;

--
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tickets_id_seq OWNED BY tickets.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tokens (
    id bigint NOT NULL,
    token character varying(50) NOT NULL,
    time_stamp bigint DEFAULT 0 NOT NULL,
    user_id bigint
);


ALTER TABLE tokens OWNER TO postgres;

--
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tokens_id_seq OWNER TO postgres;

--
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tokens_id_seq OWNED BY tokens.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id bigint NOT NULL,
    first_name character varying(30),
    last_name character varying(30),
    password character varying(70),
    email character varying(50),
    address bigint,
    phone character varying(10),
    mobile_phone character varying(10),
    user_role integer DEFAULT 1::numeric NOT NULL,
    account_status integer DEFAULT 0 NOT NULL,
    civility_id bigint,
    work_day character varying(32) DEFAULT 'tttttff'::character varying NOT NULL,
    daily_hour character varying(32) DEFAULT '09:00 AM - 05:00 PM'::character varying NOT NULL,
    avatar_file_name character varying(100),
    draft_message character varying(500)
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_events; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users_events (
    users_id bigint NOT NULL,
    events_id bigint NOT NULL
);


ALTER TABLE users_events OWNER TO postgres;

--
-- Name: users_groups; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users_groups (
    users_id bigint NOT NULL,
    groups_id bigint NOT NULL
);


ALTER TABLE users_groups OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_projects; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users_projects (
    user_id bigint NOT NULL,
    project_id bigint NOT NULL
);


ALTER TABLE users_projects OWNER TO postgres;

--
-- Name: users_tasks; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users_tasks (
    users_id bigint NOT NULL,
    tasks_id bigint NOT NULL
);


ALTER TABLE users_tasks OWNER TO postgres;

--
-- Name: users_tickets; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users_tickets (
    user_id bigint NOT NULL,
    ticket_id bigint NOT NULL
);


ALTER TABLE users_tickets OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY address ALTER COLUMN id SET DEFAULT nextval('address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY civility ALTER COLUMN id SET DEFAULT nextval('civility_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY event ALTER COLUMN id SET DEFAULT nextval('event_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY project ALTER COLUMN id SET DEFAULT nextval('project_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subtask ALTER COLUMN id SET DEFAULT nextval('subtask_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task ALTER COLUMN id SET DEFAULT nextval('task_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task_messages ALTER COLUMN id SET DEFAULT nextval('task_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task_priority ALTER COLUMN id SET DEFAULT nextval('task_priority_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ticket_messages ALTER COLUMN id SET DEFAULT nextval('ticket_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ticket_priority ALTER COLUMN id SET DEFAULT nextval('ticket_priority_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ticket_tracker ALTER COLUMN id SET DEFAULT nextval('ticket_tracker_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tickets ALTER COLUMN id SET DEFAULT nextval('tickets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tokens ALTER COLUMN id SET DEFAULT nextval('tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY address (id, street_number, street_name, city, zipcode, country, user_id) FROM stdin;
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('address_id_seq', 1, false);


--
-- Data for Name: civility; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY civility (id, name) FROM stdin;
1	projecthandler.civility.mister
2	projecthandler.civility.mrs
3	projecthandler.civility.miss
\.


--
-- Name: civility_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('civility_id_seq', 3, true);

--
-- Data for Name: task_priority; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY task_priority (id, value, name) FROM stdin;
1	20	MEDIUM
2	30	HIGH
4	10	LOW
\.

--
-- Name: task_priority_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('task_priority_id_seq', 4, true);


--
-- Name: ticket_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ticket_messages_id_seq', 56, true);


--
-- Data for Name: ticket_priority; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ticket_priority (id, value, name) FROM stdin;
4	10	low
5	20	medium
6	30	high
\.

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (id, first_name, last_name, password, email, address, phone, mobile_phone, user_role, account_status, civility_id, work_day, daily_hour, avatar_file_name, draft_message) FROM stdin;
1	Admin	Admin	$2a$10$fFP2m2eUoiC4AKusRtbeI.8BQBe4vToDLsiH0YP745w7CrYbTDtWG	admin@admin.com	\N	0123456789		0	1	1	tttttff	09:00 AM - 05:00 PM	\N	\N
\.

--
-- Name: address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: civility_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY civility
    ADD CONSTRAINT civility_pkey PRIMARY KEY (id);


--
-- Name: depend_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY depend_tasks
    ADD CONSTRAINT depend_tasks_pkey PRIMARY KEY (task_id1, task_id2);


--
-- Name: event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: subtask_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subtask
    ADD CONSTRAINT subtask_pkey PRIMARY KEY (id);


--
-- Name: task_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY task_messages
    ADD CONSTRAINT task_messages_pkey PRIMARY KEY (id);


--
-- Name: task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: task_priority_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY task_priority
    ADD CONSTRAINT task_priority_pkey PRIMARY KEY (id);


--
-- Name: ticket_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ticket_messages
    ADD CONSTRAINT ticket_messages_pkey PRIMARY KEY (id);


--
-- Name: ticket_priority_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ticket_priority
    ADD CONSTRAINT ticket_priority_pkey PRIMARY KEY (id);


--
-- Name: ticket_tracker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ticket_tracker
    ADD CONSTRAINT ticket_tracker_pkey PRIMARY KEY (id);


--
-- Name: tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- Name: tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: users_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users_events
    ADD CONSTRAINT users_events_pkey PRIMARY KEY (users_id, events_id);


--
-- Name: users_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users_groups
    ADD CONSTRAINT users_groups_pkey PRIMARY KEY (users_id, groups_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users_projects
    ADD CONSTRAINT users_projects_pkey PRIMARY KEY (user_id, project_id);


--
-- Name: users_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users_tasks
    ADD CONSTRAINT users_tasks_pkey PRIMARY KEY (users_id, tasks_id);


--
-- Name: users_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users_tickets
    ADD CONSTRAINT users_tickets_pkey PRIMARY KEY (user_id, ticket_id);


--
-- Name: address_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX address_user_id ON address USING btree (user_id);


--
-- Name: depend_tasks_task_id2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX depend_tasks_task_id2 ON depend_tasks USING btree (task_id2);


--
-- Name: subtask_subtask_ibfk_1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX subtask_subtask_ibfk_1 ON subtask USING btree (task_id);


--
-- Name: subtask_subtask_ibfk_2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX subtask_subtask_ibfk_2 ON subtask USING btree (user_id);


--
-- Name: task_messages_task_messages_ibfk_1; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX task_messages_task_messages_ibfk_1 ON task_messages USING btree (user_id);


--
-- Name: task_messages_task_messages_ibfk_2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX task_messages_task_messages_ibfk_2 ON task_messages USING btree (task_id);


--
-- Name: task_task_priority_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX task_task_priority_id ON task USING btree (task_priority_id);


--
-- Name: task_task_project_ibkf; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX task_task_project_ibkf ON task USING btree (project_id);


--
-- Name: ticket_messages_ticket_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ticket_messages_ticket_id ON ticket_messages USING btree (ticket_id);


--
-- Name: ticket_messages_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ticket_messages_user_id ON ticket_messages USING btree (user_id);


--
-- Name: tickets_project_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tickets_project_id ON tickets USING btree (project_id);


--
-- Name: tickets_ticket_priority_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tickets_ticket_priority_id ON tickets USING btree (ticket_priority_id);


--
-- Name: tickets_ticket_tracker_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tickets_ticket_tracker_id ON tickets USING btree (ticket_tracker_id);


--
-- Name: tickets_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tickets_user_id ON tickets USING btree (user_id);


--
-- Name: tokens_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tokens_user_id ON tokens USING btree (user_id);


--
-- Name: users_address; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_address ON users USING btree (address);


--
-- Name: users_civility_ibfk; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_civility_ibfk ON users USING btree (civility_id);


--
-- Name: users_events_events_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_events_events_id ON users_events USING btree (events_id);


--
-- Name: users_events_users_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_events_users_id ON users_events USING btree (users_id);


--
-- Name: users_groups_users_groups_ibfk_2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_groups_users_groups_ibfk_2 ON users_groups USING btree (groups_id);


--
-- Name: users_projects_users_projects_ibfk_2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_projects_users_projects_ibfk_2 ON users_projects USING btree (project_id);


--
-- Name: users_tasks_users_tasks_ibfk_2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_tasks_users_tasks_ibfk_2 ON users_tasks USING btree (tasks_id);


--
-- Name: users_tickets_users_tickets_ibfk_2; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX users_tickets_users_tickets_ibfk_2 ON users_tickets USING btree (ticket_id);


--
-- Name: address_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: civility_ibfk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT civility_ibfk FOREIGN KEY (civility_id) REFERENCES civility(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: depend_tasks_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY depend_tasks
    ADD CONSTRAINT depend_tasks_ibfk_1 FOREIGN KEY (task_id1) REFERENCES task(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: depend_tasks_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY depend_tasks
    ADD CONSTRAINT depend_tasks_ibfk_2 FOREIGN KEY (task_id2) REFERENCES task(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fk_ticket_project; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT fk_ticket_project FOREIGN KEY (project_id) REFERENCES project(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: fk_ticket_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT fk_ticket_user FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: fk_ticketmessage_ticket; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ticket_messages
    ADD CONSTRAINT fk_ticketmessage_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: fk_ticketmessage_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ticket_messages
    ADD CONSTRAINT fk_ticketmessage_user FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: subtask_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subtask
    ADD CONSTRAINT subtask_ibfk_1 FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: subtask_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subtask
    ADD CONSTRAINT subtask_ibfk_2 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: task_messages_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task_messages
    ADD CONSTRAINT task_messages_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: task_messages_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task_messages
    ADD CONSTRAINT task_messages_ibfk_2 FOREIGN KEY (task_id) REFERENCES task(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: task_priority_ibkf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_priority_ibkf FOREIGN KEY (task_priority_id) REFERENCES task_priority(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: task_project_ibkf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_project_ibkf FOREIGN KEY (project_id) REFERENCES project(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: ticket_priority_ibkf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT ticket_priority_ibkf FOREIGN KEY (ticket_priority_id) REFERENCES ticket_priority(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: ticket_tracker_ibfk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT ticket_tracker_ibfk FOREIGN KEY (ticket_tracker_id) REFERENCES ticket_tracker(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: tokens_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tokens
    ADD CONSTRAINT tokens_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: users_events_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_events
    ADD CONSTRAINT users_events_ibfk_1 FOREIGN KEY (users_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_events_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_events
    ADD CONSTRAINT users_events_ibfk_2 FOREIGN KEY (events_id) REFERENCES event(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_groups_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_groups
    ADD CONSTRAINT users_groups_ibfk_1 FOREIGN KEY (users_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_groups_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_groups
    ADD CONSTRAINT users_groups_ibfk_2 FOREIGN KEY (groups_id) REFERENCES groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_projects_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_projects
    ADD CONSTRAINT users_projects_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: users_projects_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_projects
    ADD CONSTRAINT users_projects_ibfk_2 FOREIGN KEY (project_id) REFERENCES project(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_tasks_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_tasks
    ADD CONSTRAINT users_tasks_ibfk_1 FOREIGN KEY (users_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_tasks_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_tasks
    ADD CONSTRAINT users_tasks_ibfk_2 FOREIGN KEY (tasks_id) REFERENCES task(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_tickets_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_tickets
    ADD CONSTRAINT users_tickets_ibfk_1 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: users_tickets_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_tickets
    ADD CONSTRAINT users_tickets_ibfk_2 FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--