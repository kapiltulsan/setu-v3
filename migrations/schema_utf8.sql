--
-- PostgreSQL database dump
--

\restrict ycVQ3avWGJ5eaVHOaXRGSR2Jcsh1z0PLyCRZoda5DmBwnVyp3sbD7tMQO9TH44D

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data (Community Edition)';


--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA audit;


ALTER SCHEMA audit OWNER TO postgres;

--
-- Name: ohlc; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ohlc;


ALTER SCHEMA ohlc OWNER TO postgres;

--
-- Name: ref; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ref;


ALTER SCHEMA ref OWNER TO postgres;

--
-- Name: sys; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sys;


ALTER SCHEMA sys OWNER TO postgres;

--
-- Name: trading; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA trading;


ALTER SCHEMA trading OWNER TO postgres;

--
-- Name: cleanup_old_triggers(); Type: FUNCTION; Schema: sys; Owner: postgres
--

CREATE FUNCTION sys.cleanup_old_triggers() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM sys.job_triggers WHERE triggered_at < NOW() - INTERVAL '7 days';
END;
$$;


ALTER FUNCTION sys.cleanup_old_triggers() OWNER TO postgres;

--
-- Name: cleanup_zombie_jobs(); Type: FUNCTION; Schema: sys; Owner: postgres
--

CREATE FUNCTION sys.cleanup_zombie_jobs() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    updated_count INT;
BEGIN
    UPDATE sys.job_history
    SET status = 'CRASHED',
        end_time = NOW(),
        output_summary = 'Job marked as CRASHED during scheduler startup cleanup.'
    WHERE status = 'RUNNING' AND start_time < NOW() - INTERVAL '1 hour'; -- Safety buffer
    
    GET DIAGNOSTICS updated_count = ROW_COUNT;
    RETURN updated_count;
END;
$$;


ALTER FUNCTION sys.cleanup_zombie_jobs() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: job_run; Type: TABLE; Schema: audit; Owner: postgres
--

CREATE TABLE audit.job_run (
    job_run_id bigint NOT NULL,
    env_name text NOT NULL,
    job_name text NOT NULL,
    timeframe text,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    finished_at timestamp with time zone,
    status text DEFAULT 'RUNNING'::text NOT NULL,
    rows_written bigint,
    error_message text
);


ALTER TABLE audit.job_run OWNER TO postgres;

--
-- Name: job_run_job_run_id_seq; Type: SEQUENCE; Schema: audit; Owner: postgres
--

CREATE SEQUENCE audit.job_run_job_run_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE audit.job_run_job_run_id_seq OWNER TO postgres;

--
-- Name: job_run_job_run_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: postgres
--

ALTER SEQUENCE audit.job_run_job_run_id_seq OWNED BY audit.job_run.job_run_id;


--
-- Name: candles_1d; Type: TABLE; Schema: ohlc; Owner: postgres
--

