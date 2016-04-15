CREATE TABLE fetchmail (
    id integer NOT NULL,
    mailbox text NOT NULL,
    active integer DEFAULT 1 NOT NULL,
    src_server text NOT NULL,
    src_auth text DEFAULT 'password'::text NOT NULL,
    src_user text NOT NULL,
    src_password text NOT NULL,
    src_folder text,
    poll_time integer DEFAULT 10 NOT NULL,
    fetchall integer DEFAULT 0 NOT NULL,
    keep integer DEFAULT 1 NOT NULL,
    protocol text DEFAULT 'IMAP'::text NOT NULL,
    usessl integer DEFAULT 1 NOT NULL,
    sslcertck BOOLEAN NOT NULL DEFAULT 'f',
    sslcertpath character varying(255) DEFAULT ''::character varying,
    sslfingerprint character varying(255) DEFAULT ''::character varying,
    extra_options text,
    returned_text text,
    mda text,
    date timestamp with time zone NOT NULL DEFAULT now() NOT NULL
);

CREATE SEQUENCE fetchmail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	
ALTER SEQUENCE fetchmail_id_seq OWNED BY fetchmail.id;

ALTER TABLE ONLY fetchmail ALTER COLUMN id SET DEFAULT nextval('fetchmail_id_seq'::regclass);

ALTER TABLE ONLY fetchmail ADD CONSTRAINT fetchmail_pkey PRIMARY KEY (id);
