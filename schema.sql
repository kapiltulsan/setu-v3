--
-- PostgreSQL database dump
--

\restrict vaPIwLDdCZWdEWir90hf01Jiqln0EhyuGIDvAgcWsPSMRsQ9blpJuYROXN8Bwv5

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
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data (Community Edition)';


--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA audit;


--
-- Name: ohlc; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ohlc;


--
-- Name: ref; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ref;


--
-- Name: sys; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA sys;


--
-- Name: trading; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA trading;


--
-- Name: cleanup_old_triggers(); Type: FUNCTION; Schema: sys; Owner: -
--

CREATE FUNCTION sys.cleanup_old_triggers() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM sys.job_triggers WHERE triggered_at < NOW() - INTERVAL '7 days';
END;
$$;


--
-- Name: cleanup_zombie_jobs(); Type: FUNCTION; Schema: sys; Owner: -
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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: candles_60m; Type: TABLE; Schema: ohlc; Owner: -
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


--
-- Name: _hyper_3_159_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_159_chunk (
    CONSTRAINT constraint_159 CHECK (((candle_start >= '2024-12-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_160_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_160_chunk (
    CONSTRAINT constraint_160 CHECK (((candle_start >= '2024-12-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_161_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_161_chunk (
    CONSTRAINT constraint_161 CHECK (((candle_start >= '2024-12-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_162_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_162_chunk (
    CONSTRAINT constraint_162 CHECK (((candle_start >= '2024-12-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_163_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_163_chunk (
    CONSTRAINT constraint_163 CHECK (((candle_start >= '2025-01-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_164_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_164_chunk (
    CONSTRAINT constraint_164 CHECK (((candle_start >= '2025-01-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_165_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_165_chunk (
    CONSTRAINT constraint_165 CHECK (((candle_start >= '2025-01-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_166_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_166_chunk (
    CONSTRAINT constraint_166 CHECK (((candle_start >= '2025-01-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_167_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_167_chunk (
    CONSTRAINT constraint_167 CHECK (((candle_start >= '2025-01-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_168_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_168_chunk (
    CONSTRAINT constraint_168 CHECK (((candle_start >= '2025-02-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_169_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_169_chunk (
    CONSTRAINT constraint_169 CHECK (((candle_start >= '2025-02-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_170_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_170_chunk (
    CONSTRAINT constraint_170 CHECK (((candle_start >= '2025-02-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_171_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_171_chunk (
    CONSTRAINT constraint_171 CHECK (((candle_start >= '2025-02-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_172_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_172_chunk (
    CONSTRAINT constraint_172 CHECK (((candle_start >= '2025-03-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_173_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_173_chunk (
    CONSTRAINT constraint_173 CHECK (((candle_start >= '2025-03-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_174_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_174_chunk (
    CONSTRAINT constraint_174 CHECK (((candle_start >= '2025-03-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_175_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_175_chunk (
    CONSTRAINT constraint_175 CHECK (((candle_start >= '2025-03-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_176_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_176_chunk (
    CONSTRAINT constraint_176 CHECK (((candle_start >= '2025-04-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_177_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_177_chunk (
    CONSTRAINT constraint_177 CHECK (((candle_start >= '2025-04-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_178_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_178_chunk (
    CONSTRAINT constraint_178 CHECK (((candle_start >= '2025-04-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_179_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_179_chunk (
    CONSTRAINT constraint_179 CHECK (((candle_start >= '2025-04-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_180_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_180_chunk (
    CONSTRAINT constraint_180 CHECK (((candle_start >= '2025-05-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_181_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_181_chunk (
    CONSTRAINT constraint_181 CHECK (((candle_start >= '2025-05-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_182_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_182_chunk (
    CONSTRAINT constraint_182 CHECK (((candle_start >= '2025-05-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_183_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_183_chunk (
    CONSTRAINT constraint_183 CHECK (((candle_start >= '2025-05-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_184_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_184_chunk (
    CONSTRAINT constraint_184 CHECK (((candle_start >= '2025-05-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_185_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_185_chunk (
    CONSTRAINT constraint_185 CHECK (((candle_start >= '2025-06-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_186_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_186_chunk (
    CONSTRAINT constraint_186 CHECK (((candle_start >= '2025-06-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_187_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_187_chunk (
    CONSTRAINT constraint_187 CHECK (((candle_start >= '2025-06-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_188_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_188_chunk (
    CONSTRAINT constraint_188 CHECK (((candle_start >= '2025-06-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_189_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_189_chunk (
    CONSTRAINT constraint_189 CHECK (((candle_start >= '2025-07-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_190_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_190_chunk (
    CONSTRAINT constraint_190 CHECK (((candle_start >= '2025-07-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_191_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_191_chunk (
    CONSTRAINT constraint_191 CHECK (((candle_start >= '2025-07-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_192_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_192_chunk (
    CONSTRAINT constraint_192 CHECK (((candle_start >= '2025-07-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_193_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_193_chunk (
    CONSTRAINT constraint_193 CHECK (((candle_start >= '2025-07-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_194_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_194_chunk (
    CONSTRAINT constraint_194 CHECK (((candle_start >= '2025-08-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_195_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_195_chunk (
    CONSTRAINT constraint_195 CHECK (((candle_start >= '2025-08-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_196_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_196_chunk (
    CONSTRAINT constraint_196 CHECK (((candle_start >= '2025-08-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_197_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_197_chunk (
    CONSTRAINT constraint_197 CHECK (((candle_start >= '2025-08-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_198_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_198_chunk (
    CONSTRAINT constraint_198 CHECK (((candle_start >= '2025-09-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_199_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_199_chunk (
    CONSTRAINT constraint_199 CHECK (((candle_start >= '2025-09-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_200_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_200_chunk (
    CONSTRAINT constraint_200 CHECK (((candle_start >= '2025-09-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_201_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_201_chunk (
    CONSTRAINT constraint_201 CHECK (((candle_start >= '2025-09-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_202_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_202_chunk (
    CONSTRAINT constraint_202 CHECK (((candle_start >= '2025-10-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_203_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_203_chunk (
    CONSTRAINT constraint_203 CHECK (((candle_start >= '2025-10-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_204_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_204_chunk (
    CONSTRAINT constraint_204 CHECK (((candle_start >= '2025-10-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_205_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_205_chunk (
    CONSTRAINT constraint_205 CHECK (((candle_start >= '2025-10-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_206_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_206_chunk (
    CONSTRAINT constraint_206 CHECK (((candle_start >= '2025-10-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_207_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_207_chunk (
    CONSTRAINT constraint_207 CHECK (((candle_start >= '2025-11-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_208_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_208_chunk (
    CONSTRAINT constraint_208 CHECK (((candle_start >= '2025-11-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_209_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_209_chunk (
    CONSTRAINT constraint_209 CHECK (((candle_start >= '2025-11-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_210_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_210_chunk (
    CONSTRAINT constraint_210 CHECK (((candle_start >= '2025-11-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_211_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_211_chunk (
    CONSTRAINT constraint_211 CHECK (((candle_start >= '2025-12-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_215_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_215_chunk (
    CONSTRAINT constraint_215 CHECK (((candle_start >= '2025-12-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_216_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_216_chunk (
    CONSTRAINT constraint_216 CHECK (((candle_start >= '2025-12-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_3_217_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_3_217_chunk (
    CONSTRAINT constraint_217 CHECK (((candle_start >= '2025-12-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: candles_1d; Type: TABLE; Schema: ohlc; Owner: -
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


--
-- Name: _hyper_4_100_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_100_chunk (
    CONSTRAINT constraint_100 CHECK (((candle_start >= '2024-10-24'::date) AND (candle_start < '2024-10-31'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_101_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_101_chunk (
    CONSTRAINT constraint_101 CHECK (((candle_start >= '2024-10-31'::date) AND (candle_start < '2024-11-07'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_102_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_102_chunk (
    CONSTRAINT constraint_102 CHECK (((candle_start >= '2024-11-07'::date) AND (candle_start < '2024-11-14'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_103_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_103_chunk (
    CONSTRAINT constraint_103 CHECK (((candle_start >= '2024-11-14'::date) AND (candle_start < '2024-11-21'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_104_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_104_chunk (
    CONSTRAINT constraint_104 CHECK (((candle_start >= '2024-11-21'::date) AND (candle_start < '2024-11-28'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_105_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_105_chunk (
    CONSTRAINT constraint_105 CHECK (((candle_start >= '2024-11-28'::date) AND (candle_start < '2024-12-05'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_106_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_106_chunk (
    CONSTRAINT constraint_106 CHECK (((candle_start >= '2024-12-05'::date) AND (candle_start < '2024-12-12'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_107_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_107_chunk (
    CONSTRAINT constraint_107 CHECK (((candle_start >= '2024-12-12'::date) AND (candle_start < '2024-12-19'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_108_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_108_chunk (
    CONSTRAINT constraint_108 CHECK (((candle_start >= '2024-12-19'::date) AND (candle_start < '2024-12-26'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_109_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_109_chunk (
    CONSTRAINT constraint_109 CHECK (((candle_start >= '2024-12-26'::date) AND (candle_start < '2025-01-02'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_10_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_10_chunk (
    CONSTRAINT constraint_10 CHECK (((candle_start >= '2023-02-02'::date) AND (candle_start < '2023-02-09'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_110_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_110_chunk (
    CONSTRAINT constraint_110 CHECK (((candle_start >= '2025-01-02'::date) AND (candle_start < '2025-01-09'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_111_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_111_chunk (
    CONSTRAINT constraint_111 CHECK (((candle_start >= '2025-01-09'::date) AND (candle_start < '2025-01-16'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_112_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_112_chunk (
    CONSTRAINT constraint_112 CHECK (((candle_start >= '2025-01-16'::date) AND (candle_start < '2025-01-23'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_113_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_113_chunk (
    CONSTRAINT constraint_113 CHECK (((candle_start >= '2025-01-23'::date) AND (candle_start < '2025-01-30'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_114_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_114_chunk (
    CONSTRAINT constraint_114 CHECK (((candle_start >= '2025-01-30'::date) AND (candle_start < '2025-02-06'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_115_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_115_chunk (
    CONSTRAINT constraint_115 CHECK (((candle_start >= '2025-02-06'::date) AND (candle_start < '2025-02-13'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_116_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_116_chunk (
    CONSTRAINT constraint_116 CHECK (((candle_start >= '2025-02-13'::date) AND (candle_start < '2025-02-20'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_117_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_117_chunk (
    CONSTRAINT constraint_117 CHECK (((candle_start >= '2025-02-20'::date) AND (candle_start < '2025-02-27'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_118_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_118_chunk (
    CONSTRAINT constraint_118 CHECK (((candle_start >= '2025-02-27'::date) AND (candle_start < '2025-03-06'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_119_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_119_chunk (
    CONSTRAINT constraint_119 CHECK (((candle_start >= '2025-03-06'::date) AND (candle_start < '2025-03-13'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_11_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_11_chunk (
    CONSTRAINT constraint_11 CHECK (((candle_start >= '2023-02-09'::date) AND (candle_start < '2023-02-16'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_120_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_120_chunk (
    CONSTRAINT constraint_120 CHECK (((candle_start >= '2025-03-13'::date) AND (candle_start < '2025-03-20'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_121_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_121_chunk (
    CONSTRAINT constraint_121 CHECK (((candle_start >= '2025-03-20'::date) AND (candle_start < '2025-03-27'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_122_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_122_chunk (
    CONSTRAINT constraint_122 CHECK (((candle_start >= '2025-03-27'::date) AND (candle_start < '2025-04-03'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_123_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_123_chunk (
    CONSTRAINT constraint_123 CHECK (((candle_start >= '2025-04-03'::date) AND (candle_start < '2025-04-10'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_124_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_124_chunk (
    CONSTRAINT constraint_124 CHECK (((candle_start >= '2025-04-10'::date) AND (candle_start < '2025-04-17'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_125_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_125_chunk (
    CONSTRAINT constraint_125 CHECK (((candle_start >= '2025-04-17'::date) AND (candle_start < '2025-04-24'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_126_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_126_chunk (
    CONSTRAINT constraint_126 CHECK (((candle_start >= '2025-04-24'::date) AND (candle_start < '2025-05-01'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_127_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_127_chunk (
    CONSTRAINT constraint_127 CHECK (((candle_start >= '2025-05-01'::date) AND (candle_start < '2025-05-08'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_128_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_128_chunk (
    CONSTRAINT constraint_128 CHECK (((candle_start >= '2025-05-08'::date) AND (candle_start < '2025-05-15'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_129_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_129_chunk (
    CONSTRAINT constraint_129 CHECK (((candle_start >= '2025-05-15'::date) AND (candle_start < '2025-05-22'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_12_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_12_chunk (
    CONSTRAINT constraint_12 CHECK (((candle_start >= '2023-02-16'::date) AND (candle_start < '2023-02-23'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_130_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_130_chunk (
    CONSTRAINT constraint_130 CHECK (((candle_start >= '2025-05-22'::date) AND (candle_start < '2025-05-29'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_131_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_131_chunk (
    CONSTRAINT constraint_131 CHECK (((candle_start >= '2025-05-29'::date) AND (candle_start < '2025-06-05'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_132_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_132_chunk (
    CONSTRAINT constraint_132 CHECK (((candle_start >= '2025-06-05'::date) AND (candle_start < '2025-06-12'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_133_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_133_chunk (
    CONSTRAINT constraint_133 CHECK (((candle_start >= '2025-06-12'::date) AND (candle_start < '2025-06-19'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_134_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_134_chunk (
    CONSTRAINT constraint_134 CHECK (((candle_start >= '2025-06-19'::date) AND (candle_start < '2025-06-26'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_135_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_135_chunk (
    CONSTRAINT constraint_135 CHECK (((candle_start >= '2025-06-26'::date) AND (candle_start < '2025-07-03'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_136_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_136_chunk (
    CONSTRAINT constraint_136 CHECK (((candle_start >= '2025-07-03'::date) AND (candle_start < '2025-07-10'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_137_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_137_chunk (
    CONSTRAINT constraint_137 CHECK (((candle_start >= '2025-07-10'::date) AND (candle_start < '2025-07-17'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_138_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_138_chunk (
    CONSTRAINT constraint_138 CHECK (((candle_start >= '2025-07-17'::date) AND (candle_start < '2025-07-24'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_139_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_139_chunk (
    CONSTRAINT constraint_139 CHECK (((candle_start >= '2025-07-24'::date) AND (candle_start < '2025-07-31'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_13_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_13_chunk (
    CONSTRAINT constraint_13 CHECK (((candle_start >= '2023-02-23'::date) AND (candle_start < '2023-03-02'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_140_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_140_chunk (
    CONSTRAINT constraint_140 CHECK (((candle_start >= '2025-07-31'::date) AND (candle_start < '2025-08-07'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_141_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_141_chunk (
    CONSTRAINT constraint_141 CHECK (((candle_start >= '2025-08-07'::date) AND (candle_start < '2025-08-14'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_142_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_142_chunk (
    CONSTRAINT constraint_142 CHECK (((candle_start >= '2025-08-14'::date) AND (candle_start < '2025-08-21'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_143_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_143_chunk (
    CONSTRAINT constraint_143 CHECK (((candle_start >= '2025-08-21'::date) AND (candle_start < '2025-08-28'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_144_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_144_chunk (
    CONSTRAINT constraint_144 CHECK (((candle_start >= '2025-08-28'::date) AND (candle_start < '2025-09-04'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_145_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_145_chunk (
    CONSTRAINT constraint_145 CHECK (((candle_start >= '2025-09-04'::date) AND (candle_start < '2025-09-11'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_146_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_146_chunk (
    CONSTRAINT constraint_146 CHECK (((candle_start >= '2025-09-11'::date) AND (candle_start < '2025-09-18'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_147_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_147_chunk (
    CONSTRAINT constraint_147 CHECK (((candle_start >= '2025-09-18'::date) AND (candle_start < '2025-09-25'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_148_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_148_chunk (
    CONSTRAINT constraint_148 CHECK (((candle_start >= '2025-09-25'::date) AND (candle_start < '2025-10-02'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_149_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_149_chunk (
    CONSTRAINT constraint_149 CHECK (((candle_start >= '2025-10-02'::date) AND (candle_start < '2025-10-09'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_14_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_14_chunk (
    CONSTRAINT constraint_14 CHECK (((candle_start >= '2023-03-02'::date) AND (candle_start < '2023-03-09'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_150_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_150_chunk (
    CONSTRAINT constraint_150 CHECK (((candle_start >= '2025-10-09'::date) AND (candle_start < '2025-10-16'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_151_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_151_chunk (
    CONSTRAINT constraint_151 CHECK (((candle_start >= '2025-10-16'::date) AND (candle_start < '2025-10-23'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_152_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_152_chunk (
    CONSTRAINT constraint_152 CHECK (((candle_start >= '2025-10-23'::date) AND (candle_start < '2025-10-30'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_153_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_153_chunk (
    CONSTRAINT constraint_153 CHECK (((candle_start >= '2025-10-30'::date) AND (candle_start < '2025-11-06'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_154_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_154_chunk (
    CONSTRAINT constraint_154 CHECK (((candle_start >= '2025-11-06'::date) AND (candle_start < '2025-11-13'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_155_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_155_chunk (
    CONSTRAINT constraint_155 CHECK (((candle_start >= '2025-11-13'::date) AND (candle_start < '2025-11-20'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_156_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_156_chunk (
    CONSTRAINT constraint_156 CHECK (((candle_start >= '2025-11-20'::date) AND (candle_start < '2025-11-27'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_157_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_157_chunk (
    CONSTRAINT constraint_157 CHECK (((candle_start >= '2025-11-27'::date) AND (candle_start < '2025-12-04'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_158_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_158_chunk (
    CONSTRAINT constraint_158 CHECK (((candle_start >= '2025-12-04'::date) AND (candle_start < '2025-12-11'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_15_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_15_chunk (
    CONSTRAINT constraint_15 CHECK (((candle_start >= '2023-03-09'::date) AND (candle_start < '2023-03-16'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_16_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_16_chunk (
    CONSTRAINT constraint_16 CHECK (((candle_start >= '2023-03-16'::date) AND (candle_start < '2023-03-23'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_17_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_17_chunk (
    CONSTRAINT constraint_17 CHECK (((candle_start >= '2023-03-23'::date) AND (candle_start < '2023-03-30'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_18_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_18_chunk (
    CONSTRAINT constraint_18 CHECK (((candle_start >= '2023-03-30'::date) AND (candle_start < '2023-04-06'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_19_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_19_chunk (
    CONSTRAINT constraint_19 CHECK (((candle_start >= '2023-04-06'::date) AND (candle_start < '2023-04-13'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_1_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_1_chunk (
    CONSTRAINT constraint_1 CHECK (((candle_start >= '2022-12-01'::date) AND (candle_start < '2022-12-08'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_20_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_20_chunk (
    CONSTRAINT constraint_20 CHECK (((candle_start >= '2023-04-13'::date) AND (candle_start < '2023-04-20'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_212_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_212_chunk (
    CONSTRAINT constraint_212 CHECK (((candle_start >= '2025-12-11'::date) AND (candle_start < '2025-12-18'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_213_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_213_chunk (
    CONSTRAINT constraint_213 CHECK (((candle_start >= '2025-12-18'::date) AND (candle_start < '2025-12-25'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_214_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_214_chunk (
    CONSTRAINT constraint_214 CHECK (((candle_start >= '2025-12-25'::date) AND (candle_start < '2026-01-01'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_21_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_21_chunk (
    CONSTRAINT constraint_21 CHECK (((candle_start >= '2023-04-20'::date) AND (candle_start < '2023-04-27'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_22_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_22_chunk (
    CONSTRAINT constraint_22 CHECK (((candle_start >= '2023-04-27'::date) AND (candle_start < '2023-05-04'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_23_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_23_chunk (
    CONSTRAINT constraint_23 CHECK (((candle_start >= '2023-05-04'::date) AND (candle_start < '2023-05-11'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_24_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_24_chunk (
    CONSTRAINT constraint_24 CHECK (((candle_start >= '2023-05-11'::date) AND (candle_start < '2023-05-18'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_25_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_25_chunk (
    CONSTRAINT constraint_25 CHECK (((candle_start >= '2023-05-18'::date) AND (candle_start < '2023-05-25'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_26_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_26_chunk (
    CONSTRAINT constraint_26 CHECK (((candle_start >= '2023-05-25'::date) AND (candle_start < '2023-06-01'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_27_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_27_chunk (
    CONSTRAINT constraint_27 CHECK (((candle_start >= '2023-06-01'::date) AND (candle_start < '2023-06-08'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_28_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_28_chunk (
    CONSTRAINT constraint_28 CHECK (((candle_start >= '2023-06-08'::date) AND (candle_start < '2023-06-15'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_29_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_29_chunk (
    CONSTRAINT constraint_29 CHECK (((candle_start >= '2023-06-15'::date) AND (candle_start < '2023-06-22'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_2_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_2_chunk (
    CONSTRAINT constraint_2 CHECK (((candle_start >= '2022-12-08'::date) AND (candle_start < '2022-12-15'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_30_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_30_chunk (
    CONSTRAINT constraint_30 CHECK (((candle_start >= '2023-06-22'::date) AND (candle_start < '2023-06-29'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_31_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_31_chunk (
    CONSTRAINT constraint_31 CHECK (((candle_start >= '2023-06-29'::date) AND (candle_start < '2023-07-06'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_32_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_32_chunk (
    CONSTRAINT constraint_32 CHECK (((candle_start >= '2023-07-06'::date) AND (candle_start < '2023-07-13'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_33_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_33_chunk (
    CONSTRAINT constraint_33 CHECK (((candle_start >= '2023-07-13'::date) AND (candle_start < '2023-07-20'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_34_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_34_chunk (
    CONSTRAINT constraint_34 CHECK (((candle_start >= '2023-07-20'::date) AND (candle_start < '2023-07-27'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_35_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_35_chunk (
    CONSTRAINT constraint_35 CHECK (((candle_start >= '2023-07-27'::date) AND (candle_start < '2023-08-03'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_36_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_36_chunk (
    CONSTRAINT constraint_36 CHECK (((candle_start >= '2023-08-03'::date) AND (candle_start < '2023-08-10'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_37_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_37_chunk (
    CONSTRAINT constraint_37 CHECK (((candle_start >= '2023-08-10'::date) AND (candle_start < '2023-08-17'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_38_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_38_chunk (
    CONSTRAINT constraint_38 CHECK (((candle_start >= '2023-08-17'::date) AND (candle_start < '2023-08-24'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_39_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_39_chunk (
    CONSTRAINT constraint_39 CHECK (((candle_start >= '2023-08-24'::date) AND (candle_start < '2023-08-31'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_3_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_3_chunk (
    CONSTRAINT constraint_3 CHECK (((candle_start >= '2022-12-15'::date) AND (candle_start < '2022-12-22'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_40_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_40_chunk (
    CONSTRAINT constraint_40 CHECK (((candle_start >= '2023-08-31'::date) AND (candle_start < '2023-09-07'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_41_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_41_chunk (
    CONSTRAINT constraint_41 CHECK (((candle_start >= '2023-09-07'::date) AND (candle_start < '2023-09-14'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_42_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_42_chunk (
    CONSTRAINT constraint_42 CHECK (((candle_start >= '2023-09-14'::date) AND (candle_start < '2023-09-21'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_43_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_43_chunk (
    CONSTRAINT constraint_43 CHECK (((candle_start >= '2023-09-21'::date) AND (candle_start < '2023-09-28'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_44_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_44_chunk (
    CONSTRAINT constraint_44 CHECK (((candle_start >= '2023-09-28'::date) AND (candle_start < '2023-10-05'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_45_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_45_chunk (
    CONSTRAINT constraint_45 CHECK (((candle_start >= '2023-10-05'::date) AND (candle_start < '2023-10-12'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_46_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_46_chunk (
    CONSTRAINT constraint_46 CHECK (((candle_start >= '2023-10-12'::date) AND (candle_start < '2023-10-19'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_47_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_47_chunk (
    CONSTRAINT constraint_47 CHECK (((candle_start >= '2023-10-19'::date) AND (candle_start < '2023-10-26'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_48_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_48_chunk (
    CONSTRAINT constraint_48 CHECK (((candle_start >= '2023-10-26'::date) AND (candle_start < '2023-11-02'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_49_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_49_chunk (
    CONSTRAINT constraint_49 CHECK (((candle_start >= '2023-11-02'::date) AND (candle_start < '2023-11-09'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_4_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_4_chunk (
    CONSTRAINT constraint_4 CHECK (((candle_start >= '2022-12-22'::date) AND (candle_start < '2022-12-29'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_50_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_50_chunk (
    CONSTRAINT constraint_50 CHECK (((candle_start >= '2023-11-09'::date) AND (candle_start < '2023-11-16'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_51_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_51_chunk (
    CONSTRAINT constraint_51 CHECK (((candle_start >= '2023-11-16'::date) AND (candle_start < '2023-11-23'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_52_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_52_chunk (
    CONSTRAINT constraint_52 CHECK (((candle_start >= '2023-11-23'::date) AND (candle_start < '2023-11-30'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_53_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_53_chunk (
    CONSTRAINT constraint_53 CHECK (((candle_start >= '2023-11-30'::date) AND (candle_start < '2023-12-07'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_54_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_54_chunk (
    CONSTRAINT constraint_54 CHECK (((candle_start >= '2023-12-07'::date) AND (candle_start < '2023-12-14'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_55_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_55_chunk (
    CONSTRAINT constraint_55 CHECK (((candle_start >= '2023-12-14'::date) AND (candle_start < '2023-12-21'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_56_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_56_chunk (
    CONSTRAINT constraint_56 CHECK (((candle_start >= '2023-12-21'::date) AND (candle_start < '2023-12-28'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_57_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_57_chunk (
    CONSTRAINT constraint_57 CHECK (((candle_start >= '2023-12-28'::date) AND (candle_start < '2024-01-04'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_58_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_58_chunk (
    CONSTRAINT constraint_58 CHECK (((candle_start >= '2024-01-04'::date) AND (candle_start < '2024-01-11'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_59_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_59_chunk (
    CONSTRAINT constraint_59 CHECK (((candle_start >= '2024-01-11'::date) AND (candle_start < '2024-01-18'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_5_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_5_chunk (
    CONSTRAINT constraint_5 CHECK (((candle_start >= '2022-12-29'::date) AND (candle_start < '2023-01-05'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_60_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_60_chunk (
    CONSTRAINT constraint_60 CHECK (((candle_start >= '2024-01-18'::date) AND (candle_start < '2024-01-25'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_61_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_61_chunk (
    CONSTRAINT constraint_61 CHECK (((candle_start >= '2024-01-25'::date) AND (candle_start < '2024-02-01'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_62_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_62_chunk (
    CONSTRAINT constraint_62 CHECK (((candle_start >= '2024-02-01'::date) AND (candle_start < '2024-02-08'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_63_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_63_chunk (
    CONSTRAINT constraint_63 CHECK (((candle_start >= '2024-02-08'::date) AND (candle_start < '2024-02-15'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_64_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_64_chunk (
    CONSTRAINT constraint_64 CHECK (((candle_start >= '2024-02-15'::date) AND (candle_start < '2024-02-22'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_65_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_65_chunk (
    CONSTRAINT constraint_65 CHECK (((candle_start >= '2024-02-22'::date) AND (candle_start < '2024-02-29'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_66_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_66_chunk (
    CONSTRAINT constraint_66 CHECK (((candle_start >= '2024-02-29'::date) AND (candle_start < '2024-03-07'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_67_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_67_chunk (
    CONSTRAINT constraint_67 CHECK (((candle_start >= '2024-03-07'::date) AND (candle_start < '2024-03-14'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_68_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_68_chunk (
    CONSTRAINT constraint_68 CHECK (((candle_start >= '2024-03-14'::date) AND (candle_start < '2024-03-21'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_69_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_69_chunk (
    CONSTRAINT constraint_69 CHECK (((candle_start >= '2024-03-21'::date) AND (candle_start < '2024-03-28'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_6_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_6_chunk (
    CONSTRAINT constraint_6 CHECK (((candle_start >= '2023-01-05'::date) AND (candle_start < '2023-01-12'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_70_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_70_chunk (
    CONSTRAINT constraint_70 CHECK (((candle_start >= '2024-03-28'::date) AND (candle_start < '2024-04-04'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_71_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_71_chunk (
    CONSTRAINT constraint_71 CHECK (((candle_start >= '2024-04-04'::date) AND (candle_start < '2024-04-11'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_72_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_72_chunk (
    CONSTRAINT constraint_72 CHECK (((candle_start >= '2024-04-11'::date) AND (candle_start < '2024-04-18'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_73_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_73_chunk (
    CONSTRAINT constraint_73 CHECK (((candle_start >= '2024-04-18'::date) AND (candle_start < '2024-04-25'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_74_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_74_chunk (
    CONSTRAINT constraint_74 CHECK (((candle_start >= '2024-04-25'::date) AND (candle_start < '2024-05-02'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_75_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_75_chunk (
    CONSTRAINT constraint_75 CHECK (((candle_start >= '2024-05-02'::date) AND (candle_start < '2024-05-09'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_76_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_76_chunk (
    CONSTRAINT constraint_76 CHECK (((candle_start >= '2024-05-09'::date) AND (candle_start < '2024-05-16'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_77_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_77_chunk (
    CONSTRAINT constraint_77 CHECK (((candle_start >= '2024-05-16'::date) AND (candle_start < '2024-05-23'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_78_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_78_chunk (
    CONSTRAINT constraint_78 CHECK (((candle_start >= '2024-05-23'::date) AND (candle_start < '2024-05-30'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_79_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_79_chunk (
    CONSTRAINT constraint_79 CHECK (((candle_start >= '2024-05-30'::date) AND (candle_start < '2024-06-06'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_7_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_7_chunk (
    CONSTRAINT constraint_7 CHECK (((candle_start >= '2023-01-12'::date) AND (candle_start < '2023-01-19'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_80_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_80_chunk (
    CONSTRAINT constraint_80 CHECK (((candle_start >= '2024-06-06'::date) AND (candle_start < '2024-06-13'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_81_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_81_chunk (
    CONSTRAINT constraint_81 CHECK (((candle_start >= '2024-06-13'::date) AND (candle_start < '2024-06-20'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_82_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_82_chunk (
    CONSTRAINT constraint_82 CHECK (((candle_start >= '2024-06-20'::date) AND (candle_start < '2024-06-27'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_83_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_83_chunk (
    CONSTRAINT constraint_83 CHECK (((candle_start >= '2024-06-27'::date) AND (candle_start < '2024-07-04'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_84_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_84_chunk (
    CONSTRAINT constraint_84 CHECK (((candle_start >= '2024-07-04'::date) AND (candle_start < '2024-07-11'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_85_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_85_chunk (
    CONSTRAINT constraint_85 CHECK (((candle_start >= '2024-07-11'::date) AND (candle_start < '2024-07-18'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_86_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_86_chunk (
    CONSTRAINT constraint_86 CHECK (((candle_start >= '2024-07-18'::date) AND (candle_start < '2024-07-25'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_87_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_87_chunk (
    CONSTRAINT constraint_87 CHECK (((candle_start >= '2024-07-25'::date) AND (candle_start < '2024-08-01'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_88_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_88_chunk (
    CONSTRAINT constraint_88 CHECK (((candle_start >= '2024-08-01'::date) AND (candle_start < '2024-08-08'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_89_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_89_chunk (
    CONSTRAINT constraint_89 CHECK (((candle_start >= '2024-08-08'::date) AND (candle_start < '2024-08-15'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_8_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_8_chunk (
    CONSTRAINT constraint_8 CHECK (((candle_start >= '2023-01-19'::date) AND (candle_start < '2023-01-26'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_90_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_90_chunk (
    CONSTRAINT constraint_90 CHECK (((candle_start >= '2024-08-15'::date) AND (candle_start < '2024-08-22'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_91_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_91_chunk (
    CONSTRAINT constraint_91 CHECK (((candle_start >= '2024-08-22'::date) AND (candle_start < '2024-08-29'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_92_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_92_chunk (
    CONSTRAINT constraint_92 CHECK (((candle_start >= '2024-08-29'::date) AND (candle_start < '2024-09-05'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_93_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_93_chunk (
    CONSTRAINT constraint_93 CHECK (((candle_start >= '2024-09-05'::date) AND (candle_start < '2024-09-12'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_94_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_94_chunk (
    CONSTRAINT constraint_94 CHECK (((candle_start >= '2024-09-12'::date) AND (candle_start < '2024-09-19'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_95_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_95_chunk (
    CONSTRAINT constraint_95 CHECK (((candle_start >= '2024-09-19'::date) AND (candle_start < '2024-09-26'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_96_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_96_chunk (
    CONSTRAINT constraint_96 CHECK (((candle_start >= '2024-09-26'::date) AND (candle_start < '2024-10-03'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_97_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_97_chunk (
    CONSTRAINT constraint_97 CHECK (((candle_start >= '2024-10-03'::date) AND (candle_start < '2024-10-10'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_98_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_98_chunk (
    CONSTRAINT constraint_98 CHECK (((candle_start >= '2024-10-10'::date) AND (candle_start < '2024-10-17'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_99_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_99_chunk (
    CONSTRAINT constraint_99 CHECK (((candle_start >= '2024-10-17'::date) AND (candle_start < '2024-10-24'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_4_9_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_4_9_chunk (
    CONSTRAINT constraint_9 CHECK (((candle_start >= '2023-01-26'::date) AND (candle_start < '2023-02-02'::date)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: job_run; Type: TABLE; Schema: audit; Owner: -
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


--
-- Name: job_run_job_run_id_seq; Type: SEQUENCE; Schema: audit; Owner: -
--

CREATE SEQUENCE audit.job_run_job_run_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_run_job_run_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: -
--

ALTER SEQUENCE audit.job_run_job_run_id_seq OWNED BY audit.job_run.job_run_id;


--
-- Name: exchange; Type: TABLE; Schema: ref; Owner: -
--

CREATE TABLE ref.exchange (
    exchange_code text NOT NULL,
    exchange_name text NOT NULL,
    country text DEFAULT 'IN'::text,
    timezone text DEFAULT 'Asia/Kolkata'::text,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: index_mapping; Type: TABLE; Schema: ref; Owner: -
--

CREATE TABLE ref.index_mapping (
    mapping_id bigint NOT NULL,
    index_name text NOT NULL,
    stock_symbol text NOT NULL
);


--
-- Name: index_mapping_mapping_id_seq; Type: SEQUENCE; Schema: ref; Owner: -
--

CREATE SEQUENCE ref.index_mapping_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: index_mapping_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: -
--

ALTER SEQUENCE ref.index_mapping_mapping_id_seq OWNED BY ref.index_mapping.mapping_id;


--
-- Name: index_source; Type: TABLE; Schema: ref; Owner: -
--

CREATE TABLE ref.index_source (
    index_name text NOT NULL,
    source_url text NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: symbol; Type: TABLE; Schema: ref; Owner: -
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


--
-- Name: symbol_symbol_id_seq; Type: SEQUENCE; Schema: ref; Owner: -
--

CREATE SEQUENCE ref.symbol_symbol_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: symbol_symbol_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: -
--

ALTER SEQUENCE ref.symbol_symbol_id_seq OWNED BY ref.symbol.symbol_id;


--
-- Name: app_logs; Type: TABLE; Schema: sys; Owner: -
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


--
-- Name: app_logs_id_seq; Type: SEQUENCE; Schema: sys; Owner: -
--

CREATE SEQUENCE sys.app_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: -
--

ALTER SEQUENCE sys.app_logs_id_seq OWNED BY sys.app_logs.id;


--
-- Name: job_history; Type: TABLE; Schema: sys; Owner: -
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


--
-- Name: job_history_id_seq; Type: SEQUENCE; Schema: sys; Owner: -
--

CREATE SEQUENCE sys.job_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_history_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: -
--

ALTER SEQUENCE sys.job_history_id_seq OWNED BY sys.job_history.id;


--
-- Name: job_triggers; Type: TABLE; Schema: sys; Owner: -
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


--
-- Name: job_triggers_id_seq; Type: SEQUENCE; Schema: sys; Owner: -
--

CREATE SEQUENCE sys.job_triggers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: -
--

ALTER SEQUENCE sys.job_triggers_id_seq OWNED BY sys.job_triggers.id;


--
-- Name: scanners; Type: TABLE; Schema: sys; Owner: -
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


--
-- Name: scanners_id_seq; Type: SEQUENCE; Schema: sys; Owner: -
--

CREATE SEQUENCE sys.scanners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scanners_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: -
--

ALTER SEQUENCE sys.scanners_id_seq OWNED BY sys.scanners.id;


--
-- Name: scheduled_jobs; Type: TABLE; Schema: sys; Owner: -
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


--
-- Name: scheduled_jobs_id_seq; Type: SEQUENCE; Schema: sys; Owner: -
--

CREATE SEQUENCE sys.scheduled_jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheduled_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: -
--

ALTER SEQUENCE sys.scheduled_jobs_id_seq OWNED BY sys.scheduled_jobs.id;


--
-- Name: service_status; Type: TABLE; Schema: sys; Owner: -
--

CREATE TABLE sys.service_status (
    service_name text NOT NULL,
    last_heartbeat timestamp with time zone,
    status text,
    info jsonb
);


--
-- Name: daily_pnl; Type: TABLE; Schema: trading; Owner: -
--

CREATE TABLE trading.daily_pnl (
    id integer NOT NULL,
    date date NOT NULL,
    realized_pnl numeric(14,4) DEFAULT 0,
    unrealized_pnl numeric(14,4) DEFAULT 0,
    charges numeric(14,4) DEFAULT 0,
    net_pnl numeric(14,4) DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: daily_pnl_id_seq; Type: SEQUENCE; Schema: trading; Owner: -
--

CREATE SEQUENCE trading.daily_pnl_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: daily_pnl_id_seq; Type: SEQUENCE OWNED BY; Schema: trading; Owner: -
--

ALTER SEQUENCE trading.daily_pnl_id_seq OWNED BY trading.daily_pnl.id;


--
-- Name: orders; Type: TABLE; Schema: trading; Owner: -
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
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: portfolio; Type: TABLE; Schema: trading; Owner: -
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
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: portfolio_id_seq; Type: SEQUENCE; Schema: trading; Owner: -
--

CREATE SEQUENCE trading.portfolio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portfolio_id_seq; Type: SEQUENCE OWNED BY; Schema: trading; Owner: -
--

ALTER SEQUENCE trading.portfolio_id_seq OWNED BY trading.portfolio.id;


--
-- Name: portfolio_view; Type: VIEW; Schema: trading; Owner: -
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


--
-- Name: positions; Type: TABLE; Schema: trading; Owner: -
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
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: trading; Owner: -
--

CREATE SEQUENCE trading.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: trading; Owner: -
--

ALTER SEQUENCE trading.positions_id_seq OWNED BY trading.positions.id;


--
-- Name: scanner_results; Type: TABLE; Schema: trading; Owner: -
--

CREATE TABLE trading.scanner_results (
    id integer NOT NULL,
    scanner_id integer,
    run_date timestamp with time zone DEFAULT now(),
    symbol text NOT NULL,
    match_data jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: scanner_results_id_seq; Type: SEQUENCE; Schema: trading; Owner: -
--

CREATE SEQUENCE trading.scanner_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scanner_results_id_seq; Type: SEQUENCE OWNED BY; Schema: trading; Owner: -
--

ALTER SEQUENCE trading.scanner_results_id_seq OWNED BY trading.scanner_results.id;


--
-- Name: trades; Type: TABLE; Schema: trading; Owner: -
--

CREATE TABLE trading.trades (
    trade_id bigint NOT NULL,
    broker_order_id text,
    symbol text NOT NULL,
    exchange_code text DEFAULT 'NSE'::text,
    transaction_type text NOT NULL,
    quantity integer NOT NULL,
    price numeric(14,4) NOT NULL,
    trade_date timestamp with time zone DEFAULT now(),
    holder_name text DEFAULT 'Primary'::text NOT NULL,
    strategy_name text DEFAULT 'Manual'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    broker_name text DEFAULT 'Zerodha'::text,
    isin text,
    product_type text DEFAULT 'CNC'::text NOT NULL,
    total_charges numeric(10,2) DEFAULT 0,
    net_amount numeric(14,2),
    currency text DEFAULT 'INR'::text,
    notes text,
    CONSTRAINT check_prod_type CHECK ((product_type = ANY (ARRAY['CNC'::text, 'MIS'::text, 'NRML'::text, 'CO'::text]))),
    CONSTRAINT check_txn_type CHECK ((transaction_type = ANY (ARRAY['BUY'::text, 'SELL'::text])))
);


--
-- Name: trades_trade_id_seq; Type: SEQUENCE; Schema: trading; Owner: -
--

CREATE SEQUENCE trading.trades_trade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trades_trade_id_seq; Type: SEQUENCE OWNED BY; Schema: trading; Owner: -
--

ALTER SEQUENCE trading.trades_trade_id_seq OWNED BY trading.trades.trade_id;


--
-- Name: _hyper_3_159_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_159_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_159_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_159_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_159_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_159_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_160_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_160_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_160_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_160_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_160_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_160_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_161_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_161_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_161_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_161_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_161_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_161_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_162_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_162_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_162_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_162_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_162_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_162_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_163_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_163_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_163_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_163_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_163_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_163_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_164_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_164_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_164_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_164_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_164_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_164_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_165_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_165_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_165_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_165_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_165_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_165_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_166_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_166_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_166_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_166_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_166_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_166_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_167_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_167_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_167_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_167_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_167_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_167_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_168_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_168_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_168_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_168_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_168_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_168_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_169_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_169_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_169_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_169_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_169_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_169_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_170_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_170_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_170_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_170_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_170_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_170_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_171_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_171_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_171_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_171_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_171_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_171_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_172_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_172_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_172_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_172_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_172_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_172_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_173_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_173_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_173_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_173_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_173_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_173_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_174_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_174_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_174_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_174_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_174_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_174_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_175_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_175_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_175_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_175_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_175_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_175_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_176_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_176_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_176_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_176_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_176_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_176_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_177_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_177_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_177_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_177_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_177_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_177_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_178_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_178_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_178_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_178_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_178_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_178_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_179_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_179_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_179_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_179_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_179_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_179_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_180_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_180_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_180_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_180_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_180_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_180_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_181_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_181_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_181_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_181_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_181_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_181_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_182_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_182_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_182_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_182_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_182_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_182_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_183_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_183_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_183_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_183_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_183_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_183_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_184_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_184_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_184_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_184_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_184_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_184_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_185_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_185_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_185_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_185_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_185_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_185_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_186_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_186_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_186_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_186_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_186_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_186_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_187_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_187_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_187_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_187_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_187_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_187_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_188_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_188_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_188_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_188_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_188_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_188_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_189_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_189_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_189_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_189_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_189_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_189_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_190_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_190_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_190_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_190_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_190_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_190_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_191_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_191_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_191_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_191_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_191_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_191_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_192_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_192_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_192_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_192_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_192_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_192_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_193_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_193_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_193_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_193_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_193_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_193_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_194_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_194_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_194_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_194_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_194_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_194_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_195_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_195_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_195_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_195_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_195_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_195_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_196_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_196_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_196_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_196_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_196_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_196_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_197_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_197_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_197_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_197_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_197_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_197_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_198_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_198_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_198_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_198_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_198_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_198_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_199_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_199_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_199_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_199_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_199_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_199_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_200_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_200_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_200_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_200_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_200_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_200_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_201_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_201_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_201_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_201_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_201_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_201_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_202_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_202_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_202_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_202_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_202_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_202_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_203_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_203_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_203_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_203_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_203_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_203_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_204_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_204_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_204_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_204_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_204_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_204_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_205_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_205_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_205_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_205_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_205_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_205_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_206_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_206_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_206_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_206_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_206_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_206_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_207_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_207_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_207_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_207_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_207_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_207_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_208_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_208_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_208_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_208_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_208_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_208_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_209_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_209_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_209_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_209_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_209_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_209_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_210_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_210_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_210_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_210_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_210_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_210_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_211_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_211_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_211_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_211_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_211_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_211_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_215_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_215_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_215_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_215_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_215_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_215_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_216_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_216_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_216_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_216_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_216_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_216_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_3_217_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_217_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_3_217_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_217_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_3_217_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_217_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_100_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_100_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_100_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_100_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_100_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_100_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_101_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_101_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_101_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_101_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_101_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_101_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_102_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_102_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_102_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_102_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_102_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_102_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_103_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_103_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_103_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_103_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_103_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_103_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_104_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_104_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_104_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_104_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_104_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_104_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_105_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_105_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_105_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_105_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_105_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_105_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_106_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_106_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_106_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_106_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_106_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_106_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_107_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_107_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_107_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_107_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_107_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_107_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_108_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_108_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_108_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_108_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_108_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_108_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_109_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_109_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_109_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_109_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_109_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_109_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_10_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_10_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_10_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_10_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_10_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_10_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_110_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_110_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_110_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_110_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_110_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_110_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_111_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_111_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_111_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_111_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_111_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_111_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_112_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_112_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_112_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_112_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_112_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_112_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_113_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_113_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_113_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_113_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_113_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_113_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_114_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_114_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_114_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_114_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_114_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_114_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_115_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_115_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_115_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_115_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_115_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_115_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_116_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_116_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_116_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_116_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_116_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_116_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_117_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_117_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_117_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_117_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_117_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_117_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_118_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_118_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_118_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_118_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_118_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_118_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_119_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_119_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_119_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_119_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_119_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_119_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_11_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_11_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_11_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_11_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_11_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_11_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_120_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_120_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_120_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_120_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_120_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_120_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_121_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_121_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_121_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_121_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_121_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_121_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_122_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_122_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_122_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_122_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_122_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_122_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_123_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_123_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_123_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_123_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_123_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_123_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_124_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_124_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_124_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_124_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_124_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_124_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_125_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_125_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_125_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_125_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_125_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_125_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_126_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_126_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_126_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_126_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_126_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_126_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_127_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_127_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_127_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_127_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_127_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_127_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_128_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_128_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_128_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_128_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_128_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_128_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_129_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_129_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_129_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_129_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_129_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_129_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_12_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_12_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_12_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_12_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_12_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_12_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_130_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_130_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_130_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_130_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_130_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_130_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_131_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_131_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_131_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_131_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_131_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_131_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_132_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_132_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_132_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_132_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_132_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_132_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_133_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_133_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_133_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_133_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_133_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_133_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_134_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_134_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_134_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_134_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_134_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_134_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_135_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_135_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_135_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_135_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_135_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_135_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_136_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_136_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_136_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_136_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_136_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_136_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_137_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_137_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_137_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_137_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_137_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_137_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_138_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_138_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_138_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_138_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_138_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_138_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_139_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_139_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_139_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_139_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_139_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_139_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_13_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_13_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_13_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_13_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_13_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_13_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_140_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_140_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_140_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_140_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_140_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_140_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_141_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_141_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_141_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_141_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_141_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_141_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_142_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_142_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_142_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_142_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_142_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_142_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_143_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_143_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_143_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_143_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_143_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_143_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_144_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_144_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_144_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_144_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_144_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_144_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_145_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_145_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_145_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_145_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_145_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_145_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_146_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_146_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_146_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_146_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_146_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_146_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_147_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_147_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_147_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_147_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_147_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_147_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_148_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_148_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_148_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_148_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_148_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_148_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_149_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_149_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_149_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_149_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_149_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_149_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_14_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_14_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_14_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_14_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_14_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_14_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_150_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_150_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_150_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_150_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_150_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_150_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_151_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_151_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_151_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_151_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_151_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_151_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_152_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_152_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_152_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_152_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_152_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_152_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_153_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_153_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_153_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_153_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_153_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_153_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_154_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_154_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_154_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_154_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_154_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_154_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_155_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_155_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_155_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_155_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_155_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_155_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_156_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_156_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_156_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_156_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_156_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_156_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_157_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_157_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_157_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_157_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_157_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_157_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_158_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_158_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_158_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_158_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_158_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_158_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_15_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_15_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_15_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_15_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_15_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_15_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_16_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_16_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_16_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_16_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_16_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_16_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_17_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_17_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_17_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_17_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_17_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_17_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_18_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_18_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_18_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_18_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_18_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_18_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_19_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_19_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_19_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_19_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_19_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_19_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_1_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_1_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_1_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_1_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_1_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_1_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_20_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_20_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_20_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_20_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_20_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_20_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_212_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_212_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_212_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_212_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_212_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_212_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_213_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_213_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_213_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_213_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_213_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_213_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_214_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_214_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_214_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_214_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_214_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_214_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_21_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_21_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_21_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_21_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_21_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_21_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_22_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_22_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_22_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_22_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_22_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_22_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_23_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_23_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_23_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_23_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_23_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_23_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_24_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_24_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_24_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_24_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_24_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_24_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_25_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_25_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_25_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_25_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_25_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_25_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_26_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_26_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_26_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_26_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_26_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_26_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_27_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_27_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_27_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_27_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_27_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_27_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_28_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_28_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_28_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_28_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_28_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_28_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_29_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_29_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_29_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_29_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_29_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_29_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_2_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_2_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_2_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_2_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_2_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_2_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_30_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_30_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_30_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_30_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_30_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_30_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_31_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_31_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_31_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_31_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_31_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_31_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_32_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_32_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_32_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_32_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_32_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_32_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_33_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_33_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_33_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_33_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_33_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_33_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_34_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_34_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_34_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_34_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_34_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_34_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_35_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_35_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_35_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_35_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_35_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_35_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_36_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_36_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_36_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_36_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_36_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_36_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_37_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_37_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_37_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_37_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_37_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_37_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_38_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_38_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_38_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_38_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_38_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_38_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_39_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_39_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_39_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_39_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_39_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_39_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_3_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_3_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_3_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_3_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_3_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_3_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_40_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_40_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_40_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_40_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_40_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_40_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_41_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_41_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_41_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_41_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_41_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_41_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_42_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_42_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_42_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_42_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_42_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_42_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_43_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_43_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_43_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_43_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_43_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_43_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_44_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_44_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_44_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_44_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_44_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_44_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_45_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_45_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_45_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_45_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_45_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_45_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_46_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_46_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_46_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_46_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_46_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_46_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_47_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_47_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_47_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_47_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_47_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_47_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_48_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_48_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_48_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_48_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_48_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_48_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_49_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_49_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_49_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_49_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_49_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_49_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_4_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_4_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_4_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_4_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_4_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_4_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_50_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_50_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_50_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_50_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_50_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_50_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_51_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_51_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_51_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_51_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_51_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_51_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_52_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_52_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_52_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_52_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_52_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_52_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_53_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_53_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_53_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_53_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_53_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_53_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_54_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_54_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_54_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_54_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_54_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_54_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_55_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_55_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_55_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_55_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_55_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_55_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_56_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_56_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_56_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_56_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_56_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_56_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_57_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_57_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_57_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_57_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_57_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_57_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_58_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_58_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_58_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_58_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_58_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_58_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_59_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_59_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_59_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_59_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_59_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_59_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_5_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_5_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_5_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_5_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_5_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_5_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_60_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_60_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_60_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_60_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_60_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_60_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_61_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_61_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_61_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_61_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_61_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_61_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_62_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_62_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_62_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_62_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_62_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_62_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_63_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_63_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_63_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_63_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_63_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_63_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_64_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_64_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_64_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_64_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_64_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_64_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_65_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_65_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_65_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_65_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_65_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_65_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_66_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_66_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_66_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_66_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_66_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_66_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_67_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_67_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_67_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_67_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_67_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_67_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_68_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_68_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_68_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_68_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_68_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_68_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_69_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_69_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_69_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_69_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_69_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_69_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_6_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_6_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_6_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_6_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_6_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_6_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_70_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_70_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_70_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_70_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_70_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_70_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_71_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_71_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_71_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_71_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_71_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_71_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_72_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_72_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_72_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_72_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_72_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_72_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_73_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_73_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_73_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_73_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_73_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_73_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_74_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_74_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_74_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_74_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_74_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_74_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_75_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_75_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_75_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_75_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_75_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_75_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_76_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_76_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_76_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_76_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_76_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_76_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_77_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_77_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_77_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_77_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_77_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_77_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_78_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_78_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_78_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_78_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_78_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_78_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_79_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_79_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_79_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_79_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_79_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_79_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_7_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_7_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_7_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_7_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_7_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_7_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_80_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_80_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_80_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_80_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_80_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_80_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_81_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_81_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_81_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_81_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_81_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_81_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_82_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_82_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_82_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_82_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_82_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_82_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_83_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_83_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_83_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_83_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_83_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_83_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_84_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_84_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_84_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_84_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_84_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_84_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_85_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_85_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_85_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_85_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_85_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_85_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_86_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_86_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_86_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_86_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_86_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_86_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_87_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_87_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_87_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_87_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_87_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_87_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_88_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_88_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_88_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_88_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_88_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_88_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_89_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_89_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_89_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_89_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_89_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_89_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_8_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_8_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_8_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_8_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_8_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_8_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_90_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_90_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_90_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_90_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_90_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_90_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_91_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_91_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_91_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_91_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_91_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_91_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_92_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_92_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_92_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_92_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_92_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_92_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_93_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_93_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_93_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_93_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_93_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_93_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_94_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_94_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_94_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_94_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_94_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_94_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_95_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_95_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_95_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_95_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_95_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_95_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_96_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_96_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_96_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_96_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_96_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_96_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_97_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_97_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_97_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_97_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_97_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_97_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_98_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_98_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_98_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_98_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_98_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_98_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_99_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_99_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_99_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_99_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_99_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_99_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: _hyper_4_9_chunk exchange_code; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_9_chunk ALTER COLUMN exchange_code SET DEFAULT 'NSE'::text;


--
-- Name: _hyper_4_9_chunk volume; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_9_chunk ALTER COLUMN volume SET DEFAULT 0;


--
-- Name: _hyper_4_9_chunk created_at; Type: DEFAULT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_9_chunk ALTER COLUMN created_at SET DEFAULT now();


--
-- Name: job_run job_run_id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.job_run ALTER COLUMN job_run_id SET DEFAULT nextval('audit.job_run_job_run_id_seq'::regclass);


--
-- Name: index_mapping mapping_id; Type: DEFAULT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.index_mapping ALTER COLUMN mapping_id SET DEFAULT nextval('ref.index_mapping_mapping_id_seq'::regclass);


--
-- Name: symbol symbol_id; Type: DEFAULT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.symbol ALTER COLUMN symbol_id SET DEFAULT nextval('ref.symbol_symbol_id_seq'::regclass);


--
-- Name: app_logs id; Type: DEFAULT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.app_logs ALTER COLUMN id SET DEFAULT nextval('sys.app_logs_id_seq'::regclass);


--
-- Name: job_history id; Type: DEFAULT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.job_history ALTER COLUMN id SET DEFAULT nextval('sys.job_history_id_seq'::regclass);


--
-- Name: job_triggers id; Type: DEFAULT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.job_triggers ALTER COLUMN id SET DEFAULT nextval('sys.job_triggers_id_seq'::regclass);


--
-- Name: scanners id; Type: DEFAULT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.scanners ALTER COLUMN id SET DEFAULT nextval('sys.scanners_id_seq'::regclass);


--
-- Name: scheduled_jobs id; Type: DEFAULT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.scheduled_jobs ALTER COLUMN id SET DEFAULT nextval('sys.scheduled_jobs_id_seq'::regclass);


--
-- Name: daily_pnl id; Type: DEFAULT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.daily_pnl ALTER COLUMN id SET DEFAULT nextval('trading.daily_pnl_id_seq'::regclass);


--
-- Name: portfolio id; Type: DEFAULT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.portfolio ALTER COLUMN id SET DEFAULT nextval('trading.portfolio_id_seq'::regclass);


--
-- Name: positions id; Type: DEFAULT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.positions ALTER COLUMN id SET DEFAULT nextval('trading.positions_id_seq'::regclass);


--
-- Name: scanner_results id; Type: DEFAULT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.scanner_results ALTER COLUMN id SET DEFAULT nextval('trading.scanner_results_id_seq'::regclass);


--
-- Name: trades trade_id; Type: DEFAULT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.trades ALTER COLUMN trade_id SET DEFAULT nextval('trading.trades_trade_id_seq'::regclass);


--
-- Name: _hyper_4_100_chunk 100_200_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_100_chunk
    ADD CONSTRAINT "100_200_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_101_chunk 101_202_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_101_chunk
    ADD CONSTRAINT "101_202_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_102_chunk 102_204_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_102_chunk
    ADD CONSTRAINT "102_204_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_103_chunk 103_206_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_103_chunk
    ADD CONSTRAINT "103_206_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_104_chunk 104_208_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_104_chunk
    ADD CONSTRAINT "104_208_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_105_chunk 105_210_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_105_chunk
    ADD CONSTRAINT "105_210_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_106_chunk 106_212_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_106_chunk
    ADD CONSTRAINT "106_212_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_107_chunk 107_214_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_107_chunk
    ADD CONSTRAINT "107_214_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_108_chunk 108_216_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_108_chunk
    ADD CONSTRAINT "108_216_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_109_chunk 109_218_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_109_chunk
    ADD CONSTRAINT "109_218_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_10_chunk 10_20_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_10_chunk
    ADD CONSTRAINT "10_20_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_110_chunk 110_220_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_110_chunk
    ADD CONSTRAINT "110_220_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_111_chunk 111_222_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_111_chunk
    ADD CONSTRAINT "111_222_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_112_chunk 112_224_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_112_chunk
    ADD CONSTRAINT "112_224_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_113_chunk 113_226_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_113_chunk
    ADD CONSTRAINT "113_226_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_114_chunk 114_228_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_114_chunk
    ADD CONSTRAINT "114_228_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_115_chunk 115_230_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_115_chunk
    ADD CONSTRAINT "115_230_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_116_chunk 116_232_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_116_chunk
    ADD CONSTRAINT "116_232_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_117_chunk 117_234_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_117_chunk
    ADD CONSTRAINT "117_234_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_118_chunk 118_236_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_118_chunk
    ADD CONSTRAINT "118_236_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_119_chunk 119_238_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_119_chunk
    ADD CONSTRAINT "119_238_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_11_chunk 11_22_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_11_chunk
    ADD CONSTRAINT "11_22_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_120_chunk 120_240_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_120_chunk
    ADD CONSTRAINT "120_240_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_121_chunk 121_242_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_121_chunk
    ADD CONSTRAINT "121_242_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_122_chunk 122_244_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_122_chunk
    ADD CONSTRAINT "122_244_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_123_chunk 123_246_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_123_chunk
    ADD CONSTRAINT "123_246_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_124_chunk 124_248_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_124_chunk
    ADD CONSTRAINT "124_248_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_125_chunk 125_250_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_125_chunk
    ADD CONSTRAINT "125_250_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_126_chunk 126_252_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_126_chunk
    ADD CONSTRAINT "126_252_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_127_chunk 127_254_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_127_chunk
    ADD CONSTRAINT "127_254_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_128_chunk 128_256_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_128_chunk
    ADD CONSTRAINT "128_256_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_129_chunk 129_258_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_129_chunk
    ADD CONSTRAINT "129_258_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_12_chunk 12_24_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_12_chunk
    ADD CONSTRAINT "12_24_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_130_chunk 130_260_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_130_chunk
    ADD CONSTRAINT "130_260_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_131_chunk 131_262_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_131_chunk
    ADD CONSTRAINT "131_262_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_132_chunk 132_264_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_132_chunk
    ADD CONSTRAINT "132_264_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_133_chunk 133_266_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_133_chunk
    ADD CONSTRAINT "133_266_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_134_chunk 134_268_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_134_chunk
    ADD CONSTRAINT "134_268_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_135_chunk 135_270_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_135_chunk
    ADD CONSTRAINT "135_270_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_136_chunk 136_272_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_136_chunk
    ADD CONSTRAINT "136_272_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_137_chunk 137_274_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_137_chunk
    ADD CONSTRAINT "137_274_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_138_chunk 138_276_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_138_chunk
    ADD CONSTRAINT "138_276_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_139_chunk 139_278_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_139_chunk
    ADD CONSTRAINT "139_278_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_13_chunk 13_26_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_13_chunk
    ADD CONSTRAINT "13_26_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_140_chunk 140_280_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_140_chunk
    ADD CONSTRAINT "140_280_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_141_chunk 141_282_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_141_chunk
    ADD CONSTRAINT "141_282_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_142_chunk 142_284_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_142_chunk
    ADD CONSTRAINT "142_284_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_143_chunk 143_286_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_143_chunk
    ADD CONSTRAINT "143_286_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_144_chunk 144_288_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_144_chunk
    ADD CONSTRAINT "144_288_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_145_chunk 145_290_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_145_chunk
    ADD CONSTRAINT "145_290_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_146_chunk 146_292_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_146_chunk
    ADD CONSTRAINT "146_292_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_147_chunk 147_294_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_147_chunk
    ADD CONSTRAINT "147_294_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_148_chunk 148_296_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_148_chunk
    ADD CONSTRAINT "148_296_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_149_chunk 149_298_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_149_chunk
    ADD CONSTRAINT "149_298_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_14_chunk 14_28_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_14_chunk
    ADD CONSTRAINT "14_28_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_150_chunk 150_300_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_150_chunk
    ADD CONSTRAINT "150_300_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_151_chunk 151_302_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_151_chunk
    ADD CONSTRAINT "151_302_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_152_chunk 152_304_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_152_chunk
    ADD CONSTRAINT "152_304_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_153_chunk 153_306_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_153_chunk
    ADD CONSTRAINT "153_306_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_154_chunk 154_308_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_154_chunk
    ADD CONSTRAINT "154_308_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_155_chunk 155_310_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_155_chunk
    ADD CONSTRAINT "155_310_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_156_chunk 156_312_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_156_chunk
    ADD CONSTRAINT "156_312_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_157_chunk 157_314_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_157_chunk
    ADD CONSTRAINT "157_314_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_158_chunk 158_316_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_158_chunk
    ADD CONSTRAINT "158_316_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_159_chunk 159_318_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_159_chunk
    ADD CONSTRAINT "159_318_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_15_chunk 15_30_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_15_chunk
    ADD CONSTRAINT "15_30_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_160_chunk 160_320_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_160_chunk
    ADD CONSTRAINT "160_320_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_161_chunk 161_322_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_161_chunk
    ADD CONSTRAINT "161_322_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_162_chunk 162_324_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_162_chunk
    ADD CONSTRAINT "162_324_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_163_chunk 163_326_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_163_chunk
    ADD CONSTRAINT "163_326_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_164_chunk 164_328_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_164_chunk
    ADD CONSTRAINT "164_328_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_165_chunk 165_330_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_165_chunk
    ADD CONSTRAINT "165_330_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_166_chunk 166_332_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_166_chunk
    ADD CONSTRAINT "166_332_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_167_chunk 167_334_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_167_chunk
    ADD CONSTRAINT "167_334_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_168_chunk 168_336_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_168_chunk
    ADD CONSTRAINT "168_336_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_169_chunk 169_338_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_169_chunk
    ADD CONSTRAINT "169_338_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_16_chunk 16_32_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_16_chunk
    ADD CONSTRAINT "16_32_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_170_chunk 170_340_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_170_chunk
    ADD CONSTRAINT "170_340_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_171_chunk 171_342_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_171_chunk
    ADD CONSTRAINT "171_342_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_172_chunk 172_344_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_172_chunk
    ADD CONSTRAINT "172_344_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_173_chunk 173_346_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_173_chunk
    ADD CONSTRAINT "173_346_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_174_chunk 174_348_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_174_chunk
    ADD CONSTRAINT "174_348_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_175_chunk 175_350_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_175_chunk
    ADD CONSTRAINT "175_350_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_176_chunk 176_352_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_176_chunk
    ADD CONSTRAINT "176_352_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_177_chunk 177_354_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_177_chunk
    ADD CONSTRAINT "177_354_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_178_chunk 178_356_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_178_chunk
    ADD CONSTRAINT "178_356_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_179_chunk 179_358_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_179_chunk
    ADD CONSTRAINT "179_358_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_17_chunk 17_34_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_17_chunk
    ADD CONSTRAINT "17_34_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_180_chunk 180_360_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_180_chunk
    ADD CONSTRAINT "180_360_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_181_chunk 181_362_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_181_chunk
    ADD CONSTRAINT "181_362_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_182_chunk 182_364_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_182_chunk
    ADD CONSTRAINT "182_364_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_183_chunk 183_366_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_183_chunk
    ADD CONSTRAINT "183_366_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_184_chunk 184_368_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_184_chunk
    ADD CONSTRAINT "184_368_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_185_chunk 185_370_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_185_chunk
    ADD CONSTRAINT "185_370_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_186_chunk 186_372_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_186_chunk
    ADD CONSTRAINT "186_372_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_187_chunk 187_374_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_187_chunk
    ADD CONSTRAINT "187_374_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_188_chunk 188_376_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_188_chunk
    ADD CONSTRAINT "188_376_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_189_chunk 189_378_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_189_chunk
    ADD CONSTRAINT "189_378_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_18_chunk 18_36_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_18_chunk
    ADD CONSTRAINT "18_36_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_190_chunk 190_380_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_190_chunk
    ADD CONSTRAINT "190_380_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_191_chunk 191_382_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_191_chunk
    ADD CONSTRAINT "191_382_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_192_chunk 192_384_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_192_chunk
    ADD CONSTRAINT "192_384_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_193_chunk 193_386_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_193_chunk
    ADD CONSTRAINT "193_386_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_194_chunk 194_388_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_194_chunk
    ADD CONSTRAINT "194_388_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_195_chunk 195_390_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_195_chunk
    ADD CONSTRAINT "195_390_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_196_chunk 196_392_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_196_chunk
    ADD CONSTRAINT "196_392_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_197_chunk 197_394_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_197_chunk
    ADD CONSTRAINT "197_394_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_198_chunk 198_396_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_198_chunk
    ADD CONSTRAINT "198_396_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_199_chunk 199_398_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_199_chunk
    ADD CONSTRAINT "199_398_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_19_chunk 19_38_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_19_chunk
    ADD CONSTRAINT "19_38_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_1_chunk 1_2_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_1_chunk
    ADD CONSTRAINT "1_2_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_200_chunk 200_400_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_200_chunk
    ADD CONSTRAINT "200_400_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_201_chunk 201_402_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_201_chunk
    ADD CONSTRAINT "201_402_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_202_chunk 202_404_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_202_chunk
    ADD CONSTRAINT "202_404_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_203_chunk 203_406_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_203_chunk
    ADD CONSTRAINT "203_406_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_204_chunk 204_408_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_204_chunk
    ADD CONSTRAINT "204_408_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_205_chunk 205_410_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_205_chunk
    ADD CONSTRAINT "205_410_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_206_chunk 206_412_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_206_chunk
    ADD CONSTRAINT "206_412_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_207_chunk 207_414_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_207_chunk
    ADD CONSTRAINT "207_414_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_208_chunk 208_416_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_208_chunk
    ADD CONSTRAINT "208_416_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_209_chunk 209_418_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_209_chunk
    ADD CONSTRAINT "209_418_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_20_chunk 20_40_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_20_chunk
    ADD CONSTRAINT "20_40_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_210_chunk 210_420_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_210_chunk
    ADD CONSTRAINT "210_420_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_211_chunk 211_422_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_211_chunk
    ADD CONSTRAINT "211_422_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_212_chunk 212_424_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_212_chunk
    ADD CONSTRAINT "212_424_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_213_chunk 213_426_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_213_chunk
    ADD CONSTRAINT "213_426_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_214_chunk 214_428_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_214_chunk
    ADD CONSTRAINT "214_428_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_215_chunk 215_430_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_215_chunk
    ADD CONSTRAINT "215_430_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_216_chunk 216_432_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_216_chunk
    ADD CONSTRAINT "216_432_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_3_217_chunk 217_434_pk_candles_60m; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_217_chunk
    ADD CONSTRAINT "217_434_pk_candles_60m" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_21_chunk 21_42_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_21_chunk
    ADD CONSTRAINT "21_42_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_22_chunk 22_44_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_22_chunk
    ADD CONSTRAINT "22_44_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_23_chunk 23_46_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_23_chunk
    ADD CONSTRAINT "23_46_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_24_chunk 24_48_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_24_chunk
    ADD CONSTRAINT "24_48_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_25_chunk 25_50_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_25_chunk
    ADD CONSTRAINT "25_50_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_26_chunk 26_52_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_26_chunk
    ADD CONSTRAINT "26_52_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_27_chunk 27_54_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_27_chunk
    ADD CONSTRAINT "27_54_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_28_chunk 28_56_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_28_chunk
    ADD CONSTRAINT "28_56_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_29_chunk 29_58_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_29_chunk
    ADD CONSTRAINT "29_58_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_2_chunk 2_4_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_2_chunk
    ADD CONSTRAINT "2_4_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_30_chunk 30_60_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_30_chunk
    ADD CONSTRAINT "30_60_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_31_chunk 31_62_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_31_chunk
    ADD CONSTRAINT "31_62_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_32_chunk 32_64_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_32_chunk
    ADD CONSTRAINT "32_64_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_33_chunk 33_66_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_33_chunk
    ADD CONSTRAINT "33_66_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_34_chunk 34_68_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_34_chunk
    ADD CONSTRAINT "34_68_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_35_chunk 35_70_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_35_chunk
    ADD CONSTRAINT "35_70_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_36_chunk 36_72_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_36_chunk
    ADD CONSTRAINT "36_72_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_37_chunk 37_74_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_37_chunk
    ADD CONSTRAINT "37_74_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_38_chunk 38_76_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_38_chunk
    ADD CONSTRAINT "38_76_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_39_chunk 39_78_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_39_chunk
    ADD CONSTRAINT "39_78_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_3_chunk 3_6_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_3_chunk
    ADD CONSTRAINT "3_6_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_40_chunk 40_80_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_40_chunk
    ADD CONSTRAINT "40_80_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_41_chunk 41_82_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_41_chunk
    ADD CONSTRAINT "41_82_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_42_chunk 42_84_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_42_chunk
    ADD CONSTRAINT "42_84_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_43_chunk 43_86_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_43_chunk
    ADD CONSTRAINT "43_86_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_44_chunk 44_88_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_44_chunk
    ADD CONSTRAINT "44_88_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_45_chunk 45_90_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_45_chunk
    ADD CONSTRAINT "45_90_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_46_chunk 46_92_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_46_chunk
    ADD CONSTRAINT "46_92_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_47_chunk 47_94_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_47_chunk
    ADD CONSTRAINT "47_94_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_48_chunk 48_96_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_48_chunk
    ADD CONSTRAINT "48_96_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_49_chunk 49_98_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_49_chunk
    ADD CONSTRAINT "49_98_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_4_chunk 4_8_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_4_chunk
    ADD CONSTRAINT "4_8_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_50_chunk 50_100_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_50_chunk
    ADD CONSTRAINT "50_100_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_51_chunk 51_102_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_51_chunk
    ADD CONSTRAINT "51_102_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_52_chunk 52_104_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_52_chunk
    ADD CONSTRAINT "52_104_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_53_chunk 53_106_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_53_chunk
    ADD CONSTRAINT "53_106_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_54_chunk 54_108_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_54_chunk
    ADD CONSTRAINT "54_108_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_55_chunk 55_110_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_55_chunk
    ADD CONSTRAINT "55_110_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_56_chunk 56_112_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_56_chunk
    ADD CONSTRAINT "56_112_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_57_chunk 57_114_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_57_chunk
    ADD CONSTRAINT "57_114_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_58_chunk 58_116_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_58_chunk
    ADD CONSTRAINT "58_116_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_59_chunk 59_118_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_59_chunk
    ADD CONSTRAINT "59_118_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_5_chunk 5_10_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_5_chunk
    ADD CONSTRAINT "5_10_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_60_chunk 60_120_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_60_chunk
    ADD CONSTRAINT "60_120_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_61_chunk 61_122_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_61_chunk
    ADD CONSTRAINT "61_122_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_62_chunk 62_124_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_62_chunk
    ADD CONSTRAINT "62_124_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_63_chunk 63_126_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_63_chunk
    ADD CONSTRAINT "63_126_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_64_chunk 64_128_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_64_chunk
    ADD CONSTRAINT "64_128_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_65_chunk 65_130_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_65_chunk
    ADD CONSTRAINT "65_130_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_66_chunk 66_132_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_66_chunk
    ADD CONSTRAINT "66_132_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_67_chunk 67_134_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_67_chunk
    ADD CONSTRAINT "67_134_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_68_chunk 68_136_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_68_chunk
    ADD CONSTRAINT "68_136_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_69_chunk 69_138_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_69_chunk
    ADD CONSTRAINT "69_138_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_6_chunk 6_12_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_6_chunk
    ADD CONSTRAINT "6_12_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_70_chunk 70_140_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_70_chunk
    ADD CONSTRAINT "70_140_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_71_chunk 71_142_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_71_chunk
    ADD CONSTRAINT "71_142_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_72_chunk 72_144_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_72_chunk
    ADD CONSTRAINT "72_144_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_73_chunk 73_146_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_73_chunk
    ADD CONSTRAINT "73_146_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_74_chunk 74_148_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_74_chunk
    ADD CONSTRAINT "74_148_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_75_chunk 75_150_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_75_chunk
    ADD CONSTRAINT "75_150_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_76_chunk 76_152_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_76_chunk
    ADD CONSTRAINT "76_152_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_77_chunk 77_154_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_77_chunk
    ADD CONSTRAINT "77_154_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_78_chunk 78_156_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_78_chunk
    ADD CONSTRAINT "78_156_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_79_chunk 79_158_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_79_chunk
    ADD CONSTRAINT "79_158_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_7_chunk 7_14_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_7_chunk
    ADD CONSTRAINT "7_14_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_80_chunk 80_160_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_80_chunk
    ADD CONSTRAINT "80_160_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_81_chunk 81_162_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_81_chunk
    ADD CONSTRAINT "81_162_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_82_chunk 82_164_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_82_chunk
    ADD CONSTRAINT "82_164_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_83_chunk 83_166_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_83_chunk
    ADD CONSTRAINT "83_166_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_84_chunk 84_168_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_84_chunk
    ADD CONSTRAINT "84_168_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_85_chunk 85_170_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_85_chunk
    ADD CONSTRAINT "85_170_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_86_chunk 86_172_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_86_chunk
    ADD CONSTRAINT "86_172_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_87_chunk 87_174_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_87_chunk
    ADD CONSTRAINT "87_174_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_88_chunk 88_176_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_88_chunk
    ADD CONSTRAINT "88_176_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_89_chunk 89_178_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_89_chunk
    ADD CONSTRAINT "89_178_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_8_chunk 8_16_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_8_chunk
    ADD CONSTRAINT "8_16_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_90_chunk 90_180_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_90_chunk
    ADD CONSTRAINT "90_180_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_91_chunk 91_182_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_91_chunk
    ADD CONSTRAINT "91_182_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_92_chunk 92_184_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_92_chunk
    ADD CONSTRAINT "92_184_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_93_chunk 93_186_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_93_chunk
    ADD CONSTRAINT "93_186_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_94_chunk 94_188_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_94_chunk
    ADD CONSTRAINT "94_188_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_95_chunk 95_190_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_95_chunk
    ADD CONSTRAINT "95_190_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_96_chunk 96_192_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_96_chunk
    ADD CONSTRAINT "96_192_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_97_chunk 97_194_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_97_chunk
    ADD CONSTRAINT "97_194_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_98_chunk 98_196_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_98_chunk
    ADD CONSTRAINT "98_196_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_99_chunk 99_198_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_99_chunk
    ADD CONSTRAINT "99_198_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: _hyper_4_9_chunk 9_18_pk_candles_1d; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_9_chunk
    ADD CONSTRAINT "9_18_pk_candles_1d" PRIMARY KEY (symbol, candle_start);


--
-- Name: job_run job_run_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.job_run
    ADD CONSTRAINT job_run_pkey PRIMARY KEY (job_run_id);


--
-- Name: candles_1d pk_candles_1d; Type: CONSTRAINT; Schema: ohlc; Owner: -
--

ALTER TABLE ONLY ohlc.candles_1d
    ADD CONSTRAINT pk_candles_1d PRIMARY KEY (symbol, candle_start);


--
-- Name: candles_60m pk_candles_60m; Type: CONSTRAINT; Schema: ohlc; Owner: -
--

ALTER TABLE ONLY ohlc.candles_60m
    ADD CONSTRAINT pk_candles_60m PRIMARY KEY (symbol, candle_start);


--
-- Name: exchange exchange_pkey; Type: CONSTRAINT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.exchange
    ADD CONSTRAINT exchange_pkey PRIMARY KEY (exchange_code);


--
-- Name: index_mapping index_mapping_pkey; Type: CONSTRAINT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.index_mapping
    ADD CONSTRAINT index_mapping_pkey PRIMARY KEY (mapping_id);


--
-- Name: index_source index_source_pkey; Type: CONSTRAINT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.index_source
    ADD CONSTRAINT index_source_pkey PRIMARY KEY (index_name);


--
-- Name: symbol symbol_pkey; Type: CONSTRAINT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.symbol
    ADD CONSTRAINT symbol_pkey PRIMARY KEY (symbol_id);


--
-- Name: index_mapping ux_index_stock; Type: CONSTRAINT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.index_mapping
    ADD CONSTRAINT ux_index_stock UNIQUE (index_name, stock_symbol);


--
-- Name: app_logs app_logs_pkey; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.app_logs
    ADD CONSTRAINT app_logs_pkey PRIMARY KEY (id);


--
-- Name: job_history job_history_pkey; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.job_history
    ADD CONSTRAINT job_history_pkey PRIMARY KEY (id);


--
-- Name: job_triggers job_triggers_pkey; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.job_triggers
    ADD CONSTRAINT job_triggers_pkey PRIMARY KEY (id);


--
-- Name: scanners scanners_name_key; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.scanners
    ADD CONSTRAINT scanners_name_key UNIQUE (name);


--
-- Name: scanners scanners_pkey; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.scanners
    ADD CONSTRAINT scanners_pkey PRIMARY KEY (id);


--
-- Name: scheduled_jobs scheduled_jobs_name_key; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.scheduled_jobs
    ADD CONSTRAINT scheduled_jobs_name_key UNIQUE (name);


--
-- Name: scheduled_jobs scheduled_jobs_pkey; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.scheduled_jobs
    ADD CONSTRAINT scheduled_jobs_pkey PRIMARY KEY (id);


--
-- Name: service_status service_status_pkey; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.service_status
    ADD CONSTRAINT service_status_pkey PRIMARY KEY (service_name);


--
-- Name: daily_pnl daily_pnl_date_key; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.daily_pnl
    ADD CONSTRAINT daily_pnl_date_key UNIQUE (date);


--
-- Name: daily_pnl daily_pnl_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.daily_pnl
    ADD CONSTRAINT daily_pnl_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: portfolio portfolio_date_symbol_key; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.portfolio
    ADD CONSTRAINT portfolio_date_symbol_key UNIQUE (date, symbol);


--
-- Name: portfolio portfolio_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.portfolio
    ADD CONSTRAINT portfolio_pkey PRIMARY KEY (id);


--
-- Name: positions positions_date_symbol_product_key; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.positions
    ADD CONSTRAINT positions_date_symbol_product_key UNIQUE (date, symbol, product);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: scanner_results scanner_results_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.scanner_results
    ADD CONSTRAINT scanner_results_pkey PRIMARY KEY (id);


--
-- Name: trades trades_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.trades
    ADD CONSTRAINT trades_pkey PRIMARY KEY (trade_id);


--
-- Name: trades trades_zerodha_order_id_key; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.trades
    ADD CONSTRAINT trades_zerodha_order_id_key UNIQUE (broker_order_id);


--
-- Name: _hyper_3_159_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_159_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_159_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_160_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_160_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_160_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_161_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_161_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_161_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_162_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_162_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_162_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_163_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_163_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_163_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_164_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_164_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_164_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_165_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_165_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_165_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_166_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_166_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_166_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_167_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_167_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_167_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_168_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_168_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_168_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_169_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_169_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_169_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_170_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_170_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_170_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_171_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_171_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_171_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_172_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_172_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_172_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_173_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_173_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_173_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_174_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_174_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_174_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_175_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_175_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_175_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_176_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_176_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_176_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_177_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_177_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_177_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_178_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_178_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_178_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_179_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_179_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_179_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_180_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_180_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_180_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_181_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_181_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_181_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_182_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_182_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_182_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_183_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_183_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_183_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_184_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_184_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_184_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_185_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_185_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_185_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_186_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_186_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_186_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_187_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_187_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_187_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_188_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_188_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_188_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_189_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_189_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_189_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_190_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_190_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_190_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_191_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_191_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_191_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_192_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_192_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_192_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_193_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_193_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_193_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_194_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_194_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_194_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_195_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_195_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_195_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_196_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_196_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_196_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_197_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_197_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_197_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_198_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_198_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_198_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_199_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_199_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_199_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_200_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_200_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_200_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_201_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_201_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_201_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_202_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_202_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_202_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_203_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_203_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_203_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_204_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_204_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_204_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_205_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_205_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_205_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_206_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_206_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_206_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_207_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_207_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_207_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_208_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_208_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_208_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_209_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_209_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_209_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_210_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_210_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_210_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_211_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_211_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_211_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_215_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_215_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_215_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_216_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_216_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_216_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_3_217_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_3_217_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_3_217_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_100_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_100_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_100_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_101_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_101_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_101_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_102_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_102_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_102_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_103_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_103_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_103_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_104_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_104_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_104_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_105_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_105_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_105_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_106_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_106_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_106_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_107_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_107_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_107_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_108_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_108_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_108_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_109_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_109_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_109_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_10_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_10_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_10_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_110_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_110_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_110_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_111_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_111_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_111_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_112_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_112_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_112_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_113_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_113_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_113_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_114_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_114_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_114_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_115_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_115_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_115_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_116_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_116_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_116_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_117_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_117_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_117_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_118_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_118_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_118_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_119_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_119_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_119_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_11_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_11_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_11_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_120_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_120_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_120_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_121_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_121_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_121_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_122_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_122_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_122_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_123_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_123_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_123_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_124_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_124_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_124_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_125_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_125_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_125_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_126_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_126_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_126_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_127_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_127_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_127_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_128_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_128_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_128_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_129_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_129_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_129_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_12_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_12_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_12_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_130_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_130_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_130_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_131_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_131_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_131_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_132_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_132_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_132_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_133_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_133_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_133_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_134_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_134_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_134_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_135_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_135_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_135_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_136_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_136_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_136_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_137_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_137_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_137_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_138_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_138_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_138_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_139_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_139_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_139_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_13_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_13_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_13_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_140_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_140_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_140_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_141_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_141_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_141_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_142_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_142_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_142_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_143_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_143_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_143_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_144_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_144_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_144_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_145_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_145_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_145_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_146_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_146_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_146_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_147_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_147_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_147_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_148_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_148_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_148_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_149_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_149_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_149_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_14_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_14_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_14_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_150_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_150_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_150_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_151_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_151_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_151_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_152_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_152_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_152_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_153_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_153_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_153_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_154_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_154_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_154_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_155_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_155_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_155_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_156_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_156_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_156_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_157_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_157_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_157_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_158_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_158_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_158_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_15_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_15_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_15_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_16_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_16_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_16_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_17_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_17_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_17_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_18_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_18_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_18_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_19_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_19_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_19_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_1_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_1_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_1_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_20_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_20_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_20_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_212_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_212_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_212_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_213_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_213_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_213_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_214_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_214_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_214_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_21_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_21_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_21_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_22_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_22_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_22_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_23_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_23_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_23_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_24_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_24_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_24_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_25_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_25_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_25_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_26_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_26_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_26_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_27_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_27_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_27_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_28_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_28_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_28_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_29_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_29_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_29_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_2_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_2_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_2_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_30_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_30_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_30_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_31_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_31_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_31_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_32_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_32_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_32_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_33_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_33_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_33_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_34_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_34_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_34_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_35_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_35_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_35_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_36_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_36_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_36_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_37_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_37_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_37_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_38_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_38_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_38_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_39_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_39_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_39_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_3_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_3_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_3_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_40_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_40_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_40_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_41_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_41_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_41_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_42_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_42_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_42_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_43_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_43_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_43_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_44_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_44_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_44_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_45_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_45_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_45_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_46_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_46_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_46_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_47_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_47_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_47_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_48_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_48_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_48_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_49_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_49_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_49_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_4_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_4_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_4_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_50_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_50_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_50_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_51_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_51_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_51_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_52_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_52_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_52_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_53_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_53_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_53_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_54_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_54_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_54_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_55_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_55_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_55_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_56_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_56_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_56_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_57_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_57_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_57_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_58_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_58_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_58_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_59_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_59_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_59_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_5_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_5_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_5_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_60_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_60_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_60_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_61_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_61_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_61_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_62_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_62_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_62_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_63_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_63_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_63_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_64_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_64_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_64_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_65_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_65_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_65_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_66_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_66_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_66_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_67_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_67_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_67_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_68_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_68_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_68_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_69_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_69_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_69_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_6_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_6_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_6_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_70_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_70_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_70_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_71_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_71_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_71_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_72_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_72_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_72_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_73_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_73_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_73_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_74_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_74_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_74_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_75_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_75_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_75_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_76_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_76_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_76_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_77_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_77_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_77_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_78_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_78_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_78_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_79_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_79_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_79_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_7_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_7_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_7_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_80_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_80_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_80_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_81_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_81_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_81_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_82_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_82_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_82_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_83_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_83_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_83_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_84_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_84_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_84_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_85_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_85_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_85_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_86_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_86_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_86_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_87_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_87_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_87_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_88_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_88_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_88_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_89_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_89_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_89_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_8_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_8_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_8_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_90_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_90_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_90_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_91_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_91_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_91_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_92_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_92_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_92_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_93_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_93_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_93_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_94_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_94_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_94_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_95_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_95_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_95_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_96_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_96_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_96_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_97_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_97_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_97_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_98_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_98_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_98_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_99_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_99_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_99_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_4_9_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_4_9_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_4_9_chunk USING btree (candle_start DESC);


--
-- Name: candles_1d_candle_start_idx; Type: INDEX; Schema: ohlc; Owner: -
--

CREATE INDEX candles_1d_candle_start_idx ON ohlc.candles_1d USING btree (candle_start DESC);


--
-- Name: candles_60m_candle_start_idx; Type: INDEX; Schema: ohlc; Owner: -
--

CREATE INDEX candles_60m_candle_start_idx ON ohlc.candles_60m USING btree (candle_start DESC);


--
-- Name: ux_symbol_exchange; Type: INDEX; Schema: ref; Owner: -
--

CREATE UNIQUE INDEX ux_symbol_exchange ON ref.symbol USING btree (exchange_code, symbol);


--
-- Name: idx_app_logs_history_id; Type: INDEX; Schema: sys; Owner: -
--

CREATE INDEX idx_app_logs_history_id ON sys.app_logs USING btree (history_id);


--
-- Name: idx_app_logs_timestamp; Type: INDEX; Schema: sys; Owner: -
--

CREATE INDEX idx_app_logs_timestamp ON sys.app_logs USING btree ("timestamp" DESC);


--
-- Name: idx_job_history_job_name; Type: INDEX; Schema: sys; Owner: -
--

CREATE INDEX idx_job_history_job_name ON sys.job_history USING btree (job_name);


--
-- Name: idx_job_history_job_start; Type: INDEX; Schema: sys; Owner: -
--

CREATE INDEX idx_job_history_job_start ON sys.job_history USING btree (job_name, start_time DESC);


--
-- Name: idx_job_history_start_time; Type: INDEX; Schema: sys; Owner: -
--

CREATE INDEX idx_job_history_start_time ON sys.job_history USING btree (start_time DESC);


--
-- Name: idx_job_history_status; Type: INDEX; Schema: sys; Owner: -
--

CREATE INDEX idx_job_history_status ON sys.job_history USING btree (status);


--
-- Name: idx_job_triggers_pending; Type: INDEX; Schema: sys; Owner: -
--

CREATE INDEX idx_job_triggers_pending ON sys.job_triggers USING btree (status) WHERE (status = 'PENDING'::text);


--
-- Name: idx_portfolio_date; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX idx_portfolio_date ON trading.portfolio USING btree (date);


--
-- Name: idx_scanner_results_run_date; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX idx_scanner_results_run_date ON trading.scanner_results USING btree (run_date);


--
-- Name: idx_scanner_results_scanner_id; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX idx_scanner_results_scanner_id ON trading.scanner_results USING btree (scanner_id);


--
-- Name: idx_trades_date; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX idx_trades_date ON trading.trades USING btree (trade_date);


--
-- Name: idx_trades_symbol_date; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX idx_trades_symbol_date ON trading.trades USING btree (symbol, trade_date);


--
-- Name: ix_trades_strategy; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX ix_trades_strategy ON trading.trades USING btree (strategy_name);


--
-- Name: ix_trades_symbol; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX ix_trades_symbol ON trading.trades USING btree (symbol);


--
-- Name: _hyper_4_100_chunk 100_199_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_100_chunk
    ADD CONSTRAINT "100_199_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_101_chunk 101_201_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_101_chunk
    ADD CONSTRAINT "101_201_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_102_chunk 102_203_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_102_chunk
    ADD CONSTRAINT "102_203_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_103_chunk 103_205_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_103_chunk
    ADD CONSTRAINT "103_205_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_104_chunk 104_207_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_104_chunk
    ADD CONSTRAINT "104_207_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_105_chunk 105_209_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_105_chunk
    ADD CONSTRAINT "105_209_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_106_chunk 106_211_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_106_chunk
    ADD CONSTRAINT "106_211_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_107_chunk 107_213_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_107_chunk
    ADD CONSTRAINT "107_213_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_108_chunk 108_215_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_108_chunk
    ADD CONSTRAINT "108_215_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_109_chunk 109_217_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_109_chunk
    ADD CONSTRAINT "109_217_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_10_chunk 10_19_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_10_chunk
    ADD CONSTRAINT "10_19_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_110_chunk 110_219_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_110_chunk
    ADD CONSTRAINT "110_219_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_111_chunk 111_221_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_111_chunk
    ADD CONSTRAINT "111_221_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_112_chunk 112_223_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_112_chunk
    ADD CONSTRAINT "112_223_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_113_chunk 113_225_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_113_chunk
    ADD CONSTRAINT "113_225_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_114_chunk 114_227_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_114_chunk
    ADD CONSTRAINT "114_227_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_115_chunk 115_229_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_115_chunk
    ADD CONSTRAINT "115_229_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_116_chunk 116_231_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_116_chunk
    ADD CONSTRAINT "116_231_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_117_chunk 117_233_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_117_chunk
    ADD CONSTRAINT "117_233_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_118_chunk 118_235_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_118_chunk
    ADD CONSTRAINT "118_235_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_119_chunk 119_237_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_119_chunk
    ADD CONSTRAINT "119_237_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_11_chunk 11_21_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_11_chunk
    ADD CONSTRAINT "11_21_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_120_chunk 120_239_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_120_chunk
    ADD CONSTRAINT "120_239_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_121_chunk 121_241_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_121_chunk
    ADD CONSTRAINT "121_241_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_122_chunk 122_243_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_122_chunk
    ADD CONSTRAINT "122_243_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_123_chunk 123_245_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_123_chunk
    ADD CONSTRAINT "123_245_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_124_chunk 124_247_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_124_chunk
    ADD CONSTRAINT "124_247_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_125_chunk 125_249_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_125_chunk
    ADD CONSTRAINT "125_249_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_126_chunk 126_251_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_126_chunk
    ADD CONSTRAINT "126_251_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_127_chunk 127_253_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_127_chunk
    ADD CONSTRAINT "127_253_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_128_chunk 128_255_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_128_chunk
    ADD CONSTRAINT "128_255_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_129_chunk 129_257_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_129_chunk
    ADD CONSTRAINT "129_257_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_12_chunk 12_23_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_12_chunk
    ADD CONSTRAINT "12_23_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_130_chunk 130_259_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_130_chunk
    ADD CONSTRAINT "130_259_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_131_chunk 131_261_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_131_chunk
    ADD CONSTRAINT "131_261_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_132_chunk 132_263_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_132_chunk
    ADD CONSTRAINT "132_263_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_133_chunk 133_265_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_133_chunk
    ADD CONSTRAINT "133_265_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_134_chunk 134_267_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_134_chunk
    ADD CONSTRAINT "134_267_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_135_chunk 135_269_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_135_chunk
    ADD CONSTRAINT "135_269_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_136_chunk 136_271_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_136_chunk
    ADD CONSTRAINT "136_271_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_137_chunk 137_273_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_137_chunk
    ADD CONSTRAINT "137_273_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_138_chunk 138_275_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_138_chunk
    ADD CONSTRAINT "138_275_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_139_chunk 139_277_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_139_chunk
    ADD CONSTRAINT "139_277_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_13_chunk 13_25_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_13_chunk
    ADD CONSTRAINT "13_25_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_140_chunk 140_279_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_140_chunk
    ADD CONSTRAINT "140_279_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_141_chunk 141_281_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_141_chunk
    ADD CONSTRAINT "141_281_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_142_chunk 142_283_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_142_chunk
    ADD CONSTRAINT "142_283_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_143_chunk 143_285_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_143_chunk
    ADD CONSTRAINT "143_285_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_144_chunk 144_287_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_144_chunk
    ADD CONSTRAINT "144_287_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_145_chunk 145_289_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_145_chunk
    ADD CONSTRAINT "145_289_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_146_chunk 146_291_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_146_chunk
    ADD CONSTRAINT "146_291_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_147_chunk 147_293_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_147_chunk
    ADD CONSTRAINT "147_293_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_148_chunk 148_295_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_148_chunk
    ADD CONSTRAINT "148_295_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_149_chunk 149_297_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_149_chunk
    ADD CONSTRAINT "149_297_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_14_chunk 14_27_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_14_chunk
    ADD CONSTRAINT "14_27_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_150_chunk 150_299_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_150_chunk
    ADD CONSTRAINT "150_299_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_151_chunk 151_301_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_151_chunk
    ADD CONSTRAINT "151_301_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_152_chunk 152_303_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_152_chunk
    ADD CONSTRAINT "152_303_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_153_chunk 153_305_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_153_chunk
    ADD CONSTRAINT "153_305_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_154_chunk 154_307_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_154_chunk
    ADD CONSTRAINT "154_307_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_155_chunk 155_309_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_155_chunk
    ADD CONSTRAINT "155_309_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_156_chunk 156_311_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_156_chunk
    ADD CONSTRAINT "156_311_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_157_chunk 157_313_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_157_chunk
    ADD CONSTRAINT "157_313_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_158_chunk 158_315_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_158_chunk
    ADD CONSTRAINT "158_315_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_159_chunk 159_317_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_159_chunk
    ADD CONSTRAINT "159_317_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_15_chunk 15_29_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_15_chunk
    ADD CONSTRAINT "15_29_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_160_chunk 160_319_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_160_chunk
    ADD CONSTRAINT "160_319_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_161_chunk 161_321_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_161_chunk
    ADD CONSTRAINT "161_321_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_162_chunk 162_323_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_162_chunk
    ADD CONSTRAINT "162_323_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_163_chunk 163_325_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_163_chunk
    ADD CONSTRAINT "163_325_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_164_chunk 164_327_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_164_chunk
    ADD CONSTRAINT "164_327_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_165_chunk 165_329_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_165_chunk
    ADD CONSTRAINT "165_329_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_166_chunk 166_331_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_166_chunk
    ADD CONSTRAINT "166_331_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_167_chunk 167_333_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_167_chunk
    ADD CONSTRAINT "167_333_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_168_chunk 168_335_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_168_chunk
    ADD CONSTRAINT "168_335_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_169_chunk 169_337_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_169_chunk
    ADD CONSTRAINT "169_337_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_16_chunk 16_31_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_16_chunk
    ADD CONSTRAINT "16_31_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_170_chunk 170_339_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_170_chunk
    ADD CONSTRAINT "170_339_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_171_chunk 171_341_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_171_chunk
    ADD CONSTRAINT "171_341_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_172_chunk 172_343_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_172_chunk
    ADD CONSTRAINT "172_343_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_173_chunk 173_345_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_173_chunk
    ADD CONSTRAINT "173_345_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_174_chunk 174_347_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_174_chunk
    ADD CONSTRAINT "174_347_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_175_chunk 175_349_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_175_chunk
    ADD CONSTRAINT "175_349_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_176_chunk 176_351_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_176_chunk
    ADD CONSTRAINT "176_351_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_177_chunk 177_353_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_177_chunk
    ADD CONSTRAINT "177_353_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_178_chunk 178_355_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_178_chunk
    ADD CONSTRAINT "178_355_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_179_chunk 179_357_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_179_chunk
    ADD CONSTRAINT "179_357_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_17_chunk 17_33_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_17_chunk
    ADD CONSTRAINT "17_33_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_180_chunk 180_359_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_180_chunk
    ADD CONSTRAINT "180_359_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_181_chunk 181_361_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_181_chunk
    ADD CONSTRAINT "181_361_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_182_chunk 182_363_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_182_chunk
    ADD CONSTRAINT "182_363_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_183_chunk 183_365_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_183_chunk
    ADD CONSTRAINT "183_365_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_184_chunk 184_367_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_184_chunk
    ADD CONSTRAINT "184_367_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_185_chunk 185_369_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_185_chunk
    ADD CONSTRAINT "185_369_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_186_chunk 186_371_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_186_chunk
    ADD CONSTRAINT "186_371_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_187_chunk 187_373_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_187_chunk
    ADD CONSTRAINT "187_373_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_188_chunk 188_375_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_188_chunk
    ADD CONSTRAINT "188_375_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_189_chunk 189_377_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_189_chunk
    ADD CONSTRAINT "189_377_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_18_chunk 18_35_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_18_chunk
    ADD CONSTRAINT "18_35_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_190_chunk 190_379_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_190_chunk
    ADD CONSTRAINT "190_379_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_191_chunk 191_381_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_191_chunk
    ADD CONSTRAINT "191_381_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_192_chunk 192_383_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_192_chunk
    ADD CONSTRAINT "192_383_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_193_chunk 193_385_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_193_chunk
    ADD CONSTRAINT "193_385_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_194_chunk 194_387_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_194_chunk
    ADD CONSTRAINT "194_387_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_195_chunk 195_389_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_195_chunk
    ADD CONSTRAINT "195_389_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_196_chunk 196_391_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_196_chunk
    ADD CONSTRAINT "196_391_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_197_chunk 197_393_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_197_chunk
    ADD CONSTRAINT "197_393_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_198_chunk 198_395_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_198_chunk
    ADD CONSTRAINT "198_395_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_199_chunk 199_397_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_199_chunk
    ADD CONSTRAINT "199_397_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_19_chunk 19_37_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_19_chunk
    ADD CONSTRAINT "19_37_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_1_chunk 1_1_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_1_chunk
    ADD CONSTRAINT "1_1_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_200_chunk 200_399_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_200_chunk
    ADD CONSTRAINT "200_399_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_201_chunk 201_401_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_201_chunk
    ADD CONSTRAINT "201_401_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_202_chunk 202_403_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_202_chunk
    ADD CONSTRAINT "202_403_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_203_chunk 203_405_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_203_chunk
    ADD CONSTRAINT "203_405_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_204_chunk 204_407_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_204_chunk
    ADD CONSTRAINT "204_407_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_205_chunk 205_409_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_205_chunk
    ADD CONSTRAINT "205_409_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_206_chunk 206_411_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_206_chunk
    ADD CONSTRAINT "206_411_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_207_chunk 207_413_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_207_chunk
    ADD CONSTRAINT "207_413_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_208_chunk 208_415_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_208_chunk
    ADD CONSTRAINT "208_415_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_209_chunk 209_417_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_209_chunk
    ADD CONSTRAINT "209_417_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_20_chunk 20_39_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_20_chunk
    ADD CONSTRAINT "20_39_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_210_chunk 210_419_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_210_chunk
    ADD CONSTRAINT "210_419_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_211_chunk 211_421_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_211_chunk
    ADD CONSTRAINT "211_421_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_212_chunk 212_423_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_212_chunk
    ADD CONSTRAINT "212_423_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_213_chunk 213_425_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_213_chunk
    ADD CONSTRAINT "213_425_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_214_chunk 214_427_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_214_chunk
    ADD CONSTRAINT "214_427_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_215_chunk 215_429_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_215_chunk
    ADD CONSTRAINT "215_429_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_216_chunk 216_431_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_216_chunk
    ADD CONSTRAINT "216_431_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_3_217_chunk 217_433_candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_3_217_chunk
    ADD CONSTRAINT "217_433_candles_60m_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_21_chunk 21_41_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_21_chunk
    ADD CONSTRAINT "21_41_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_22_chunk 22_43_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_22_chunk
    ADD CONSTRAINT "22_43_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_23_chunk 23_45_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_23_chunk
    ADD CONSTRAINT "23_45_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_24_chunk 24_47_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_24_chunk
    ADD CONSTRAINT "24_47_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_25_chunk 25_49_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_25_chunk
    ADD CONSTRAINT "25_49_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_26_chunk 26_51_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_26_chunk
    ADD CONSTRAINT "26_51_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_27_chunk 27_53_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_27_chunk
    ADD CONSTRAINT "27_53_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_28_chunk 28_55_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_28_chunk
    ADD CONSTRAINT "28_55_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_29_chunk 29_57_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_29_chunk
    ADD CONSTRAINT "29_57_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_2_chunk 2_3_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_2_chunk
    ADD CONSTRAINT "2_3_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_30_chunk 30_59_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_30_chunk
    ADD CONSTRAINT "30_59_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_31_chunk 31_61_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_31_chunk
    ADD CONSTRAINT "31_61_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_32_chunk 32_63_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_32_chunk
    ADD CONSTRAINT "32_63_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_33_chunk 33_65_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_33_chunk
    ADD CONSTRAINT "33_65_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_34_chunk 34_67_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_34_chunk
    ADD CONSTRAINT "34_67_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_35_chunk 35_69_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_35_chunk
    ADD CONSTRAINT "35_69_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_36_chunk 36_71_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_36_chunk
    ADD CONSTRAINT "36_71_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_37_chunk 37_73_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_37_chunk
    ADD CONSTRAINT "37_73_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_38_chunk 38_75_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_38_chunk
    ADD CONSTRAINT "38_75_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_39_chunk 39_77_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_39_chunk
    ADD CONSTRAINT "39_77_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_3_chunk 3_5_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_3_chunk
    ADD CONSTRAINT "3_5_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_40_chunk 40_79_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_40_chunk
    ADD CONSTRAINT "40_79_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_41_chunk 41_81_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_41_chunk
    ADD CONSTRAINT "41_81_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_42_chunk 42_83_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_42_chunk
    ADD CONSTRAINT "42_83_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_43_chunk 43_85_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_43_chunk
    ADD CONSTRAINT "43_85_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_44_chunk 44_87_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_44_chunk
    ADD CONSTRAINT "44_87_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_45_chunk 45_89_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_45_chunk
    ADD CONSTRAINT "45_89_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_46_chunk 46_91_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_46_chunk
    ADD CONSTRAINT "46_91_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_47_chunk 47_93_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_47_chunk
    ADD CONSTRAINT "47_93_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_48_chunk 48_95_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_48_chunk
    ADD CONSTRAINT "48_95_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_49_chunk 49_97_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_49_chunk
    ADD CONSTRAINT "49_97_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_4_chunk 4_7_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_4_chunk
    ADD CONSTRAINT "4_7_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_50_chunk 50_99_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_50_chunk
    ADD CONSTRAINT "50_99_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_51_chunk 51_101_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_51_chunk
    ADD CONSTRAINT "51_101_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_52_chunk 52_103_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_52_chunk
    ADD CONSTRAINT "52_103_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_53_chunk 53_105_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_53_chunk
    ADD CONSTRAINT "53_105_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_54_chunk 54_107_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_54_chunk
    ADD CONSTRAINT "54_107_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_55_chunk 55_109_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_55_chunk
    ADD CONSTRAINT "55_109_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_56_chunk 56_111_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_56_chunk
    ADD CONSTRAINT "56_111_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_57_chunk 57_113_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_57_chunk
    ADD CONSTRAINT "57_113_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_58_chunk 58_115_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_58_chunk
    ADD CONSTRAINT "58_115_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_59_chunk 59_117_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_59_chunk
    ADD CONSTRAINT "59_117_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_5_chunk 5_9_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_5_chunk
    ADD CONSTRAINT "5_9_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_60_chunk 60_119_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_60_chunk
    ADD CONSTRAINT "60_119_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_61_chunk 61_121_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_61_chunk
    ADD CONSTRAINT "61_121_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_62_chunk 62_123_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_62_chunk
    ADD CONSTRAINT "62_123_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_63_chunk 63_125_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_63_chunk
    ADD CONSTRAINT "63_125_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_64_chunk 64_127_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_64_chunk
    ADD CONSTRAINT "64_127_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_65_chunk 65_129_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_65_chunk
    ADD CONSTRAINT "65_129_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_66_chunk 66_131_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_66_chunk
    ADD CONSTRAINT "66_131_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_67_chunk 67_133_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_67_chunk
    ADD CONSTRAINT "67_133_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_68_chunk 68_135_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_68_chunk
    ADD CONSTRAINT "68_135_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_69_chunk 69_137_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_69_chunk
    ADD CONSTRAINT "69_137_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_6_chunk 6_11_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_6_chunk
    ADD CONSTRAINT "6_11_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_70_chunk 70_139_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_70_chunk
    ADD CONSTRAINT "70_139_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_71_chunk 71_141_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_71_chunk
    ADD CONSTRAINT "71_141_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_72_chunk 72_143_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_72_chunk
    ADD CONSTRAINT "72_143_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_73_chunk 73_145_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_73_chunk
    ADD CONSTRAINT "73_145_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_74_chunk 74_147_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_74_chunk
    ADD CONSTRAINT "74_147_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_75_chunk 75_149_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_75_chunk
    ADD CONSTRAINT "75_149_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_76_chunk 76_151_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_76_chunk
    ADD CONSTRAINT "76_151_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_77_chunk 77_153_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_77_chunk
    ADD CONSTRAINT "77_153_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_78_chunk 78_155_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_78_chunk
    ADD CONSTRAINT "78_155_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_79_chunk 79_157_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_79_chunk
    ADD CONSTRAINT "79_157_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_7_chunk 7_13_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_7_chunk
    ADD CONSTRAINT "7_13_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_80_chunk 80_159_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_80_chunk
    ADD CONSTRAINT "80_159_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_81_chunk 81_161_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_81_chunk
    ADD CONSTRAINT "81_161_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_82_chunk 82_163_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_82_chunk
    ADD CONSTRAINT "82_163_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_83_chunk 83_165_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_83_chunk
    ADD CONSTRAINT "83_165_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_84_chunk 84_167_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_84_chunk
    ADD CONSTRAINT "84_167_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_85_chunk 85_169_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_85_chunk
    ADD CONSTRAINT "85_169_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_86_chunk 86_171_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_86_chunk
    ADD CONSTRAINT "86_171_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_87_chunk 87_173_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_87_chunk
    ADD CONSTRAINT "87_173_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_88_chunk 88_175_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_88_chunk
    ADD CONSTRAINT "88_175_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_89_chunk 89_177_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_89_chunk
    ADD CONSTRAINT "89_177_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_8_chunk 8_15_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_8_chunk
    ADD CONSTRAINT "8_15_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_90_chunk 90_179_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_90_chunk
    ADD CONSTRAINT "90_179_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_91_chunk 91_181_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_91_chunk
    ADD CONSTRAINT "91_181_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_92_chunk 92_183_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_92_chunk
    ADD CONSTRAINT "92_183_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_93_chunk 93_185_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_93_chunk
    ADD CONSTRAINT "93_185_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_94_chunk 94_187_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_94_chunk
    ADD CONSTRAINT "94_187_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_95_chunk 95_189_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_95_chunk
    ADD CONSTRAINT "95_189_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_96_chunk 96_191_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_96_chunk
    ADD CONSTRAINT "96_191_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_97_chunk 97_193_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_97_chunk
    ADD CONSTRAINT "97_193_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_98_chunk 98_195_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_98_chunk
    ADD CONSTRAINT "98_195_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_99_chunk 99_197_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_99_chunk
    ADD CONSTRAINT "99_197_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: _hyper_4_9_chunk 9_17_candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_4_9_chunk
    ADD CONSTRAINT "9_17_candles_1d_symbol_id_fkey" FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: candles_1d candles_1d_symbol_id_fkey; Type: FK CONSTRAINT; Schema: ohlc; Owner: -
--

ALTER TABLE ONLY ohlc.candles_1d
    ADD CONSTRAINT candles_1d_symbol_id_fkey FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: candles_60m candles_60m_symbol_id_fkey; Type: FK CONSTRAINT; Schema: ohlc; Owner: -
--

ALTER TABLE ONLY ohlc.candles_60m
    ADD CONSTRAINT candles_60m_symbol_id_fkey FOREIGN KEY (symbol_id) REFERENCES ref.symbol(symbol_id);


--
-- Name: symbol symbol_exchange_code_fkey; Type: FK CONSTRAINT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.symbol
    ADD CONSTRAINT symbol_exchange_code_fkey FOREIGN KEY (exchange_code) REFERENCES ref.exchange(exchange_code);


--
-- Name: app_logs app_logs_history_id_fkey; Type: FK CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.app_logs
    ADD CONSTRAINT app_logs_history_id_fkey FOREIGN KEY (history_id) REFERENCES sys.job_history(id) ON DELETE CASCADE;


--
-- Name: job_triggers job_triggers_job_name_fkey; Type: FK CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.job_triggers
    ADD CONSTRAINT job_triggers_job_name_fkey FOREIGN KEY (job_name) REFERENCES sys.scheduled_jobs(name) ON DELETE CASCADE;


--
-- Name: scanner_results scanner_results_scanner_id_fkey; Type: FK CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.scanner_results
    ADD CONSTRAINT scanner_results_scanner_id_fkey FOREIGN KEY (scanner_id) REFERENCES sys.scanners(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict vaPIwLDdCZWdEWir90hf01Jiqln0EhyuGIDvAgcWsPSMRsQ9blpJuYROXN8Bwv5