CREATE TABLE ohlc.candles_1d (
    symbol_id bigint,
    symbol text NOT NULL,
    exchange_code text DEFAULT 'NSE'::text NOT NULL,
    candle_start date NOT NULL,
    open numeric(14,4) NOT NULL,
    high numeric(14,4) NOT NULL,
    low numeric(14,4) NOT NULL,
    close numeric(14,4) NOT NULL,
    volume bigint DEFAULT 0 NOT NULL,
    oi bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE ohlc.candles_1d OWNER TO postgres;

--
-- Name: candles_60m; Type: TABLE; Schema: ohlc; Owner: postgres
--

CREATE TABLE ohlc.candles_60m (
    symbol_id bigint,
    symbol text NOT NULL,
    exchange_code text DEFAULT 'NSE'::text NOT NULL,
    candle_start timestamp with time zone NOT NULL,
    open numeric(14,4) NOT NULL,
    high numeric(14,4) NOT NULL,
    low numeric(14,4) NOT NULL,
    close numeric(14,4) NOT NULL,
    volume bigint DEFAULT 0 NOT NULL,
    oi bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE ohlc.candles_60m OWNER TO postgres;

--
-- Name: exchange; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.exchange (
    exchange_code text NOT NULL,
    exchange_name text NOT NULL,
    country text DEFAULT 'IN'::text,
    timezone text DEFAULT 'Asia/Kolkata'::text,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE ref.exchange OWNER TO postgres;

--
-- Name: index_mapping; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.index_mapping (
    mapping_id bigint NOT NULL,
    index_name text NOT NULL,
    stock_symbol text NOT NULL
);


ALTER TABLE ref.index_mapping OWNER TO postgres;

--
-- Name: index_mapping_mapping_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.index_mapping_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.index_mapping_mapping_id_seq OWNER TO postgres;

--
-- Name: index_mapping_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.index_mapping_mapping_id_seq OWNED BY ref.index_mapping.mapping_id;


--
-- Name: index_source; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.index_source (
    index_name text NOT NULL,
    source_url text NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE ref.index_source OWNER TO postgres;

--
-- Name: symbol; Type: TABLE; Schema: ref; Owner: postgres
--

CREATE TABLE ref.symbol (
    symbol_id bigint NOT NULL,
    exchange_code text NOT NULL,
    symbol text NOT NULL,
    trading_symbol text,
    instrument_token bigint,
    segment text,
    lot_size integer,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_index boolean DEFAULT false NOT NULL
);


ALTER TABLE ref.symbol OWNER TO postgres;

--
-- Name: symbol_symbol_id_seq; Type: SEQUENCE; Schema: ref; Owner: postgres
--

CREATE SEQUENCE ref.symbol_symbol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ref.symbol_symbol_id_seq OWNER TO postgres;

--
-- Name: symbol_symbol_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: postgres
--

ALTER SEQUENCE ref.symbol_symbol_id_seq OWNED BY ref.symbol.symbol_id;


--
-- Name: app_logs; Type: TABLE; Schema: sys; Owner: postgres
--

CREATE TABLE sys.app_logs (
    id integer NOT NULL,
    history_id integer,
    level character varying(10) NOT NULL,
    message text NOT NULL,
    module text,
    "timestamp" timestamp with time zone DEFAULT now(),
    metadata jsonb
);


ALTER TABLE sys.app_logs OWNER TO postgres;

--
-- Name: app_logs_id_seq; Type: SEQUENCE; Schema: sys; Owner: postgres
--

CREATE SEQUENCE sys.app_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sys.app_logs_id_seq OWNER TO postgres;

--
-- Name: app_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: postgres
--

ALTER SEQUENCE sys.app_logs_id_seq OWNED BY sys.app_logs.id;


--
-- Name: broker_configs; Type: TABLE; Schema: sys; Owner: postgres
--

CREATE TABLE sys.broker_configs (
    provider text NOT NULL,
    skip_rows integer DEFAULT 0,
    header_row integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    skip_cols integer DEFAULT 0
);


ALTER TABLE sys.broker_configs OWNER TO postgres;

--
-- Name: csv_mappings; Type: TABLE; Schema: sys; Owner: postgres
--

CREATE TABLE sys.csv_mappings (
    id integer NOT NULL,
    provider text NOT NULL,
    csv_column text NOT NULL,
    db_column text NOT NULL,
    is_required boolean DEFAULT true,
    default_value text,
    data_type text DEFAULT 'text'::text
);


ALTER TABLE sys.csv_mappings OWNER TO postgres;

--
-- Name: csv_mappings_id_seq; Type: SEQUENCE; Schema: sys; Owner: postgres
--

CREATE SEQUENCE sys.csv_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sys.csv_mappings_id_seq OWNER TO postgres;

--
-- Name: csv_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: postgres
--

ALTER SEQUENCE sys.csv_mappings_id_seq OWNED BY sys.csv_mappings.id;


--
-- Name: job_history; Type: TABLE; Schema: sys; Owner: postgres
--

CREATE TABLE sys.job_history (
    id integer NOT NULL,
    job_name text NOT NULL,
    start_time timestamp with time zone DEFAULT now(),
    end_time timestamp with time zone,
    status text,
    details text,
    created_at timestamp with time zone DEFAULT now(),
    output_summary text,
    pid integer,
    CONSTRAINT job_history_status_check CHECK ((status = ANY (ARRAY['RUNNING'::text, 'SUCCESS'::text, 'FAILURE'::text, 'TIMEOUT'::text, 'CRASHED'::text, 'WARNING'::text])))
);


ALTER TABLE sys.job_history OWNER TO postgres;

--
-- Name: job_history_id_seq; Type: SEQUENCE; Schema: sys; Owner: postgres
--

CREATE SEQUENCE sys.job_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sys.job_history_id_seq OWNER TO postgres;

--
-- Name: job_history_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: postgres
--

ALTER SEQUENCE sys.job_history_id_seq OWNED BY sys.job_history.id;


--
-- Name: job_triggers; Type: TABLE; Schema: sys; Owner: postgres
--

CREATE TABLE sys.job_triggers (
    id integer NOT NULL,
    job_name text NOT NULL,
    params jsonb DEFAULT '{}'::jsonb,
    triggered_by text DEFAULT 'system'::text,
    triggered_at timestamp with time zone DEFAULT now(),
    processed_at timestamp with time zone,
    status text DEFAULT 'PENDING'::text,
    execution_id uuid,
    error_message text,
    CONSTRAINT job_triggers_status_check CHECK ((status = ANY (ARRAY['PENDING'::text, 'PROCESSED'::text, 'FAILED'::text])))
);


ALTER TABLE sys.job_triggers OWNER TO postgres;

--
-- Name: job_triggers_id_seq; Type: SEQUENCE; Schema: sys; Owner: postgres
--

CREATE SEQUENCE sys.job_triggers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sys.job_triggers_id_seq OWNER TO postgres;

--
-- Name: job_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: postgres
--

ALTER SEQUENCE sys.job_triggers_id_seq OWNED BY sys.job_triggers.id;


--
-- Name: scanners; Type: TABLE; Schema: sys; Owner: postgres
--

CREATE TABLE sys.scanners (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    source_universe text NOT NULL,
    logic_config jsonb NOT NULL,
    schedule_cron text,
    is_active boolean DEFAULT true,
    last_run_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_run_stats jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE sys.scanners OWNER TO postgres;

--
-- Name: scanners_id_seq; Type: SEQUENCE; Schema: sys; Owner: postgres
--

CREATE SEQUENCE sys.scanners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sys.scanners_id_seq OWNER TO postgres;

--
-- Name: scanners_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: postgres
--

ALTER SEQUENCE sys.scanners_id_seq OWNED BY sys.scanners.id;


--
-- Name: scheduled_jobs; Type: TABLE; Schema: sys; Owner: postgres
--

CREATE TABLE sys.scheduled_jobs (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    command text NOT NULL,
    schedule_cron text NOT NULL,
    is_enabled boolean DEFAULT true,
    max_retries integer DEFAULT 0,
    timeout_sec integer DEFAULT 3600,
    last_run_at timestamp with time zone,
    next_run_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE sys.scheduled_jobs OWNER TO postgres;

--
-- Name: scheduled_jobs_id_seq; Type: SEQUENCE; Schema: sys; Owner: postgres
--

CREATE SEQUENCE sys.scheduled_jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sys.scheduled_jobs_id_seq OWNER TO postgres;

--
-- Name: scheduled_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: postgres
--

ALTER SEQUENCE sys.scheduled_jobs_id_seq OWNED BY sys.scheduled_jobs.id;


--
-- Name: service_status; Type: TABLE; Schema: sys; Owner: postgres
--

CREATE TABLE sys.service_status (
    service_name text NOT NULL,
    last_heartbeat timestamp with time zone,
    status text,
    info jsonb
);


ALTER TABLE sys.service_status OWNER TO postgres;

--
-- Name: daily_pnl; Type: TABLE; Schema: trading; Owner: postgres
--

CREATE TABLE trading.daily_pnl (
    id integer NOT NULL,
    date date NOT NULL,
    realized_pnl numeric(14,4) DEFAULT 0,
    unrealized_pnl numeric(14,4) DEFAULT 0,
    charges numeric(14,4) DEFAULT 0,
    net_pnl numeric(14,4) DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    account_id text DEFAULT 'default'::text
);


ALTER TABLE trading.daily_pnl OWNER TO postgres;

--
-- Name: daily_pnl_id_seq; Type: SEQUENCE; Schema: trading; Owner: postgres
--

CREATE SEQUENCE trading.daily_pnl_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE trading.daily_pnl_id_seq OWNER TO postgres;

--
-- Name: daily_pnl_id_seq; Type: SEQUENCE OWNED BY; Schema: trading; Owner: postgres
--

ALTER SEQUENCE trading.daily_pnl_id_seq OWNED BY trading.daily_pnl.id;


--
-- Name: orders; Type: TABLE; Schema: trading; Owner: postgres
--

CREATE TABLE trading.orders (
    order_id text NOT NULL,
    exchange_order_id text,
    symbol text NOT NULL,
    exchange text,
    txn_type text,
    quantity integer,
    price numeric(14,4),
    status text,
    order_timestamp timestamp with time zone,
    average_price numeric(14,4),
    filled_quantity integer,
    variety text,
    validity text,
    product text,
    tag text,
    status_message text,
    created_at timestamp with time zone DEFAULT now(),
    account_id text DEFAULT 'default'::text
);


ALTER TABLE trading.orders OWNER TO postgres;

--
-- Name: portfolio; Type: TABLE; Schema: trading; Owner: postgres
--

CREATE TABLE trading.portfolio (
    id integer NOT NULL,
    date date NOT NULL,
    symbol text NOT NULL,
    total_quantity numeric(14,4) NOT NULL,
    average_price numeric(14,4) NOT NULL,
    invested_value numeric(14,4) NOT NULL,
    current_value numeric(14,4),
    pnl numeric(14,4),
    created_at timestamp with time zone DEFAULT now(),
    account_id text DEFAULT 'default'::text
);


ALTER TABLE trading.portfolio OWNER TO postgres;

--
-- Name: portfolio_id_seq; Type: SEQUENCE; Schema: trading; Owner: postgres
--

CREATE SEQUENCE trading.portfolio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE trading.portfolio_id_seq OWNER TO postgres;

--
-- Name: portfolio_id_seq; Type: SEQUENCE OWNED BY; Schema: trading; Owner: postgres
--

ALTER SEQUENCE trading.portfolio_id_seq OWNED BY trading.portfolio.id;


--
-- Name: portfolio_view; Type: VIEW; Schema: trading; Owner: postgres
--

CREATE VIEW trading.portfolio_view AS
 SELECT symbol,
    total_quantity AS net_quantity,
    average_price,
    invested_value,
    current_value,
    pnl,
    date AS snapshot_date
   FROM trading.portfolio
  WHERE (date = ( SELECT max(portfolio_1.date) AS max
           FROM trading.portfolio portfolio_1));


ALTER VIEW trading.portfolio_view OWNER TO postgres;

--
-- Name: positions; Type: TABLE; Schema: trading; Owner: postgres
--

CREATE TABLE trading.positions (
    id integer NOT NULL,
    date date NOT NULL,
    symbol text NOT NULL,
    exchange text,
    product text,
    quantity integer,
    average_price numeric(14,4),
    last_price numeric(14,4),
    pnl numeric(14,4),
    m2m numeric(14,4),
    realised numeric(14,4),
    unrealised numeric(14,4),
    value numeric(14,4),
    created_at timestamp with time zone DEFAULT now(),
    account_id text DEFAULT 'default'::text
);


ALTER TABLE trading.positions OWNER TO postgres;

--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: trading; Owner: postgres
--

CREATE SEQUENCE trading.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE trading.positions_id_seq OWNER TO postgres;

--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: trading; Owner: postgres
--

ALTER SEQUENCE trading.positions_id_seq OWNED BY trading.positions.id;


--
-- Name: scanner_results; Type: TABLE; Schema: trading; Owner: postgres
--

CREATE TABLE trading.scanner_results (
    id integer NOT NULL,
    scanner_id integer,
    run_date timestamp with time zone DEFAULT now(),
    symbol text NOT NULL,
    match_data jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE trading.scanner_results OWNER TO postgres;

--
-- Name: scanner_results_id_seq; Type: SEQUENCE; Schema: trading; Owner: postgres
--

CREATE SEQUENCE trading.scanner_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE trading.scanner_results_id_seq OWNER TO postgres;

--
-- Name: scanner_results_id_seq; Type: SEQUENCE OWNED BY; Schema: trading; Owner: postgres
--

ALTER SEQUENCE trading.scanner_results_id_seq OWNED BY trading.scanner_results.id;


--
-- Name: trades; Type: TABLE; Schema: trading; Owner: postgres
--

CREATE TABLE trading.trades (
    trade_id bigint NOT NULL,
    broker_order_id text,
    symbol text NOT NULL,
    exchange_code text DEFAULT 'NSE'::text,
    quantity integer NOT NULL,
    price numeric(14,4) NOT NULL,
    trade_date timestamp with time zone DEFAULT now(),
    holder_name text DEFAULT 'Primary'::text,
    strategy_name text DEFAULT 'Manual'::text,
    created_at timestamp with time zone DEFAULT now(),
    broker_name text DEFAULT 'Zerodha'::text,
    isin text,
    product_type text DEFAULT 'CNC'::text,
    total_charges numeric(10,2) DEFAULT 0,
    net_amount numeric(14,2),
    currency text DEFAULT 'INR'::text,
    notes text,
    account_id text DEFAULT 'default'::text,
    exchange text,
    txn_type text NOT NULL,
    fees numeric DEFAULT 0,
    source text,
    external_trade_id text,
    order_id text,
    segment text,
    series text,
    CONSTRAINT check_prod_type CHECK ((product_type = ANY (ARRAY['CNC'::text, 'MIS'::text, 'NRML'::text, 'CO'::text])))
);


ALTER TABLE trading.trades OWNER TO postgres;

--
-- Name: trades_trade_id_seq; Type: SEQUENCE; Schema: trading; Owner: postgres
--

CREATE SEQUENCE trading.trades_trade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE trading.trades_trade_id_seq OWNER TO postgres;

--
-- Name: trades_trade_id_seq; Type: SEQUENCE OWNED BY; Schema: trading; Owner: postgres
--

ALTER SEQUENCE trading.trades_trade_id_seq OWNED BY trading.trades.trade_id;


--
-- Name: job_run job_run_id; Type: DEFAULT; Schema: audit; Owner: postgres
--

ALTER TABLE ONLY audit.job_run ALTER COLUMN job_run_id SET DEFAULT nextval('audit.job_run_job_run_id_seq'::regclass);


--
-- Name: index_mapping mapping_id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.index_mapping ALTER COLUMN mapping_id SET DEFAULT nextval('ref.index_mapping_mapping_id_seq'::regclass);


--
-- Name: symbol symbol_id; Type: DEFAULT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.symbol ALTER COLUMN symbol_id SET DEFAULT nextval('ref.symbol_symbol_id_seq'::regclass);


--
-- Name: app_logs id; Type: DEFAULT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.app_logs ALTER COLUMN id SET DEFAULT nextval('sys.app_logs_id_seq'::regclass);


--
-- Name: csv_mappings id; Type: DEFAULT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.csv_mappings ALTER COLUMN id SET DEFAULT nextval('sys.csv_mappings_id_seq'::regclass);


--
-- Name: job_history id; Type: DEFAULT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.job_history ALTER COLUMN id SET DEFAULT nextval('sys.job_history_id_seq'::regclass);


--
-- Name: job_triggers id; Type: DEFAULT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.job_triggers ALTER COLUMN id SET DEFAULT nextval('sys.job_triggers_id_seq'::regclass);


--
-- Name: scanners id; Type: DEFAULT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.scanners ALTER COLUMN id SET DEFAULT nextval('sys.scanners_id_seq'::regclass);


--
-- Name: scheduled_jobs id; Type: DEFAULT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.scheduled_jobs ALTER COLUMN id SET DEFAULT nextval('sys.scheduled_jobs_id_seq'::regclass);


--
-- Name: daily_pnl id; Type: DEFAULT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.daily_pnl ALTER COLUMN id SET DEFAULT nextval('trading.daily_pnl_id_seq'::regclass);


--
-- Name: portfolio id; Type: DEFAULT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.portfolio ALTER COLUMN id SET DEFAULT nextval('trading.portfolio_id_seq'::regclass);


--
-- Name: positions id; Type: DEFAULT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.positions ALTER COLUMN id SET DEFAULT nextval('trading.positions_id_seq'::regclass);


--
-- Name: scanner_results id; Type: DEFAULT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.scanner_results ALTER COLUMN id SET DEFAULT nextval('trading.scanner_results_id_seq'::regclass);


--
-- Name: trades trade_id; Type: DEFAULT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.trades ALTER COLUMN trade_id SET DEFAULT nextval('trading.trades_trade_id_seq'::regclass);


--
-- Name: job_run job_run_pkey; Type: CONSTRAINT; Schema: audit; Owner: postgres
--

ALTER TABLE ONLY audit.job_run
    ADD CONSTRAINT job_run_pkey PRIMARY KEY (job_run_id);


--
-- Name: candles_1d pk_candles_1d; Type: CONSTRAINT; Schema: ohlc; Owner: postgres
--

ALTER TABLE ONLY ohlc.candles_1d
    ADD CONSTRAINT pk_candles_1d PRIMARY KEY (symbol, candle_start);


--
-- Name: candles_60m pk_candles_60m; Type: CONSTRAINT; Schema: ohlc; Owner: postgres
--

ALTER TABLE ONLY ohlc.candles_60m
    ADD CONSTRAINT pk_candles_60m PRIMARY KEY (symbol, candle_start);


--
-- Name: exchange exchange_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.exchange
    ADD CONSTRAINT exchange_pkey PRIMARY KEY (exchange_code);


--
-- Name: index_mapping index_mapping_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.index_mapping
    ADD CONSTRAINT index_mapping_pkey PRIMARY KEY (mapping_id);


--
-- Name: index_source index_source_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.index_source
    ADD CONSTRAINT index_source_pkey PRIMARY KEY (index_name);


--
-- Name: symbol symbol_pkey; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.symbol
    ADD CONSTRAINT symbol_pkey PRIMARY KEY (symbol_id);


--
-- Name: index_mapping ux_index_stock; Type: CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.index_mapping
    ADD CONSTRAINT ux_index_stock UNIQUE (index_name, stock_symbol);


--
-- Name: app_logs app_logs_pkey; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.app_logs
    ADD CONSTRAINT app_logs_pkey PRIMARY KEY (id);


--
-- Name: broker_configs broker_configs_pkey; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.broker_configs
    ADD CONSTRAINT broker_configs_pkey PRIMARY KEY (provider);


--
-- Name: csv_mappings csv_mappings_pkey; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.csv_mappings
    ADD CONSTRAINT csv_mappings_pkey PRIMARY KEY (id);


--
-- Name: csv_mappings csv_mappings_provider_db_column_key; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.csv_mappings
    ADD CONSTRAINT csv_mappings_provider_db_column_key UNIQUE (provider, db_column);


--
-- Name: job_history job_history_pkey; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.job_history
    ADD CONSTRAINT job_history_pkey PRIMARY KEY (id);


--
-- Name: job_triggers job_triggers_pkey; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.job_triggers
    ADD CONSTRAINT job_triggers_pkey PRIMARY KEY (id);


--
-- Name: scanners scanners_name_key; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.scanners
    ADD CONSTRAINT scanners_name_key UNIQUE (name);


--
-- Name: scanners scanners_pkey; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.scanners
    ADD CONSTRAINT scanners_pkey PRIMARY KEY (id);


--
-- Name: scheduled_jobs scheduled_jobs_name_key; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.scheduled_jobs
    ADD CONSTRAINT scheduled_jobs_name_key UNIQUE (name);


--
-- Name: scheduled_jobs scheduled_jobs_pkey; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.scheduled_jobs
    ADD CONSTRAINT scheduled_jobs_pkey PRIMARY KEY (id);


--
-- Name: service_status service_status_pkey; Type: CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.service_status
    ADD CONSTRAINT service_status_pkey PRIMARY KEY (service_name);


--
-- Name: daily_pnl daily_pnl_pkey; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.daily_pnl
    ADD CONSTRAINT daily_pnl_pkey PRIMARY KEY (id);


--
-- Name: daily_pnl daily_pnl_unique_entry; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.daily_pnl
    ADD CONSTRAINT daily_pnl_unique_entry UNIQUE (date, account_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: portfolio portfolio_pkey; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.portfolio
    ADD CONSTRAINT portfolio_pkey PRIMARY KEY (id);


--
-- Name: portfolio portfolio_unique_entry; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.portfolio
    ADD CONSTRAINT portfolio_unique_entry UNIQUE (date, symbol, account_id);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: positions positions_unique_entry; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.positions
    ADD CONSTRAINT positions_unique_entry UNIQUE (date, symbol, product, account_id);


--
-- Name: scanner_results scanner_results_pkey; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.scanner_results
    ADD CONSTRAINT scanner_results_pkey PRIMARY KEY (id);


--
-- Name: trades trades_external_trade_id_source_key; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.trades
    ADD CONSTRAINT trades_external_trade_id_source_key UNIQUE (external_trade_id, source);


--
-- Name: trades trades_pkey; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.trades
    ADD CONSTRAINT trades_pkey PRIMARY KEY (trade_id);


--
-- Name: trades trades_zerodha_order_id_key; Type: CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.trades
    ADD CONSTRAINT trades_zerodha_order_id_key UNIQUE (broker_order_id);


--
-- Name: candles_1d_candle_start_idx; Type: INDEX; Schema: ohlc; Owner: postgres
--

CREATE INDEX candles_1d_candle_start_idx ON ohlc.candles_1d USING btree (candle_start DESC);


--
-- Name: candles_60m_candle_start_idx; Type: INDEX; Schema: ohlc; Owner: postgres
--

CREATE INDEX candles_60m_candle_start_idx ON ohlc.candles_60m USING btree (candle_start DESC);


--
-- Name: ux_symbol_exchange; Type: INDEX; Schema: ref; Owner: postgres
--

CREATE UNIQUE INDEX ux_symbol_exchange ON ref.symbol USING btree (exchange_code, symbol);


--
-- Name: idx_app_logs_history_id; Type: INDEX; Schema: sys; Owner: postgres
--

CREATE INDEX idx_app_logs_history_id ON sys.app_logs USING btree (history_id);


--
-- Name: idx_app_logs_timestamp; Type: INDEX; Schema: sys; Owner: postgres
--

CREATE INDEX idx_app_logs_timestamp ON sys.app_logs USING btree ("timestamp" DESC);


--
-- Name: idx_csv_mappings_provider; Type: INDEX; Schema: sys; Owner: postgres
--

CREATE INDEX idx_csv_mappings_provider ON sys.csv_mappings USING btree (provider);


--
-- Name: idx_job_history_job_name; Type: INDEX; Schema: sys; Owner: postgres
--

CREATE INDEX idx_job_history_job_name ON sys.job_history USING btree (job_name);


--
-- Name: idx_job_history_job_start; Type: INDEX; Schema: sys; Owner: postgres
--

CREATE INDEX idx_job_history_job_start ON sys.job_history USING btree (job_name, start_time DESC);


--
-- Name: idx_job_history_start_time; Type: INDEX; Schema: sys; Owner: postgres
--

CREATE INDEX idx_job_history_start_time ON sys.job_history USING btree (start_time DESC);


--
-- Name: idx_job_history_status; Type: INDEX; Schema: sys; Owner: postgres
--

CREATE INDEX idx_job_history_status ON sys.job_history USING btree (status);


--
-- Name: idx_job_triggers_pending; Type: INDEX; Schema: sys; Owner: postgres
--

CREATE INDEX idx_job_triggers_pending ON sys.job_triggers USING btree (status) WHERE (status = 'PENDING'::text);


--
-- Name: idx_orders_account_id; Type: INDEX; Schema: trading; Owner: postgres
--

CREATE INDEX idx_orders_account_id ON trading.orders USING btree (account_id);


--
-- Name: idx_portfolio_date; Type: INDEX; Schema: trading; Owner: postgres
--

CREATE INDEX idx_portfolio_date ON trading.portfolio USING btree (date);


--
-- Name: idx_scanner_results_run_date; Type: INDEX; Schema: trading; Owner: postgres
--

CREATE INDEX idx_scanner_results_run_date ON trading.scanner_results USING btree (run_date);


--
-- Name: idx_scanner_results_scanner_id; Type: INDEX; Schema: trading; Owner: postgres
--

CREATE INDEX idx_scanner_results_scanner_id ON trading.scanner_results USING btree (scanner_id);


--
-- Name: idx_trades_account_id; Type: INDEX; Schema: trading; Owner: postgres
--

CREATE INDEX idx_trades_account_id ON trading.trades USING btree (account_id);


--
-- Name: idx_trades_date; Type: INDEX; Schema: trading; Owner: postgres
--

CREATE INDEX idx_trades_date ON trading.trades USING btree (trade_date);


--
-- Name: idx_trades_symbol_date; Type: INDEX; Schema: trading; Owner: postgres
--

CREATE INDEX idx_trades_symbol_date ON trading.trades USING btree (symbol, trade_date);


--
-- Name: ix_trades_strategy; Type: INDEX; Schema: trading; Owner: postgres
--

CREATE INDEX ix_trades_strategy ON trading.trades USING btree (strategy_name);


--
-- Name: ix_trades_symbol; Type: INDEX; Schema: trading; Owner: postgres
--

CREATE INDEX ix_trades_symbol ON trading.trades USING btree (symbol);


--
-- Name: candles_1d candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: ohlc; Owner: postgres
--

ALTER TABLE ONLY ohlc.candles_1d
    ADD CONSTRAINT candles_1d_symbol_id_fkey FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: candles_60m candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: ohlc; Owner: postgres
--

ALTER TABLE ONLY ohlc.candles_60m
    ADD CONSTRAINT candles_60m_symbol_id_fkey FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: symbol symbol_exchange_code_fkey; Type: FK CONSTRAINT; Schema: ref; Owner: postgres
--

ALTER TABLE ONLY ref.symbol
    ADD CONSTRAINT symbol_exchange_code_fkey FOREIGN KEY (exchange_code) REFERENCES ref.exchange(exchange_code);


--
-- Name: app_logs app_logs_history_id_fkey; Type: FK CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.app_logs
    ADD CONSTRAINT app_logs_history_id_fkey FOREIGN KEY (history_id) REFERENCES sys.job_history(id) ON DELETE CASCADE;


--
-- Name: job_triggers job_triggers_job_name_fkey; Type: FK CONSTRAINT; Schema: sys; Owner: postgres
--

ALTER TABLE ONLY sys.job_triggers
    ADD CONSTRAINT job_triggers_job_name_fkey FOREIGN KEY (job_name) REFERENCES sys.scheduled_jobs(name) ON DELETE CASCADE;


--
-- Name: scanner_results scanner_results_scanner_id_fkey; Type: FK CONSTRAINT; Schema: trading; Owner: postgres
--

ALTER TABLE ONLY trading.scanner_results
    ADD CONSTRAINT scanner_results_scanner_id_fkey FOREIGN KEY (scanner_id) REFERENCES sys.scanners(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ycVQ3avWGJ5eaVHOaXRGSR2Jcsh1z0PLyCRZoda5DmBwnVyp3sbD7tMQO9TH44D

