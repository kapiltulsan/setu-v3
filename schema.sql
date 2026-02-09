--
-- PostgreSQL database dump
--

\restrict LVxYBuGY3DivfaRodYRlfbxOWYPGYrAQ1DI7zLrmf8gEviFwdoT3k4SVlZw1AwG

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg13+1)
-- Dumped by pg_dump version 16.11 (Debian 16.11-1.pgdg13+1)

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
    candle_start timestamp with time zone NOT NULL,
    symbol text NOT NULL,
    exchange_code text NOT NULL,
    open numeric,
    high numeric,
    low numeric,
    close numeric,
    volume bigint
);


--
-- Name: _hyper_1_1155_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1155_chunk (
    CONSTRAINT constraint_1155 CHECK (((candle_start >= '2022-10-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-10-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1156_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1156_chunk (
    CONSTRAINT constraint_1156 CHECK (((candle_start >= '2022-10-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-11-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1157_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1157_chunk (
    CONSTRAINT constraint_1157 CHECK (((candle_start >= '2022-11-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-11-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1158_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1158_chunk (
    CONSTRAINT constraint_1158 CHECK (((candle_start >= '2022-12-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-12-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1159_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1159_chunk (
    CONSTRAINT constraint_1159 CHECK (((candle_start >= '2022-12-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-12-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1160_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1160_chunk (
    CONSTRAINT constraint_1160 CHECK (((candle_start >= '2022-12-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-12-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1161_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1161_chunk (
    CONSTRAINT constraint_1161 CHECK (((candle_start >= '2022-12-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-01-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1162_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1162_chunk (
    CONSTRAINT constraint_1162 CHECK (((candle_start >= '2023-01-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-02-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1163_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1163_chunk (
    CONSTRAINT constraint_1163 CHECK (((candle_start >= '2023-02-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-02-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1164_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1164_chunk (
    CONSTRAINT constraint_1164 CHECK (((candle_start >= '2023-02-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-02-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1165_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1165_chunk (
    CONSTRAINT constraint_1165 CHECK (((candle_start >= '2023-02-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-02-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1166_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1166_chunk (
    CONSTRAINT constraint_1166 CHECK (((candle_start >= '2023-02-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-03-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1167_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1167_chunk (
    CONSTRAINT constraint_1167 CHECK (((candle_start >= '2023-03-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-03-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1168_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1168_chunk (
    CONSTRAINT constraint_1168 CHECK (((candle_start >= '2023-03-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-03-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1169_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1169_chunk (
    CONSTRAINT constraint_1169 CHECK (((candle_start >= '2023-03-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-03-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1170_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1170_chunk (
    CONSTRAINT constraint_1170 CHECK (((candle_start >= '2023-03-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-03-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1171_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1171_chunk (
    CONSTRAINT constraint_1171 CHECK (((candle_start >= '2023-03-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-04-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1172_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1172_chunk (
    CONSTRAINT constraint_1172 CHECK (((candle_start >= '2023-04-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-04-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1173_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1173_chunk (
    CONSTRAINT constraint_1173 CHECK (((candle_start >= '2023-04-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-04-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1174_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1174_chunk (
    CONSTRAINT constraint_1174 CHECK (((candle_start >= '2023-04-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-04-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1175_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1175_chunk (
    CONSTRAINT constraint_1175 CHECK (((candle_start >= '2023-04-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-05-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1176_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1176_chunk (
    CONSTRAINT constraint_1176 CHECK (((candle_start >= '2023-05-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-05-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1177_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1177_chunk (
    CONSTRAINT constraint_1177 CHECK (((candle_start >= '2023-05-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-05-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1178_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1178_chunk (
    CONSTRAINT constraint_1178 CHECK (((candle_start >= '2023-05-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-05-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1179_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1179_chunk (
    CONSTRAINT constraint_1179 CHECK (((candle_start >= '2023-05-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-06-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1180_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1180_chunk (
    CONSTRAINT constraint_1180 CHECK (((candle_start >= '2023-06-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-06-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1181_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1181_chunk (
    CONSTRAINT constraint_1181 CHECK (((candle_start >= '2023-06-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-06-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1182_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1182_chunk (
    CONSTRAINT constraint_1182 CHECK (((candle_start >= '2023-06-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-06-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1183_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1183_chunk (
    CONSTRAINT constraint_1183 CHECK (((candle_start >= '2023-06-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-06-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1184_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1184_chunk (
    CONSTRAINT constraint_1184 CHECK (((candle_start >= '2023-06-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-07-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1185_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1185_chunk (
    CONSTRAINT constraint_1185 CHECK (((candle_start >= '2023-07-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-07-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1186_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1186_chunk (
    CONSTRAINT constraint_1186 CHECK (((candle_start >= '2023-07-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-07-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1187_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1187_chunk (
    CONSTRAINT constraint_1187 CHECK (((candle_start >= '2023-07-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-07-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1188_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1188_chunk (
    CONSTRAINT constraint_1188 CHECK (((candle_start >= '2023-07-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-08-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1189_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1189_chunk (
    CONSTRAINT constraint_1189 CHECK (((candle_start >= '2023-08-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-08-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1190_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1190_chunk (
    CONSTRAINT constraint_1190 CHECK (((candle_start >= '2023-08-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-08-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1191_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1191_chunk (
    CONSTRAINT constraint_1191 CHECK (((candle_start >= '2023-08-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-08-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1192_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1192_chunk (
    CONSTRAINT constraint_1192 CHECK (((candle_start >= '2023-08-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-08-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1193_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1193_chunk (
    CONSTRAINT constraint_1193 CHECK (((candle_start >= '2023-08-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-09-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1194_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1194_chunk (
    CONSTRAINT constraint_1194 CHECK (((candle_start >= '2023-09-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-09-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1195_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1195_chunk (
    CONSTRAINT constraint_1195 CHECK (((candle_start >= '2023-09-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-09-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1196_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1196_chunk (
    CONSTRAINT constraint_1196 CHECK (((candle_start >= '2023-09-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-09-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1197_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1197_chunk (
    CONSTRAINT constraint_1197 CHECK (((candle_start >= '2023-09-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-10-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1198_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1198_chunk (
    CONSTRAINT constraint_1198 CHECK (((candle_start >= '2023-10-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-10-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1199_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1199_chunk (
    CONSTRAINT constraint_1199 CHECK (((candle_start >= '2023-10-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-10-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1200_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1200_chunk (
    CONSTRAINT constraint_1200 CHECK (((candle_start >= '2023-10-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-10-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1201_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1201_chunk (
    CONSTRAINT constraint_1201 CHECK (((candle_start >= '2023-10-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-11-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1202_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1202_chunk (
    CONSTRAINT constraint_1202 CHECK (((candle_start >= '2023-11-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-11-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1203_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1203_chunk (
    CONSTRAINT constraint_1203 CHECK (((candle_start >= '2023-11-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-11-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1204_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1204_chunk (
    CONSTRAINT constraint_1204 CHECK (((candle_start >= '2023-11-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-11-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1205_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1205_chunk (
    CONSTRAINT constraint_1205 CHECK (((candle_start >= '2023-11-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-11-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1206_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1206_chunk (
    CONSTRAINT constraint_1206 CHECK (((candle_start >= '2023-11-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-12-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1207_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1207_chunk (
    CONSTRAINT constraint_1207 CHECK (((candle_start >= '2023-12-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-12-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1208_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1208_chunk (
    CONSTRAINT constraint_1208 CHECK (((candle_start >= '2023-12-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-12-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1209_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1209_chunk (
    CONSTRAINT constraint_1209 CHECK (((candle_start >= '2023-12-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-12-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1210_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1210_chunk (
    CONSTRAINT constraint_1210 CHECK (((candle_start >= '2023-12-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-01-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1211_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1211_chunk (
    CONSTRAINT constraint_1211 CHECK (((candle_start >= '2024-01-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-01-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1212_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1212_chunk (
    CONSTRAINT constraint_1212 CHECK (((candle_start >= '2024-01-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-01-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1213_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1213_chunk (
    CONSTRAINT constraint_1213 CHECK (((candle_start >= '2024-01-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-01-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1214_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1214_chunk (
    CONSTRAINT constraint_1214 CHECK (((candle_start >= '2024-01-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-02-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1215_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1215_chunk (
    CONSTRAINT constraint_1215 CHECK (((candle_start >= '2024-02-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-02-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1216_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1216_chunk (
    CONSTRAINT constraint_1216 CHECK (((candle_start >= '2024-02-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-02-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1217_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1217_chunk (
    CONSTRAINT constraint_1217 CHECK (((candle_start >= '2024-02-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-02-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1218_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1218_chunk (
    CONSTRAINT constraint_1218 CHECK (((candle_start >= '2024-02-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-02-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1219_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1219_chunk (
    CONSTRAINT constraint_1219 CHECK (((candle_start >= '2024-02-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-03-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1220_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1220_chunk (
    CONSTRAINT constraint_1220 CHECK (((candle_start >= '2024-03-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-03-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1221_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1221_chunk (
    CONSTRAINT constraint_1221 CHECK (((candle_start >= '2024-03-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-03-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1222_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1222_chunk (
    CONSTRAINT constraint_1222 CHECK (((candle_start >= '2024-03-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-03-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1223_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1223_chunk (
    CONSTRAINT constraint_1223 CHECK (((candle_start >= '2024-03-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-04-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1224_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1224_chunk (
    CONSTRAINT constraint_1224 CHECK (((candle_start >= '2024-04-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-04-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1225_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1225_chunk (
    CONSTRAINT constraint_1225 CHECK (((candle_start >= '2024-04-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-04-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1226_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1226_chunk (
    CONSTRAINT constraint_1226 CHECK (((candle_start >= '2024-04-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-04-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1227_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1227_chunk (
    CONSTRAINT constraint_1227 CHECK (((candle_start >= '2024-04-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-05-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1228_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1228_chunk (
    CONSTRAINT constraint_1228 CHECK (((candle_start >= '2024-05-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-05-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1229_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1229_chunk (
    CONSTRAINT constraint_1229 CHECK (((candle_start >= '2024-05-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-05-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1230_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1230_chunk (
    CONSTRAINT constraint_1230 CHECK (((candle_start >= '2024-05-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-05-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1231_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1231_chunk (
    CONSTRAINT constraint_1231 CHECK (((candle_start >= '2024-05-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-05-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1232_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1232_chunk (
    CONSTRAINT constraint_1232 CHECK (((candle_start >= '2024-05-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-06-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1233_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1233_chunk (
    CONSTRAINT constraint_1233 CHECK (((candle_start >= '2024-06-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-06-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1234_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1234_chunk (
    CONSTRAINT constraint_1234 CHECK (((candle_start >= '2024-06-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-06-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1235_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1235_chunk (
    CONSTRAINT constraint_1235 CHECK (((candle_start >= '2024-06-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-06-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1236_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1236_chunk (
    CONSTRAINT constraint_1236 CHECK (((candle_start >= '2024-06-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-07-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1237_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1237_chunk (
    CONSTRAINT constraint_1237 CHECK (((candle_start >= '2024-07-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-07-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1238_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1238_chunk (
    CONSTRAINT constraint_1238 CHECK (((candle_start >= '2024-07-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-07-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1239_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1239_chunk (
    CONSTRAINT constraint_1239 CHECK (((candle_start >= '2024-07-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-07-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1240_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1240_chunk (
    CONSTRAINT constraint_1240 CHECK (((candle_start >= '2024-07-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-08-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1241_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1241_chunk (
    CONSTRAINT constraint_1241 CHECK (((candle_start >= '2024-08-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-08-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1242_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1242_chunk (
    CONSTRAINT constraint_1242 CHECK (((candle_start >= '2024-08-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-08-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1243_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1243_chunk (
    CONSTRAINT constraint_1243 CHECK (((candle_start >= '2024-08-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-08-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1244_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1244_chunk (
    CONSTRAINT constraint_1244 CHECK (((candle_start >= '2024-08-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-08-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1245_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1245_chunk (
    CONSTRAINT constraint_1245 CHECK (((candle_start >= '2024-08-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-09-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1246_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1246_chunk (
    CONSTRAINT constraint_1246 CHECK (((candle_start >= '2024-09-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-09-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1247_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1247_chunk (
    CONSTRAINT constraint_1247 CHECK (((candle_start >= '2024-09-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-09-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1248_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1248_chunk (
    CONSTRAINT constraint_1248 CHECK (((candle_start >= '2024-09-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-09-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1249_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1249_chunk (
    CONSTRAINT constraint_1249 CHECK (((candle_start >= '2024-09-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-10-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1250_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1250_chunk (
    CONSTRAINT constraint_1250 CHECK (((candle_start >= '2024-10-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-10-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1251_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1251_chunk (
    CONSTRAINT constraint_1251 CHECK (((candle_start >= '2024-10-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-10-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1252_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1252_chunk (
    CONSTRAINT constraint_1252 CHECK (((candle_start >= '2024-10-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-10-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1253_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1253_chunk (
    CONSTRAINT constraint_1253 CHECK (((candle_start >= '2024-10-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-10-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1254_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1254_chunk (
    CONSTRAINT constraint_1254 CHECK (((candle_start >= '2024-10-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-11-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1255_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1255_chunk (
    CONSTRAINT constraint_1255 CHECK (((candle_start >= '2024-11-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-11-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1256_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1256_chunk (
    CONSTRAINT constraint_1256 CHECK (((candle_start >= '2024-11-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-11-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1257_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1257_chunk (
    CONSTRAINT constraint_1257 CHECK (((candle_start >= '2024-11-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-11-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1258_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1258_chunk (
    CONSTRAINT constraint_1258 CHECK (((candle_start >= '2024-11-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1259_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1259_chunk (
    CONSTRAINT constraint_1259 CHECK (((candle_start >= '2024-12-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1260_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1260_chunk (
    CONSTRAINT constraint_1260 CHECK (((candle_start >= '2024-12-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1261_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1261_chunk (
    CONSTRAINT constraint_1261 CHECK (((candle_start >= '2024-12-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1262_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1262_chunk (
    CONSTRAINT constraint_1262 CHECK (((candle_start >= '2024-12-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1263_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1263_chunk (
    CONSTRAINT constraint_1263 CHECK (((candle_start >= '2025-01-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1264_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1264_chunk (
    CONSTRAINT constraint_1264 CHECK (((candle_start >= '2025-01-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1265_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1265_chunk (
    CONSTRAINT constraint_1265 CHECK (((candle_start >= '2025-01-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1266_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1266_chunk (
    CONSTRAINT constraint_1266 CHECK (((candle_start >= '2025-01-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1267_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1267_chunk (
    CONSTRAINT constraint_1267 CHECK (((candle_start >= '2025-01-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1268_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1268_chunk (
    CONSTRAINT constraint_1268 CHECK (((candle_start >= '2025-02-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1269_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1269_chunk (
    CONSTRAINT constraint_1269 CHECK (((candle_start >= '2025-02-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1270_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1270_chunk (
    CONSTRAINT constraint_1270 CHECK (((candle_start >= '2025-02-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1271_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1271_chunk (
    CONSTRAINT constraint_1271 CHECK (((candle_start >= '2025-02-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1272_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1272_chunk (
    CONSTRAINT constraint_1272 CHECK (((candle_start >= '2025-03-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1273_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1273_chunk (
    CONSTRAINT constraint_1273 CHECK (((candle_start >= '2025-03-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1274_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1274_chunk (
    CONSTRAINT constraint_1274 CHECK (((candle_start >= '2025-03-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1275_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1275_chunk (
    CONSTRAINT constraint_1275 CHECK (((candle_start >= '2025-03-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1276_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1276_chunk (
    CONSTRAINT constraint_1276 CHECK (((candle_start >= '2025-04-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1277_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1277_chunk (
    CONSTRAINT constraint_1277 CHECK (((candle_start >= '2025-04-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1278_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1278_chunk (
    CONSTRAINT constraint_1278 CHECK (((candle_start >= '2025-04-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1279_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1279_chunk (
    CONSTRAINT constraint_1279 CHECK (((candle_start >= '2025-04-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1280_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1280_chunk (
    CONSTRAINT constraint_1280 CHECK (((candle_start >= '2025-05-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1281_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1281_chunk (
    CONSTRAINT constraint_1281 CHECK (((candle_start >= '2025-05-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1282_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1282_chunk (
    CONSTRAINT constraint_1282 CHECK (((candle_start >= '2025-05-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1283_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1283_chunk (
    CONSTRAINT constraint_1283 CHECK (((candle_start >= '2025-05-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1284_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1284_chunk (
    CONSTRAINT constraint_1284 CHECK (((candle_start >= '2025-05-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1285_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1285_chunk (
    CONSTRAINT constraint_1285 CHECK (((candle_start >= '2025-06-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1286_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1286_chunk (
    CONSTRAINT constraint_1286 CHECK (((candle_start >= '2025-06-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1287_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1287_chunk (
    CONSTRAINT constraint_1287 CHECK (((candle_start >= '2025-06-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1288_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1288_chunk (
    CONSTRAINT constraint_1288 CHECK (((candle_start >= '2025-06-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1289_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1289_chunk (
    CONSTRAINT constraint_1289 CHECK (((candle_start >= '2025-07-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1290_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1290_chunk (
    CONSTRAINT constraint_1290 CHECK (((candle_start >= '2025-07-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1291_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1291_chunk (
    CONSTRAINT constraint_1291 CHECK (((candle_start >= '2025-07-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1292_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1292_chunk (
    CONSTRAINT constraint_1292 CHECK (((candle_start >= '2025-07-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1293_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1293_chunk (
    CONSTRAINT constraint_1293 CHECK (((candle_start >= '2025-07-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1294_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1294_chunk (
    CONSTRAINT constraint_1294 CHECK (((candle_start >= '2025-08-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1295_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1295_chunk (
    CONSTRAINT constraint_1295 CHECK (((candle_start >= '2025-08-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1296_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1296_chunk (
    CONSTRAINT constraint_1296 CHECK (((candle_start >= '2025-08-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1297_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1297_chunk (
    CONSTRAINT constraint_1297 CHECK (((candle_start >= '2025-08-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1298_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1298_chunk (
    CONSTRAINT constraint_1298 CHECK (((candle_start >= '2025-09-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1299_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1299_chunk (
    CONSTRAINT constraint_1299 CHECK (((candle_start >= '2025-09-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1300_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1300_chunk (
    CONSTRAINT constraint_1300 CHECK (((candle_start >= '2025-09-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1301_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1301_chunk (
    CONSTRAINT constraint_1301 CHECK (((candle_start >= '2025-09-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1302_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1302_chunk (
    CONSTRAINT constraint_1302 CHECK (((candle_start >= '2025-10-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1303_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1303_chunk (
    CONSTRAINT constraint_1303 CHECK (((candle_start >= '2025-10-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1304_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1304_chunk (
    CONSTRAINT constraint_1304 CHECK (((candle_start >= '2025-10-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1305_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1305_chunk (
    CONSTRAINT constraint_1305 CHECK (((candle_start >= '2025-10-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1306_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1306_chunk (
    CONSTRAINT constraint_1306 CHECK (((candle_start >= '2025-10-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1307_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1307_chunk (
    CONSTRAINT constraint_1307 CHECK (((candle_start >= '2025-11-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1308_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1308_chunk (
    CONSTRAINT constraint_1308 CHECK (((candle_start >= '2025-11-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1309_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1309_chunk (
    CONSTRAINT constraint_1309 CHECK (((candle_start >= '2025-11-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1310_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1310_chunk (
    CONSTRAINT constraint_1310 CHECK (((candle_start >= '2025-11-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1311_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1311_chunk (
    CONSTRAINT constraint_1311 CHECK (((candle_start >= '2025-12-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1312_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1312_chunk (
    CONSTRAINT constraint_1312 CHECK (((candle_start >= '2025-12-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1313_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1313_chunk (
    CONSTRAINT constraint_1313 CHECK (((candle_start >= '2025-12-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1314_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1314_chunk (
    CONSTRAINT constraint_1314 CHECK (((candle_start >= '2025-12-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1315_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1315_chunk (
    CONSTRAINT constraint_1315 CHECK (((candle_start >= '2026-01-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1316_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1316_chunk (
    CONSTRAINT constraint_1316 CHECK (((candle_start >= '2026-01-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1317_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1317_chunk (
    CONSTRAINT constraint_1317 CHECK (((candle_start >= '2026-01-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1318_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1318_chunk (
    CONSTRAINT constraint_1318 CHECK (((candle_start >= '2026-01-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1319_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1319_chunk (
    CONSTRAINT constraint_1319 CHECK (((candle_start >= '2022-10-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-10-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1320_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1320_chunk (
    CONSTRAINT constraint_1320 CHECK (((candle_start >= '2022-11-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-11-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1321_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1321_chunk (
    CONSTRAINT constraint_1321 CHECK (((candle_start >= '2022-11-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-11-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1322_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1322_chunk (
    CONSTRAINT constraint_1322 CHECK (((candle_start >= '2022-11-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-12-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1323_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1323_chunk (
    CONSTRAINT constraint_1323 CHECK (((candle_start >= '2022-12-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-12-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1324_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1324_chunk (
    CONSTRAINT constraint_1324 CHECK (((candle_start >= '2023-01-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-01-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1325_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1325_chunk (
    CONSTRAINT constraint_1325 CHECK (((candle_start >= '2023-01-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-01-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1326_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1326_chunk (
    CONSTRAINT constraint_1326 CHECK (((candle_start >= '2023-01-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-01-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: _hyper_1_1327_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_1_1327_chunk (
    CONSTRAINT constraint_1327 CHECK (((candle_start >= '2026-01-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-02-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_60m);


--
-- Name: candles_1d; Type: TABLE; Schema: ohlc; Owner: -
--

CREATE TABLE ohlc.candles_1d (
    candle_start timestamp with time zone NOT NULL,
    symbol text NOT NULL,
    exchange_code text NOT NULL,
    open numeric,
    high numeric,
    low numeric,
    close numeric,
    volume bigint
);


--
-- Name: _hyper_2_1000_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1000_chunk (
    CONSTRAINT constraint_1000 CHECK (((candle_start >= '2016-09-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-09-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1001_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1001_chunk (
    CONSTRAINT constraint_1001 CHECK (((candle_start >= '2016-09-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-10-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1002_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1002_chunk (
    CONSTRAINT constraint_1002 CHECK (((candle_start >= '2016-10-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-10-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1003_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1003_chunk (
    CONSTRAINT constraint_1003 CHECK (((candle_start >= '2016-10-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-10-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1004_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1004_chunk (
    CONSTRAINT constraint_1004 CHECK (((candle_start >= '2016-10-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-10-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1005_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1005_chunk (
    CONSTRAINT constraint_1005 CHECK (((candle_start >= '2016-10-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-11-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1006_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1006_chunk (
    CONSTRAINT constraint_1006 CHECK (((candle_start >= '2016-11-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-11-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1007_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1007_chunk (
    CONSTRAINT constraint_1007 CHECK (((candle_start >= '2016-11-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-11-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1008_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1008_chunk (
    CONSTRAINT constraint_1008 CHECK (((candle_start >= '2016-11-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-11-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1009_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1009_chunk (
    CONSTRAINT constraint_1009 CHECK (((candle_start >= '2016-11-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-12-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1010_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1010_chunk (
    CONSTRAINT constraint_1010 CHECK (((candle_start >= '2016-12-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-12-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1011_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1011_chunk (
    CONSTRAINT constraint_1011 CHECK (((candle_start >= '2016-12-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-12-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1012_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1012_chunk (
    CONSTRAINT constraint_1012 CHECK (((candle_start >= '2016-12-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-12-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1013_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1013_chunk (
    CONSTRAINT constraint_1013 CHECK (((candle_start >= '2016-12-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-12-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1014_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1014_chunk (
    CONSTRAINT constraint_1014 CHECK (((candle_start >= '2016-12-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-01-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1015_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1015_chunk (
    CONSTRAINT constraint_1015 CHECK (((candle_start >= '2017-01-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-01-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1016_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1016_chunk (
    CONSTRAINT constraint_1016 CHECK (((candle_start >= '2017-01-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-01-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1017_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1017_chunk (
    CONSTRAINT constraint_1017 CHECK (((candle_start >= '2017-01-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-01-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1018_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1018_chunk (
    CONSTRAINT constraint_1018 CHECK (((candle_start >= '2017-01-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-02-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1019_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1019_chunk (
    CONSTRAINT constraint_1019 CHECK (((candle_start >= '2017-02-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-02-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1020_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1020_chunk (
    CONSTRAINT constraint_1020 CHECK (((candle_start >= '2017-02-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-02-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1021_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1021_chunk (
    CONSTRAINT constraint_1021 CHECK (((candle_start >= '2017-02-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-02-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1022_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1022_chunk (
    CONSTRAINT constraint_1022 CHECK (((candle_start >= '2017-02-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-03-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1023_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1023_chunk (
    CONSTRAINT constraint_1023 CHECK (((candle_start >= '2017-03-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-03-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1024_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1024_chunk (
    CONSTRAINT constraint_1024 CHECK (((candle_start >= '2017-03-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-03-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1025_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1025_chunk (
    CONSTRAINT constraint_1025 CHECK (((candle_start >= '2017-03-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-03-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1026_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1026_chunk (
    CONSTRAINT constraint_1026 CHECK (((candle_start >= '2017-03-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-03-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1027_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1027_chunk (
    CONSTRAINT constraint_1027 CHECK (((candle_start >= '2017-03-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-04-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1028_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1028_chunk (
    CONSTRAINT constraint_1028 CHECK (((candle_start >= '2017-04-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-04-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1029_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1029_chunk (
    CONSTRAINT constraint_1029 CHECK (((candle_start >= '2017-04-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-04-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1030_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1030_chunk (
    CONSTRAINT constraint_1030 CHECK (((candle_start >= '2017-04-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-04-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1031_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1031_chunk (
    CONSTRAINT constraint_1031 CHECK (((candle_start >= '2017-04-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-05-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1032_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1032_chunk (
    CONSTRAINT constraint_1032 CHECK (((candle_start >= '2017-05-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-05-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1033_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1033_chunk (
    CONSTRAINT constraint_1033 CHECK (((candle_start >= '2017-05-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-05-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1034_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1034_chunk (
    CONSTRAINT constraint_1034 CHECK (((candle_start >= '2017-05-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-05-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1035_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1035_chunk (
    CONSTRAINT constraint_1035 CHECK (((candle_start >= '2017-05-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-06-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1036_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1036_chunk (
    CONSTRAINT constraint_1036 CHECK (((candle_start >= '2017-06-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-06-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1037_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1037_chunk (
    CONSTRAINT constraint_1037 CHECK (((candle_start >= '2017-06-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-06-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1038_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1038_chunk (
    CONSTRAINT constraint_1038 CHECK (((candle_start >= '2017-06-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-06-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1039_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1039_chunk (
    CONSTRAINT constraint_1039 CHECK (((candle_start >= '2017-06-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-06-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1040_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1040_chunk (
    CONSTRAINT constraint_1040 CHECK (((candle_start >= '2017-06-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-07-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1041_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1041_chunk (
    CONSTRAINT constraint_1041 CHECK (((candle_start >= '2017-07-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-07-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1042_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1042_chunk (
    CONSTRAINT constraint_1042 CHECK (((candle_start >= '2017-07-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-07-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1043_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1043_chunk (
    CONSTRAINT constraint_1043 CHECK (((candle_start >= '2017-07-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-07-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1044_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1044_chunk (
    CONSTRAINT constraint_1044 CHECK (((candle_start >= '2017-07-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-08-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1045_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1045_chunk (
    CONSTRAINT constraint_1045 CHECK (((candle_start >= '2017-08-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-08-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1046_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1046_chunk (
    CONSTRAINT constraint_1046 CHECK (((candle_start >= '2017-08-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-08-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1047_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1047_chunk (
    CONSTRAINT constraint_1047 CHECK (((candle_start >= '2017-08-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-08-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1048_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1048_chunk (
    CONSTRAINT constraint_1048 CHECK (((candle_start >= '2017-08-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-08-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1049_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1049_chunk (
    CONSTRAINT constraint_1049 CHECK (((candle_start >= '2017-08-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-09-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1050_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1050_chunk (
    CONSTRAINT constraint_1050 CHECK (((candle_start >= '2017-09-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-09-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1051_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1051_chunk (
    CONSTRAINT constraint_1051 CHECK (((candle_start >= '2017-09-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-09-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1052_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1052_chunk (
    CONSTRAINT constraint_1052 CHECK (((candle_start >= '2017-09-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-09-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1053_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1053_chunk (
    CONSTRAINT constraint_1053 CHECK (((candle_start >= '2017-09-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-10-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1054_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1054_chunk (
    CONSTRAINT constraint_1054 CHECK (((candle_start >= '2017-10-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-10-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1055_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1055_chunk (
    CONSTRAINT constraint_1055 CHECK (((candle_start >= '2017-10-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-10-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1056_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1056_chunk (
    CONSTRAINT constraint_1056 CHECK (((candle_start >= '2017-10-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-10-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1057_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1057_chunk (
    CONSTRAINT constraint_1057 CHECK (((candle_start >= '2017-10-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-11-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1058_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1058_chunk (
    CONSTRAINT constraint_1058 CHECK (((candle_start >= '2017-11-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-11-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1059_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1059_chunk (
    CONSTRAINT constraint_1059 CHECK (((candle_start >= '2017-11-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-11-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1060_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1060_chunk (
    CONSTRAINT constraint_1060 CHECK (((candle_start >= '2017-11-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-11-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1061_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1061_chunk (
    CONSTRAINT constraint_1061 CHECK (((candle_start >= '2017-11-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-11-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1062_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1062_chunk (
    CONSTRAINT constraint_1062 CHECK (((candle_start >= '2017-11-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-12-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1063_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1063_chunk (
    CONSTRAINT constraint_1063 CHECK (((candle_start >= '2017-12-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-12-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1064_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1064_chunk (
    CONSTRAINT constraint_1064 CHECK (((candle_start >= '2017-12-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-12-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1065_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1065_chunk (
    CONSTRAINT constraint_1065 CHECK (((candle_start >= '2017-12-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2017-12-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1066_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1066_chunk (
    CONSTRAINT constraint_1066 CHECK (((candle_start >= '2017-12-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-01-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1067_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1067_chunk (
    CONSTRAINT constraint_1067 CHECK (((candle_start >= '2018-01-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-01-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1068_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1068_chunk (
    CONSTRAINT constraint_1068 CHECK (((candle_start >= '2018-01-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-01-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1069_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1069_chunk (
    CONSTRAINT constraint_1069 CHECK (((candle_start >= '2018-01-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-01-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1070_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1070_chunk (
    CONSTRAINT constraint_1070 CHECK (((candle_start >= '2018-01-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-02-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1071_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1071_chunk (
    CONSTRAINT constraint_1071 CHECK (((candle_start >= '2018-02-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-02-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1072_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1072_chunk (
    CONSTRAINT constraint_1072 CHECK (((candle_start >= '2018-02-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-02-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1073_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1073_chunk (
    CONSTRAINT constraint_1073 CHECK (((candle_start >= '2018-02-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-02-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1074_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1074_chunk (
    CONSTRAINT constraint_1074 CHECK (((candle_start >= '2018-02-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-03-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1075_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1075_chunk (
    CONSTRAINT constraint_1075 CHECK (((candle_start >= '2018-03-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-03-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1076_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1076_chunk (
    CONSTRAINT constraint_1076 CHECK (((candle_start >= '2018-03-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-03-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1077_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1077_chunk (
    CONSTRAINT constraint_1077 CHECK (((candle_start >= '2018-03-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-03-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1078_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1078_chunk (
    CONSTRAINT constraint_1078 CHECK (((candle_start >= '2018-03-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-03-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1079_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1079_chunk (
    CONSTRAINT constraint_1079 CHECK (((candle_start >= '2018-03-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-04-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1080_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1080_chunk (
    CONSTRAINT constraint_1080 CHECK (((candle_start >= '2018-04-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-04-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1081_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1081_chunk (
    CONSTRAINT constraint_1081 CHECK (((candle_start >= '2018-04-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-04-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1082_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1082_chunk (
    CONSTRAINT constraint_1082 CHECK (((candle_start >= '2018-04-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-04-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1083_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1083_chunk (
    CONSTRAINT constraint_1083 CHECK (((candle_start >= '2018-04-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-05-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1084_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1084_chunk (
    CONSTRAINT constraint_1084 CHECK (((candle_start >= '2018-05-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-05-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1085_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1085_chunk (
    CONSTRAINT constraint_1085 CHECK (((candle_start >= '2018-05-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-05-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1086_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1086_chunk (
    CONSTRAINT constraint_1086 CHECK (((candle_start >= '2018-05-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-05-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1087_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1087_chunk (
    CONSTRAINT constraint_1087 CHECK (((candle_start >= '2018-05-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-05-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1088_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1088_chunk (
    CONSTRAINT constraint_1088 CHECK (((candle_start >= '2018-05-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-06-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1089_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1089_chunk (
    CONSTRAINT constraint_1089 CHECK (((candle_start >= '2018-06-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-06-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1090_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1090_chunk (
    CONSTRAINT constraint_1090 CHECK (((candle_start >= '2018-06-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-06-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1091_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1091_chunk (
    CONSTRAINT constraint_1091 CHECK (((candle_start >= '2018-06-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-06-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1092_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1092_chunk (
    CONSTRAINT constraint_1092 CHECK (((candle_start >= '2018-06-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-07-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1093_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1093_chunk (
    CONSTRAINT constraint_1093 CHECK (((candle_start >= '2018-07-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-07-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1094_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1094_chunk (
    CONSTRAINT constraint_1094 CHECK (((candle_start >= '2018-07-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-07-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1095_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1095_chunk (
    CONSTRAINT constraint_1095 CHECK (((candle_start >= '2018-07-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-07-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1096_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1096_chunk (
    CONSTRAINT constraint_1096 CHECK (((candle_start >= '2018-07-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-08-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1097_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1097_chunk (
    CONSTRAINT constraint_1097 CHECK (((candle_start >= '2018-08-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-08-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1098_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1098_chunk (
    CONSTRAINT constraint_1098 CHECK (((candle_start >= '2018-08-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-08-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1099_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1099_chunk (
    CONSTRAINT constraint_1099 CHECK (((candle_start >= '2018-08-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-08-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1100_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1100_chunk (
    CONSTRAINT constraint_1100 CHECK (((candle_start >= '2018-08-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-08-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1101_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1101_chunk (
    CONSTRAINT constraint_1101 CHECK (((candle_start >= '2018-08-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-09-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1102_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1102_chunk (
    CONSTRAINT constraint_1102 CHECK (((candle_start >= '2018-09-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-09-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1103_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1103_chunk (
    CONSTRAINT constraint_1103 CHECK (((candle_start >= '2018-09-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-09-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1104_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1104_chunk (
    CONSTRAINT constraint_1104 CHECK (((candle_start >= '2018-09-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-09-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1105_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1105_chunk (
    CONSTRAINT constraint_1105 CHECK (((candle_start >= '2018-09-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-10-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1106_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1106_chunk (
    CONSTRAINT constraint_1106 CHECK (((candle_start >= '2018-10-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-10-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1107_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1107_chunk (
    CONSTRAINT constraint_1107 CHECK (((candle_start >= '2018-10-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-10-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1108_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1108_chunk (
    CONSTRAINT constraint_1108 CHECK (((candle_start >= '2018-10-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-10-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1109_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1109_chunk (
    CONSTRAINT constraint_1109 CHECK (((candle_start >= '2018-10-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-11-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1110_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1110_chunk (
    CONSTRAINT constraint_1110 CHECK (((candle_start >= '2018-11-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-11-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1111_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1111_chunk (
    CONSTRAINT constraint_1111 CHECK (((candle_start >= '2018-11-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-11-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1112_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1112_chunk (
    CONSTRAINT constraint_1112 CHECK (((candle_start >= '2018-11-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-11-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1113_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1113_chunk (
    CONSTRAINT constraint_1113 CHECK (((candle_start >= '2018-11-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-11-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1114_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1114_chunk (
    CONSTRAINT constraint_1114 CHECK (((candle_start >= '2018-11-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-12-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1115_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1115_chunk (
    CONSTRAINT constraint_1115 CHECK (((candle_start >= '2018-12-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-12-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1116_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1116_chunk (
    CONSTRAINT constraint_1116 CHECK (((candle_start >= '2018-12-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-12-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1117_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1117_chunk (
    CONSTRAINT constraint_1117 CHECK (((candle_start >= '2018-12-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2018-12-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1118_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1118_chunk (
    CONSTRAINT constraint_1118 CHECK (((candle_start >= '2018-12-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-01-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1119_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1119_chunk (
    CONSTRAINT constraint_1119 CHECK (((candle_start >= '2019-01-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-01-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1120_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1120_chunk (
    CONSTRAINT constraint_1120 CHECK (((candle_start >= '2019-01-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-01-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1121_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1121_chunk (
    CONSTRAINT constraint_1121 CHECK (((candle_start >= '2019-01-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-01-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1122_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1122_chunk (
    CONSTRAINT constraint_1122 CHECK (((candle_start >= '2019-01-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-01-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1123_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1123_chunk (
    CONSTRAINT constraint_1123 CHECK (((candle_start >= '2019-01-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-02-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1124_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1124_chunk (
    CONSTRAINT constraint_1124 CHECK (((candle_start >= '2019-02-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-02-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1125_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1125_chunk (
    CONSTRAINT constraint_1125 CHECK (((candle_start >= '2019-02-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-02-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1126_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1126_chunk (
    CONSTRAINT constraint_1126 CHECK (((candle_start >= '2019-02-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-02-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1127_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1127_chunk (
    CONSTRAINT constraint_1127 CHECK (((candle_start >= '2019-02-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-03-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1128_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1128_chunk (
    CONSTRAINT constraint_1128 CHECK (((candle_start >= '2019-03-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-03-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1129_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1129_chunk (
    CONSTRAINT constraint_1129 CHECK (((candle_start >= '2019-03-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-03-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1130_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1130_chunk (
    CONSTRAINT constraint_1130 CHECK (((candle_start >= '2019-03-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-03-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1131_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1131_chunk (
    CONSTRAINT constraint_1131 CHECK (((candle_start >= '2019-03-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-04-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1132_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1132_chunk (
    CONSTRAINT constraint_1132 CHECK (((candle_start >= '2019-04-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-04-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1133_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1133_chunk (
    CONSTRAINT constraint_1133 CHECK (((candle_start >= '2019-04-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-04-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1134_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1134_chunk (
    CONSTRAINT constraint_1134 CHECK (((candle_start >= '2019-04-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-04-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1135_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1135_chunk (
    CONSTRAINT constraint_1135 CHECK (((candle_start >= '2019-04-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-05-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1136_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1136_chunk (
    CONSTRAINT constraint_1136 CHECK (((candle_start >= '2019-05-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-05-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1137_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1137_chunk (
    CONSTRAINT constraint_1137 CHECK (((candle_start >= '2019-05-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-05-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1138_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1138_chunk (
    CONSTRAINT constraint_1138 CHECK (((candle_start >= '2019-05-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-05-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1139_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1139_chunk (
    CONSTRAINT constraint_1139 CHECK (((candle_start >= '2019-05-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-05-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1140_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1140_chunk (
    CONSTRAINT constraint_1140 CHECK (((candle_start >= '2019-05-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-06-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1141_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1141_chunk (
    CONSTRAINT constraint_1141 CHECK (((candle_start >= '2019-06-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-06-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1142_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1142_chunk (
    CONSTRAINT constraint_1142 CHECK (((candle_start >= '2019-06-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-06-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1143_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1143_chunk (
    CONSTRAINT constraint_1143 CHECK (((candle_start >= '2019-06-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-06-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1144_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1144_chunk (
    CONSTRAINT constraint_1144 CHECK (((candle_start >= '2019-06-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-07-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1145_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1145_chunk (
    CONSTRAINT constraint_1145 CHECK (((candle_start >= '2019-07-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-07-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1146_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1146_chunk (
    CONSTRAINT constraint_1146 CHECK (((candle_start >= '2019-07-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-07-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1147_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1147_chunk (
    CONSTRAINT constraint_1147 CHECK (((candle_start >= '2019-07-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-07-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1148_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1148_chunk (
    CONSTRAINT constraint_1148 CHECK (((candle_start >= '2019-07-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-08-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1149_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1149_chunk (
    CONSTRAINT constraint_1149 CHECK (((candle_start >= '2019-08-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-08-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1150_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1150_chunk (
    CONSTRAINT constraint_1150 CHECK (((candle_start >= '2019-08-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-08-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1151_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1151_chunk (
    CONSTRAINT constraint_1151 CHECK (((candle_start >= '2019-08-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-08-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1152_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1152_chunk (
    CONSTRAINT constraint_1152 CHECK (((candle_start >= '2019-08-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-08-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1153_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1153_chunk (
    CONSTRAINT constraint_1153 CHECK (((candle_start >= '2019-08-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-09-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1154_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1154_chunk (
    CONSTRAINT constraint_1154 CHECK (((candle_start >= '2019-09-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-09-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_1328_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_1328_chunk (
    CONSTRAINT constraint_1328 CHECK (((candle_start >= '2026-01-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-02-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_440_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_440_chunk (
    CONSTRAINT constraint_440 CHECK (((candle_start >= '2019-09-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-09-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_441_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_441_chunk (
    CONSTRAINT constraint_441 CHECK (((candle_start >= '2019-09-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-09-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_442_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_442_chunk (
    CONSTRAINT constraint_442 CHECK (((candle_start >= '2019-09-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-10-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_443_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_443_chunk (
    CONSTRAINT constraint_443 CHECK (((candle_start >= '2019-10-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-10-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_444_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_444_chunk (
    CONSTRAINT constraint_444 CHECK (((candle_start >= '2019-10-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-10-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_445_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_445_chunk (
    CONSTRAINT constraint_445 CHECK (((candle_start >= '2019-10-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-10-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_446_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_446_chunk (
    CONSTRAINT constraint_446 CHECK (((candle_start >= '2019-10-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-10-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_447_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_447_chunk (
    CONSTRAINT constraint_447 CHECK (((candle_start >= '2019-10-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-11-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_448_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_448_chunk (
    CONSTRAINT constraint_448 CHECK (((candle_start >= '2019-11-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-11-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_449_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_449_chunk (
    CONSTRAINT constraint_449 CHECK (((candle_start >= '2019-11-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-11-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_450_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_450_chunk (
    CONSTRAINT constraint_450 CHECK (((candle_start >= '2019-11-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-11-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_451_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_451_chunk (
    CONSTRAINT constraint_451 CHECK (((candle_start >= '2019-11-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-12-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_452_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_452_chunk (
    CONSTRAINT constraint_452 CHECK (((candle_start >= '2019-12-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-12-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_453_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_453_chunk (
    CONSTRAINT constraint_453 CHECK (((candle_start >= '2019-12-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-12-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_454_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_454_chunk (
    CONSTRAINT constraint_454 CHECK (((candle_start >= '2019-12-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2019-12-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_455_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_455_chunk (
    CONSTRAINT constraint_455 CHECK (((candle_start >= '2019-12-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-01-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_456_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_456_chunk (
    CONSTRAINT constraint_456 CHECK (((candle_start >= '2020-01-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-01-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_457_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_457_chunk (
    CONSTRAINT constraint_457 CHECK (((candle_start >= '2020-01-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-01-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_458_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_458_chunk (
    CONSTRAINT constraint_458 CHECK (((candle_start >= '2020-01-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-01-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_459_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_459_chunk (
    CONSTRAINT constraint_459 CHECK (((candle_start >= '2020-01-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-01-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_460_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_460_chunk (
    CONSTRAINT constraint_460 CHECK (((candle_start >= '2020-01-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-02-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_461_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_461_chunk (
    CONSTRAINT constraint_461 CHECK (((candle_start >= '2020-02-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-02-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_462_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_462_chunk (
    CONSTRAINT constraint_462 CHECK (((candle_start >= '2020-02-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-02-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_463_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_463_chunk (
    CONSTRAINT constraint_463 CHECK (((candle_start >= '2020-02-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-02-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_464_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_464_chunk (
    CONSTRAINT constraint_464 CHECK (((candle_start >= '2020-02-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-03-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_465_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_465_chunk (
    CONSTRAINT constraint_465 CHECK (((candle_start >= '2020-03-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-03-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_466_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_466_chunk (
    CONSTRAINT constraint_466 CHECK (((candle_start >= '2020-03-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-03-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_467_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_467_chunk (
    CONSTRAINT constraint_467 CHECK (((candle_start >= '2020-03-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-03-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_468_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_468_chunk (
    CONSTRAINT constraint_468 CHECK (((candle_start >= '2020-03-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-04-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_469_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_469_chunk (
    CONSTRAINT constraint_469 CHECK (((candle_start >= '2020-04-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-04-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_470_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_470_chunk (
    CONSTRAINT constraint_470 CHECK (((candle_start >= '2020-04-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-04-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_471_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_471_chunk (
    CONSTRAINT constraint_471 CHECK (((candle_start >= '2020-04-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-04-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_472_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_472_chunk (
    CONSTRAINT constraint_472 CHECK (((candle_start >= '2020-04-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-04-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_473_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_473_chunk (
    CONSTRAINT constraint_473 CHECK (((candle_start >= '2020-04-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-05-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_474_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_474_chunk (
    CONSTRAINT constraint_474 CHECK (((candle_start >= '2020-05-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-05-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_475_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_475_chunk (
    CONSTRAINT constraint_475 CHECK (((candle_start >= '2020-05-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-05-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_476_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_476_chunk (
    CONSTRAINT constraint_476 CHECK (((candle_start >= '2020-05-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-05-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_477_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_477_chunk (
    CONSTRAINT constraint_477 CHECK (((candle_start >= '2020-05-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-06-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_478_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_478_chunk (
    CONSTRAINT constraint_478 CHECK (((candle_start >= '2020-06-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-06-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_479_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_479_chunk (
    CONSTRAINT constraint_479 CHECK (((candle_start >= '2020-06-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-06-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_480_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_480_chunk (
    CONSTRAINT constraint_480 CHECK (((candle_start >= '2020-06-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-06-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_481_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_481_chunk (
    CONSTRAINT constraint_481 CHECK (((candle_start >= '2020-06-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-07-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_482_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_482_chunk (
    CONSTRAINT constraint_482 CHECK (((candle_start >= '2020-07-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-07-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_483_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_483_chunk (
    CONSTRAINT constraint_483 CHECK (((candle_start >= '2020-07-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-07-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_484_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_484_chunk (
    CONSTRAINT constraint_484 CHECK (((candle_start >= '2020-07-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-07-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_485_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_485_chunk (
    CONSTRAINT constraint_485 CHECK (((candle_start >= '2020-07-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-07-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_486_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_486_chunk (
    CONSTRAINT constraint_486 CHECK (((candle_start >= '2020-07-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-08-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_487_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_487_chunk (
    CONSTRAINT constraint_487 CHECK (((candle_start >= '2020-08-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-08-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_488_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_488_chunk (
    CONSTRAINT constraint_488 CHECK (((candle_start >= '2020-08-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-08-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_489_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_489_chunk (
    CONSTRAINT constraint_489 CHECK (((candle_start >= '2020-08-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-08-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_490_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_490_chunk (
    CONSTRAINT constraint_490 CHECK (((candle_start >= '2020-08-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-09-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_491_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_491_chunk (
    CONSTRAINT constraint_491 CHECK (((candle_start >= '2020-09-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-09-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_492_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_492_chunk (
    CONSTRAINT constraint_492 CHECK (((candle_start >= '2020-09-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-09-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_493_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_493_chunk (
    CONSTRAINT constraint_493 CHECK (((candle_start >= '2020-09-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-09-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_494_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_494_chunk (
    CONSTRAINT constraint_494 CHECK (((candle_start >= '2020-09-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-10-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_495_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_495_chunk (
    CONSTRAINT constraint_495 CHECK (((candle_start >= '2020-10-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-10-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_496_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_496_chunk (
    CONSTRAINT constraint_496 CHECK (((candle_start >= '2020-10-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-10-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_497_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_497_chunk (
    CONSTRAINT constraint_497 CHECK (((candle_start >= '2020-10-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-10-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_498_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_498_chunk (
    CONSTRAINT constraint_498 CHECK (((candle_start >= '2020-10-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-10-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_499_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_499_chunk (
    CONSTRAINT constraint_499 CHECK (((candle_start >= '2020-10-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-11-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_500_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_500_chunk (
    CONSTRAINT constraint_500 CHECK (((candle_start >= '2020-11-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-11-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_501_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_501_chunk (
    CONSTRAINT constraint_501 CHECK (((candle_start >= '2020-11-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-11-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_502_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_502_chunk (
    CONSTRAINT constraint_502 CHECK (((candle_start >= '2020-11-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-11-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_503_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_503_chunk (
    CONSTRAINT constraint_503 CHECK (((candle_start >= '2020-11-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-12-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_504_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_504_chunk (
    CONSTRAINT constraint_504 CHECK (((candle_start >= '2020-12-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-12-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_505_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_505_chunk (
    CONSTRAINT constraint_505 CHECK (((candle_start >= '2020-12-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-12-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_506_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_506_chunk (
    CONSTRAINT constraint_506 CHECK (((candle_start >= '2020-12-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-12-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_507_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_507_chunk (
    CONSTRAINT constraint_507 CHECK (((candle_start >= '2020-12-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2020-12-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_508_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_508_chunk (
    CONSTRAINT constraint_508 CHECK (((candle_start >= '2020-12-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-01-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_509_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_509_chunk (
    CONSTRAINT constraint_509 CHECK (((candle_start >= '2021-01-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-01-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_510_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_510_chunk (
    CONSTRAINT constraint_510 CHECK (((candle_start >= '2021-01-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-01-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_511_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_511_chunk (
    CONSTRAINT constraint_511 CHECK (((candle_start >= '2021-01-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-01-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_512_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_512_chunk (
    CONSTRAINT constraint_512 CHECK (((candle_start >= '2021-01-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-02-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_513_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_513_chunk (
    CONSTRAINT constraint_513 CHECK (((candle_start >= '2021-02-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-02-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_514_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_514_chunk (
    CONSTRAINT constraint_514 CHECK (((candle_start >= '2021-02-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-02-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_515_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_515_chunk (
    CONSTRAINT constraint_515 CHECK (((candle_start >= '2021-02-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-02-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_516_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_516_chunk (
    CONSTRAINT constraint_516 CHECK (((candle_start >= '2021-02-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-03-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_517_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_517_chunk (
    CONSTRAINT constraint_517 CHECK (((candle_start >= '2021-03-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-03-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_518_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_518_chunk (
    CONSTRAINT constraint_518 CHECK (((candle_start >= '2021-03-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-03-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_519_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_519_chunk (
    CONSTRAINT constraint_519 CHECK (((candle_start >= '2021-03-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-03-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_520_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_520_chunk (
    CONSTRAINT constraint_520 CHECK (((candle_start >= '2021-03-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-04-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_521_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_521_chunk (
    CONSTRAINT constraint_521 CHECK (((candle_start >= '2021-04-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-04-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_522_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_522_chunk (
    CONSTRAINT constraint_522 CHECK (((candle_start >= '2021-04-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-04-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_523_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_523_chunk (
    CONSTRAINT constraint_523 CHECK (((candle_start >= '2021-04-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-04-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_524_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_524_chunk (
    CONSTRAINT constraint_524 CHECK (((candle_start >= '2021-04-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-04-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_525_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_525_chunk (
    CONSTRAINT constraint_525 CHECK (((candle_start >= '2021-04-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-05-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_526_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_526_chunk (
    CONSTRAINT constraint_526 CHECK (((candle_start >= '2021-05-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-05-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_527_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_527_chunk (
    CONSTRAINT constraint_527 CHECK (((candle_start >= '2021-05-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-05-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_528_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_528_chunk (
    CONSTRAINT constraint_528 CHECK (((candle_start >= '2021-05-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-05-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_529_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_529_chunk (
    CONSTRAINT constraint_529 CHECK (((candle_start >= '2021-05-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-06-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_530_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_530_chunk (
    CONSTRAINT constraint_530 CHECK (((candle_start >= '2021-06-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-06-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_531_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_531_chunk (
    CONSTRAINT constraint_531 CHECK (((candle_start >= '2021-06-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-06-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_532_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_532_chunk (
    CONSTRAINT constraint_532 CHECK (((candle_start >= '2021-06-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-06-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_533_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_533_chunk (
    CONSTRAINT constraint_533 CHECK (((candle_start >= '2021-06-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-07-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_534_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_534_chunk (
    CONSTRAINT constraint_534 CHECK (((candle_start >= '2021-07-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-07-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_535_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_535_chunk (
    CONSTRAINT constraint_535 CHECK (((candle_start >= '2021-07-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-07-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_536_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_536_chunk (
    CONSTRAINT constraint_536 CHECK (((candle_start >= '2021-07-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-07-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_537_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_537_chunk (
    CONSTRAINT constraint_537 CHECK (((candle_start >= '2021-07-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-07-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_538_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_538_chunk (
    CONSTRAINT constraint_538 CHECK (((candle_start >= '2021-07-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-08-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_539_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_539_chunk (
    CONSTRAINT constraint_539 CHECK (((candle_start >= '2021-08-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-08-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_540_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_540_chunk (
    CONSTRAINT constraint_540 CHECK (((candle_start >= '2021-08-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-08-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_541_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_541_chunk (
    CONSTRAINT constraint_541 CHECK (((candle_start >= '2021-08-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-08-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_542_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_542_chunk (
    CONSTRAINT constraint_542 CHECK (((candle_start >= '2021-08-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-09-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_543_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_543_chunk (
    CONSTRAINT constraint_543 CHECK (((candle_start >= '2021-09-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-09-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_544_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_544_chunk (
    CONSTRAINT constraint_544 CHECK (((candle_start >= '2021-09-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-09-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_545_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_545_chunk (
    CONSTRAINT constraint_545 CHECK (((candle_start >= '2021-09-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-09-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_546_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_546_chunk (
    CONSTRAINT constraint_546 CHECK (((candle_start >= '2021-09-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-09-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_547_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_547_chunk (
    CONSTRAINT constraint_547 CHECK (((candle_start >= '2021-09-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-10-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_548_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_548_chunk (
    CONSTRAINT constraint_548 CHECK (((candle_start >= '2021-10-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-10-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_549_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_549_chunk (
    CONSTRAINT constraint_549 CHECK (((candle_start >= '2021-10-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-10-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_550_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_550_chunk (
    CONSTRAINT constraint_550 CHECK (((candle_start >= '2021-10-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-10-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_551_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_551_chunk (
    CONSTRAINT constraint_551 CHECK (((candle_start >= '2021-10-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-11-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_552_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_552_chunk (
    CONSTRAINT constraint_552 CHECK (((candle_start >= '2021-11-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-11-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_553_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_553_chunk (
    CONSTRAINT constraint_553 CHECK (((candle_start >= '2021-11-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-11-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_554_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_554_chunk (
    CONSTRAINT constraint_554 CHECK (((candle_start >= '2021-11-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-11-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_555_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_555_chunk (
    CONSTRAINT constraint_555 CHECK (((candle_start >= '2021-11-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-12-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_556_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_556_chunk (
    CONSTRAINT constraint_556 CHECK (((candle_start >= '2021-12-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-12-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_557_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_557_chunk (
    CONSTRAINT constraint_557 CHECK (((candle_start >= '2021-12-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-12-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_558_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_558_chunk (
    CONSTRAINT constraint_558 CHECK (((candle_start >= '2021-12-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-12-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_559_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_559_chunk (
    CONSTRAINT constraint_559 CHECK (((candle_start >= '2021-12-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2021-12-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_560_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_560_chunk (
    CONSTRAINT constraint_560 CHECK (((candle_start >= '2021-12-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-01-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_561_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_561_chunk (
    CONSTRAINT constraint_561 CHECK (((candle_start >= '2022-01-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-01-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_562_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_562_chunk (
    CONSTRAINT constraint_562 CHECK (((candle_start >= '2022-01-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-01-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_563_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_563_chunk (
    CONSTRAINT constraint_563 CHECK (((candle_start >= '2022-01-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-01-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_564_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_564_chunk (
    CONSTRAINT constraint_564 CHECK (((candle_start >= '2022-01-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-02-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_565_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_565_chunk (
    CONSTRAINT constraint_565 CHECK (((candle_start >= '2022-02-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-02-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_566_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_566_chunk (
    CONSTRAINT constraint_566 CHECK (((candle_start >= '2022-02-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-02-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_567_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_567_chunk (
    CONSTRAINT constraint_567 CHECK (((candle_start >= '2022-02-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-02-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_568_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_568_chunk (
    CONSTRAINT constraint_568 CHECK (((candle_start >= '2022-02-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-03-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_569_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_569_chunk (
    CONSTRAINT constraint_569 CHECK (((candle_start >= '2022-03-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-03-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_570_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_570_chunk (
    CONSTRAINT constraint_570 CHECK (((candle_start >= '2022-03-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-03-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_571_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_571_chunk (
    CONSTRAINT constraint_571 CHECK (((candle_start >= '2022-03-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-03-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_572_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_572_chunk (
    CONSTRAINT constraint_572 CHECK (((candle_start >= '2022-03-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-03-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_573_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_573_chunk (
    CONSTRAINT constraint_573 CHECK (((candle_start >= '2022-03-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-04-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_574_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_574_chunk (
    CONSTRAINT constraint_574 CHECK (((candle_start >= '2022-04-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-04-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_575_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_575_chunk (
    CONSTRAINT constraint_575 CHECK (((candle_start >= '2022-04-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-04-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_576_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_576_chunk (
    CONSTRAINT constraint_576 CHECK (((candle_start >= '2022-04-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-04-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_577_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_577_chunk (
    CONSTRAINT constraint_577 CHECK (((candle_start >= '2022-04-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-05-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_578_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_578_chunk (
    CONSTRAINT constraint_578 CHECK (((candle_start >= '2022-05-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-05-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_579_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_579_chunk (
    CONSTRAINT constraint_579 CHECK (((candle_start >= '2022-05-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-05-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_580_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_580_chunk (
    CONSTRAINT constraint_580 CHECK (((candle_start >= '2022-05-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-05-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_581_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_581_chunk (
    CONSTRAINT constraint_581 CHECK (((candle_start >= '2022-05-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-06-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_582_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_582_chunk (
    CONSTRAINT constraint_582 CHECK (((candle_start >= '2022-06-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-06-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_583_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_583_chunk (
    CONSTRAINT constraint_583 CHECK (((candle_start >= '2022-06-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-06-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_584_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_584_chunk (
    CONSTRAINT constraint_584 CHECK (((candle_start >= '2022-06-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-06-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_585_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_585_chunk (
    CONSTRAINT constraint_585 CHECK (((candle_start >= '2022-06-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-06-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_586_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_586_chunk (
    CONSTRAINT constraint_586 CHECK (((candle_start >= '2022-06-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-07-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_587_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_587_chunk (
    CONSTRAINT constraint_587 CHECK (((candle_start >= '2022-07-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-07-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_588_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_588_chunk (
    CONSTRAINT constraint_588 CHECK (((candle_start >= '2022-07-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-07-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_589_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_589_chunk (
    CONSTRAINT constraint_589 CHECK (((candle_start >= '2022-07-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-07-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_590_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_590_chunk (
    CONSTRAINT constraint_590 CHECK (((candle_start >= '2022-07-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-08-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_591_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_591_chunk (
    CONSTRAINT constraint_591 CHECK (((candle_start >= '2022-08-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-08-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_592_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_592_chunk (
    CONSTRAINT constraint_592 CHECK (((candle_start >= '2022-08-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-08-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_593_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_593_chunk (
    CONSTRAINT constraint_593 CHECK (((candle_start >= '2022-08-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-08-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_594_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_594_chunk (
    CONSTRAINT constraint_594 CHECK (((candle_start >= '2022-08-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-09-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_595_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_595_chunk (
    CONSTRAINT constraint_595 CHECK (((candle_start >= '2022-09-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-09-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_596_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_596_chunk (
    CONSTRAINT constraint_596 CHECK (((candle_start >= '2022-09-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-09-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_597_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_597_chunk (
    CONSTRAINT constraint_597 CHECK (((candle_start >= '2022-09-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-09-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_598_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_598_chunk (
    CONSTRAINT constraint_598 CHECK (((candle_start >= '2022-09-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-09-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_599_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_599_chunk (
    CONSTRAINT constraint_599 CHECK (((candle_start >= '2022-09-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-10-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_600_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_600_chunk (
    CONSTRAINT constraint_600 CHECK (((candle_start >= '2022-10-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-10-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_601_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_601_chunk (
    CONSTRAINT constraint_601 CHECK (((candle_start >= '2022-10-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-10-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_602_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_602_chunk (
    CONSTRAINT constraint_602 CHECK (((candle_start >= '2022-10-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-10-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_603_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_603_chunk (
    CONSTRAINT constraint_603 CHECK (((candle_start >= '2022-10-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-11-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_604_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_604_chunk (
    CONSTRAINT constraint_604 CHECK (((candle_start >= '2022-11-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-11-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_605_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_605_chunk (
    CONSTRAINT constraint_605 CHECK (((candle_start >= '2022-11-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-11-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_606_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_606_chunk (
    CONSTRAINT constraint_606 CHECK (((candle_start >= '2022-11-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-11-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_607_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_607_chunk (
    CONSTRAINT constraint_607 CHECK (((candle_start >= '2022-11-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-12-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_608_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_608_chunk (
    CONSTRAINT constraint_608 CHECK (((candle_start >= '2022-12-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-12-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_609_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_609_chunk (
    CONSTRAINT constraint_609 CHECK (((candle_start >= '2022-12-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-12-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_610_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_610_chunk (
    CONSTRAINT constraint_610 CHECK (((candle_start >= '2022-12-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-12-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_611_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_611_chunk (
    CONSTRAINT constraint_611 CHECK (((candle_start >= '2022-12-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2022-12-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_612_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_612_chunk (
    CONSTRAINT constraint_612 CHECK (((candle_start >= '2022-12-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-01-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_613_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_613_chunk (
    CONSTRAINT constraint_613 CHECK (((candle_start >= '2023-01-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-01-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_614_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_614_chunk (
    CONSTRAINT constraint_614 CHECK (((candle_start >= '2023-01-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-01-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_615_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_615_chunk (
    CONSTRAINT constraint_615 CHECK (((candle_start >= '2023-01-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-01-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_616_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_616_chunk (
    CONSTRAINT constraint_616 CHECK (((candle_start >= '2023-01-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-02-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_617_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_617_chunk (
    CONSTRAINT constraint_617 CHECK (((candle_start >= '2023-02-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-02-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_618_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_618_chunk (
    CONSTRAINT constraint_618 CHECK (((candle_start >= '2023-02-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-02-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_619_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_619_chunk (
    CONSTRAINT constraint_619 CHECK (((candle_start >= '2023-02-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-02-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_620_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_620_chunk (
    CONSTRAINT constraint_620 CHECK (((candle_start >= '2023-02-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-03-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_621_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_621_chunk (
    CONSTRAINT constraint_621 CHECK (((candle_start >= '2023-03-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-03-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_622_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_622_chunk (
    CONSTRAINT constraint_622 CHECK (((candle_start >= '2023-03-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-03-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_623_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_623_chunk (
    CONSTRAINT constraint_623 CHECK (((candle_start >= '2023-03-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-03-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_624_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_624_chunk (
    CONSTRAINT constraint_624 CHECK (((candle_start >= '2023-03-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-03-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_625_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_625_chunk (
    CONSTRAINT constraint_625 CHECK (((candle_start >= '2023-03-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-04-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_626_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_626_chunk (
    CONSTRAINT constraint_626 CHECK (((candle_start >= '2023-04-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-04-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_627_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_627_chunk (
    CONSTRAINT constraint_627 CHECK (((candle_start >= '2023-04-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-04-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_628_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_628_chunk (
    CONSTRAINT constraint_628 CHECK (((candle_start >= '2023-04-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-04-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_629_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_629_chunk (
    CONSTRAINT constraint_629 CHECK (((candle_start >= '2023-04-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-05-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_630_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_630_chunk (
    CONSTRAINT constraint_630 CHECK (((candle_start >= '2023-05-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-05-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_631_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_631_chunk (
    CONSTRAINT constraint_631 CHECK (((candle_start >= '2023-05-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-05-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_632_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_632_chunk (
    CONSTRAINT constraint_632 CHECK (((candle_start >= '2023-05-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-05-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_633_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_633_chunk (
    CONSTRAINT constraint_633 CHECK (((candle_start >= '2023-05-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-06-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_634_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_634_chunk (
    CONSTRAINT constraint_634 CHECK (((candle_start >= '2023-06-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-06-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_635_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_635_chunk (
    CONSTRAINT constraint_635 CHECK (((candle_start >= '2023-06-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-06-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_636_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_636_chunk (
    CONSTRAINT constraint_636 CHECK (((candle_start >= '2023-06-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-06-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_637_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_637_chunk (
    CONSTRAINT constraint_637 CHECK (((candle_start >= '2023-06-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-06-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_638_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_638_chunk (
    CONSTRAINT constraint_638 CHECK (((candle_start >= '2023-06-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-07-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_639_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_639_chunk (
    CONSTRAINT constraint_639 CHECK (((candle_start >= '2023-07-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-07-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_640_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_640_chunk (
    CONSTRAINT constraint_640 CHECK (((candle_start >= '2023-07-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-07-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_641_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_641_chunk (
    CONSTRAINT constraint_641 CHECK (((candle_start >= '2023-07-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-07-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_642_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_642_chunk (
    CONSTRAINT constraint_642 CHECK (((candle_start >= '2023-07-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-08-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_643_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_643_chunk (
    CONSTRAINT constraint_643 CHECK (((candle_start >= '2023-08-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-08-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_644_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_644_chunk (
    CONSTRAINT constraint_644 CHECK (((candle_start >= '2023-08-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-08-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_645_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_645_chunk (
    CONSTRAINT constraint_645 CHECK (((candle_start >= '2023-08-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-08-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_646_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_646_chunk (
    CONSTRAINT constraint_646 CHECK (((candle_start >= '2023-08-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-08-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_647_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_647_chunk (
    CONSTRAINT constraint_647 CHECK (((candle_start >= '2023-08-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-09-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_648_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_648_chunk (
    CONSTRAINT constraint_648 CHECK (((candle_start >= '2023-09-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-09-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_649_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_649_chunk (
    CONSTRAINT constraint_649 CHECK (((candle_start >= '2023-09-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-09-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_650_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_650_chunk (
    CONSTRAINT constraint_650 CHECK (((candle_start >= '2023-09-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-09-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_651_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_651_chunk (
    CONSTRAINT constraint_651 CHECK (((candle_start >= '2023-09-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-10-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_652_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_652_chunk (
    CONSTRAINT constraint_652 CHECK (((candle_start >= '2023-10-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-10-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_653_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_653_chunk (
    CONSTRAINT constraint_653 CHECK (((candle_start >= '2023-10-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-10-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_654_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_654_chunk (
    CONSTRAINT constraint_654 CHECK (((candle_start >= '2023-10-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-10-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_655_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_655_chunk (
    CONSTRAINT constraint_655 CHECK (((candle_start >= '2023-10-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-11-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_656_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_656_chunk (
    CONSTRAINT constraint_656 CHECK (((candle_start >= '2023-11-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-11-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_657_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_657_chunk (
    CONSTRAINT constraint_657 CHECK (((candle_start >= '2023-11-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-11-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_658_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_658_chunk (
    CONSTRAINT constraint_658 CHECK (((candle_start >= '2023-11-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-11-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_659_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_659_chunk (
    CONSTRAINT constraint_659 CHECK (((candle_start >= '2023-11-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-11-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_660_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_660_chunk (
    CONSTRAINT constraint_660 CHECK (((candle_start >= '2023-11-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-12-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_661_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_661_chunk (
    CONSTRAINT constraint_661 CHECK (((candle_start >= '2023-12-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-12-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_662_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_662_chunk (
    CONSTRAINT constraint_662 CHECK (((candle_start >= '2023-12-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-12-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_663_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_663_chunk (
    CONSTRAINT constraint_663 CHECK (((candle_start >= '2023-12-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2023-12-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_664_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_664_chunk (
    CONSTRAINT constraint_664 CHECK (((candle_start >= '2023-12-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-01-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_665_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_665_chunk (
    CONSTRAINT constraint_665 CHECK (((candle_start >= '2024-01-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-01-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_666_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_666_chunk (
    CONSTRAINT constraint_666 CHECK (((candle_start >= '2024-01-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-01-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_667_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_667_chunk (
    CONSTRAINT constraint_667 CHECK (((candle_start >= '2024-01-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-01-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_668_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_668_chunk (
    CONSTRAINT constraint_668 CHECK (((candle_start >= '2024-01-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-02-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_669_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_669_chunk (
    CONSTRAINT constraint_669 CHECK (((candle_start >= '2024-02-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-02-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_670_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_670_chunk (
    CONSTRAINT constraint_670 CHECK (((candle_start >= '2024-02-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-02-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_671_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_671_chunk (
    CONSTRAINT constraint_671 CHECK (((candle_start >= '2024-02-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-02-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_672_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_672_chunk (
    CONSTRAINT constraint_672 CHECK (((candle_start >= '2024-02-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-02-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_673_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_673_chunk (
    CONSTRAINT constraint_673 CHECK (((candle_start >= '2024-02-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-03-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_674_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_674_chunk (
    CONSTRAINT constraint_674 CHECK (((candle_start >= '2024-03-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-03-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_675_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_675_chunk (
    CONSTRAINT constraint_675 CHECK (((candle_start >= '2024-03-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-03-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_676_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_676_chunk (
    CONSTRAINT constraint_676 CHECK (((candle_start >= '2024-03-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-03-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_677_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_677_chunk (
    CONSTRAINT constraint_677 CHECK (((candle_start >= '2024-03-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-04-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_678_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_678_chunk (
    CONSTRAINT constraint_678 CHECK (((candle_start >= '2024-04-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-04-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_679_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_679_chunk (
    CONSTRAINT constraint_679 CHECK (((candle_start >= '2024-04-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-04-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_680_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_680_chunk (
    CONSTRAINT constraint_680 CHECK (((candle_start >= '2024-04-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-04-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_681_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_681_chunk (
    CONSTRAINT constraint_681 CHECK (((candle_start >= '2024-04-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-05-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_682_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_682_chunk (
    CONSTRAINT constraint_682 CHECK (((candle_start >= '2024-05-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-05-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_683_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_683_chunk (
    CONSTRAINT constraint_683 CHECK (((candle_start >= '2024-05-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-05-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_684_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_684_chunk (
    CONSTRAINT constraint_684 CHECK (((candle_start >= '2024-05-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-05-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_685_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_685_chunk (
    CONSTRAINT constraint_685 CHECK (((candle_start >= '2024-05-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-05-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_686_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_686_chunk (
    CONSTRAINT constraint_686 CHECK (((candle_start >= '2024-05-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-06-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_687_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_687_chunk (
    CONSTRAINT constraint_687 CHECK (((candle_start >= '2024-06-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-06-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_688_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_688_chunk (
    CONSTRAINT constraint_688 CHECK (((candle_start >= '2024-06-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-06-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_689_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_689_chunk (
    CONSTRAINT constraint_689 CHECK (((candle_start >= '2024-06-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-06-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_690_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_690_chunk (
    CONSTRAINT constraint_690 CHECK (((candle_start >= '2024-06-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-07-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_691_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_691_chunk (
    CONSTRAINT constraint_691 CHECK (((candle_start >= '2024-07-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-07-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_692_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_692_chunk (
    CONSTRAINT constraint_692 CHECK (((candle_start >= '2024-07-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-07-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_693_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_693_chunk (
    CONSTRAINT constraint_693 CHECK (((candle_start >= '2024-07-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-07-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_694_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_694_chunk (
    CONSTRAINT constraint_694 CHECK (((candle_start >= '2024-07-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-08-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_695_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_695_chunk (
    CONSTRAINT constraint_695 CHECK (((candle_start >= '2024-08-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-08-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_696_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_696_chunk (
    CONSTRAINT constraint_696 CHECK (((candle_start >= '2024-08-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-08-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_697_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_697_chunk (
    CONSTRAINT constraint_697 CHECK (((candle_start >= '2024-08-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-08-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_698_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_698_chunk (
    CONSTRAINT constraint_698 CHECK (((candle_start >= '2024-08-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-08-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_699_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_699_chunk (
    CONSTRAINT constraint_699 CHECK (((candle_start >= '2024-08-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-09-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_700_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_700_chunk (
    CONSTRAINT constraint_700 CHECK (((candle_start >= '2024-09-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-09-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_701_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_701_chunk (
    CONSTRAINT constraint_701 CHECK (((candle_start >= '2024-09-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-09-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_702_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_702_chunk (
    CONSTRAINT constraint_702 CHECK (((candle_start >= '2024-09-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-09-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_703_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_703_chunk (
    CONSTRAINT constraint_703 CHECK (((candle_start >= '2024-09-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-10-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_704_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_704_chunk (
    CONSTRAINT constraint_704 CHECK (((candle_start >= '2024-10-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-10-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_705_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_705_chunk (
    CONSTRAINT constraint_705 CHECK (((candle_start >= '2024-10-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-10-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_706_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_706_chunk (
    CONSTRAINT constraint_706 CHECK (((candle_start >= '2024-10-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-10-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_707_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_707_chunk (
    CONSTRAINT constraint_707 CHECK (((candle_start >= '2024-10-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-10-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_708_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_708_chunk (
    CONSTRAINT constraint_708 CHECK (((candle_start >= '2024-10-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-11-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_709_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_709_chunk (
    CONSTRAINT constraint_709 CHECK (((candle_start >= '2024-11-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-11-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_710_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_710_chunk (
    CONSTRAINT constraint_710 CHECK (((candle_start >= '2024-11-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-11-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_711_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_711_chunk (
    CONSTRAINT constraint_711 CHECK (((candle_start >= '2024-11-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-11-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_712_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_712_chunk (
    CONSTRAINT constraint_712 CHECK (((candle_start >= '2024-11-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_713_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_713_chunk (
    CONSTRAINT constraint_713 CHECK (((candle_start >= '2024-12-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_714_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_714_chunk (
    CONSTRAINT constraint_714 CHECK (((candle_start >= '2024-12-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_715_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_715_chunk (
    CONSTRAINT constraint_715 CHECK (((candle_start >= '2024-12-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2024-12-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_716_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_716_chunk (
    CONSTRAINT constraint_716 CHECK (((candle_start >= '2024-12-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_717_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_717_chunk (
    CONSTRAINT constraint_717 CHECK (((candle_start >= '2025-01-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_718_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_718_chunk (
    CONSTRAINT constraint_718 CHECK (((candle_start >= '2025-01-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_719_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_719_chunk (
    CONSTRAINT constraint_719 CHECK (((candle_start >= '2025-01-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_720_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_720_chunk (
    CONSTRAINT constraint_720 CHECK (((candle_start >= '2025-01-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-01-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_721_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_721_chunk (
    CONSTRAINT constraint_721 CHECK (((candle_start >= '2025-01-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_722_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_722_chunk (
    CONSTRAINT constraint_722 CHECK (((candle_start >= '2025-02-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_723_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_723_chunk (
    CONSTRAINT constraint_723 CHECK (((candle_start >= '2025-02-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_724_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_724_chunk (
    CONSTRAINT constraint_724 CHECK (((candle_start >= '2025-02-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-02-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_725_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_725_chunk (
    CONSTRAINT constraint_725 CHECK (((candle_start >= '2025-02-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_726_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_726_chunk (
    CONSTRAINT constraint_726 CHECK (((candle_start >= '2025-03-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_727_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_727_chunk (
    CONSTRAINT constraint_727 CHECK (((candle_start >= '2025-03-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_728_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_728_chunk (
    CONSTRAINT constraint_728 CHECK (((candle_start >= '2025-03-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-03-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_729_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_729_chunk (
    CONSTRAINT constraint_729 CHECK (((candle_start >= '2025-03-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_730_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_730_chunk (
    CONSTRAINT constraint_730 CHECK (((candle_start >= '2025-04-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_731_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_731_chunk (
    CONSTRAINT constraint_731 CHECK (((candle_start >= '2025-04-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_732_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_732_chunk (
    CONSTRAINT constraint_732 CHECK (((candle_start >= '2025-04-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-04-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_733_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_733_chunk (
    CONSTRAINT constraint_733 CHECK (((candle_start >= '2025-04-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_734_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_734_chunk (
    CONSTRAINT constraint_734 CHECK (((candle_start >= '2025-05-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_735_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_735_chunk (
    CONSTRAINT constraint_735 CHECK (((candle_start >= '2025-05-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_736_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_736_chunk (
    CONSTRAINT constraint_736 CHECK (((candle_start >= '2025-05-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_737_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_737_chunk (
    CONSTRAINT constraint_737 CHECK (((candle_start >= '2025-05-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-05-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_738_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_738_chunk (
    CONSTRAINT constraint_738 CHECK (((candle_start >= '2025-05-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_739_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_739_chunk (
    CONSTRAINT constraint_739 CHECK (((candle_start >= '2025-06-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_740_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_740_chunk (
    CONSTRAINT constraint_740 CHECK (((candle_start >= '2025-06-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_741_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_741_chunk (
    CONSTRAINT constraint_741 CHECK (((candle_start >= '2025-06-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-06-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_742_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_742_chunk (
    CONSTRAINT constraint_742 CHECK (((candle_start >= '2025-06-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_743_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_743_chunk (
    CONSTRAINT constraint_743 CHECK (((candle_start >= '2025-07-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_744_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_744_chunk (
    CONSTRAINT constraint_744 CHECK (((candle_start >= '2025-07-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_745_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_745_chunk (
    CONSTRAINT constraint_745 CHECK (((candle_start >= '2025-07-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_746_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_746_chunk (
    CONSTRAINT constraint_746 CHECK (((candle_start >= '2025-07-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-07-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_747_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_747_chunk (
    CONSTRAINT constraint_747 CHECK (((candle_start >= '2025-07-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_748_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_748_chunk (
    CONSTRAINT constraint_748 CHECK (((candle_start >= '2025-08-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_749_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_749_chunk (
    CONSTRAINT constraint_749 CHECK (((candle_start >= '2025-08-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_750_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_750_chunk (
    CONSTRAINT constraint_750 CHECK (((candle_start >= '2025-08-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-08-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_751_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_751_chunk (
    CONSTRAINT constraint_751 CHECK (((candle_start >= '2025-08-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_752_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_752_chunk (
    CONSTRAINT constraint_752 CHECK (((candle_start >= '2025-09-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_753_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_753_chunk (
    CONSTRAINT constraint_753 CHECK (((candle_start >= '2025-09-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_754_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_754_chunk (
    CONSTRAINT constraint_754 CHECK (((candle_start >= '2025-09-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-09-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_755_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_755_chunk (
    CONSTRAINT constraint_755 CHECK (((candle_start >= '2025-09-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_756_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_756_chunk (
    CONSTRAINT constraint_756 CHECK (((candle_start >= '2025-10-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_757_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_757_chunk (
    CONSTRAINT constraint_757 CHECK (((candle_start >= '2025-10-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_758_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_758_chunk (
    CONSTRAINT constraint_758 CHECK (((candle_start >= '2025-10-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_759_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_759_chunk (
    CONSTRAINT constraint_759 CHECK (((candle_start >= '2025-10-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-10-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_760_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_760_chunk (
    CONSTRAINT constraint_760 CHECK (((candle_start >= '2025-10-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_761_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_761_chunk (
    CONSTRAINT constraint_761 CHECK (((candle_start >= '2025-11-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_762_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_762_chunk (
    CONSTRAINT constraint_762 CHECK (((candle_start >= '2025-11-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_763_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_763_chunk (
    CONSTRAINT constraint_763 CHECK (((candle_start >= '2025-11-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-11-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_764_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_764_chunk (
    CONSTRAINT constraint_764 CHECK (((candle_start >= '2025-11-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_765_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_765_chunk (
    CONSTRAINT constraint_765 CHECK (((candle_start >= '2025-12-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_766_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_766_chunk (
    CONSTRAINT constraint_766 CHECK (((candle_start >= '2025-12-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_767_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_767_chunk (
    CONSTRAINT constraint_767 CHECK (((candle_start >= '2025-12-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2025-12-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_768_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_768_chunk (
    CONSTRAINT constraint_768 CHECK (((candle_start >= '2025-12-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_769_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_769_chunk (
    CONSTRAINT constraint_769 CHECK (((candle_start >= '2026-01-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_770_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_770_chunk (
    CONSTRAINT constraint_770 CHECK (((candle_start >= '2026-01-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_771_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_771_chunk (
    CONSTRAINT constraint_771 CHECK (((candle_start >= '2026-01-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_772_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_772_chunk (
    CONSTRAINT constraint_772 CHECK (((candle_start >= '2026-01-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2026-01-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_773_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_773_chunk (
    CONSTRAINT constraint_773 CHECK (((candle_start >= '2012-05-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-05-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_774_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_774_chunk (
    CONSTRAINT constraint_774 CHECK (((candle_start >= '2012-05-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-05-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_775_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_775_chunk (
    CONSTRAINT constraint_775 CHECK (((candle_start >= '2012-05-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-06-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_776_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_776_chunk (
    CONSTRAINT constraint_776 CHECK (((candle_start >= '2012-06-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-06-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_777_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_777_chunk (
    CONSTRAINT constraint_777 CHECK (((candle_start >= '2012-06-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-06-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_778_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_778_chunk (
    CONSTRAINT constraint_778 CHECK (((candle_start >= '2012-06-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-06-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_779_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_779_chunk (
    CONSTRAINT constraint_779 CHECK (((candle_start >= '2012-06-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-07-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_780_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_780_chunk (
    CONSTRAINT constraint_780 CHECK (((candle_start >= '2012-07-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-07-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_781_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_781_chunk (
    CONSTRAINT constraint_781 CHECK (((candle_start >= '2012-07-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-07-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_782_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_782_chunk (
    CONSTRAINT constraint_782 CHECK (((candle_start >= '2012-07-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-07-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_783_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_783_chunk (
    CONSTRAINT constraint_783 CHECK (((candle_start >= '2012-07-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-08-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_784_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_784_chunk (
    CONSTRAINT constraint_784 CHECK (((candle_start >= '2012-08-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-08-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_785_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_785_chunk (
    CONSTRAINT constraint_785 CHECK (((candle_start >= '2012-08-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-08-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_786_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_786_chunk (
    CONSTRAINT constraint_786 CHECK (((candle_start >= '2012-08-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-08-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_787_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_787_chunk (
    CONSTRAINT constraint_787 CHECK (((candle_start >= '2012-08-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-08-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_788_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_788_chunk (
    CONSTRAINT constraint_788 CHECK (((candle_start >= '2012-08-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-09-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_789_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_789_chunk (
    CONSTRAINT constraint_789 CHECK (((candle_start >= '2012-09-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-09-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_790_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_790_chunk (
    CONSTRAINT constraint_790 CHECK (((candle_start >= '2012-09-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-09-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_791_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_791_chunk (
    CONSTRAINT constraint_791 CHECK (((candle_start >= '2012-09-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-09-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_792_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_792_chunk (
    CONSTRAINT constraint_792 CHECK (((candle_start >= '2012-09-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-10-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_793_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_793_chunk (
    CONSTRAINT constraint_793 CHECK (((candle_start >= '2012-10-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-10-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_794_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_794_chunk (
    CONSTRAINT constraint_794 CHECK (((candle_start >= '2012-10-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-10-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_795_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_795_chunk (
    CONSTRAINT constraint_795 CHECK (((candle_start >= '2012-10-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-10-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_796_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_796_chunk (
    CONSTRAINT constraint_796 CHECK (((candle_start >= '2012-10-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-11-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_797_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_797_chunk (
    CONSTRAINT constraint_797 CHECK (((candle_start >= '2012-11-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-11-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_798_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_798_chunk (
    CONSTRAINT constraint_798 CHECK (((candle_start >= '2012-11-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-11-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_799_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_799_chunk (
    CONSTRAINT constraint_799 CHECK (((candle_start >= '2012-11-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-11-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_800_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_800_chunk (
    CONSTRAINT constraint_800 CHECK (((candle_start >= '2012-11-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-11-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_801_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_801_chunk (
    CONSTRAINT constraint_801 CHECK (((candle_start >= '2012-11-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-12-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_802_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_802_chunk (
    CONSTRAINT constraint_802 CHECK (((candle_start >= '2012-12-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-12-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_803_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_803_chunk (
    CONSTRAINT constraint_803 CHECK (((candle_start >= '2012-12-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-12-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_804_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_804_chunk (
    CONSTRAINT constraint_804 CHECK (((candle_start >= '2012-12-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2012-12-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_805_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_805_chunk (
    CONSTRAINT constraint_805 CHECK (((candle_start >= '2012-12-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-01-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_806_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_806_chunk (
    CONSTRAINT constraint_806 CHECK (((candle_start >= '2013-01-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-01-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_807_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_807_chunk (
    CONSTRAINT constraint_807 CHECK (((candle_start >= '2013-01-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-01-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_808_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_808_chunk (
    CONSTRAINT constraint_808 CHECK (((candle_start >= '2013-01-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-01-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_809_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_809_chunk (
    CONSTRAINT constraint_809 CHECK (((candle_start >= '2013-01-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-01-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_810_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_810_chunk (
    CONSTRAINT constraint_810 CHECK (((candle_start >= '2013-01-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-02-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_811_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_811_chunk (
    CONSTRAINT constraint_811 CHECK (((candle_start >= '2013-02-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-02-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_812_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_812_chunk (
    CONSTRAINT constraint_812 CHECK (((candle_start >= '2013-02-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-02-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_813_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_813_chunk (
    CONSTRAINT constraint_813 CHECK (((candle_start >= '2013-02-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-02-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_814_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_814_chunk (
    CONSTRAINT constraint_814 CHECK (((candle_start >= '2013-02-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-03-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_815_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_815_chunk (
    CONSTRAINT constraint_815 CHECK (((candle_start >= '2013-03-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-03-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_816_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_816_chunk (
    CONSTRAINT constraint_816 CHECK (((candle_start >= '2013-03-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-03-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_817_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_817_chunk (
    CONSTRAINT constraint_817 CHECK (((candle_start >= '2013-03-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-03-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_818_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_818_chunk (
    CONSTRAINT constraint_818 CHECK (((candle_start >= '2013-03-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-04-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_819_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_819_chunk (
    CONSTRAINT constraint_819 CHECK (((candle_start >= '2013-04-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-04-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_820_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_820_chunk (
    CONSTRAINT constraint_820 CHECK (((candle_start >= '2013-04-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-04-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_821_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_821_chunk (
    CONSTRAINT constraint_821 CHECK (((candle_start >= '2013-04-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-04-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_822_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_822_chunk (
    CONSTRAINT constraint_822 CHECK (((candle_start >= '2013-04-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-05-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_823_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_823_chunk (
    CONSTRAINT constraint_823 CHECK (((candle_start >= '2013-05-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-05-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_824_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_824_chunk (
    CONSTRAINT constraint_824 CHECK (((candle_start >= '2013-05-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-05-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_825_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_825_chunk (
    CONSTRAINT constraint_825 CHECK (((candle_start >= '2013-05-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-05-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_826_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_826_chunk (
    CONSTRAINT constraint_826 CHECK (((candle_start >= '2013-05-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-05-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_827_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_827_chunk (
    CONSTRAINT constraint_827 CHECK (((candle_start >= '2013-05-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-06-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_828_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_828_chunk (
    CONSTRAINT constraint_828 CHECK (((candle_start >= '2013-06-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-06-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_829_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_829_chunk (
    CONSTRAINT constraint_829 CHECK (((candle_start >= '2013-06-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-06-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_830_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_830_chunk (
    CONSTRAINT constraint_830 CHECK (((candle_start >= '2013-06-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-06-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_831_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_831_chunk (
    CONSTRAINT constraint_831 CHECK (((candle_start >= '2013-06-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-07-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_832_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_832_chunk (
    CONSTRAINT constraint_832 CHECK (((candle_start >= '2013-07-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-07-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_833_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_833_chunk (
    CONSTRAINT constraint_833 CHECK (((candle_start >= '2013-07-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-07-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_834_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_834_chunk (
    CONSTRAINT constraint_834 CHECK (((candle_start >= '2013-07-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-07-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_835_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_835_chunk (
    CONSTRAINT constraint_835 CHECK (((candle_start >= '2013-07-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-08-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_836_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_836_chunk (
    CONSTRAINT constraint_836 CHECK (((candle_start >= '2013-08-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-08-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_837_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_837_chunk (
    CONSTRAINT constraint_837 CHECK (((candle_start >= '2013-08-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-08-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_838_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_838_chunk (
    CONSTRAINT constraint_838 CHECK (((candle_start >= '2013-08-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-08-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_839_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_839_chunk (
    CONSTRAINT constraint_839 CHECK (((candle_start >= '2013-08-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-08-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_840_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_840_chunk (
    CONSTRAINT constraint_840 CHECK (((candle_start >= '2013-08-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-09-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_841_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_841_chunk (
    CONSTRAINT constraint_841 CHECK (((candle_start >= '2013-09-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-09-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_842_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_842_chunk (
    CONSTRAINT constraint_842 CHECK (((candle_start >= '2013-09-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-09-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_843_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_843_chunk (
    CONSTRAINT constraint_843 CHECK (((candle_start >= '2013-09-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-09-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_844_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_844_chunk (
    CONSTRAINT constraint_844 CHECK (((candle_start >= '2013-09-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-10-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_845_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_845_chunk (
    CONSTRAINT constraint_845 CHECK (((candle_start >= '2013-10-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-10-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_846_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_846_chunk (
    CONSTRAINT constraint_846 CHECK (((candle_start >= '2013-10-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-10-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_847_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_847_chunk (
    CONSTRAINT constraint_847 CHECK (((candle_start >= '2013-10-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-10-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_848_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_848_chunk (
    CONSTRAINT constraint_848 CHECK (((candle_start >= '2013-10-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-10-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_849_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_849_chunk (
    CONSTRAINT constraint_849 CHECK (((candle_start >= '2013-10-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-11-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_850_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_850_chunk (
    CONSTRAINT constraint_850 CHECK (((candle_start >= '2013-11-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-11-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_851_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_851_chunk (
    CONSTRAINT constraint_851 CHECK (((candle_start >= '2013-11-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-11-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_852_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_852_chunk (
    CONSTRAINT constraint_852 CHECK (((candle_start >= '2013-11-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-11-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_853_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_853_chunk (
    CONSTRAINT constraint_853 CHECK (((candle_start >= '2013-11-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-12-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_854_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_854_chunk (
    CONSTRAINT constraint_854 CHECK (((candle_start >= '2013-12-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-12-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_855_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_855_chunk (
    CONSTRAINT constraint_855 CHECK (((candle_start >= '2013-12-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-12-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_856_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_856_chunk (
    CONSTRAINT constraint_856 CHECK (((candle_start >= '2013-12-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2013-12-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_857_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_857_chunk (
    CONSTRAINT constraint_857 CHECK (((candle_start >= '2013-12-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-01-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_858_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_858_chunk (
    CONSTRAINT constraint_858 CHECK (((candle_start >= '2014-01-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-01-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_859_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_859_chunk (
    CONSTRAINT constraint_859 CHECK (((candle_start >= '2014-01-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-01-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_860_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_860_chunk (
    CONSTRAINT constraint_860 CHECK (((candle_start >= '2014-01-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-01-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_861_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_861_chunk (
    CONSTRAINT constraint_861 CHECK (((candle_start >= '2014-01-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-01-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_862_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_862_chunk (
    CONSTRAINT constraint_862 CHECK (((candle_start >= '2014-01-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-02-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_863_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_863_chunk (
    CONSTRAINT constraint_863 CHECK (((candle_start >= '2014-02-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-02-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_864_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_864_chunk (
    CONSTRAINT constraint_864 CHECK (((candle_start >= '2014-02-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-02-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_865_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_865_chunk (
    CONSTRAINT constraint_865 CHECK (((candle_start >= '2014-02-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-02-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_866_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_866_chunk (
    CONSTRAINT constraint_866 CHECK (((candle_start >= '2014-02-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-03-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_867_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_867_chunk (
    CONSTRAINT constraint_867 CHECK (((candle_start >= '2014-03-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-03-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_868_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_868_chunk (
    CONSTRAINT constraint_868 CHECK (((candle_start >= '2014-03-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-03-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_869_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_869_chunk (
    CONSTRAINT constraint_869 CHECK (((candle_start >= '2014-03-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-03-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_870_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_870_chunk (
    CONSTRAINT constraint_870 CHECK (((candle_start >= '2014-03-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-04-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_871_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_871_chunk (
    CONSTRAINT constraint_871 CHECK (((candle_start >= '2014-04-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-04-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_872_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_872_chunk (
    CONSTRAINT constraint_872 CHECK (((candle_start >= '2014-04-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-04-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_873_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_873_chunk (
    CONSTRAINT constraint_873 CHECK (((candle_start >= '2014-04-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-04-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_874_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_874_chunk (
    CONSTRAINT constraint_874 CHECK (((candle_start >= '2014-04-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-05-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_875_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_875_chunk (
    CONSTRAINT constraint_875 CHECK (((candle_start >= '2014-05-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-05-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_876_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_876_chunk (
    CONSTRAINT constraint_876 CHECK (((candle_start >= '2014-05-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-05-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_877_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_877_chunk (
    CONSTRAINT constraint_877 CHECK (((candle_start >= '2014-05-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-05-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_878_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_878_chunk (
    CONSTRAINT constraint_878 CHECK (((candle_start >= '2014-05-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-05-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_879_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_879_chunk (
    CONSTRAINT constraint_879 CHECK (((candle_start >= '2014-05-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-06-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_880_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_880_chunk (
    CONSTRAINT constraint_880 CHECK (((candle_start >= '2014-06-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-06-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_881_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_881_chunk (
    CONSTRAINT constraint_881 CHECK (((candle_start >= '2014-06-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-06-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_882_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_882_chunk (
    CONSTRAINT constraint_882 CHECK (((candle_start >= '2014-06-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-06-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_883_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_883_chunk (
    CONSTRAINT constraint_883 CHECK (((candle_start >= '2014-06-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-07-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_884_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_884_chunk (
    CONSTRAINT constraint_884 CHECK (((candle_start >= '2014-07-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-07-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_885_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_885_chunk (
    CONSTRAINT constraint_885 CHECK (((candle_start >= '2014-07-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-07-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_886_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_886_chunk (
    CONSTRAINT constraint_886 CHECK (((candle_start >= '2014-07-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-07-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_887_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_887_chunk (
    CONSTRAINT constraint_887 CHECK (((candle_start >= '2014-07-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-07-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_888_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_888_chunk (
    CONSTRAINT constraint_888 CHECK (((candle_start >= '2014-07-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-08-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_889_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_889_chunk (
    CONSTRAINT constraint_889 CHECK (((candle_start >= '2014-08-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-08-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_890_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_890_chunk (
    CONSTRAINT constraint_890 CHECK (((candle_start >= '2014-08-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-08-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_891_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_891_chunk (
    CONSTRAINT constraint_891 CHECK (((candle_start >= '2014-08-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-08-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_892_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_892_chunk (
    CONSTRAINT constraint_892 CHECK (((candle_start >= '2014-08-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-09-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_893_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_893_chunk (
    CONSTRAINT constraint_893 CHECK (((candle_start >= '2014-09-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-09-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_894_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_894_chunk (
    CONSTRAINT constraint_894 CHECK (((candle_start >= '2014-09-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-09-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_895_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_895_chunk (
    CONSTRAINT constraint_895 CHECK (((candle_start >= '2014-09-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-09-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_896_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_896_chunk (
    CONSTRAINT constraint_896 CHECK (((candle_start >= '2014-09-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-10-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_897_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_897_chunk (
    CONSTRAINT constraint_897 CHECK (((candle_start >= '2014-10-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-10-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_898_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_898_chunk (
    CONSTRAINT constraint_898 CHECK (((candle_start >= '2014-10-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-10-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_899_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_899_chunk (
    CONSTRAINT constraint_899 CHECK (((candle_start >= '2014-10-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-10-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_900_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_900_chunk (
    CONSTRAINT constraint_900 CHECK (((candle_start >= '2014-10-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-10-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_901_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_901_chunk (
    CONSTRAINT constraint_901 CHECK (((candle_start >= '2014-10-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-11-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_902_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_902_chunk (
    CONSTRAINT constraint_902 CHECK (((candle_start >= '2014-11-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-11-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_903_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_903_chunk (
    CONSTRAINT constraint_903 CHECK (((candle_start >= '2014-11-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-11-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_904_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_904_chunk (
    CONSTRAINT constraint_904 CHECK (((candle_start >= '2014-11-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-11-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_905_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_905_chunk (
    CONSTRAINT constraint_905 CHECK (((candle_start >= '2014-11-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-12-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_906_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_906_chunk (
    CONSTRAINT constraint_906 CHECK (((candle_start >= '2014-12-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-12-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_907_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_907_chunk (
    CONSTRAINT constraint_907 CHECK (((candle_start >= '2014-12-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-12-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_908_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_908_chunk (
    CONSTRAINT constraint_908 CHECK (((candle_start >= '2014-12-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2014-12-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_909_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_909_chunk (
    CONSTRAINT constraint_909 CHECK (((candle_start >= '2014-12-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-01-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_910_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_910_chunk (
    CONSTRAINT constraint_910 CHECK (((candle_start >= '2015-01-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-01-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_911_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_911_chunk (
    CONSTRAINT constraint_911 CHECK (((candle_start >= '2015-01-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-01-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_912_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_912_chunk (
    CONSTRAINT constraint_912 CHECK (((candle_start >= '2015-01-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-01-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_913_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_913_chunk (
    CONSTRAINT constraint_913 CHECK (((candle_start >= '2015-01-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-01-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_914_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_914_chunk (
    CONSTRAINT constraint_914 CHECK (((candle_start >= '2015-01-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-02-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_915_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_915_chunk (
    CONSTRAINT constraint_915 CHECK (((candle_start >= '2015-02-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-02-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_916_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_916_chunk (
    CONSTRAINT constraint_916 CHECK (((candle_start >= '2015-02-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-02-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_917_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_917_chunk (
    CONSTRAINT constraint_917 CHECK (((candle_start >= '2015-02-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-02-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_918_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_918_chunk (
    CONSTRAINT constraint_918 CHECK (((candle_start >= '2015-02-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-03-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_919_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_919_chunk (
    CONSTRAINT constraint_919 CHECK (((candle_start >= '2015-03-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-03-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_920_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_920_chunk (
    CONSTRAINT constraint_920 CHECK (((candle_start >= '2015-03-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-03-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_921_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_921_chunk (
    CONSTRAINT constraint_921 CHECK (((candle_start >= '2015-03-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-03-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_922_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_922_chunk (
    CONSTRAINT constraint_922 CHECK (((candle_start >= '2015-03-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-04-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_923_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_923_chunk (
    CONSTRAINT constraint_923 CHECK (((candle_start >= '2015-04-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-04-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_924_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_924_chunk (
    CONSTRAINT constraint_924 CHECK (((candle_start >= '2015-04-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-04-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_925_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_925_chunk (
    CONSTRAINT constraint_925 CHECK (((candle_start >= '2015-04-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-04-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_926_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_926_chunk (
    CONSTRAINT constraint_926 CHECK (((candle_start >= '2015-04-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-04-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_927_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_927_chunk (
    CONSTRAINT constraint_927 CHECK (((candle_start >= '2015-04-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-05-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_928_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_928_chunk (
    CONSTRAINT constraint_928 CHECK (((candle_start >= '2015-05-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-05-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_929_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_929_chunk (
    CONSTRAINT constraint_929 CHECK (((candle_start >= '2015-05-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-05-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_930_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_930_chunk (
    CONSTRAINT constraint_930 CHECK (((candle_start >= '2015-05-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-05-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_931_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_931_chunk (
    CONSTRAINT constraint_931 CHECK (((candle_start >= '2015-05-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-06-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_932_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_932_chunk (
    CONSTRAINT constraint_932 CHECK (((candle_start >= '2015-06-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-06-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_933_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_933_chunk (
    CONSTRAINT constraint_933 CHECK (((candle_start >= '2015-06-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-06-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_934_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_934_chunk (
    CONSTRAINT constraint_934 CHECK (((candle_start >= '2015-06-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-06-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_935_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_935_chunk (
    CONSTRAINT constraint_935 CHECK (((candle_start >= '2015-06-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-07-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_936_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_936_chunk (
    CONSTRAINT constraint_936 CHECK (((candle_start >= '2015-07-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-07-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_937_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_937_chunk (
    CONSTRAINT constraint_937 CHECK (((candle_start >= '2015-07-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-07-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_938_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_938_chunk (
    CONSTRAINT constraint_938 CHECK (((candle_start >= '2015-07-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-07-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_939_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_939_chunk (
    CONSTRAINT constraint_939 CHECK (((candle_start >= '2015-07-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-07-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_940_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_940_chunk (
    CONSTRAINT constraint_940 CHECK (((candle_start >= '2015-07-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-08-06 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_941_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_941_chunk (
    CONSTRAINT constraint_941 CHECK (((candle_start >= '2015-08-06 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-08-13 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_942_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_942_chunk (
    CONSTRAINT constraint_942 CHECK (((candle_start >= '2015-08-13 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-08-20 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_943_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_943_chunk (
    CONSTRAINT constraint_943 CHECK (((candle_start >= '2015-08-20 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-08-27 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_944_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_944_chunk (
    CONSTRAINT constraint_944 CHECK (((candle_start >= '2015-08-27 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-09-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_945_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_945_chunk (
    CONSTRAINT constraint_945 CHECK (((candle_start >= '2015-09-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-09-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_946_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_946_chunk (
    CONSTRAINT constraint_946 CHECK (((candle_start >= '2015-09-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-09-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_947_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_947_chunk (
    CONSTRAINT constraint_947 CHECK (((candle_start >= '2015-09-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-09-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_948_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_948_chunk (
    CONSTRAINT constraint_948 CHECK (((candle_start >= '2015-09-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-10-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_949_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_949_chunk (
    CONSTRAINT constraint_949 CHECK (((candle_start >= '2015-10-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-10-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_950_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_950_chunk (
    CONSTRAINT constraint_950 CHECK (((candle_start >= '2015-10-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-10-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_951_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_951_chunk (
    CONSTRAINT constraint_951 CHECK (((candle_start >= '2015-10-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-10-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_952_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_952_chunk (
    CONSTRAINT constraint_952 CHECK (((candle_start >= '2015-10-22 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-10-29 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_953_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_953_chunk (
    CONSTRAINT constraint_953 CHECK (((candle_start >= '2015-10-29 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-11-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_954_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_954_chunk (
    CONSTRAINT constraint_954 CHECK (((candle_start >= '2015-11-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-11-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_955_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_955_chunk (
    CONSTRAINT constraint_955 CHECK (((candle_start >= '2015-11-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-11-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_956_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_956_chunk (
    CONSTRAINT constraint_956 CHECK (((candle_start >= '2015-11-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-11-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_957_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_957_chunk (
    CONSTRAINT constraint_957 CHECK (((candle_start >= '2015-11-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-12-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_958_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_958_chunk (
    CONSTRAINT constraint_958 CHECK (((candle_start >= '2015-12-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-12-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_959_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_959_chunk (
    CONSTRAINT constraint_959 CHECK (((candle_start >= '2015-12-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-12-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_960_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_960_chunk (
    CONSTRAINT constraint_960 CHECK (((candle_start >= '2015-12-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-12-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_961_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_961_chunk (
    CONSTRAINT constraint_961 CHECK (((candle_start >= '2015-12-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2015-12-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_962_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_962_chunk (
    CONSTRAINT constraint_962 CHECK (((candle_start >= '2015-12-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-01-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_963_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_963_chunk (
    CONSTRAINT constraint_963 CHECK (((candle_start >= '2016-01-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-01-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_964_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_964_chunk (
    CONSTRAINT constraint_964 CHECK (((candle_start >= '2016-01-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-01-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_965_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_965_chunk (
    CONSTRAINT constraint_965 CHECK (((candle_start >= '2016-01-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-01-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_966_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_966_chunk (
    CONSTRAINT constraint_966 CHECK (((candle_start >= '2016-01-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-02-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_967_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_967_chunk (
    CONSTRAINT constraint_967 CHECK (((candle_start >= '2016-02-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-02-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_968_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_968_chunk (
    CONSTRAINT constraint_968 CHECK (((candle_start >= '2016-02-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-02-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_969_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_969_chunk (
    CONSTRAINT constraint_969 CHECK (((candle_start >= '2016-02-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-02-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_970_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_970_chunk (
    CONSTRAINT constraint_970 CHECK (((candle_start >= '2016-02-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-03-03 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_971_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_971_chunk (
    CONSTRAINT constraint_971 CHECK (((candle_start >= '2016-03-03 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-03-10 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_972_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_972_chunk (
    CONSTRAINT constraint_972 CHECK (((candle_start >= '2016-03-10 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-03-17 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_973_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_973_chunk (
    CONSTRAINT constraint_973 CHECK (((candle_start >= '2016-03-17 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-03-24 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_974_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_974_chunk (
    CONSTRAINT constraint_974 CHECK (((candle_start >= '2016-03-24 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-03-31 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_975_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_975_chunk (
    CONSTRAINT constraint_975 CHECK (((candle_start >= '2016-03-31 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-04-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_976_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_976_chunk (
    CONSTRAINT constraint_976 CHECK (((candle_start >= '2016-04-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-04-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_977_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_977_chunk (
    CONSTRAINT constraint_977 CHECK (((candle_start >= '2016-04-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-04-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_978_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_978_chunk (
    CONSTRAINT constraint_978 CHECK (((candle_start >= '2016-04-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-04-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_979_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_979_chunk (
    CONSTRAINT constraint_979 CHECK (((candle_start >= '2016-04-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-05-05 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_980_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_980_chunk (
    CONSTRAINT constraint_980 CHECK (((candle_start >= '2016-05-05 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-05-12 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_981_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_981_chunk (
    CONSTRAINT constraint_981 CHECK (((candle_start >= '2016-05-12 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-05-19 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_982_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_982_chunk (
    CONSTRAINT constraint_982 CHECK (((candle_start >= '2016-05-19 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-05-26 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_983_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_983_chunk (
    CONSTRAINT constraint_983 CHECK (((candle_start >= '2016-05-26 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-06-02 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_984_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_984_chunk (
    CONSTRAINT constraint_984 CHECK (((candle_start >= '2016-06-02 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-06-09 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_985_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_985_chunk (
    CONSTRAINT constraint_985 CHECK (((candle_start >= '2016-06-09 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-06-16 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_986_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_986_chunk (
    CONSTRAINT constraint_986 CHECK (((candle_start >= '2016-06-16 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-06-23 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_987_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_987_chunk (
    CONSTRAINT constraint_987 CHECK (((candle_start >= '2016-06-23 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-06-30 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_988_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_988_chunk (
    CONSTRAINT constraint_988 CHECK (((candle_start >= '2016-06-30 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-07-07 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_989_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_989_chunk (
    CONSTRAINT constraint_989 CHECK (((candle_start >= '2016-07-07 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-07-14 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_990_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_990_chunk (
    CONSTRAINT constraint_990 CHECK (((candle_start >= '2016-07-14 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-07-21 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_991_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_991_chunk (
    CONSTRAINT constraint_991 CHECK (((candle_start >= '2016-07-21 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-07-28 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_992_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_992_chunk (
    CONSTRAINT constraint_992 CHECK (((candle_start >= '2016-07-28 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-08-04 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_993_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_993_chunk (
    CONSTRAINT constraint_993 CHECK (((candle_start >= '2016-08-04 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-08-11 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_994_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_994_chunk (
    CONSTRAINT constraint_994 CHECK (((candle_start >= '2016-08-11 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-08-18 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_995_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_995_chunk (
    CONSTRAINT constraint_995 CHECK (((candle_start >= '2016-08-18 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-08-25 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_996_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_996_chunk (
    CONSTRAINT constraint_996 CHECK (((candle_start >= '2016-08-25 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-09-01 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_997_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_997_chunk (
    CONSTRAINT constraint_997 CHECK (((candle_start >= '2016-09-01 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-09-08 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_998_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_998_chunk (
    CONSTRAINT constraint_998 CHECK (((candle_start >= '2016-09-08 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-09-15 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: _hyper_2_999_chunk; Type: TABLE; Schema: _timescaledb_internal; Owner: -
--

CREATE TABLE _timescaledb_internal._hyper_2_999_chunk (
    CONSTRAINT constraint_999 CHECK (((candle_start >= '2016-09-15 05:30:00+05:30'::timestamp with time zone) AND (candle_start < '2016-09-22 05:30:00+05:30'::timestamp with time zone)))
)
INHERITS (ohlc.candles_1d);


--
-- Name: job_run; Type: TABLE; Schema: audit; Owner: -
--

CREATE TABLE audit.job_run (
    job_run_id bigint NOT NULL,
    job_name text NOT NULL,
    status text NOT NULL,
    start_time timestamp with time zone DEFAULT now(),
    end_time timestamp with time zone,
    rows_affected integer,
    message text
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
-- Name: indices_daily; Type: TABLE; Schema: ohlc; Owner: -
--

CREATE TABLE ohlc.indices_daily (
    index_name character varying NOT NULL,
    trade_date date NOT NULL,
    open_value double precision,
    high_value double precision,
    low_value double precision,
    close_value double precision,
    volume bigint,
    pe_ratio double precision,
    pb_ratio double precision,
    div_yield double precision,
    points_change double precision,
    change_pct double precision,
    turnover_cr double precision
);


--
-- Name: market_data_daily; Type: TABLE; Schema: ohlc; Owner: -
--

CREATE TABLE ohlc.market_data_daily (
    symbol character varying NOT NULL,
    trade_date date NOT NULL,
    series character varying,
    open_price double precision,
    high_price double precision,
    low_price double precision,
    close_price double precision,
    volume bigint,
    delivery_qty bigint,
    delivery_pct double precision,
    prev_close double precision,
    last_price double precision,
    avg_price double precision,
    turnover_lacs double precision,
    no_of_trades bigint
);


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
    stock_symbol text NOT NULL,
    created_at character varying(50)
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
    created_at timestamp with time zone DEFAULT now(),
    mapping_id integer,
    stock_symbol character varying(50)
);


--
-- Name: strategies; Type: TABLE; Schema: ref; Owner: -
--

CREATE TABLE ref.strategies (
    strategy_id integer NOT NULL,
    name text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: strategies_strategy_id_seq; Type: SEQUENCE; Schema: ref; Owner: -
--

CREATE SEQUENCE ref.strategies_strategy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: strategies_strategy_id_seq; Type: SEQUENCE OWNED BY; Schema: ref; Owner: -
--

ALTER SEQUENCE ref.strategies_strategy_id_seq OWNED BY ref.strategies.strategy_id;


--
-- Name: symbol; Type: TABLE; Schema: ref; Owner: -
--

CREATE TABLE ref.symbol (
    symbol_id bigint NOT NULL,
    exchange_code text NOT NULL,
    symbol text NOT NULL,
    trading_symbol text NOT NULL,
    instrument_token integer NOT NULL,
    segment text,
    lot_size integer,
    is_index boolean DEFAULT false,
    is_active boolean DEFAULT true,
    is_index_constituent boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
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
-- Name: broker_configs; Type: TABLE; Schema: sys; Owner: -
--

CREATE TABLE sys.broker_configs (
    provider text NOT NULL,
    skip_rows integer DEFAULT 0,
    header_row integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    skip_cols integer DEFAULT 0
);


--
-- Name: csv_mappings; Type: TABLE; Schema: sys; Owner: -
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


--
-- Name: csv_mappings_id_seq; Type: SEQUENCE; Schema: sys; Owner: -
--

CREATE SEQUENCE sys.csv_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: csv_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: sys; Owner: -
--

ALTER SEQUENCE sys.csv_mappings_id_seq OWNED BY sys.csv_mappings.id;


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
    log_path text,
    duration_seconds numeric(10,2),
    exit_message text,
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
    source_universe text DEFAULT 'Nifty 50'::text,
    logic_config jsonb NOT NULL,
    schedule_cron text,
    last_run_at timestamp with time zone,
    last_match_count integer DEFAULT 0,
    last_run_stats jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_active boolean DEFAULT true
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
    created_at timestamp with time zone DEFAULT now(),
    account_id text DEFAULT 'default'::text
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
    created_at timestamp with time zone DEFAULT now(),
    account_id text DEFAULT 'default'::text
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
    created_at timestamp with time zone DEFAULT now(),
    account_id text DEFAULT 'default'::text,
    strategy_name text DEFAULT 'Open'::text
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
    created_at timestamp with time zone DEFAULT now(),
    account_id text DEFAULT 'default'::text
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
    run_date timestamp with time zone NOT NULL,
    symbol text NOT NULL,
    match_data jsonb NOT NULL,
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
    holder_name text DEFAULT 'Primary'::text,
    strategy_name text DEFAULT 'Manual'::text,
    trade_date timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    broker_name text DEFAULT 'Zerodha'::text,
    isin text,
    product_type text DEFAULT 'CNC'::text NOT NULL,
    total_charges numeric(10,2) DEFAULT 0,
    net_amount numeric(14,2),
    currency text DEFAULT 'INR'::text,
    notes text,
    account_id text DEFAULT 'default'::text,
    exchange text,
    txn_type text,
    fees numeric DEFAULT 0,
    source text,
    external_trade_id text,
    order_id text,
    segment text,
    series text,
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
-- Name: job_run job_run_id; Type: DEFAULT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.job_run ALTER COLUMN job_run_id SET DEFAULT nextval('audit.job_run_job_run_id_seq'::regclass);


--
-- Name: index_mapping mapping_id; Type: DEFAULT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.index_mapping ALTER COLUMN mapping_id SET DEFAULT nextval('ref.index_mapping_mapping_id_seq'::regclass);


--
-- Name: strategies strategy_id; Type: DEFAULT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.strategies ALTER COLUMN strategy_id SET DEFAULT nextval('ref.strategies_strategy_id_seq'::regclass);


--
-- Name: symbol symbol_id; Type: DEFAULT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.symbol ALTER COLUMN symbol_id SET DEFAULT nextval('ref.symbol_symbol_id_seq'::regclass);


--
-- Name: app_logs id; Type: DEFAULT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.app_logs ALTER COLUMN id SET DEFAULT nextval('sys.app_logs_id_seq'::regclass);


--
-- Name: csv_mappings id; Type: DEFAULT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.csv_mappings ALTER COLUMN id SET DEFAULT nextval('sys.csv_mappings_id_seq'::regclass);


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
-- Name: _hyper_2_1000_chunk 1000_1000_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1000_chunk
    ADD CONSTRAINT "1000_1000_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1001_chunk 1001_1001_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1001_chunk
    ADD CONSTRAINT "1001_1001_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1002_chunk 1002_1002_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1002_chunk
    ADD CONSTRAINT "1002_1002_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1003_chunk 1003_1003_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1003_chunk
    ADD CONSTRAINT "1003_1003_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1004_chunk 1004_1004_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1004_chunk
    ADD CONSTRAINT "1004_1004_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1005_chunk 1005_1005_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1005_chunk
    ADD CONSTRAINT "1005_1005_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1006_chunk 1006_1006_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1006_chunk
    ADD CONSTRAINT "1006_1006_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1007_chunk 1007_1007_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1007_chunk
    ADD CONSTRAINT "1007_1007_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1008_chunk 1008_1008_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1008_chunk
    ADD CONSTRAINT "1008_1008_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1009_chunk 1009_1009_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1009_chunk
    ADD CONSTRAINT "1009_1009_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1010_chunk 1010_1010_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1010_chunk
    ADD CONSTRAINT "1010_1010_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1011_chunk 1011_1011_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1011_chunk
    ADD CONSTRAINT "1011_1011_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1012_chunk 1012_1012_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1012_chunk
    ADD CONSTRAINT "1012_1012_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1013_chunk 1013_1013_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1013_chunk
    ADD CONSTRAINT "1013_1013_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1014_chunk 1014_1014_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1014_chunk
    ADD CONSTRAINT "1014_1014_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1015_chunk 1015_1015_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1015_chunk
    ADD CONSTRAINT "1015_1015_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1016_chunk 1016_1016_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1016_chunk
    ADD CONSTRAINT "1016_1016_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1017_chunk 1017_1017_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1017_chunk
    ADD CONSTRAINT "1017_1017_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1018_chunk 1018_1018_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1018_chunk
    ADD CONSTRAINT "1018_1018_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1019_chunk 1019_1019_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1019_chunk
    ADD CONSTRAINT "1019_1019_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1020_chunk 1020_1020_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1020_chunk
    ADD CONSTRAINT "1020_1020_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1021_chunk 1021_1021_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1021_chunk
    ADD CONSTRAINT "1021_1021_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1022_chunk 1022_1022_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1022_chunk
    ADD CONSTRAINT "1022_1022_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1023_chunk 1023_1023_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1023_chunk
    ADD CONSTRAINT "1023_1023_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1024_chunk 1024_1024_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1024_chunk
    ADD CONSTRAINT "1024_1024_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1025_chunk 1025_1025_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1025_chunk
    ADD CONSTRAINT "1025_1025_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1026_chunk 1026_1026_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1026_chunk
    ADD CONSTRAINT "1026_1026_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1027_chunk 1027_1027_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1027_chunk
    ADD CONSTRAINT "1027_1027_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1028_chunk 1028_1028_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1028_chunk
    ADD CONSTRAINT "1028_1028_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1029_chunk 1029_1029_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1029_chunk
    ADD CONSTRAINT "1029_1029_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1030_chunk 1030_1030_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1030_chunk
    ADD CONSTRAINT "1030_1030_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1031_chunk 1031_1031_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1031_chunk
    ADD CONSTRAINT "1031_1031_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1032_chunk 1032_1032_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1032_chunk
    ADD CONSTRAINT "1032_1032_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1033_chunk 1033_1033_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1033_chunk
    ADD CONSTRAINT "1033_1033_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1034_chunk 1034_1034_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1034_chunk
    ADD CONSTRAINT "1034_1034_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1035_chunk 1035_1035_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1035_chunk
    ADD CONSTRAINT "1035_1035_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1036_chunk 1036_1036_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1036_chunk
    ADD CONSTRAINT "1036_1036_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1037_chunk 1037_1037_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1037_chunk
    ADD CONSTRAINT "1037_1037_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1038_chunk 1038_1038_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1038_chunk
    ADD CONSTRAINT "1038_1038_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1039_chunk 1039_1039_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1039_chunk
    ADD CONSTRAINT "1039_1039_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1040_chunk 1040_1040_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1040_chunk
    ADD CONSTRAINT "1040_1040_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1041_chunk 1041_1041_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1041_chunk
    ADD CONSTRAINT "1041_1041_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1042_chunk 1042_1042_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1042_chunk
    ADD CONSTRAINT "1042_1042_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1043_chunk 1043_1043_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1043_chunk
    ADD CONSTRAINT "1043_1043_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1044_chunk 1044_1044_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1044_chunk
    ADD CONSTRAINT "1044_1044_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1045_chunk 1045_1045_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1045_chunk
    ADD CONSTRAINT "1045_1045_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1046_chunk 1046_1046_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1046_chunk
    ADD CONSTRAINT "1046_1046_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1047_chunk 1047_1047_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1047_chunk
    ADD CONSTRAINT "1047_1047_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1048_chunk 1048_1048_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1048_chunk
    ADD CONSTRAINT "1048_1048_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1049_chunk 1049_1049_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1049_chunk
    ADD CONSTRAINT "1049_1049_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1050_chunk 1050_1050_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1050_chunk
    ADD CONSTRAINT "1050_1050_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1051_chunk 1051_1051_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1051_chunk
    ADD CONSTRAINT "1051_1051_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1052_chunk 1052_1052_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1052_chunk
    ADD CONSTRAINT "1052_1052_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1053_chunk 1053_1053_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1053_chunk
    ADD CONSTRAINT "1053_1053_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1054_chunk 1054_1054_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1054_chunk
    ADD CONSTRAINT "1054_1054_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1055_chunk 1055_1055_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1055_chunk
    ADD CONSTRAINT "1055_1055_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1056_chunk 1056_1056_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1056_chunk
    ADD CONSTRAINT "1056_1056_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1057_chunk 1057_1057_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1057_chunk
    ADD CONSTRAINT "1057_1057_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1058_chunk 1058_1058_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1058_chunk
    ADD CONSTRAINT "1058_1058_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1059_chunk 1059_1059_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1059_chunk
    ADD CONSTRAINT "1059_1059_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1060_chunk 1060_1060_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1060_chunk
    ADD CONSTRAINT "1060_1060_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1061_chunk 1061_1061_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1061_chunk
    ADD CONSTRAINT "1061_1061_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1062_chunk 1062_1062_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1062_chunk
    ADD CONSTRAINT "1062_1062_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1063_chunk 1063_1063_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1063_chunk
    ADD CONSTRAINT "1063_1063_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1064_chunk 1064_1064_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1064_chunk
    ADD CONSTRAINT "1064_1064_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1065_chunk 1065_1065_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1065_chunk
    ADD CONSTRAINT "1065_1065_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1066_chunk 1066_1066_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1066_chunk
    ADD CONSTRAINT "1066_1066_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1067_chunk 1067_1067_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1067_chunk
    ADD CONSTRAINT "1067_1067_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1068_chunk 1068_1068_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1068_chunk
    ADD CONSTRAINT "1068_1068_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1069_chunk 1069_1069_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1069_chunk
    ADD CONSTRAINT "1069_1069_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1070_chunk 1070_1070_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1070_chunk
    ADD CONSTRAINT "1070_1070_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1071_chunk 1071_1071_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1071_chunk
    ADD CONSTRAINT "1071_1071_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1072_chunk 1072_1072_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1072_chunk
    ADD CONSTRAINT "1072_1072_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1073_chunk 1073_1073_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1073_chunk
    ADD CONSTRAINT "1073_1073_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1074_chunk 1074_1074_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1074_chunk
    ADD CONSTRAINT "1074_1074_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1075_chunk 1075_1075_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1075_chunk
    ADD CONSTRAINT "1075_1075_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1076_chunk 1076_1076_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1076_chunk
    ADD CONSTRAINT "1076_1076_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1077_chunk 1077_1077_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1077_chunk
    ADD CONSTRAINT "1077_1077_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1078_chunk 1078_1078_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1078_chunk
    ADD CONSTRAINT "1078_1078_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1079_chunk 1079_1079_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1079_chunk
    ADD CONSTRAINT "1079_1079_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1080_chunk 1080_1080_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1080_chunk
    ADD CONSTRAINT "1080_1080_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1081_chunk 1081_1081_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1081_chunk
    ADD CONSTRAINT "1081_1081_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1082_chunk 1082_1082_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1082_chunk
    ADD CONSTRAINT "1082_1082_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1083_chunk 1083_1083_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1083_chunk
    ADD CONSTRAINT "1083_1083_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1084_chunk 1084_1084_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1084_chunk
    ADD CONSTRAINT "1084_1084_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1085_chunk 1085_1085_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1085_chunk
    ADD CONSTRAINT "1085_1085_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1086_chunk 1086_1086_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1086_chunk
    ADD CONSTRAINT "1086_1086_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1087_chunk 1087_1087_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1087_chunk
    ADD CONSTRAINT "1087_1087_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1088_chunk 1088_1088_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1088_chunk
    ADD CONSTRAINT "1088_1088_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1089_chunk 1089_1089_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1089_chunk
    ADD CONSTRAINT "1089_1089_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1090_chunk 1090_1090_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1090_chunk
    ADD CONSTRAINT "1090_1090_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1091_chunk 1091_1091_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1091_chunk
    ADD CONSTRAINT "1091_1091_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1092_chunk 1092_1092_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1092_chunk
    ADD CONSTRAINT "1092_1092_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1093_chunk 1093_1093_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1093_chunk
    ADD CONSTRAINT "1093_1093_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1094_chunk 1094_1094_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1094_chunk
    ADD CONSTRAINT "1094_1094_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1095_chunk 1095_1095_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1095_chunk
    ADD CONSTRAINT "1095_1095_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1096_chunk 1096_1096_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1096_chunk
    ADD CONSTRAINT "1096_1096_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1097_chunk 1097_1097_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1097_chunk
    ADD CONSTRAINT "1097_1097_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1098_chunk 1098_1098_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1098_chunk
    ADD CONSTRAINT "1098_1098_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1099_chunk 1099_1099_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1099_chunk
    ADD CONSTRAINT "1099_1099_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1100_chunk 1100_1100_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1100_chunk
    ADD CONSTRAINT "1100_1100_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1101_chunk 1101_1101_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1101_chunk
    ADD CONSTRAINT "1101_1101_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1102_chunk 1102_1102_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1102_chunk
    ADD CONSTRAINT "1102_1102_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1103_chunk 1103_1103_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1103_chunk
    ADD CONSTRAINT "1103_1103_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1104_chunk 1104_1104_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1104_chunk
    ADD CONSTRAINT "1104_1104_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1105_chunk 1105_1105_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1105_chunk
    ADD CONSTRAINT "1105_1105_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1106_chunk 1106_1106_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1106_chunk
    ADD CONSTRAINT "1106_1106_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1107_chunk 1107_1107_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1107_chunk
    ADD CONSTRAINT "1107_1107_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1108_chunk 1108_1108_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1108_chunk
    ADD CONSTRAINT "1108_1108_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1109_chunk 1109_1109_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1109_chunk
    ADD CONSTRAINT "1109_1109_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1110_chunk 1110_1110_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1110_chunk
    ADD CONSTRAINT "1110_1110_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1111_chunk 1111_1111_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1111_chunk
    ADD CONSTRAINT "1111_1111_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1112_chunk 1112_1112_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1112_chunk
    ADD CONSTRAINT "1112_1112_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1113_chunk 1113_1113_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1113_chunk
    ADD CONSTRAINT "1113_1113_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1114_chunk 1114_1114_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1114_chunk
    ADD CONSTRAINT "1114_1114_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1115_chunk 1115_1115_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1115_chunk
    ADD CONSTRAINT "1115_1115_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1116_chunk 1116_1116_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1116_chunk
    ADD CONSTRAINT "1116_1116_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1117_chunk 1117_1117_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1117_chunk
    ADD CONSTRAINT "1117_1117_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1118_chunk 1118_1118_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1118_chunk
    ADD CONSTRAINT "1118_1118_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1119_chunk 1119_1119_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1119_chunk
    ADD CONSTRAINT "1119_1119_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1120_chunk 1120_1120_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1120_chunk
    ADD CONSTRAINT "1120_1120_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1121_chunk 1121_1121_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1121_chunk
    ADD CONSTRAINT "1121_1121_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1122_chunk 1122_1122_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1122_chunk
    ADD CONSTRAINT "1122_1122_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1123_chunk 1123_1123_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1123_chunk
    ADD CONSTRAINT "1123_1123_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1124_chunk 1124_1124_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1124_chunk
    ADD CONSTRAINT "1124_1124_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1125_chunk 1125_1125_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1125_chunk
    ADD CONSTRAINT "1125_1125_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1126_chunk 1126_1126_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1126_chunk
    ADD CONSTRAINT "1126_1126_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1127_chunk 1127_1127_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1127_chunk
    ADD CONSTRAINT "1127_1127_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1128_chunk 1128_1128_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1128_chunk
    ADD CONSTRAINT "1128_1128_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1129_chunk 1129_1129_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1129_chunk
    ADD CONSTRAINT "1129_1129_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1130_chunk 1130_1130_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1130_chunk
    ADD CONSTRAINT "1130_1130_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1131_chunk 1131_1131_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1131_chunk
    ADD CONSTRAINT "1131_1131_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1132_chunk 1132_1132_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1132_chunk
    ADD CONSTRAINT "1132_1132_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1133_chunk 1133_1133_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1133_chunk
    ADD CONSTRAINT "1133_1133_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1134_chunk 1134_1134_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1134_chunk
    ADD CONSTRAINT "1134_1134_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1135_chunk 1135_1135_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1135_chunk
    ADD CONSTRAINT "1135_1135_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1136_chunk 1136_1136_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1136_chunk
    ADD CONSTRAINT "1136_1136_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1137_chunk 1137_1137_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1137_chunk
    ADD CONSTRAINT "1137_1137_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1138_chunk 1138_1138_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1138_chunk
    ADD CONSTRAINT "1138_1138_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1139_chunk 1139_1139_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1139_chunk
    ADD CONSTRAINT "1139_1139_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1140_chunk 1140_1140_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1140_chunk
    ADD CONSTRAINT "1140_1140_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1141_chunk 1141_1141_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1141_chunk
    ADD CONSTRAINT "1141_1141_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1142_chunk 1142_1142_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1142_chunk
    ADD CONSTRAINT "1142_1142_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1143_chunk 1143_1143_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1143_chunk
    ADD CONSTRAINT "1143_1143_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1144_chunk 1144_1144_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1144_chunk
    ADD CONSTRAINT "1144_1144_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1145_chunk 1145_1145_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1145_chunk
    ADD CONSTRAINT "1145_1145_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1146_chunk 1146_1146_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1146_chunk
    ADD CONSTRAINT "1146_1146_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1147_chunk 1147_1147_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1147_chunk
    ADD CONSTRAINT "1147_1147_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1148_chunk 1148_1148_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1148_chunk
    ADD CONSTRAINT "1148_1148_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1149_chunk 1149_1149_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1149_chunk
    ADD CONSTRAINT "1149_1149_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1150_chunk 1150_1150_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1150_chunk
    ADD CONSTRAINT "1150_1150_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1151_chunk 1151_1151_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1151_chunk
    ADD CONSTRAINT "1151_1151_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1152_chunk 1152_1152_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1152_chunk
    ADD CONSTRAINT "1152_1152_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1153_chunk 1153_1153_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1153_chunk
    ADD CONSTRAINT "1153_1153_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1154_chunk 1154_1154_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1154_chunk
    ADD CONSTRAINT "1154_1154_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1155_chunk 1155_1155_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1155_chunk
    ADD CONSTRAINT "1155_1155_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1156_chunk 1156_1156_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1156_chunk
    ADD CONSTRAINT "1156_1156_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1157_chunk 1157_1157_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1157_chunk
    ADD CONSTRAINT "1157_1157_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1158_chunk 1158_1158_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1158_chunk
    ADD CONSTRAINT "1158_1158_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1159_chunk 1159_1159_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1159_chunk
    ADD CONSTRAINT "1159_1159_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1160_chunk 1160_1160_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1160_chunk
    ADD CONSTRAINT "1160_1160_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1161_chunk 1161_1161_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1161_chunk
    ADD CONSTRAINT "1161_1161_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1162_chunk 1162_1162_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1162_chunk
    ADD CONSTRAINT "1162_1162_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1163_chunk 1163_1163_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1163_chunk
    ADD CONSTRAINT "1163_1163_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1164_chunk 1164_1164_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1164_chunk
    ADD CONSTRAINT "1164_1164_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1165_chunk 1165_1165_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1165_chunk
    ADD CONSTRAINT "1165_1165_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1166_chunk 1166_1166_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1166_chunk
    ADD CONSTRAINT "1166_1166_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1167_chunk 1167_1167_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1167_chunk
    ADD CONSTRAINT "1167_1167_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1168_chunk 1168_1168_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1168_chunk
    ADD CONSTRAINT "1168_1168_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1169_chunk 1169_1169_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1169_chunk
    ADD CONSTRAINT "1169_1169_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1170_chunk 1170_1170_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1170_chunk
    ADD CONSTRAINT "1170_1170_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1171_chunk 1171_1171_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1171_chunk
    ADD CONSTRAINT "1171_1171_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1172_chunk 1172_1172_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1172_chunk
    ADD CONSTRAINT "1172_1172_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1173_chunk 1173_1173_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1173_chunk
    ADD CONSTRAINT "1173_1173_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1174_chunk 1174_1174_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1174_chunk
    ADD CONSTRAINT "1174_1174_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1175_chunk 1175_1175_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1175_chunk
    ADD CONSTRAINT "1175_1175_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1176_chunk 1176_1176_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1176_chunk
    ADD CONSTRAINT "1176_1176_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1177_chunk 1177_1177_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1177_chunk
    ADD CONSTRAINT "1177_1177_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1178_chunk 1178_1178_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1178_chunk
    ADD CONSTRAINT "1178_1178_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1179_chunk 1179_1179_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1179_chunk
    ADD CONSTRAINT "1179_1179_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1180_chunk 1180_1180_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1180_chunk
    ADD CONSTRAINT "1180_1180_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1181_chunk 1181_1181_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1181_chunk
    ADD CONSTRAINT "1181_1181_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1182_chunk 1182_1182_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1182_chunk
    ADD CONSTRAINT "1182_1182_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1183_chunk 1183_1183_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1183_chunk
    ADD CONSTRAINT "1183_1183_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1184_chunk 1184_1184_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1184_chunk
    ADD CONSTRAINT "1184_1184_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1185_chunk 1185_1185_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1185_chunk
    ADD CONSTRAINT "1185_1185_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1186_chunk 1186_1186_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1186_chunk
    ADD CONSTRAINT "1186_1186_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1187_chunk 1187_1187_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1187_chunk
    ADD CONSTRAINT "1187_1187_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1188_chunk 1188_1188_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1188_chunk
    ADD CONSTRAINT "1188_1188_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1189_chunk 1189_1189_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1189_chunk
    ADD CONSTRAINT "1189_1189_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1190_chunk 1190_1190_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1190_chunk
    ADD CONSTRAINT "1190_1190_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1191_chunk 1191_1191_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1191_chunk
    ADD CONSTRAINT "1191_1191_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1192_chunk 1192_1192_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1192_chunk
    ADD CONSTRAINT "1192_1192_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1193_chunk 1193_1193_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1193_chunk
    ADD CONSTRAINT "1193_1193_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1194_chunk 1194_1194_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1194_chunk
    ADD CONSTRAINT "1194_1194_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1195_chunk 1195_1195_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1195_chunk
    ADD CONSTRAINT "1195_1195_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1196_chunk 1196_1196_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1196_chunk
    ADD CONSTRAINT "1196_1196_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1197_chunk 1197_1197_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1197_chunk
    ADD CONSTRAINT "1197_1197_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1198_chunk 1198_1198_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1198_chunk
    ADD CONSTRAINT "1198_1198_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1199_chunk 1199_1199_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1199_chunk
    ADD CONSTRAINT "1199_1199_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1200_chunk 1200_1200_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1200_chunk
    ADD CONSTRAINT "1200_1200_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1201_chunk 1201_1201_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1201_chunk
    ADD CONSTRAINT "1201_1201_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1202_chunk 1202_1202_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1202_chunk
    ADD CONSTRAINT "1202_1202_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1203_chunk 1203_1203_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1203_chunk
    ADD CONSTRAINT "1203_1203_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1204_chunk 1204_1204_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1204_chunk
    ADD CONSTRAINT "1204_1204_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1205_chunk 1205_1205_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1205_chunk
    ADD CONSTRAINT "1205_1205_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1206_chunk 1206_1206_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1206_chunk
    ADD CONSTRAINT "1206_1206_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1207_chunk 1207_1207_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1207_chunk
    ADD CONSTRAINT "1207_1207_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1208_chunk 1208_1208_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1208_chunk
    ADD CONSTRAINT "1208_1208_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1209_chunk 1209_1209_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1209_chunk
    ADD CONSTRAINT "1209_1209_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1210_chunk 1210_1210_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1210_chunk
    ADD CONSTRAINT "1210_1210_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1211_chunk 1211_1211_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1211_chunk
    ADD CONSTRAINT "1211_1211_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1212_chunk 1212_1212_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1212_chunk
    ADD CONSTRAINT "1212_1212_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1213_chunk 1213_1213_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1213_chunk
    ADD CONSTRAINT "1213_1213_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1214_chunk 1214_1214_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1214_chunk
    ADD CONSTRAINT "1214_1214_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1215_chunk 1215_1215_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1215_chunk
    ADD CONSTRAINT "1215_1215_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1216_chunk 1216_1216_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1216_chunk
    ADD CONSTRAINT "1216_1216_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1217_chunk 1217_1217_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1217_chunk
    ADD CONSTRAINT "1217_1217_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1218_chunk 1218_1218_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1218_chunk
    ADD CONSTRAINT "1218_1218_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1219_chunk 1219_1219_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1219_chunk
    ADD CONSTRAINT "1219_1219_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1220_chunk 1220_1220_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1220_chunk
    ADD CONSTRAINT "1220_1220_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1221_chunk 1221_1221_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1221_chunk
    ADD CONSTRAINT "1221_1221_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1222_chunk 1222_1222_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1222_chunk
    ADD CONSTRAINT "1222_1222_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1223_chunk 1223_1223_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1223_chunk
    ADD CONSTRAINT "1223_1223_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1224_chunk 1224_1224_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1224_chunk
    ADD CONSTRAINT "1224_1224_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1225_chunk 1225_1225_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1225_chunk
    ADD CONSTRAINT "1225_1225_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1226_chunk 1226_1226_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1226_chunk
    ADD CONSTRAINT "1226_1226_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1227_chunk 1227_1227_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1227_chunk
    ADD CONSTRAINT "1227_1227_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1228_chunk 1228_1228_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1228_chunk
    ADD CONSTRAINT "1228_1228_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1229_chunk 1229_1229_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1229_chunk
    ADD CONSTRAINT "1229_1229_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1230_chunk 1230_1230_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1230_chunk
    ADD CONSTRAINT "1230_1230_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1231_chunk 1231_1231_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1231_chunk
    ADD CONSTRAINT "1231_1231_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1232_chunk 1232_1232_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1232_chunk
    ADD CONSTRAINT "1232_1232_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1233_chunk 1233_1233_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1233_chunk
    ADD CONSTRAINT "1233_1233_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1234_chunk 1234_1234_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1234_chunk
    ADD CONSTRAINT "1234_1234_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1235_chunk 1235_1235_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1235_chunk
    ADD CONSTRAINT "1235_1235_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1236_chunk 1236_1236_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1236_chunk
    ADD CONSTRAINT "1236_1236_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1237_chunk 1237_1237_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1237_chunk
    ADD CONSTRAINT "1237_1237_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1238_chunk 1238_1238_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1238_chunk
    ADD CONSTRAINT "1238_1238_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1239_chunk 1239_1239_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1239_chunk
    ADD CONSTRAINT "1239_1239_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1240_chunk 1240_1240_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1240_chunk
    ADD CONSTRAINT "1240_1240_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1241_chunk 1241_1241_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1241_chunk
    ADD CONSTRAINT "1241_1241_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1242_chunk 1242_1242_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1242_chunk
    ADD CONSTRAINT "1242_1242_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1243_chunk 1243_1243_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1243_chunk
    ADD CONSTRAINT "1243_1243_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1244_chunk 1244_1244_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1244_chunk
    ADD CONSTRAINT "1244_1244_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1245_chunk 1245_1245_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1245_chunk
    ADD CONSTRAINT "1245_1245_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1246_chunk 1246_1246_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1246_chunk
    ADD CONSTRAINT "1246_1246_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1247_chunk 1247_1247_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1247_chunk
    ADD CONSTRAINT "1247_1247_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1248_chunk 1248_1248_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1248_chunk
    ADD CONSTRAINT "1248_1248_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1249_chunk 1249_1249_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1249_chunk
    ADD CONSTRAINT "1249_1249_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1250_chunk 1250_1250_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1250_chunk
    ADD CONSTRAINT "1250_1250_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1251_chunk 1251_1251_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1251_chunk
    ADD CONSTRAINT "1251_1251_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1252_chunk 1252_1252_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1252_chunk
    ADD CONSTRAINT "1252_1252_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1253_chunk 1253_1253_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1253_chunk
    ADD CONSTRAINT "1253_1253_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1254_chunk 1254_1254_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1254_chunk
    ADD CONSTRAINT "1254_1254_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1255_chunk 1255_1255_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1255_chunk
    ADD CONSTRAINT "1255_1255_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1256_chunk 1256_1256_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1256_chunk
    ADD CONSTRAINT "1256_1256_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1257_chunk 1257_1257_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1257_chunk
    ADD CONSTRAINT "1257_1257_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1258_chunk 1258_1258_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1258_chunk
    ADD CONSTRAINT "1258_1258_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1259_chunk 1259_1259_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1259_chunk
    ADD CONSTRAINT "1259_1259_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1260_chunk 1260_1260_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1260_chunk
    ADD CONSTRAINT "1260_1260_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1261_chunk 1261_1261_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1261_chunk
    ADD CONSTRAINT "1261_1261_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1262_chunk 1262_1262_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1262_chunk
    ADD CONSTRAINT "1262_1262_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1263_chunk 1263_1263_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1263_chunk
    ADD CONSTRAINT "1263_1263_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1264_chunk 1264_1264_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1264_chunk
    ADD CONSTRAINT "1264_1264_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1265_chunk 1265_1265_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1265_chunk
    ADD CONSTRAINT "1265_1265_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1266_chunk 1266_1266_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1266_chunk
    ADD CONSTRAINT "1266_1266_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1267_chunk 1267_1267_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1267_chunk
    ADD CONSTRAINT "1267_1267_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1268_chunk 1268_1268_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1268_chunk
    ADD CONSTRAINT "1268_1268_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1269_chunk 1269_1269_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1269_chunk
    ADD CONSTRAINT "1269_1269_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1270_chunk 1270_1270_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1270_chunk
    ADD CONSTRAINT "1270_1270_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1271_chunk 1271_1271_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1271_chunk
    ADD CONSTRAINT "1271_1271_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1272_chunk 1272_1272_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1272_chunk
    ADD CONSTRAINT "1272_1272_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1273_chunk 1273_1273_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1273_chunk
    ADD CONSTRAINT "1273_1273_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1274_chunk 1274_1274_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1274_chunk
    ADD CONSTRAINT "1274_1274_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1275_chunk 1275_1275_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1275_chunk
    ADD CONSTRAINT "1275_1275_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1276_chunk 1276_1276_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1276_chunk
    ADD CONSTRAINT "1276_1276_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1277_chunk 1277_1277_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1277_chunk
    ADD CONSTRAINT "1277_1277_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1278_chunk 1278_1278_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1278_chunk
    ADD CONSTRAINT "1278_1278_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1279_chunk 1279_1279_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1279_chunk
    ADD CONSTRAINT "1279_1279_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1280_chunk 1280_1280_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1280_chunk
    ADD CONSTRAINT "1280_1280_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1281_chunk 1281_1281_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1281_chunk
    ADD CONSTRAINT "1281_1281_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1282_chunk 1282_1282_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1282_chunk
    ADD CONSTRAINT "1282_1282_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1283_chunk 1283_1283_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1283_chunk
    ADD CONSTRAINT "1283_1283_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1284_chunk 1284_1284_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1284_chunk
    ADD CONSTRAINT "1284_1284_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1285_chunk 1285_1285_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1285_chunk
    ADD CONSTRAINT "1285_1285_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1286_chunk 1286_1286_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1286_chunk
    ADD CONSTRAINT "1286_1286_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1287_chunk 1287_1287_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1287_chunk
    ADD CONSTRAINT "1287_1287_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1288_chunk 1288_1288_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1288_chunk
    ADD CONSTRAINT "1288_1288_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1289_chunk 1289_1289_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1289_chunk
    ADD CONSTRAINT "1289_1289_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1290_chunk 1290_1290_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1290_chunk
    ADD CONSTRAINT "1290_1290_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1291_chunk 1291_1291_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1291_chunk
    ADD CONSTRAINT "1291_1291_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1292_chunk 1292_1292_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1292_chunk
    ADD CONSTRAINT "1292_1292_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1293_chunk 1293_1293_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1293_chunk
    ADD CONSTRAINT "1293_1293_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1294_chunk 1294_1294_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1294_chunk
    ADD CONSTRAINT "1294_1294_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1295_chunk 1295_1295_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1295_chunk
    ADD CONSTRAINT "1295_1295_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1296_chunk 1296_1296_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1296_chunk
    ADD CONSTRAINT "1296_1296_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1297_chunk 1297_1297_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1297_chunk
    ADD CONSTRAINT "1297_1297_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1298_chunk 1298_1298_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1298_chunk
    ADD CONSTRAINT "1298_1298_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1299_chunk 1299_1299_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1299_chunk
    ADD CONSTRAINT "1299_1299_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1300_chunk 1300_1300_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1300_chunk
    ADD CONSTRAINT "1300_1300_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1301_chunk 1301_1301_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1301_chunk
    ADD CONSTRAINT "1301_1301_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1302_chunk 1302_1302_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1302_chunk
    ADD CONSTRAINT "1302_1302_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1303_chunk 1303_1303_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1303_chunk
    ADD CONSTRAINT "1303_1303_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1304_chunk 1304_1304_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1304_chunk
    ADD CONSTRAINT "1304_1304_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1305_chunk 1305_1305_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1305_chunk
    ADD CONSTRAINT "1305_1305_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1306_chunk 1306_1306_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1306_chunk
    ADD CONSTRAINT "1306_1306_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1307_chunk 1307_1307_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1307_chunk
    ADD CONSTRAINT "1307_1307_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1308_chunk 1308_1308_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1308_chunk
    ADD CONSTRAINT "1308_1308_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1309_chunk 1309_1309_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1309_chunk
    ADD CONSTRAINT "1309_1309_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1310_chunk 1310_1310_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1310_chunk
    ADD CONSTRAINT "1310_1310_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1311_chunk 1311_1311_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1311_chunk
    ADD CONSTRAINT "1311_1311_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1312_chunk 1312_1312_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1312_chunk
    ADD CONSTRAINT "1312_1312_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1313_chunk 1313_1313_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1313_chunk
    ADD CONSTRAINT "1313_1313_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1314_chunk 1314_1314_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1314_chunk
    ADD CONSTRAINT "1314_1314_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1315_chunk 1315_1315_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1315_chunk
    ADD CONSTRAINT "1315_1315_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1316_chunk 1316_1316_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1316_chunk
    ADD CONSTRAINT "1316_1316_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1317_chunk 1317_1317_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1317_chunk
    ADD CONSTRAINT "1317_1317_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1318_chunk 1318_1318_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1318_chunk
    ADD CONSTRAINT "1318_1318_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1319_chunk 1319_1319_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1319_chunk
    ADD CONSTRAINT "1319_1319_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1320_chunk 1320_1320_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1320_chunk
    ADD CONSTRAINT "1320_1320_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1321_chunk 1321_1321_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1321_chunk
    ADD CONSTRAINT "1321_1321_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1322_chunk 1322_1322_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1322_chunk
    ADD CONSTRAINT "1322_1322_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1323_chunk 1323_1323_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1323_chunk
    ADD CONSTRAINT "1323_1323_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1324_chunk 1324_1324_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1324_chunk
    ADD CONSTRAINT "1324_1324_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1325_chunk 1325_1325_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1325_chunk
    ADD CONSTRAINT "1325_1325_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1326_chunk 1326_1326_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1326_chunk
    ADD CONSTRAINT "1326_1326_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_1_1327_chunk 1327_1327_candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_1_1327_chunk
    ADD CONSTRAINT "1327_1327_candles_60m_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_1328_chunk 1328_1328_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_1328_chunk
    ADD CONSTRAINT "1328_1328_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_440_chunk 440_440_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_440_chunk
    ADD CONSTRAINT "440_440_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_441_chunk 441_441_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_441_chunk
    ADD CONSTRAINT "441_441_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_442_chunk 442_442_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_442_chunk
    ADD CONSTRAINT "442_442_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_443_chunk 443_443_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_443_chunk
    ADD CONSTRAINT "443_443_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_444_chunk 444_444_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_444_chunk
    ADD CONSTRAINT "444_444_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_445_chunk 445_445_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_445_chunk
    ADD CONSTRAINT "445_445_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_446_chunk 446_446_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_446_chunk
    ADD CONSTRAINT "446_446_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_447_chunk 447_447_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_447_chunk
    ADD CONSTRAINT "447_447_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_448_chunk 448_448_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_448_chunk
    ADD CONSTRAINT "448_448_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_449_chunk 449_449_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_449_chunk
    ADD CONSTRAINT "449_449_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_450_chunk 450_450_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_450_chunk
    ADD CONSTRAINT "450_450_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_451_chunk 451_451_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_451_chunk
    ADD CONSTRAINT "451_451_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_452_chunk 452_452_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_452_chunk
    ADD CONSTRAINT "452_452_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_453_chunk 453_453_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_453_chunk
    ADD CONSTRAINT "453_453_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_454_chunk 454_454_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_454_chunk
    ADD CONSTRAINT "454_454_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_455_chunk 455_455_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_455_chunk
    ADD CONSTRAINT "455_455_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_456_chunk 456_456_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_456_chunk
    ADD CONSTRAINT "456_456_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_457_chunk 457_457_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_457_chunk
    ADD CONSTRAINT "457_457_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_458_chunk 458_458_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_458_chunk
    ADD CONSTRAINT "458_458_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_459_chunk 459_459_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_459_chunk
    ADD CONSTRAINT "459_459_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_460_chunk 460_460_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_460_chunk
    ADD CONSTRAINT "460_460_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_461_chunk 461_461_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_461_chunk
    ADD CONSTRAINT "461_461_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_462_chunk 462_462_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_462_chunk
    ADD CONSTRAINT "462_462_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_463_chunk 463_463_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_463_chunk
    ADD CONSTRAINT "463_463_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_464_chunk 464_464_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_464_chunk
    ADD CONSTRAINT "464_464_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_465_chunk 465_465_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_465_chunk
    ADD CONSTRAINT "465_465_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_466_chunk 466_466_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_466_chunk
    ADD CONSTRAINT "466_466_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_467_chunk 467_467_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_467_chunk
    ADD CONSTRAINT "467_467_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_468_chunk 468_468_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_468_chunk
    ADD CONSTRAINT "468_468_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_469_chunk 469_469_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_469_chunk
    ADD CONSTRAINT "469_469_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_470_chunk 470_470_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_470_chunk
    ADD CONSTRAINT "470_470_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_471_chunk 471_471_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_471_chunk
    ADD CONSTRAINT "471_471_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_472_chunk 472_472_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_472_chunk
    ADD CONSTRAINT "472_472_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_473_chunk 473_473_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_473_chunk
    ADD CONSTRAINT "473_473_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_474_chunk 474_474_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_474_chunk
    ADD CONSTRAINT "474_474_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_475_chunk 475_475_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_475_chunk
    ADD CONSTRAINT "475_475_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_476_chunk 476_476_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_476_chunk
    ADD CONSTRAINT "476_476_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_477_chunk 477_477_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_477_chunk
    ADD CONSTRAINT "477_477_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_478_chunk 478_478_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_478_chunk
    ADD CONSTRAINT "478_478_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_479_chunk 479_479_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_479_chunk
    ADD CONSTRAINT "479_479_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_480_chunk 480_480_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_480_chunk
    ADD CONSTRAINT "480_480_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_481_chunk 481_481_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_481_chunk
    ADD CONSTRAINT "481_481_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_482_chunk 482_482_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_482_chunk
    ADD CONSTRAINT "482_482_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_483_chunk 483_483_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_483_chunk
    ADD CONSTRAINT "483_483_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_484_chunk 484_484_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_484_chunk
    ADD CONSTRAINT "484_484_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_485_chunk 485_485_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_485_chunk
    ADD CONSTRAINT "485_485_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_486_chunk 486_486_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_486_chunk
    ADD CONSTRAINT "486_486_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_487_chunk 487_487_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_487_chunk
    ADD CONSTRAINT "487_487_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_488_chunk 488_488_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_488_chunk
    ADD CONSTRAINT "488_488_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_489_chunk 489_489_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_489_chunk
    ADD CONSTRAINT "489_489_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_490_chunk 490_490_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_490_chunk
    ADD CONSTRAINT "490_490_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_491_chunk 491_491_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_491_chunk
    ADD CONSTRAINT "491_491_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_492_chunk 492_492_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_492_chunk
    ADD CONSTRAINT "492_492_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_493_chunk 493_493_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_493_chunk
    ADD CONSTRAINT "493_493_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_494_chunk 494_494_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_494_chunk
    ADD CONSTRAINT "494_494_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_495_chunk 495_495_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_495_chunk
    ADD CONSTRAINT "495_495_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_496_chunk 496_496_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_496_chunk
    ADD CONSTRAINT "496_496_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_497_chunk 497_497_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_497_chunk
    ADD CONSTRAINT "497_497_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_498_chunk 498_498_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_498_chunk
    ADD CONSTRAINT "498_498_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_499_chunk 499_499_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_499_chunk
    ADD CONSTRAINT "499_499_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_500_chunk 500_500_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_500_chunk
    ADD CONSTRAINT "500_500_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_501_chunk 501_501_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_501_chunk
    ADD CONSTRAINT "501_501_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_502_chunk 502_502_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_502_chunk
    ADD CONSTRAINT "502_502_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_503_chunk 503_503_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_503_chunk
    ADD CONSTRAINT "503_503_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_504_chunk 504_504_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_504_chunk
    ADD CONSTRAINT "504_504_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_505_chunk 505_505_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_505_chunk
    ADD CONSTRAINT "505_505_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_506_chunk 506_506_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_506_chunk
    ADD CONSTRAINT "506_506_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_507_chunk 507_507_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_507_chunk
    ADD CONSTRAINT "507_507_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_508_chunk 508_508_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_508_chunk
    ADD CONSTRAINT "508_508_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_509_chunk 509_509_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_509_chunk
    ADD CONSTRAINT "509_509_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_510_chunk 510_510_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_510_chunk
    ADD CONSTRAINT "510_510_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_511_chunk 511_511_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_511_chunk
    ADD CONSTRAINT "511_511_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_512_chunk 512_512_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_512_chunk
    ADD CONSTRAINT "512_512_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_513_chunk 513_513_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_513_chunk
    ADD CONSTRAINT "513_513_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_514_chunk 514_514_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_514_chunk
    ADD CONSTRAINT "514_514_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_515_chunk 515_515_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_515_chunk
    ADD CONSTRAINT "515_515_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_516_chunk 516_516_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_516_chunk
    ADD CONSTRAINT "516_516_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_517_chunk 517_517_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_517_chunk
    ADD CONSTRAINT "517_517_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_518_chunk 518_518_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_518_chunk
    ADD CONSTRAINT "518_518_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_519_chunk 519_519_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_519_chunk
    ADD CONSTRAINT "519_519_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_520_chunk 520_520_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_520_chunk
    ADD CONSTRAINT "520_520_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_521_chunk 521_521_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_521_chunk
    ADD CONSTRAINT "521_521_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_522_chunk 522_522_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_522_chunk
    ADD CONSTRAINT "522_522_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_523_chunk 523_523_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_523_chunk
    ADD CONSTRAINT "523_523_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_524_chunk 524_524_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_524_chunk
    ADD CONSTRAINT "524_524_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_525_chunk 525_525_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_525_chunk
    ADD CONSTRAINT "525_525_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_526_chunk 526_526_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_526_chunk
    ADD CONSTRAINT "526_526_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_527_chunk 527_527_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_527_chunk
    ADD CONSTRAINT "527_527_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_528_chunk 528_528_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_528_chunk
    ADD CONSTRAINT "528_528_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_529_chunk 529_529_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_529_chunk
    ADD CONSTRAINT "529_529_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_530_chunk 530_530_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_530_chunk
    ADD CONSTRAINT "530_530_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_531_chunk 531_531_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_531_chunk
    ADD CONSTRAINT "531_531_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_532_chunk 532_532_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_532_chunk
    ADD CONSTRAINT "532_532_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_533_chunk 533_533_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_533_chunk
    ADD CONSTRAINT "533_533_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_534_chunk 534_534_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_534_chunk
    ADD CONSTRAINT "534_534_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_535_chunk 535_535_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_535_chunk
    ADD CONSTRAINT "535_535_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_536_chunk 536_536_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_536_chunk
    ADD CONSTRAINT "536_536_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_537_chunk 537_537_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_537_chunk
    ADD CONSTRAINT "537_537_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_538_chunk 538_538_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_538_chunk
    ADD CONSTRAINT "538_538_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_539_chunk 539_539_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_539_chunk
    ADD CONSTRAINT "539_539_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_540_chunk 540_540_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_540_chunk
    ADD CONSTRAINT "540_540_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_541_chunk 541_541_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_541_chunk
    ADD CONSTRAINT "541_541_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_542_chunk 542_542_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_542_chunk
    ADD CONSTRAINT "542_542_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_543_chunk 543_543_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_543_chunk
    ADD CONSTRAINT "543_543_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_544_chunk 544_544_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_544_chunk
    ADD CONSTRAINT "544_544_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_545_chunk 545_545_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_545_chunk
    ADD CONSTRAINT "545_545_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_546_chunk 546_546_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_546_chunk
    ADD CONSTRAINT "546_546_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_547_chunk 547_547_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_547_chunk
    ADD CONSTRAINT "547_547_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_548_chunk 548_548_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_548_chunk
    ADD CONSTRAINT "548_548_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_549_chunk 549_549_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_549_chunk
    ADD CONSTRAINT "549_549_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_550_chunk 550_550_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_550_chunk
    ADD CONSTRAINT "550_550_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_551_chunk 551_551_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_551_chunk
    ADD CONSTRAINT "551_551_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_552_chunk 552_552_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_552_chunk
    ADD CONSTRAINT "552_552_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_553_chunk 553_553_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_553_chunk
    ADD CONSTRAINT "553_553_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_554_chunk 554_554_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_554_chunk
    ADD CONSTRAINT "554_554_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_555_chunk 555_555_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_555_chunk
    ADD CONSTRAINT "555_555_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_556_chunk 556_556_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_556_chunk
    ADD CONSTRAINT "556_556_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_557_chunk 557_557_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_557_chunk
    ADD CONSTRAINT "557_557_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_558_chunk 558_558_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_558_chunk
    ADD CONSTRAINT "558_558_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_559_chunk 559_559_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_559_chunk
    ADD CONSTRAINT "559_559_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_560_chunk 560_560_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_560_chunk
    ADD CONSTRAINT "560_560_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_561_chunk 561_561_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_561_chunk
    ADD CONSTRAINT "561_561_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_562_chunk 562_562_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_562_chunk
    ADD CONSTRAINT "562_562_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_563_chunk 563_563_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_563_chunk
    ADD CONSTRAINT "563_563_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_564_chunk 564_564_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_564_chunk
    ADD CONSTRAINT "564_564_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_565_chunk 565_565_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_565_chunk
    ADD CONSTRAINT "565_565_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_566_chunk 566_566_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_566_chunk
    ADD CONSTRAINT "566_566_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_567_chunk 567_567_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_567_chunk
    ADD CONSTRAINT "567_567_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_568_chunk 568_568_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_568_chunk
    ADD CONSTRAINT "568_568_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_569_chunk 569_569_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_569_chunk
    ADD CONSTRAINT "569_569_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_570_chunk 570_570_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_570_chunk
    ADD CONSTRAINT "570_570_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_571_chunk 571_571_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_571_chunk
    ADD CONSTRAINT "571_571_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_572_chunk 572_572_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_572_chunk
    ADD CONSTRAINT "572_572_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_573_chunk 573_573_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_573_chunk
    ADD CONSTRAINT "573_573_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_574_chunk 574_574_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_574_chunk
    ADD CONSTRAINT "574_574_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_575_chunk 575_575_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_575_chunk
    ADD CONSTRAINT "575_575_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_576_chunk 576_576_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_576_chunk
    ADD CONSTRAINT "576_576_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_577_chunk 577_577_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_577_chunk
    ADD CONSTRAINT "577_577_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_578_chunk 578_578_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_578_chunk
    ADD CONSTRAINT "578_578_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_579_chunk 579_579_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_579_chunk
    ADD CONSTRAINT "579_579_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_580_chunk 580_580_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_580_chunk
    ADD CONSTRAINT "580_580_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_581_chunk 581_581_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_581_chunk
    ADD CONSTRAINT "581_581_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_582_chunk 582_582_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_582_chunk
    ADD CONSTRAINT "582_582_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_583_chunk 583_583_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_583_chunk
    ADD CONSTRAINT "583_583_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_584_chunk 584_584_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_584_chunk
    ADD CONSTRAINT "584_584_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_585_chunk 585_585_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_585_chunk
    ADD CONSTRAINT "585_585_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_586_chunk 586_586_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_586_chunk
    ADD CONSTRAINT "586_586_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_587_chunk 587_587_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_587_chunk
    ADD CONSTRAINT "587_587_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_588_chunk 588_588_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_588_chunk
    ADD CONSTRAINT "588_588_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_589_chunk 589_589_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_589_chunk
    ADD CONSTRAINT "589_589_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_590_chunk 590_590_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_590_chunk
    ADD CONSTRAINT "590_590_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_591_chunk 591_591_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_591_chunk
    ADD CONSTRAINT "591_591_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_592_chunk 592_592_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_592_chunk
    ADD CONSTRAINT "592_592_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_593_chunk 593_593_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_593_chunk
    ADD CONSTRAINT "593_593_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_594_chunk 594_594_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_594_chunk
    ADD CONSTRAINT "594_594_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_595_chunk 595_595_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_595_chunk
    ADD CONSTRAINT "595_595_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_596_chunk 596_596_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_596_chunk
    ADD CONSTRAINT "596_596_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_597_chunk 597_597_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_597_chunk
    ADD CONSTRAINT "597_597_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_598_chunk 598_598_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_598_chunk
    ADD CONSTRAINT "598_598_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_599_chunk 599_599_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_599_chunk
    ADD CONSTRAINT "599_599_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_600_chunk 600_600_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_600_chunk
    ADD CONSTRAINT "600_600_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_601_chunk 601_601_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_601_chunk
    ADD CONSTRAINT "601_601_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_602_chunk 602_602_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_602_chunk
    ADD CONSTRAINT "602_602_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_603_chunk 603_603_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_603_chunk
    ADD CONSTRAINT "603_603_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_604_chunk 604_604_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_604_chunk
    ADD CONSTRAINT "604_604_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_605_chunk 605_605_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_605_chunk
    ADD CONSTRAINT "605_605_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_606_chunk 606_606_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_606_chunk
    ADD CONSTRAINT "606_606_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_607_chunk 607_607_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_607_chunk
    ADD CONSTRAINT "607_607_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_608_chunk 608_608_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_608_chunk
    ADD CONSTRAINT "608_608_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_609_chunk 609_609_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_609_chunk
    ADD CONSTRAINT "609_609_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_610_chunk 610_610_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_610_chunk
    ADD CONSTRAINT "610_610_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_611_chunk 611_611_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_611_chunk
    ADD CONSTRAINT "611_611_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_612_chunk 612_612_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_612_chunk
    ADD CONSTRAINT "612_612_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_613_chunk 613_613_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_613_chunk
    ADD CONSTRAINT "613_613_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_614_chunk 614_614_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_614_chunk
    ADD CONSTRAINT "614_614_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_615_chunk 615_615_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_615_chunk
    ADD CONSTRAINT "615_615_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_616_chunk 616_616_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_616_chunk
    ADD CONSTRAINT "616_616_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_617_chunk 617_617_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_617_chunk
    ADD CONSTRAINT "617_617_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_618_chunk 618_618_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_618_chunk
    ADD CONSTRAINT "618_618_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_619_chunk 619_619_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_619_chunk
    ADD CONSTRAINT "619_619_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_620_chunk 620_620_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_620_chunk
    ADD CONSTRAINT "620_620_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_621_chunk 621_621_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_621_chunk
    ADD CONSTRAINT "621_621_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_622_chunk 622_622_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_622_chunk
    ADD CONSTRAINT "622_622_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_623_chunk 623_623_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_623_chunk
    ADD CONSTRAINT "623_623_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_624_chunk 624_624_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_624_chunk
    ADD CONSTRAINT "624_624_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_625_chunk 625_625_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_625_chunk
    ADD CONSTRAINT "625_625_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_626_chunk 626_626_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_626_chunk
    ADD CONSTRAINT "626_626_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_627_chunk 627_627_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_627_chunk
    ADD CONSTRAINT "627_627_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_628_chunk 628_628_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_628_chunk
    ADD CONSTRAINT "628_628_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_629_chunk 629_629_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_629_chunk
    ADD CONSTRAINT "629_629_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_630_chunk 630_630_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_630_chunk
    ADD CONSTRAINT "630_630_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_631_chunk 631_631_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_631_chunk
    ADD CONSTRAINT "631_631_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_632_chunk 632_632_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_632_chunk
    ADD CONSTRAINT "632_632_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_633_chunk 633_633_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_633_chunk
    ADD CONSTRAINT "633_633_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_634_chunk 634_634_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_634_chunk
    ADD CONSTRAINT "634_634_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_635_chunk 635_635_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_635_chunk
    ADD CONSTRAINT "635_635_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_636_chunk 636_636_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_636_chunk
    ADD CONSTRAINT "636_636_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_637_chunk 637_637_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_637_chunk
    ADD CONSTRAINT "637_637_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_638_chunk 638_638_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_638_chunk
    ADD CONSTRAINT "638_638_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_639_chunk 639_639_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_639_chunk
    ADD CONSTRAINT "639_639_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_640_chunk 640_640_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_640_chunk
    ADD CONSTRAINT "640_640_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_641_chunk 641_641_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_641_chunk
    ADD CONSTRAINT "641_641_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_642_chunk 642_642_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_642_chunk
    ADD CONSTRAINT "642_642_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_643_chunk 643_643_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_643_chunk
    ADD CONSTRAINT "643_643_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_644_chunk 644_644_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_644_chunk
    ADD CONSTRAINT "644_644_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_645_chunk 645_645_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_645_chunk
    ADD CONSTRAINT "645_645_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_646_chunk 646_646_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_646_chunk
    ADD CONSTRAINT "646_646_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_647_chunk 647_647_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_647_chunk
    ADD CONSTRAINT "647_647_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_648_chunk 648_648_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_648_chunk
    ADD CONSTRAINT "648_648_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_649_chunk 649_649_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_649_chunk
    ADD CONSTRAINT "649_649_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_650_chunk 650_650_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_650_chunk
    ADD CONSTRAINT "650_650_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_651_chunk 651_651_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_651_chunk
    ADD CONSTRAINT "651_651_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_652_chunk 652_652_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_652_chunk
    ADD CONSTRAINT "652_652_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_653_chunk 653_653_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_653_chunk
    ADD CONSTRAINT "653_653_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_654_chunk 654_654_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_654_chunk
    ADD CONSTRAINT "654_654_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_655_chunk 655_655_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_655_chunk
    ADD CONSTRAINT "655_655_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_656_chunk 656_656_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_656_chunk
    ADD CONSTRAINT "656_656_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_657_chunk 657_657_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_657_chunk
    ADD CONSTRAINT "657_657_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_658_chunk 658_658_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_658_chunk
    ADD CONSTRAINT "658_658_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_659_chunk 659_659_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_659_chunk
    ADD CONSTRAINT "659_659_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_660_chunk 660_660_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_660_chunk
    ADD CONSTRAINT "660_660_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_661_chunk 661_661_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_661_chunk
    ADD CONSTRAINT "661_661_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_662_chunk 662_662_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_662_chunk
    ADD CONSTRAINT "662_662_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_663_chunk 663_663_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_663_chunk
    ADD CONSTRAINT "663_663_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_664_chunk 664_664_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_664_chunk
    ADD CONSTRAINT "664_664_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_665_chunk 665_665_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_665_chunk
    ADD CONSTRAINT "665_665_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_666_chunk 666_666_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_666_chunk
    ADD CONSTRAINT "666_666_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_667_chunk 667_667_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_667_chunk
    ADD CONSTRAINT "667_667_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_668_chunk 668_668_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_668_chunk
    ADD CONSTRAINT "668_668_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_669_chunk 669_669_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_669_chunk
    ADD CONSTRAINT "669_669_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_670_chunk 670_670_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_670_chunk
    ADD CONSTRAINT "670_670_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_671_chunk 671_671_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_671_chunk
    ADD CONSTRAINT "671_671_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_672_chunk 672_672_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_672_chunk
    ADD CONSTRAINT "672_672_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_673_chunk 673_673_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_673_chunk
    ADD CONSTRAINT "673_673_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_674_chunk 674_674_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_674_chunk
    ADD CONSTRAINT "674_674_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_675_chunk 675_675_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_675_chunk
    ADD CONSTRAINT "675_675_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_676_chunk 676_676_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_676_chunk
    ADD CONSTRAINT "676_676_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_677_chunk 677_677_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_677_chunk
    ADD CONSTRAINT "677_677_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_678_chunk 678_678_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_678_chunk
    ADD CONSTRAINT "678_678_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_679_chunk 679_679_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_679_chunk
    ADD CONSTRAINT "679_679_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_680_chunk 680_680_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_680_chunk
    ADD CONSTRAINT "680_680_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_681_chunk 681_681_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_681_chunk
    ADD CONSTRAINT "681_681_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_682_chunk 682_682_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_682_chunk
    ADD CONSTRAINT "682_682_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_683_chunk 683_683_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_683_chunk
    ADD CONSTRAINT "683_683_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_684_chunk 684_684_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_684_chunk
    ADD CONSTRAINT "684_684_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_685_chunk 685_685_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_685_chunk
    ADD CONSTRAINT "685_685_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_686_chunk 686_686_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_686_chunk
    ADD CONSTRAINT "686_686_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_687_chunk 687_687_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_687_chunk
    ADD CONSTRAINT "687_687_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_688_chunk 688_688_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_688_chunk
    ADD CONSTRAINT "688_688_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_689_chunk 689_689_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_689_chunk
    ADD CONSTRAINT "689_689_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_690_chunk 690_690_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_690_chunk
    ADD CONSTRAINT "690_690_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_691_chunk 691_691_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_691_chunk
    ADD CONSTRAINT "691_691_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_692_chunk 692_692_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_692_chunk
    ADD CONSTRAINT "692_692_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_693_chunk 693_693_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_693_chunk
    ADD CONSTRAINT "693_693_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_694_chunk 694_694_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_694_chunk
    ADD CONSTRAINT "694_694_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_695_chunk 695_695_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_695_chunk
    ADD CONSTRAINT "695_695_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_696_chunk 696_696_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_696_chunk
    ADD CONSTRAINT "696_696_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_697_chunk 697_697_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_697_chunk
    ADD CONSTRAINT "697_697_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_698_chunk 698_698_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_698_chunk
    ADD CONSTRAINT "698_698_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_699_chunk 699_699_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_699_chunk
    ADD CONSTRAINT "699_699_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_700_chunk 700_700_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_700_chunk
    ADD CONSTRAINT "700_700_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_701_chunk 701_701_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_701_chunk
    ADD CONSTRAINT "701_701_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_702_chunk 702_702_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_702_chunk
    ADD CONSTRAINT "702_702_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_703_chunk 703_703_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_703_chunk
    ADD CONSTRAINT "703_703_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_704_chunk 704_704_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_704_chunk
    ADD CONSTRAINT "704_704_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_705_chunk 705_705_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_705_chunk
    ADD CONSTRAINT "705_705_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_706_chunk 706_706_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_706_chunk
    ADD CONSTRAINT "706_706_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_707_chunk 707_707_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_707_chunk
    ADD CONSTRAINT "707_707_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_708_chunk 708_708_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_708_chunk
    ADD CONSTRAINT "708_708_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_709_chunk 709_709_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_709_chunk
    ADD CONSTRAINT "709_709_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_710_chunk 710_710_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_710_chunk
    ADD CONSTRAINT "710_710_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_711_chunk 711_711_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_711_chunk
    ADD CONSTRAINT "711_711_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_712_chunk 712_712_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_712_chunk
    ADD CONSTRAINT "712_712_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_713_chunk 713_713_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_713_chunk
    ADD CONSTRAINT "713_713_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_714_chunk 714_714_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_714_chunk
    ADD CONSTRAINT "714_714_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_715_chunk 715_715_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_715_chunk
    ADD CONSTRAINT "715_715_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_716_chunk 716_716_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_716_chunk
    ADD CONSTRAINT "716_716_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_717_chunk 717_717_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_717_chunk
    ADD CONSTRAINT "717_717_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_718_chunk 718_718_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_718_chunk
    ADD CONSTRAINT "718_718_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_719_chunk 719_719_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_719_chunk
    ADD CONSTRAINT "719_719_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_720_chunk 720_720_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_720_chunk
    ADD CONSTRAINT "720_720_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_721_chunk 721_721_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_721_chunk
    ADD CONSTRAINT "721_721_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_722_chunk 722_722_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_722_chunk
    ADD CONSTRAINT "722_722_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_723_chunk 723_723_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_723_chunk
    ADD CONSTRAINT "723_723_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_724_chunk 724_724_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_724_chunk
    ADD CONSTRAINT "724_724_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_725_chunk 725_725_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_725_chunk
    ADD CONSTRAINT "725_725_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_726_chunk 726_726_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_726_chunk
    ADD CONSTRAINT "726_726_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_727_chunk 727_727_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_727_chunk
    ADD CONSTRAINT "727_727_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_728_chunk 728_728_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_728_chunk
    ADD CONSTRAINT "728_728_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_729_chunk 729_729_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_729_chunk
    ADD CONSTRAINT "729_729_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_730_chunk 730_730_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_730_chunk
    ADD CONSTRAINT "730_730_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_731_chunk 731_731_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_731_chunk
    ADD CONSTRAINT "731_731_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_732_chunk 732_732_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_732_chunk
    ADD CONSTRAINT "732_732_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_733_chunk 733_733_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_733_chunk
    ADD CONSTRAINT "733_733_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_734_chunk 734_734_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_734_chunk
    ADD CONSTRAINT "734_734_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_735_chunk 735_735_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_735_chunk
    ADD CONSTRAINT "735_735_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_736_chunk 736_736_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_736_chunk
    ADD CONSTRAINT "736_736_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_737_chunk 737_737_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_737_chunk
    ADD CONSTRAINT "737_737_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_738_chunk 738_738_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_738_chunk
    ADD CONSTRAINT "738_738_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_739_chunk 739_739_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_739_chunk
    ADD CONSTRAINT "739_739_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_740_chunk 740_740_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_740_chunk
    ADD CONSTRAINT "740_740_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_741_chunk 741_741_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_741_chunk
    ADD CONSTRAINT "741_741_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_742_chunk 742_742_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_742_chunk
    ADD CONSTRAINT "742_742_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_743_chunk 743_743_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_743_chunk
    ADD CONSTRAINT "743_743_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_744_chunk 744_744_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_744_chunk
    ADD CONSTRAINT "744_744_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_745_chunk 745_745_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_745_chunk
    ADD CONSTRAINT "745_745_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_746_chunk 746_746_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_746_chunk
    ADD CONSTRAINT "746_746_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_747_chunk 747_747_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_747_chunk
    ADD CONSTRAINT "747_747_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_748_chunk 748_748_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_748_chunk
    ADD CONSTRAINT "748_748_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_749_chunk 749_749_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_749_chunk
    ADD CONSTRAINT "749_749_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_750_chunk 750_750_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_750_chunk
    ADD CONSTRAINT "750_750_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_751_chunk 751_751_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_751_chunk
    ADD CONSTRAINT "751_751_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_752_chunk 752_752_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_752_chunk
    ADD CONSTRAINT "752_752_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_753_chunk 753_753_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_753_chunk
    ADD CONSTRAINT "753_753_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_754_chunk 754_754_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_754_chunk
    ADD CONSTRAINT "754_754_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_755_chunk 755_755_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_755_chunk
    ADD CONSTRAINT "755_755_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_756_chunk 756_756_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_756_chunk
    ADD CONSTRAINT "756_756_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_757_chunk 757_757_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_757_chunk
    ADD CONSTRAINT "757_757_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_758_chunk 758_758_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_758_chunk
    ADD CONSTRAINT "758_758_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_759_chunk 759_759_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_759_chunk
    ADD CONSTRAINT "759_759_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_760_chunk 760_760_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_760_chunk
    ADD CONSTRAINT "760_760_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_761_chunk 761_761_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_761_chunk
    ADD CONSTRAINT "761_761_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_762_chunk 762_762_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_762_chunk
    ADD CONSTRAINT "762_762_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_763_chunk 763_763_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_763_chunk
    ADD CONSTRAINT "763_763_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_764_chunk 764_764_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_764_chunk
    ADD CONSTRAINT "764_764_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_765_chunk 765_765_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_765_chunk
    ADD CONSTRAINT "765_765_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_766_chunk 766_766_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_766_chunk
    ADD CONSTRAINT "766_766_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_767_chunk 767_767_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_767_chunk
    ADD CONSTRAINT "767_767_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_768_chunk 768_768_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_768_chunk
    ADD CONSTRAINT "768_768_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_769_chunk 769_769_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_769_chunk
    ADD CONSTRAINT "769_769_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_770_chunk 770_770_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_770_chunk
    ADD CONSTRAINT "770_770_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_771_chunk 771_771_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_771_chunk
    ADD CONSTRAINT "771_771_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_772_chunk 772_772_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_772_chunk
    ADD CONSTRAINT "772_772_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_773_chunk 773_773_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_773_chunk
    ADD CONSTRAINT "773_773_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_774_chunk 774_774_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_774_chunk
    ADD CONSTRAINT "774_774_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_775_chunk 775_775_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_775_chunk
    ADD CONSTRAINT "775_775_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_776_chunk 776_776_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_776_chunk
    ADD CONSTRAINT "776_776_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_777_chunk 777_777_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_777_chunk
    ADD CONSTRAINT "777_777_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_778_chunk 778_778_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_778_chunk
    ADD CONSTRAINT "778_778_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_779_chunk 779_779_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_779_chunk
    ADD CONSTRAINT "779_779_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_780_chunk 780_780_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_780_chunk
    ADD CONSTRAINT "780_780_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_781_chunk 781_781_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_781_chunk
    ADD CONSTRAINT "781_781_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_782_chunk 782_782_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_782_chunk
    ADD CONSTRAINT "782_782_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_783_chunk 783_783_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_783_chunk
    ADD CONSTRAINT "783_783_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_784_chunk 784_784_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_784_chunk
    ADD CONSTRAINT "784_784_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_785_chunk 785_785_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_785_chunk
    ADD CONSTRAINT "785_785_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_786_chunk 786_786_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_786_chunk
    ADD CONSTRAINT "786_786_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_787_chunk 787_787_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_787_chunk
    ADD CONSTRAINT "787_787_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_788_chunk 788_788_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_788_chunk
    ADD CONSTRAINT "788_788_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_789_chunk 789_789_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_789_chunk
    ADD CONSTRAINT "789_789_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_790_chunk 790_790_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_790_chunk
    ADD CONSTRAINT "790_790_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_791_chunk 791_791_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_791_chunk
    ADD CONSTRAINT "791_791_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_792_chunk 792_792_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_792_chunk
    ADD CONSTRAINT "792_792_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_793_chunk 793_793_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_793_chunk
    ADD CONSTRAINT "793_793_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_794_chunk 794_794_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_794_chunk
    ADD CONSTRAINT "794_794_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_795_chunk 795_795_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_795_chunk
    ADD CONSTRAINT "795_795_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_796_chunk 796_796_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_796_chunk
    ADD CONSTRAINT "796_796_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_797_chunk 797_797_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_797_chunk
    ADD CONSTRAINT "797_797_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_798_chunk 798_798_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_798_chunk
    ADD CONSTRAINT "798_798_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_799_chunk 799_799_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_799_chunk
    ADD CONSTRAINT "799_799_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_800_chunk 800_800_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_800_chunk
    ADD CONSTRAINT "800_800_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_801_chunk 801_801_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_801_chunk
    ADD CONSTRAINT "801_801_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_802_chunk 802_802_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_802_chunk
    ADD CONSTRAINT "802_802_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_803_chunk 803_803_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_803_chunk
    ADD CONSTRAINT "803_803_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_804_chunk 804_804_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_804_chunk
    ADD CONSTRAINT "804_804_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_805_chunk 805_805_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_805_chunk
    ADD CONSTRAINT "805_805_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_806_chunk 806_806_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_806_chunk
    ADD CONSTRAINT "806_806_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_807_chunk 807_807_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_807_chunk
    ADD CONSTRAINT "807_807_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_808_chunk 808_808_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_808_chunk
    ADD CONSTRAINT "808_808_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_809_chunk 809_809_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_809_chunk
    ADD CONSTRAINT "809_809_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_810_chunk 810_810_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_810_chunk
    ADD CONSTRAINT "810_810_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_811_chunk 811_811_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_811_chunk
    ADD CONSTRAINT "811_811_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_812_chunk 812_812_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_812_chunk
    ADD CONSTRAINT "812_812_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_813_chunk 813_813_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_813_chunk
    ADD CONSTRAINT "813_813_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_814_chunk 814_814_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_814_chunk
    ADD CONSTRAINT "814_814_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_815_chunk 815_815_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_815_chunk
    ADD CONSTRAINT "815_815_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_816_chunk 816_816_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_816_chunk
    ADD CONSTRAINT "816_816_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_817_chunk 817_817_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_817_chunk
    ADD CONSTRAINT "817_817_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_818_chunk 818_818_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_818_chunk
    ADD CONSTRAINT "818_818_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_819_chunk 819_819_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_819_chunk
    ADD CONSTRAINT "819_819_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_820_chunk 820_820_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_820_chunk
    ADD CONSTRAINT "820_820_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_821_chunk 821_821_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_821_chunk
    ADD CONSTRAINT "821_821_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_822_chunk 822_822_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_822_chunk
    ADD CONSTRAINT "822_822_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_823_chunk 823_823_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_823_chunk
    ADD CONSTRAINT "823_823_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_824_chunk 824_824_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_824_chunk
    ADD CONSTRAINT "824_824_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_825_chunk 825_825_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_825_chunk
    ADD CONSTRAINT "825_825_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_826_chunk 826_826_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_826_chunk
    ADD CONSTRAINT "826_826_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_827_chunk 827_827_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_827_chunk
    ADD CONSTRAINT "827_827_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_828_chunk 828_828_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_828_chunk
    ADD CONSTRAINT "828_828_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_829_chunk 829_829_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_829_chunk
    ADD CONSTRAINT "829_829_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_830_chunk 830_830_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_830_chunk
    ADD CONSTRAINT "830_830_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_831_chunk 831_831_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_831_chunk
    ADD CONSTRAINT "831_831_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_832_chunk 832_832_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_832_chunk
    ADD CONSTRAINT "832_832_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_833_chunk 833_833_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_833_chunk
    ADD CONSTRAINT "833_833_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_834_chunk 834_834_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_834_chunk
    ADD CONSTRAINT "834_834_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_835_chunk 835_835_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_835_chunk
    ADD CONSTRAINT "835_835_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_836_chunk 836_836_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_836_chunk
    ADD CONSTRAINT "836_836_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_837_chunk 837_837_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_837_chunk
    ADD CONSTRAINT "837_837_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_838_chunk 838_838_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_838_chunk
    ADD CONSTRAINT "838_838_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_839_chunk 839_839_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_839_chunk
    ADD CONSTRAINT "839_839_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_840_chunk 840_840_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_840_chunk
    ADD CONSTRAINT "840_840_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_841_chunk 841_841_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_841_chunk
    ADD CONSTRAINT "841_841_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_842_chunk 842_842_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_842_chunk
    ADD CONSTRAINT "842_842_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_843_chunk 843_843_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_843_chunk
    ADD CONSTRAINT "843_843_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_844_chunk 844_844_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_844_chunk
    ADD CONSTRAINT "844_844_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_845_chunk 845_845_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_845_chunk
    ADD CONSTRAINT "845_845_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_846_chunk 846_846_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_846_chunk
    ADD CONSTRAINT "846_846_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_847_chunk 847_847_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_847_chunk
    ADD CONSTRAINT "847_847_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_848_chunk 848_848_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_848_chunk
    ADD CONSTRAINT "848_848_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_849_chunk 849_849_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_849_chunk
    ADD CONSTRAINT "849_849_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_850_chunk 850_850_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_850_chunk
    ADD CONSTRAINT "850_850_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_851_chunk 851_851_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_851_chunk
    ADD CONSTRAINT "851_851_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_852_chunk 852_852_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_852_chunk
    ADD CONSTRAINT "852_852_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_853_chunk 853_853_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_853_chunk
    ADD CONSTRAINT "853_853_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_854_chunk 854_854_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_854_chunk
    ADD CONSTRAINT "854_854_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_855_chunk 855_855_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_855_chunk
    ADD CONSTRAINT "855_855_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_856_chunk 856_856_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_856_chunk
    ADD CONSTRAINT "856_856_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_857_chunk 857_857_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_857_chunk
    ADD CONSTRAINT "857_857_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_858_chunk 858_858_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_858_chunk
    ADD CONSTRAINT "858_858_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_859_chunk 859_859_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_859_chunk
    ADD CONSTRAINT "859_859_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_860_chunk 860_860_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_860_chunk
    ADD CONSTRAINT "860_860_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_861_chunk 861_861_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_861_chunk
    ADD CONSTRAINT "861_861_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_862_chunk 862_862_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_862_chunk
    ADD CONSTRAINT "862_862_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_863_chunk 863_863_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_863_chunk
    ADD CONSTRAINT "863_863_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_864_chunk 864_864_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_864_chunk
    ADD CONSTRAINT "864_864_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_865_chunk 865_865_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_865_chunk
    ADD CONSTRAINT "865_865_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_866_chunk 866_866_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_866_chunk
    ADD CONSTRAINT "866_866_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_867_chunk 867_867_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_867_chunk
    ADD CONSTRAINT "867_867_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_868_chunk 868_868_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_868_chunk
    ADD CONSTRAINT "868_868_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_869_chunk 869_869_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_869_chunk
    ADD CONSTRAINT "869_869_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_870_chunk 870_870_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_870_chunk
    ADD CONSTRAINT "870_870_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_871_chunk 871_871_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_871_chunk
    ADD CONSTRAINT "871_871_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_872_chunk 872_872_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_872_chunk
    ADD CONSTRAINT "872_872_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_873_chunk 873_873_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_873_chunk
    ADD CONSTRAINT "873_873_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_874_chunk 874_874_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_874_chunk
    ADD CONSTRAINT "874_874_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_875_chunk 875_875_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_875_chunk
    ADD CONSTRAINT "875_875_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_876_chunk 876_876_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_876_chunk
    ADD CONSTRAINT "876_876_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_877_chunk 877_877_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_877_chunk
    ADD CONSTRAINT "877_877_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_878_chunk 878_878_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_878_chunk
    ADD CONSTRAINT "878_878_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_879_chunk 879_879_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_879_chunk
    ADD CONSTRAINT "879_879_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_880_chunk 880_880_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_880_chunk
    ADD CONSTRAINT "880_880_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_881_chunk 881_881_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_881_chunk
    ADD CONSTRAINT "881_881_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_882_chunk 882_882_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_882_chunk
    ADD CONSTRAINT "882_882_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_883_chunk 883_883_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_883_chunk
    ADD CONSTRAINT "883_883_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_884_chunk 884_884_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_884_chunk
    ADD CONSTRAINT "884_884_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_885_chunk 885_885_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_885_chunk
    ADD CONSTRAINT "885_885_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_886_chunk 886_886_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_886_chunk
    ADD CONSTRAINT "886_886_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_887_chunk 887_887_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_887_chunk
    ADD CONSTRAINT "887_887_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_888_chunk 888_888_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_888_chunk
    ADD CONSTRAINT "888_888_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_889_chunk 889_889_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_889_chunk
    ADD CONSTRAINT "889_889_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_890_chunk 890_890_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_890_chunk
    ADD CONSTRAINT "890_890_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_891_chunk 891_891_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_891_chunk
    ADD CONSTRAINT "891_891_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_892_chunk 892_892_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_892_chunk
    ADD CONSTRAINT "892_892_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_893_chunk 893_893_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_893_chunk
    ADD CONSTRAINT "893_893_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_894_chunk 894_894_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_894_chunk
    ADD CONSTRAINT "894_894_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_895_chunk 895_895_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_895_chunk
    ADD CONSTRAINT "895_895_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_896_chunk 896_896_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_896_chunk
    ADD CONSTRAINT "896_896_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_897_chunk 897_897_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_897_chunk
    ADD CONSTRAINT "897_897_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_898_chunk 898_898_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_898_chunk
    ADD CONSTRAINT "898_898_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_899_chunk 899_899_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_899_chunk
    ADD CONSTRAINT "899_899_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_900_chunk 900_900_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_900_chunk
    ADD CONSTRAINT "900_900_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_901_chunk 901_901_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_901_chunk
    ADD CONSTRAINT "901_901_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_902_chunk 902_902_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_902_chunk
    ADD CONSTRAINT "902_902_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_903_chunk 903_903_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_903_chunk
    ADD CONSTRAINT "903_903_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_904_chunk 904_904_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_904_chunk
    ADD CONSTRAINT "904_904_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_905_chunk 905_905_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_905_chunk
    ADD CONSTRAINT "905_905_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_906_chunk 906_906_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_906_chunk
    ADD CONSTRAINT "906_906_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_907_chunk 907_907_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_907_chunk
    ADD CONSTRAINT "907_907_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_908_chunk 908_908_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_908_chunk
    ADD CONSTRAINT "908_908_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_909_chunk 909_909_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_909_chunk
    ADD CONSTRAINT "909_909_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_910_chunk 910_910_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_910_chunk
    ADD CONSTRAINT "910_910_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_911_chunk 911_911_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_911_chunk
    ADD CONSTRAINT "911_911_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_912_chunk 912_912_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_912_chunk
    ADD CONSTRAINT "912_912_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_913_chunk 913_913_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_913_chunk
    ADD CONSTRAINT "913_913_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_914_chunk 914_914_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_914_chunk
    ADD CONSTRAINT "914_914_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_915_chunk 915_915_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_915_chunk
    ADD CONSTRAINT "915_915_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_916_chunk 916_916_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_916_chunk
    ADD CONSTRAINT "916_916_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_917_chunk 917_917_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_917_chunk
    ADD CONSTRAINT "917_917_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_918_chunk 918_918_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_918_chunk
    ADD CONSTRAINT "918_918_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_919_chunk 919_919_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_919_chunk
    ADD CONSTRAINT "919_919_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_920_chunk 920_920_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_920_chunk
    ADD CONSTRAINT "920_920_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_921_chunk 921_921_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_921_chunk
    ADD CONSTRAINT "921_921_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_922_chunk 922_922_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_922_chunk
    ADD CONSTRAINT "922_922_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_923_chunk 923_923_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_923_chunk
    ADD CONSTRAINT "923_923_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_924_chunk 924_924_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_924_chunk
    ADD CONSTRAINT "924_924_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_925_chunk 925_925_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_925_chunk
    ADD CONSTRAINT "925_925_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_926_chunk 926_926_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_926_chunk
    ADD CONSTRAINT "926_926_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_927_chunk 927_927_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_927_chunk
    ADD CONSTRAINT "927_927_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_928_chunk 928_928_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_928_chunk
    ADD CONSTRAINT "928_928_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_929_chunk 929_929_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_929_chunk
    ADD CONSTRAINT "929_929_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_930_chunk 930_930_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_930_chunk
    ADD CONSTRAINT "930_930_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_931_chunk 931_931_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_931_chunk
    ADD CONSTRAINT "931_931_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_932_chunk 932_932_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_932_chunk
    ADD CONSTRAINT "932_932_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_933_chunk 933_933_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_933_chunk
    ADD CONSTRAINT "933_933_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_934_chunk 934_934_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_934_chunk
    ADD CONSTRAINT "934_934_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_935_chunk 935_935_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_935_chunk
    ADD CONSTRAINT "935_935_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_936_chunk 936_936_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_936_chunk
    ADD CONSTRAINT "936_936_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_937_chunk 937_937_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_937_chunk
    ADD CONSTRAINT "937_937_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_938_chunk 938_938_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_938_chunk
    ADD CONSTRAINT "938_938_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_939_chunk 939_939_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_939_chunk
    ADD CONSTRAINT "939_939_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_940_chunk 940_940_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_940_chunk
    ADD CONSTRAINT "940_940_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_941_chunk 941_941_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_941_chunk
    ADD CONSTRAINT "941_941_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_942_chunk 942_942_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_942_chunk
    ADD CONSTRAINT "942_942_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_943_chunk 943_943_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_943_chunk
    ADD CONSTRAINT "943_943_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_944_chunk 944_944_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_944_chunk
    ADD CONSTRAINT "944_944_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_945_chunk 945_945_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_945_chunk
    ADD CONSTRAINT "945_945_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_946_chunk 946_946_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_946_chunk
    ADD CONSTRAINT "946_946_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_947_chunk 947_947_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_947_chunk
    ADD CONSTRAINT "947_947_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_948_chunk 948_948_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_948_chunk
    ADD CONSTRAINT "948_948_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_949_chunk 949_949_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_949_chunk
    ADD CONSTRAINT "949_949_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_950_chunk 950_950_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_950_chunk
    ADD CONSTRAINT "950_950_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_951_chunk 951_951_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_951_chunk
    ADD CONSTRAINT "951_951_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_952_chunk 952_952_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_952_chunk
    ADD CONSTRAINT "952_952_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_953_chunk 953_953_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_953_chunk
    ADD CONSTRAINT "953_953_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_954_chunk 954_954_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_954_chunk
    ADD CONSTRAINT "954_954_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_955_chunk 955_955_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_955_chunk
    ADD CONSTRAINT "955_955_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_956_chunk 956_956_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_956_chunk
    ADD CONSTRAINT "956_956_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_957_chunk 957_957_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_957_chunk
    ADD CONSTRAINT "957_957_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_958_chunk 958_958_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_958_chunk
    ADD CONSTRAINT "958_958_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_959_chunk 959_959_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_959_chunk
    ADD CONSTRAINT "959_959_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_960_chunk 960_960_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_960_chunk
    ADD CONSTRAINT "960_960_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_961_chunk 961_961_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_961_chunk
    ADD CONSTRAINT "961_961_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_962_chunk 962_962_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_962_chunk
    ADD CONSTRAINT "962_962_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_963_chunk 963_963_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_963_chunk
    ADD CONSTRAINT "963_963_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_964_chunk 964_964_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_964_chunk
    ADD CONSTRAINT "964_964_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_965_chunk 965_965_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_965_chunk
    ADD CONSTRAINT "965_965_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_966_chunk 966_966_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_966_chunk
    ADD CONSTRAINT "966_966_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_967_chunk 967_967_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_967_chunk
    ADD CONSTRAINT "967_967_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_968_chunk 968_968_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_968_chunk
    ADD CONSTRAINT "968_968_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_969_chunk 969_969_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_969_chunk
    ADD CONSTRAINT "969_969_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_970_chunk 970_970_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_970_chunk
    ADD CONSTRAINT "970_970_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_971_chunk 971_971_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_971_chunk
    ADD CONSTRAINT "971_971_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_972_chunk 972_972_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_972_chunk
    ADD CONSTRAINT "972_972_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_973_chunk 973_973_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_973_chunk
    ADD CONSTRAINT "973_973_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_974_chunk 974_974_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_974_chunk
    ADD CONSTRAINT "974_974_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_975_chunk 975_975_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_975_chunk
    ADD CONSTRAINT "975_975_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_976_chunk 976_976_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_976_chunk
    ADD CONSTRAINT "976_976_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_977_chunk 977_977_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_977_chunk
    ADD CONSTRAINT "977_977_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_978_chunk 978_978_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_978_chunk
    ADD CONSTRAINT "978_978_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_979_chunk 979_979_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_979_chunk
    ADD CONSTRAINT "979_979_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_980_chunk 980_980_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_980_chunk
    ADD CONSTRAINT "980_980_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_981_chunk 981_981_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_981_chunk
    ADD CONSTRAINT "981_981_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_982_chunk 982_982_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_982_chunk
    ADD CONSTRAINT "982_982_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_983_chunk 983_983_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_983_chunk
    ADD CONSTRAINT "983_983_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_984_chunk 984_984_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_984_chunk
    ADD CONSTRAINT "984_984_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_985_chunk 985_985_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_985_chunk
    ADD CONSTRAINT "985_985_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_986_chunk 986_986_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_986_chunk
    ADD CONSTRAINT "986_986_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_987_chunk 987_987_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_987_chunk
    ADD CONSTRAINT "987_987_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_988_chunk 988_988_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_988_chunk
    ADD CONSTRAINT "988_988_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_989_chunk 989_989_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_989_chunk
    ADD CONSTRAINT "989_989_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_990_chunk 990_990_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_990_chunk
    ADD CONSTRAINT "990_990_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_991_chunk 991_991_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_991_chunk
    ADD CONSTRAINT "991_991_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_992_chunk 992_992_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_992_chunk
    ADD CONSTRAINT "992_992_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_993_chunk 993_993_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_993_chunk
    ADD CONSTRAINT "993_993_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_994_chunk 994_994_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_994_chunk
    ADD CONSTRAINT "994_994_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_995_chunk 995_995_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_995_chunk
    ADD CONSTRAINT "995_995_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_996_chunk 996_996_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_996_chunk
    ADD CONSTRAINT "996_996_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_997_chunk 997_997_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_997_chunk
    ADD CONSTRAINT "997_997_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_998_chunk 998_998_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_998_chunk
    ADD CONSTRAINT "998_998_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: _hyper_2_999_chunk 999_999_candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: _timescaledb_internal; Owner: -
--

ALTER TABLE ONLY _timescaledb_internal._hyper_2_999_chunk
    ADD CONSTRAINT "999_999_candles_1d_symbol_candle_start_key" UNIQUE (symbol, candle_start);


--
-- Name: job_run job_run_pkey; Type: CONSTRAINT; Schema: audit; Owner: -
--

ALTER TABLE ONLY audit.job_run
    ADD CONSTRAINT job_run_pkey PRIMARY KEY (job_run_id);


--
-- Name: candles_1d candles_1d_symbol_candle_start_key; Type: CONSTRAINT; Schema: ohlc; Owner: -
--

ALTER TABLE ONLY ohlc.candles_1d
    ADD CONSTRAINT candles_1d_symbol_candle_start_key UNIQUE (symbol, candle_start);


--
-- Name: candles_60m candles_60m_symbol_candle_start_key; Type: CONSTRAINT; Schema: ohlc; Owner: -
--

ALTER TABLE ONLY ohlc.candles_60m
    ADD CONSTRAINT candles_60m_symbol_candle_start_key UNIQUE (symbol, candle_start);


--
-- Name: indices_daily indices_daily_pkey; Type: CONSTRAINT; Schema: ohlc; Owner: -
--

ALTER TABLE ONLY ohlc.indices_daily
    ADD CONSTRAINT indices_daily_pkey PRIMARY KEY (index_name, trade_date);


--
-- Name: market_data_daily market_data_daily_pkey; Type: CONSTRAINT; Schema: ohlc; Owner: -
--

ALTER TABLE ONLY ohlc.market_data_daily
    ADD CONSTRAINT market_data_daily_pkey PRIMARY KEY (symbol, trade_date);


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
-- Name: strategies strategies_name_key; Type: CONSTRAINT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.strategies
    ADD CONSTRAINT strategies_name_key UNIQUE (name);


--
-- Name: strategies strategies_pkey; Type: CONSTRAINT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.strategies
    ADD CONSTRAINT strategies_pkey PRIMARY KEY (strategy_id);


--
-- Name: symbol symbol_instrument_token_key; Type: CONSTRAINT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.symbol
    ADD CONSTRAINT symbol_instrument_token_key UNIQUE (instrument_token);


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
-- Name: symbol ux_symbol_exchange; Type: CONSTRAINT; Schema: ref; Owner: -
--

ALTER TABLE ONLY ref.symbol
    ADD CONSTRAINT ux_symbol_exchange UNIQUE (exchange_code, symbol);


--
-- Name: app_logs app_logs_pkey; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.app_logs
    ADD CONSTRAINT app_logs_pkey PRIMARY KEY (id);


--
-- Name: broker_configs broker_configs_pkey; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.broker_configs
    ADD CONSTRAINT broker_configs_pkey PRIMARY KEY (provider);


--
-- Name: csv_mappings csv_mappings_pkey; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.csv_mappings
    ADD CONSTRAINT csv_mappings_pkey PRIMARY KEY (id);


--
-- Name: csv_mappings csv_mappings_provider_db_column_key; Type: CONSTRAINT; Schema: sys; Owner: -
--

ALTER TABLE ONLY sys.csv_mappings
    ADD CONSTRAINT csv_mappings_provider_db_column_key UNIQUE (provider, db_column);


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
-- Name: daily_pnl daily_pnl_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.daily_pnl
    ADD CONSTRAINT daily_pnl_pkey PRIMARY KEY (id);


--
-- Name: daily_pnl daily_pnl_unique_entry; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.daily_pnl
    ADD CONSTRAINT daily_pnl_unique_entry UNIQUE (date, account_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: portfolio portfolio_date_symbol_account_id_strategy_key; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.portfolio
    ADD CONSTRAINT portfolio_date_symbol_account_id_strategy_key UNIQUE (date, symbol, account_id, strategy_name);


--
-- Name: portfolio portfolio_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.portfolio
    ADD CONSTRAINT portfolio_pkey PRIMARY KEY (id);


--
-- Name: portfolio portfolio_unique_entry; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.portfolio
    ADD CONSTRAINT portfolio_unique_entry UNIQUE (date, symbol, account_id);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: positions positions_unique_entry; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.positions
    ADD CONSTRAINT positions_unique_entry UNIQUE (date, symbol, product, account_id);


--
-- Name: scanner_results scanner_results_pkey; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.scanner_results
    ADD CONSTRAINT scanner_results_pkey PRIMARY KEY (id);


--
-- Name: trades trades_external_trade_id_source_key; Type: CONSTRAINT; Schema: trading; Owner: -
--

ALTER TABLE ONLY trading.trades
    ADD CONSTRAINT trades_external_trade_id_source_key UNIQUE (external_trade_id, source);


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
-- Name: _hyper_1_1155_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1155_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1155_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1156_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1156_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1156_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1157_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1157_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1157_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1158_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1158_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1158_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1159_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1159_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1159_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1160_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1160_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1160_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1161_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1161_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1161_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1162_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1162_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1162_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1163_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1163_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1163_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1164_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1164_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1164_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1165_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1165_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1165_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1166_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1166_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1166_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1167_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1167_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1167_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1168_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1168_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1168_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1169_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1169_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1169_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1170_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1170_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1170_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1171_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1171_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1171_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1172_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1172_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1172_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1173_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1173_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1173_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1174_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1174_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1174_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1175_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1175_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1175_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1176_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1176_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1176_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1177_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1177_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1177_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1178_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1178_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1178_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1179_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1179_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1179_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1180_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1180_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1180_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1181_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1181_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1181_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1182_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1182_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1182_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1183_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1183_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1183_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1184_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1184_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1184_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1185_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1185_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1185_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1186_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1186_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1186_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1187_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1187_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1187_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1188_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1188_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1188_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1189_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1189_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1189_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1190_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1190_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1190_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1191_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1191_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1191_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1192_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1192_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1192_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1193_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1193_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1193_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1194_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1194_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1194_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1195_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1195_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1195_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1196_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1196_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1196_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1197_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1197_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1197_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1198_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1198_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1198_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1199_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1199_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1199_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1200_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1200_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1200_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1201_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1201_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1201_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1202_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1202_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1202_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1203_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1203_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1203_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1204_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1204_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1204_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1205_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1205_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1205_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1206_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1206_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1206_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1207_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1207_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1207_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1208_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1208_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1208_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1209_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1209_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1209_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1210_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1210_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1210_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1211_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1211_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1211_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1212_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1212_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1212_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1213_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1213_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1213_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1214_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1214_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1214_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1215_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1215_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1215_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1216_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1216_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1216_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1217_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1217_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1217_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1218_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1218_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1218_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1219_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1219_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1219_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1220_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1220_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1220_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1221_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1221_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1221_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1222_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1222_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1222_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1223_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1223_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1223_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1224_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1224_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1224_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1225_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1225_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1225_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1226_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1226_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1226_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1227_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1227_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1227_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1228_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1228_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1228_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1229_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1229_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1229_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1230_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1230_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1230_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1231_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1231_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1231_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1232_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1232_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1232_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1233_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1233_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1233_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1234_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1234_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1234_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1235_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1235_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1235_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1236_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1236_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1236_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1237_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1237_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1237_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1238_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1238_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1238_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1239_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1239_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1239_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1240_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1240_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1240_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1241_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1241_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1241_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1242_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1242_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1242_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1243_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1243_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1243_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1244_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1244_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1244_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1245_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1245_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1245_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1246_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1246_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1246_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1247_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1247_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1247_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1248_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1248_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1248_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1249_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1249_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1249_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1250_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1250_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1250_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1251_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1251_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1251_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1252_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1252_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1252_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1253_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1253_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1253_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1254_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1254_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1254_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1255_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1255_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1255_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1256_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1256_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1256_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1257_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1257_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1257_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1258_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1258_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1258_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1259_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1259_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1259_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1260_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1260_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1260_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1261_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1261_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1261_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1262_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1262_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1262_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1263_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1263_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1263_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1264_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1264_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1264_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1265_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1265_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1265_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1266_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1266_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1266_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1267_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1267_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1267_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1268_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1268_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1268_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1269_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1269_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1269_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1270_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1270_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1270_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1271_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1271_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1271_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1272_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1272_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1272_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1273_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1273_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1273_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1274_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1274_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1274_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1275_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1275_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1275_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1276_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1276_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1276_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1277_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1277_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1277_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1278_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1278_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1278_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1279_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1279_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1279_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1280_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1280_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1280_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1281_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1281_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1281_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1282_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1282_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1282_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1283_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1283_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1283_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1284_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1284_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1284_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1285_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1285_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1285_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1286_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1286_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1286_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1287_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1287_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1287_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1288_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1288_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1288_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1289_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1289_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1289_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1290_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1290_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1290_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1291_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1291_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1291_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1292_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1292_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1292_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1293_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1293_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1293_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1294_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1294_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1294_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1295_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1295_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1295_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1296_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1296_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1296_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1297_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1297_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1297_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1298_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1298_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1298_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1299_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1299_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1299_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1300_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1300_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1300_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1301_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1301_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1301_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1302_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1302_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1302_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1303_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1303_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1303_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1304_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1304_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1304_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1305_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1305_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1305_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1306_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1306_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1306_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1307_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1307_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1307_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1308_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1308_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1308_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1309_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1309_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1309_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1310_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1310_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1310_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1311_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1311_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1311_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1312_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1312_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1312_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1313_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1313_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1313_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1314_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1314_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1314_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1315_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1315_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1315_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1316_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1316_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1316_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1317_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1317_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1317_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1318_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1318_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1318_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1319_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1319_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1319_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1320_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1320_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1320_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1321_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1321_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1321_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1322_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1322_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1322_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1323_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1323_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1323_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1324_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1324_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1324_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1325_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1325_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1325_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1326_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1326_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1326_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_1_1327_chunk_candles_60m_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_1_1327_chunk_candles_60m_candle_start_idx ON _timescaledb_internal._hyper_1_1327_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1000_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1000_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1000_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1001_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1001_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1001_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1002_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1002_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1002_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1003_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1003_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1003_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1004_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1004_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1004_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1005_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1005_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1005_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1006_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1006_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1006_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1007_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1007_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1007_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1008_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1008_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1008_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1009_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1009_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1009_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1010_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1010_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1010_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1011_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1011_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1011_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1012_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1012_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1012_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1013_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1013_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1013_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1014_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1014_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1014_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1015_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1015_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1015_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1016_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1016_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1016_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1017_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1017_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1017_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1018_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1018_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1018_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1019_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1019_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1019_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1020_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1020_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1020_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1021_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1021_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1021_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1022_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1022_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1022_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1023_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1023_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1023_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1024_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1024_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1024_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1025_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1025_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1025_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1026_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1026_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1026_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1027_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1027_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1027_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1028_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1028_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1028_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1029_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1029_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1029_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1030_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1030_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1030_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1031_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1031_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1031_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1032_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1032_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1032_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1033_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1033_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1033_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1034_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1034_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1034_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1035_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1035_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1035_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1036_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1036_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1036_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1037_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1037_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1037_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1038_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1038_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1038_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1039_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1039_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1039_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1040_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1040_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1040_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1041_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1041_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1041_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1042_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1042_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1042_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1043_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1043_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1043_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1044_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1044_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1044_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1045_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1045_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1045_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1046_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1046_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1046_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1047_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1047_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1047_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1048_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1048_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1048_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1049_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1049_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1049_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1050_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1050_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1050_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1051_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1051_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1051_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1052_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1052_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1052_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1053_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1053_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1053_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1054_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1054_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1054_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1055_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1055_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1055_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1056_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1056_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1056_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1057_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1057_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1057_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1058_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1058_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1058_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1059_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1059_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1059_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1060_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1060_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1060_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1061_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1061_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1061_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1062_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1062_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1062_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1063_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1063_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1063_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1064_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1064_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1064_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1065_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1065_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1065_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1066_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1066_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1066_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1067_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1067_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1067_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1068_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1068_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1068_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1069_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1069_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1069_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1070_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1070_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1070_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1071_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1071_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1071_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1072_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1072_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1072_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1073_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1073_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1073_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1074_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1074_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1074_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1075_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1075_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1075_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1076_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1076_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1076_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1077_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1077_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1077_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1078_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1078_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1078_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1079_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1079_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1079_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1080_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1080_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1080_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1081_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1081_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1081_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1082_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1082_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1082_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1083_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1083_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1083_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1084_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1084_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1084_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1085_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1085_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1085_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1086_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1086_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1086_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1087_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1087_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1087_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1088_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1088_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1088_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1089_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1089_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1089_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1090_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1090_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1090_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1091_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1091_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1091_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1092_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1092_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1092_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1093_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1093_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1093_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1094_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1094_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1094_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1095_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1095_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1095_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1096_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1096_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1096_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1097_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1097_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1097_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1098_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1098_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1098_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1099_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1099_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1099_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1100_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1100_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1100_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1101_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1101_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1101_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1102_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1102_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1102_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1103_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1103_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1103_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1104_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1104_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1104_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1105_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1105_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1105_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1106_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1106_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1106_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1107_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1107_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1107_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1108_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1108_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1108_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1109_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1109_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1109_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1110_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1110_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1110_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1111_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1111_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1111_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1112_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1112_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1112_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1113_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1113_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1113_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1114_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1114_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1114_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1115_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1115_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1115_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1116_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1116_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1116_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1117_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1117_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1117_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1118_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1118_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1118_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1119_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1119_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1119_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1120_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1120_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1120_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1121_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1121_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1121_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1122_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1122_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1122_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1123_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1123_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1123_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1124_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1124_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1124_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1125_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1125_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1125_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1126_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1126_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1126_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1127_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1127_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1127_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1128_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1128_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1128_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1129_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1129_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1129_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1130_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1130_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1130_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1131_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1131_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1131_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1132_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1132_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1132_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1133_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1133_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1133_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1134_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1134_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1134_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1135_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1135_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1135_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1136_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1136_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1136_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1137_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1137_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1137_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1138_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1138_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1138_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1139_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1139_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1139_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1140_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1140_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1140_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1141_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1141_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1141_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1142_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1142_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1142_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1143_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1143_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1143_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1144_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1144_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1144_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1145_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1145_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1145_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1146_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1146_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1146_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1147_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1147_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1147_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1148_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1148_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1148_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1149_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1149_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1149_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1150_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1150_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1150_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1151_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1151_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1151_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1152_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1152_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1152_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1153_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1153_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1153_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1154_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1154_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1154_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_1328_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_1328_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_1328_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_440_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_440_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_440_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_441_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_441_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_441_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_442_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_442_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_442_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_443_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_443_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_443_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_444_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_444_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_444_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_445_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_445_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_445_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_446_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_446_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_446_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_447_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_447_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_447_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_448_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_448_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_448_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_449_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_449_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_449_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_450_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_450_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_450_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_451_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_451_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_451_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_452_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_452_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_452_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_453_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_453_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_453_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_454_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_454_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_454_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_455_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_455_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_455_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_456_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_456_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_456_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_457_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_457_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_457_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_458_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_458_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_458_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_459_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_459_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_459_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_460_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_460_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_460_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_461_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_461_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_461_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_462_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_462_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_462_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_463_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_463_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_463_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_464_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_464_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_464_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_465_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_465_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_465_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_466_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_466_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_466_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_467_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_467_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_467_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_468_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_468_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_468_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_469_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_469_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_469_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_470_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_470_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_470_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_471_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_471_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_471_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_472_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_472_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_472_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_473_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_473_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_473_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_474_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_474_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_474_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_475_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_475_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_475_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_476_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_476_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_476_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_477_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_477_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_477_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_478_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_478_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_478_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_479_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_479_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_479_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_480_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_480_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_480_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_481_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_481_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_481_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_482_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_482_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_482_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_483_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_483_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_483_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_484_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_484_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_484_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_485_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_485_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_485_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_486_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_486_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_486_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_487_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_487_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_487_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_488_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_488_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_488_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_489_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_489_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_489_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_490_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_490_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_490_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_491_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_491_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_491_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_492_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_492_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_492_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_493_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_493_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_493_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_494_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_494_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_494_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_495_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_495_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_495_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_496_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_496_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_496_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_497_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_497_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_497_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_498_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_498_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_498_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_499_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_499_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_499_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_500_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_500_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_500_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_501_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_501_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_501_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_502_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_502_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_502_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_503_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_503_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_503_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_504_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_504_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_504_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_505_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_505_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_505_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_506_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_506_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_506_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_507_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_507_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_507_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_508_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_508_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_508_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_509_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_509_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_509_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_510_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_510_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_510_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_511_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_511_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_511_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_512_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_512_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_512_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_513_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_513_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_513_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_514_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_514_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_514_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_515_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_515_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_515_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_516_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_516_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_516_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_517_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_517_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_517_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_518_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_518_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_518_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_519_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_519_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_519_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_520_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_520_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_520_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_521_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_521_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_521_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_522_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_522_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_522_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_523_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_523_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_523_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_524_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_524_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_524_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_525_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_525_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_525_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_526_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_526_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_526_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_527_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_527_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_527_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_528_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_528_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_528_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_529_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_529_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_529_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_530_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_530_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_530_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_531_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_531_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_531_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_532_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_532_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_532_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_533_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_533_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_533_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_534_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_534_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_534_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_535_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_535_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_535_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_536_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_536_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_536_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_537_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_537_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_537_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_538_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_538_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_538_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_539_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_539_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_539_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_540_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_540_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_540_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_541_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_541_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_541_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_542_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_542_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_542_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_543_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_543_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_543_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_544_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_544_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_544_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_545_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_545_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_545_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_546_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_546_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_546_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_547_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_547_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_547_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_548_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_548_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_548_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_549_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_549_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_549_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_550_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_550_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_550_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_551_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_551_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_551_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_552_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_552_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_552_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_553_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_553_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_553_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_554_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_554_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_554_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_555_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_555_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_555_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_556_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_556_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_556_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_557_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_557_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_557_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_558_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_558_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_558_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_559_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_559_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_559_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_560_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_560_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_560_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_561_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_561_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_561_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_562_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_562_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_562_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_563_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_563_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_563_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_564_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_564_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_564_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_565_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_565_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_565_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_566_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_566_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_566_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_567_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_567_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_567_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_568_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_568_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_568_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_569_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_569_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_569_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_570_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_570_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_570_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_571_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_571_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_571_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_572_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_572_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_572_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_573_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_573_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_573_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_574_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_574_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_574_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_575_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_575_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_575_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_576_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_576_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_576_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_577_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_577_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_577_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_578_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_578_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_578_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_579_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_579_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_579_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_580_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_580_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_580_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_581_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_581_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_581_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_582_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_582_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_582_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_583_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_583_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_583_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_584_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_584_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_584_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_585_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_585_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_585_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_586_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_586_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_586_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_587_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_587_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_587_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_588_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_588_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_588_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_589_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_589_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_589_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_590_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_590_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_590_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_591_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_591_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_591_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_592_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_592_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_592_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_593_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_593_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_593_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_594_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_594_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_594_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_595_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_595_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_595_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_596_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_596_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_596_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_597_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_597_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_597_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_598_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_598_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_598_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_599_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_599_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_599_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_600_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_600_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_600_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_601_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_601_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_601_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_602_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_602_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_602_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_603_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_603_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_603_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_604_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_604_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_604_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_605_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_605_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_605_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_606_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_606_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_606_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_607_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_607_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_607_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_608_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_608_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_608_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_609_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_609_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_609_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_610_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_610_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_610_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_611_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_611_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_611_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_612_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_612_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_612_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_613_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_613_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_613_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_614_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_614_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_614_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_615_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_615_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_615_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_616_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_616_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_616_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_617_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_617_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_617_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_618_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_618_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_618_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_619_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_619_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_619_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_620_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_620_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_620_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_621_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_621_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_621_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_622_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_622_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_622_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_623_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_623_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_623_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_624_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_624_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_624_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_625_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_625_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_625_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_626_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_626_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_626_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_627_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_627_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_627_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_628_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_628_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_628_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_629_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_629_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_629_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_630_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_630_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_630_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_631_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_631_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_631_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_632_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_632_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_632_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_633_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_633_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_633_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_634_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_634_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_634_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_635_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_635_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_635_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_636_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_636_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_636_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_637_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_637_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_637_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_638_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_638_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_638_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_639_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_639_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_639_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_640_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_640_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_640_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_641_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_641_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_641_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_642_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_642_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_642_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_643_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_643_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_643_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_644_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_644_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_644_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_645_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_645_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_645_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_646_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_646_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_646_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_647_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_647_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_647_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_648_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_648_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_648_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_649_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_649_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_649_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_650_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_650_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_650_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_651_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_651_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_651_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_652_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_652_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_652_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_653_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_653_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_653_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_654_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_654_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_654_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_655_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_655_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_655_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_656_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_656_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_656_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_657_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_657_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_657_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_658_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_658_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_658_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_659_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_659_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_659_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_660_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_660_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_660_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_661_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_661_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_661_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_662_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_662_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_662_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_663_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_663_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_663_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_664_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_664_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_664_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_665_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_665_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_665_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_666_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_666_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_666_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_667_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_667_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_667_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_668_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_668_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_668_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_669_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_669_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_669_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_670_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_670_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_670_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_671_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_671_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_671_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_672_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_672_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_672_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_673_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_673_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_673_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_674_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_674_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_674_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_675_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_675_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_675_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_676_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_676_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_676_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_677_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_677_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_677_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_678_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_678_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_678_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_679_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_679_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_679_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_680_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_680_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_680_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_681_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_681_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_681_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_682_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_682_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_682_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_683_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_683_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_683_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_684_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_684_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_684_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_685_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_685_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_685_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_686_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_686_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_686_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_687_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_687_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_687_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_688_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_688_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_688_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_689_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_689_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_689_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_690_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_690_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_690_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_691_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_691_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_691_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_692_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_692_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_692_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_693_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_693_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_693_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_694_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_694_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_694_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_695_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_695_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_695_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_696_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_696_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_696_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_697_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_697_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_697_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_698_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_698_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_698_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_699_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_699_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_699_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_700_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_700_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_700_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_701_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_701_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_701_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_702_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_702_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_702_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_703_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_703_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_703_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_704_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_704_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_704_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_705_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_705_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_705_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_706_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_706_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_706_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_707_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_707_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_707_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_708_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_708_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_708_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_709_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_709_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_709_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_710_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_710_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_710_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_711_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_711_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_711_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_712_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_712_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_712_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_713_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_713_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_713_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_714_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_714_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_714_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_715_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_715_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_715_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_716_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_716_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_716_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_717_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_717_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_717_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_718_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_718_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_718_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_719_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_719_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_719_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_720_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_720_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_720_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_721_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_721_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_721_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_722_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_722_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_722_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_723_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_723_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_723_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_724_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_724_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_724_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_725_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_725_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_725_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_726_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_726_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_726_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_727_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_727_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_727_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_728_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_728_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_728_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_729_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_729_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_729_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_730_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_730_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_730_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_731_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_731_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_731_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_732_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_732_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_732_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_733_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_733_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_733_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_734_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_734_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_734_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_735_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_735_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_735_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_736_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_736_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_736_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_737_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_737_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_737_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_738_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_738_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_738_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_739_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_739_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_739_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_740_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_740_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_740_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_741_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_741_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_741_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_742_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_742_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_742_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_743_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_743_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_743_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_744_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_744_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_744_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_745_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_745_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_745_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_746_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_746_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_746_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_747_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_747_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_747_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_748_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_748_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_748_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_749_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_749_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_749_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_750_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_750_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_750_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_751_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_751_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_751_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_752_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_752_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_752_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_753_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_753_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_753_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_754_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_754_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_754_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_755_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_755_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_755_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_756_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_756_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_756_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_757_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_757_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_757_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_758_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_758_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_758_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_759_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_759_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_759_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_760_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_760_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_760_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_761_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_761_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_761_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_762_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_762_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_762_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_763_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_763_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_763_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_764_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_764_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_764_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_765_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_765_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_765_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_766_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_766_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_766_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_767_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_767_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_767_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_768_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_768_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_768_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_769_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_769_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_769_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_770_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_770_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_770_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_771_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_771_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_771_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_772_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_772_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_772_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_773_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_773_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_773_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_774_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_774_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_774_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_775_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_775_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_775_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_776_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_776_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_776_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_777_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_777_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_777_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_778_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_778_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_778_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_779_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_779_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_779_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_780_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_780_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_780_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_781_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_781_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_781_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_782_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_782_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_782_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_783_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_783_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_783_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_784_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_784_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_784_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_785_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_785_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_785_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_786_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_786_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_786_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_787_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_787_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_787_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_788_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_788_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_788_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_789_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_789_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_789_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_790_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_790_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_790_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_791_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_791_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_791_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_792_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_792_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_792_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_793_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_793_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_793_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_794_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_794_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_794_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_795_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_795_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_795_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_796_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_796_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_796_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_797_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_797_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_797_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_798_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_798_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_798_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_799_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_799_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_799_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_800_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_800_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_800_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_801_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_801_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_801_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_802_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_802_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_802_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_803_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_803_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_803_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_804_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_804_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_804_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_805_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_805_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_805_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_806_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_806_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_806_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_807_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_807_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_807_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_808_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_808_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_808_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_809_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_809_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_809_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_810_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_810_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_810_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_811_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_811_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_811_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_812_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_812_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_812_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_813_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_813_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_813_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_814_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_814_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_814_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_815_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_815_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_815_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_816_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_816_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_816_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_817_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_817_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_817_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_818_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_818_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_818_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_819_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_819_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_819_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_820_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_820_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_820_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_821_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_821_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_821_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_822_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_822_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_822_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_823_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_823_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_823_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_824_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_824_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_824_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_825_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_825_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_825_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_826_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_826_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_826_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_827_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_827_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_827_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_828_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_828_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_828_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_829_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_829_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_829_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_830_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_830_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_830_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_831_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_831_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_831_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_832_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_832_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_832_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_833_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_833_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_833_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_834_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_834_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_834_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_835_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_835_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_835_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_836_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_836_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_836_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_837_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_837_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_837_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_838_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_838_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_838_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_839_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_839_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_839_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_840_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_840_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_840_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_841_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_841_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_841_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_842_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_842_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_842_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_843_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_843_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_843_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_844_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_844_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_844_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_845_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_845_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_845_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_846_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_846_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_846_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_847_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_847_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_847_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_848_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_848_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_848_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_849_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_849_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_849_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_850_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_850_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_850_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_851_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_851_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_851_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_852_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_852_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_852_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_853_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_853_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_853_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_854_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_854_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_854_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_855_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_855_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_855_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_856_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_856_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_856_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_857_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_857_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_857_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_858_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_858_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_858_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_859_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_859_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_859_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_860_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_860_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_860_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_861_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_861_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_861_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_862_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_862_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_862_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_863_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_863_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_863_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_864_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_864_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_864_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_865_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_865_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_865_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_866_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_866_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_866_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_867_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_867_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_867_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_868_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_868_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_868_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_869_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_869_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_869_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_870_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_870_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_870_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_871_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_871_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_871_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_872_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_872_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_872_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_873_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_873_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_873_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_874_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_874_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_874_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_875_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_875_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_875_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_876_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_876_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_876_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_877_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_877_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_877_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_878_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_878_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_878_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_879_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_879_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_879_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_880_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_880_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_880_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_881_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_881_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_881_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_882_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_882_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_882_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_883_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_883_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_883_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_884_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_884_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_884_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_885_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_885_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_885_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_886_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_886_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_886_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_887_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_887_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_887_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_888_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_888_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_888_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_889_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_889_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_889_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_890_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_890_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_890_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_891_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_891_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_891_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_892_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_892_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_892_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_893_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_893_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_893_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_894_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_894_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_894_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_895_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_895_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_895_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_896_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_896_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_896_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_897_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_897_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_897_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_898_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_898_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_898_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_899_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_899_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_899_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_900_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_900_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_900_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_901_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_901_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_901_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_902_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_902_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_902_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_903_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_903_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_903_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_904_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_904_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_904_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_905_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_905_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_905_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_906_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_906_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_906_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_907_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_907_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_907_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_908_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_908_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_908_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_909_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_909_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_909_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_910_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_910_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_910_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_911_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_911_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_911_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_912_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_912_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_912_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_913_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_913_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_913_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_914_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_914_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_914_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_915_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_915_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_915_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_916_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_916_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_916_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_917_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_917_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_917_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_918_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_918_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_918_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_919_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_919_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_919_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_920_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_920_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_920_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_921_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_921_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_921_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_922_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_922_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_922_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_923_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_923_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_923_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_924_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_924_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_924_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_925_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_925_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_925_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_926_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_926_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_926_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_927_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_927_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_927_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_928_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_928_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_928_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_929_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_929_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_929_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_930_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_930_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_930_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_931_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_931_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_931_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_932_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_932_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_932_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_933_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_933_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_933_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_934_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_934_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_934_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_935_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_935_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_935_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_936_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_936_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_936_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_937_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_937_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_937_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_938_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_938_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_938_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_939_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_939_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_939_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_940_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_940_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_940_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_941_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_941_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_941_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_942_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_942_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_942_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_943_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_943_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_943_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_944_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_944_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_944_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_945_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_945_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_945_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_946_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_946_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_946_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_947_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_947_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_947_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_948_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_948_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_948_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_949_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_949_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_949_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_950_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_950_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_950_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_951_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_951_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_951_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_952_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_952_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_952_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_953_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_953_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_953_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_954_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_954_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_954_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_955_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_955_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_955_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_956_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_956_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_956_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_957_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_957_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_957_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_958_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_958_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_958_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_959_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_959_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_959_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_960_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_960_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_960_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_961_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_961_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_961_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_962_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_962_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_962_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_963_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_963_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_963_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_964_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_964_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_964_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_965_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_965_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_965_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_966_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_966_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_966_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_967_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_967_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_967_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_968_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_968_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_968_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_969_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_969_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_969_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_970_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_970_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_970_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_971_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_971_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_971_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_972_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_972_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_972_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_973_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_973_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_973_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_974_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_974_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_974_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_975_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_975_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_975_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_976_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_976_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_976_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_977_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_977_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_977_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_978_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_978_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_978_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_979_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_979_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_979_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_980_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_980_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_980_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_981_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_981_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_981_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_982_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_982_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_982_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_983_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_983_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_983_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_984_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_984_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_984_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_985_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_985_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_985_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_986_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_986_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_986_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_987_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_987_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_987_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_988_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_988_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_988_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_989_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_989_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_989_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_990_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_990_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_990_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_991_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_991_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_991_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_992_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_992_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_992_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_993_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_993_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_993_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_994_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_994_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_994_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_995_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_995_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_995_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_996_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_996_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_996_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_997_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_997_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_997_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_998_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_998_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_998_chunk USING btree (candle_start DESC);


--
-- Name: _hyper_2_999_chunk_candles_1d_candle_start_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: -
--

CREATE INDEX _hyper_2_999_chunk_candles_1d_candle_start_idx ON _timescaledb_internal._hyper_2_999_chunk USING btree (candle_start DESC);


--
-- Name: candles_1d_candle_start_idx; Type: INDEX; Schema: ohlc; Owner: -
--

CREATE INDEX candles_1d_candle_start_idx ON ohlc.candles_1d USING btree (candle_start DESC);


--
-- Name: candles_60m_candle_start_idx; Type: INDEX; Schema: ohlc; Owner: -
--

CREATE INDEX candles_60m_candle_start_idx ON ohlc.candles_60m USING btree (candle_start DESC);


--
-- Name: idx_ref_symbol_instrument_token; Type: INDEX; Schema: ref; Owner: -
--

CREATE INDEX idx_ref_symbol_instrument_token ON ref.symbol USING btree (instrument_token);


--
-- Name: idx_ref_symbol_trading_symbol; Type: INDEX; Schema: ref; Owner: -
--

CREATE INDEX idx_ref_symbol_trading_symbol ON ref.symbol USING btree (trading_symbol);


--
-- Name: idx_app_logs_history_id; Type: INDEX; Schema: sys; Owner: -
--

CREATE INDEX idx_app_logs_history_id ON sys.app_logs USING btree (history_id);


--
-- Name: idx_app_logs_timestamp; Type: INDEX; Schema: sys; Owner: -
--

CREATE INDEX idx_app_logs_timestamp ON sys.app_logs USING btree ("timestamp" DESC);


--
-- Name: idx_csv_mappings_provider; Type: INDEX; Schema: sys; Owner: -
--

CREATE INDEX idx_csv_mappings_provider ON sys.csv_mappings USING btree (provider);


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
-- Name: idx_orders_account_id; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX idx_orders_account_id ON trading.orders USING btree (account_id);


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
-- Name: idx_trades_account_id; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX idx_trades_account_id ON trading.trades USING btree (account_id);


--
-- Name: idx_trades_date; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX idx_trades_date ON trading.trades USING btree (trade_date);


--
-- Name: idx_trades_symbol_date; Type: INDEX; Schema: trading; Owner: -
--

CREATE INDEX idx_trades_symbol_date ON trading.trades USING btree (symbol, trade_date);


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

\unrestrict LVxYBuGY3DivfaRodYRlfbxOWYPGYrAQ1DI7zLrmf8gEviFwdoT3k4SVlZw1AwG

