# Database Schema Documentation

## Schema: `_timescaledb_cache`

### Table: `cache_inval_bgw_job`

*No columns found.*

### Table: `cache_inval_extension`

*No columns found.*

### Table: `cache_inval_hypertable`

*No columns found.*

## Schema: `_timescaledb_catalog`

### Table: `chunk`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('_timescaledb_catalog.chunk_id_seq'::regclass)` |
| **hypertable_id** | integer | NO | - |
| **schema_name** | name | NO | - |
| **table_name** | name | NO | - |
| **compressed_chunk_id** | integer | YES | - |
| **dropped** | boolean | NO | `false` |
| **status** | integer | NO | `0` |
| **osm_chunk** | boolean | NO | `false` |
| **creation_time** | timestamp with time zone | NO | - |

### Table: `chunk_column_stats`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('_timescaledb_catalog.chunk_column_stats_id_seq'::regclass)` |
| **hypertable_id** | integer | NO | - |
| **chunk_id** | integer | YES | - |
| **column_name** | name | NO | - |
| **range_start** | bigint | NO | - |
| **range_end** | bigint | NO | - |
| **valid** | boolean | NO | - |

### Table: `chunk_constraint`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **chunk_id** | integer | NO | - |
| **dimension_slice_id** | integer | YES | - |
| **constraint_name** | name | NO | - |
| **hypertable_constraint_name** | name | YES | - |

### Table: `chunk_rewrite`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **chunk_relid** | regclass | NO | - |
| **new_relid** | regclass | NO | - |

### Table: `compression_algorithm`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | smallint | NO | - |
| **version** | smallint | NO | - |
| **name** | name | NO | - |
| **description** | text | YES | - |

### Table: `compression_chunk_size`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **chunk_id** | integer | NO | - |
| **compressed_chunk_id** | integer | NO | - |
| **uncompressed_heap_size** | bigint | NO | - |
| **uncompressed_toast_size** | bigint | NO | - |
| **uncompressed_index_size** | bigint | NO | - |
| **compressed_heap_size** | bigint | NO | - |
| **compressed_toast_size** | bigint | NO | - |
| **compressed_index_size** | bigint | NO | - |
| **numrows_pre_compression** | bigint | YES | - |
| **numrows_post_compression** | bigint | YES | - |
| **numrows_frozen_immediately** | bigint | YES | - |

### Table: `compression_settings`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **relid** | regclass | NO | - |
| **compress_relid** | regclass | YES | - |
| **segmentby** | ARRAY | YES | - |
| **orderby** | ARRAY | YES | - |
| **orderby_desc** | ARRAY | YES | - |
| **orderby_nullsfirst** | ARRAY | YES | - |
| **index** | jsonb | YES | - |

### Table: `continuous_agg`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **mat_hypertable_id** | integer | NO | - |
| **raw_hypertable_id** | integer | NO | - |
| **parent_mat_hypertable_id** | integer | YES | - |
| **user_view_schema** | name | NO | - |
| **user_view_name** | name | NO | - |
| **partial_view_schema** | name | NO | - |
| **partial_view_name** | name | NO | - |
| **direct_view_schema** | name | NO | - |
| **direct_view_name** | name | NO | - |
| **materialized_only** | boolean | NO | `false` |
| **finalized** | boolean | NO | `true` |

### Table: `continuous_agg_migrate_plan`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **mat_hypertable_id** | integer | NO | - |
| **start_ts** | timestamp with time zone | NO | `now()` |
| **end_ts** | timestamp with time zone | YES | - |
| **user_view_definition** | text | YES | - |

### Table: `continuous_agg_migrate_plan_step`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **mat_hypertable_id** | integer | NO | - |
| **step_id** | integer | NO | `nextval('_timescaledb_catalog.continuous_agg_migrate_plan_step_step_id_seq'::regclass)` |
| **status** | text | NO | `'NOT STARTED'::text` |
| **start_ts** | timestamp with time zone | YES | - |
| **end_ts** | timestamp with time zone | YES | - |
| **type** | text | NO | - |
| **config** | jsonb | YES | - |

### Table: `continuous_aggs_bucket_function`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **mat_hypertable_id** | integer | NO | - |
| **bucket_func** | text | NO | - |
| **bucket_width** | text | NO | - |
| **bucket_origin** | text | YES | - |
| **bucket_offset** | text | YES | - |
| **bucket_timezone** | text | YES | - |
| **bucket_fixed_width** | boolean | NO | - |

### Table: `continuous_aggs_hypertable_invalidation_log`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable_id** | integer | NO | - |
| **lowest_modified_value** | bigint | NO | - |
| **greatest_modified_value** | bigint | NO | - |

### Table: `continuous_aggs_invalidation_threshold`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable_id** | integer | NO | - |
| **watermark** | bigint | NO | - |

### Table: `continuous_aggs_materialization_invalidation_log`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **materialization_id** | integer | YES | - |
| **lowest_modified_value** | bigint | NO | - |
| **greatest_modified_value** | bigint | NO | - |

### Table: `continuous_aggs_materialization_ranges`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **materialization_id** | integer | YES | - |
| **lowest_modified_value** | bigint | NO | - |
| **greatest_modified_value** | bigint | NO | - |

### Table: `continuous_aggs_watermark`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **mat_hypertable_id** | integer | NO | - |
| **watermark** | bigint | NO | - |

### Table: `dimension`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('_timescaledb_catalog.dimension_id_seq'::regclass)` |
| **hypertable_id** | integer | NO | - |
| **column_name** | name | NO | - |
| **column_type** | regtype | NO | - |
| **aligned** | boolean | NO | - |
| **num_slices** | smallint | YES | - |
| **partitioning_func_schema** | name | YES | - |
| **partitioning_func** | name | YES | - |
| **interval_length** | bigint | YES | - |
| **compress_interval_length** | bigint | YES | - |
| **integer_now_func_schema** | name | YES | - |
| **integer_now_func** | name | YES | - |

### Table: `dimension_slice`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('_timescaledb_catalog.dimension_slice_id_seq'::regclass)` |
| **dimension_id** | integer | NO | - |
| **range_start** | bigint | NO | - |
| **range_end** | bigint | NO | - |

### Table: `hypertable`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('_timescaledb_catalog.hypertable_id_seq'::regclass)` |
| **schema_name** | name | NO | - |
| **table_name** | name | NO | - |
| **associated_schema_name** | name | NO | - |
| **associated_table_prefix** | name | NO | - |
| **num_dimensions** | smallint | NO | - |
| **chunk_sizing_func_schema** | name | NO | - |
| **chunk_sizing_func_name** | name | NO | - |
| **chunk_target_size** | bigint | NO | - |
| **compression_state** | smallint | NO | `0` |
| **compressed_hypertable_id** | integer | YES | - |
| **status** | integer | NO | `0` |

### Table: `metadata`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **key** | name | NO | - |
| **value** | text | NO | - |
| **include_in_telemetry** | boolean | NO | - |

### Table: `tablespace`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('_timescaledb_catalog.tablespace_id_seq'::regclass)` |
| **hypertable_id** | integer | NO | - |
| **tablespace_name** | name | NO | - |

### Table: `telemetry_event`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **created** | timestamp with time zone | NO | `CURRENT_TIMESTAMP` |
| **tag** | name | NO | - |
| **body** | jsonb | NO | - |

## Schema: `_timescaledb_config`

### Table: `bgw_job`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('_timescaledb_config.bgw_job_id_seq'::regclass)` |
| **application_name** | name | NO | - |
| **schedule_interval** | interval | NO | - |
| **max_runtime** | interval | NO | - |
| **max_retries** | integer | NO | - |
| **retry_period** | interval | NO | - |
| **proc_schema** | name | NO | - |
| **proc_name** | name | NO | - |
| **owner** | regrole | NO | `(quote_ident((CURRENT_ROLE)::text))::regrole` |
| **scheduled** | boolean | NO | `true` |
| **fixed_schedule** | boolean | NO | `true` |
| **initial_start** | timestamp with time zone | YES | - |
| **hypertable_id** | integer | YES | - |
| **config** | jsonb | YES | - |
| **check_schema** | name | YES | - |
| **check_name** | name | YES | - |
| **timezone** | text | YES | - |

## Schema: `audit`

### Table: `job_run`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **job_run_id** | bigint | NO | `nextval('audit.job_run_job_run_id_seq'::regclass)` |
| **job_name** | text | NO | - |
| **status** | text | NO | - |
| **start_time** | timestamp with time zone | YES | `now()` |
| **end_time** | timestamp with time zone | YES | - |
| **rows_affected** | integer | YES | - |
| **message** | text | YES | - |

## Schema: `ohlc`

### Table: `candles_1d`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **candle_start** | timestamp with time zone | NO | - |
| **symbol** | text | NO | - |
| **exchange_code** | text | NO | - |
| **open** | numeric | YES | - |
| **high** | numeric | YES | - |
| **low** | numeric | YES | - |
| **close** | numeric | YES | - |
| **volume** | bigint | YES | - |

### Table: `candles_60m`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **candle_start** | timestamp with time zone | NO | - |
| **symbol** | text | NO | - |
| **exchange_code** | text | NO | - |
| **open** | numeric | YES | - |
| **high** | numeric | YES | - |
| **low** | numeric | YES | - |
| **close** | numeric | YES | - |
| **volume** | bigint | YES | - |

### Table: `indices_daily`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **index_name** | character varying | NO | - |
| **trade_date** | date | NO | - |
| **open_value** | double precision | YES | - |
| **high_value** | double precision | YES | - |
| **low_value** | double precision | YES | - |
| **close_value** | double precision | YES | - |
| **volume** | bigint | YES | - |
| **pe_ratio** | double precision | YES | - |
| **pb_ratio** | double precision | YES | - |
| **div_yield** | double precision | YES | - |
| **points_change** | double precision | YES | - |
| **change_pct** | double precision | YES | - |
| **turnover_cr** | double precision | YES | - |

### Table: `market_data_daily`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **symbol** | character varying | NO | - |
| **trade_date** | date | NO | - |
| **series** | character varying | YES | - |
| **open_price** | double precision | YES | - |
| **high_price** | double precision | YES | - |
| **low_price** | double precision | YES | - |
| **close_price** | double precision | YES | - |
| **volume** | bigint | YES | - |
| **delivery_qty** | bigint | YES | - |
| **delivery_pct** | double precision | YES | - |
| **prev_close** | double precision | YES | - |
| **last_price** | double precision | YES | - |
| **avg_price** | double precision | YES | - |
| **turnover_lacs** | double precision | YES | - |
| **no_of_trades** | bigint | YES | - |

## Schema: `ref`

### Table: `exchange`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **exchange_code** | text | NO | - |
| **exchange_name** | text | NO | - |
| **country** | text | YES | `'IN'::text` |
| **timezone** | text | YES | `'Asia/Kolkata'::text` |
| **is_active** | boolean | NO | `true` |

### Table: `index_mapping`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **mapping_id** | bigint | NO | `nextval('ref.index_mapping_mapping_id_seq'::regclass)` |
| **index_name** | text | NO | - |
| **stock_symbol** | text | NO | - |
| **created_at** | character varying | YES | - |

### Table: `index_source`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **index_name** | text | NO | - |
| **source_url** | text | NO | - |
| **is_active** | boolean | YES | `true` |
| **created_at** | timestamp with time zone | YES | `now()` |
| **mapping_id** | integer | YES | - |
| **stock_symbol** | character varying | YES | - |

### Table: `strategies`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **strategy_id** | integer | NO | `nextval('ref.strategies_strategy_id_seq'::regclass)` |
| **name** | text | NO | - |
| **description** | text | YES | - |
| **created_at** | timestamp with time zone | YES | `now()` |
| **updated_at** | timestamp with time zone | YES | `now()` |

### Table: `symbol`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **symbol_id** | bigint | NO | `nextval('ref.symbol_symbol_id_seq'::regclass)` |
| **exchange_code** | text | NO | - |
| **symbol** | text | NO | - |
| **trading_symbol** | text | NO | - |
| **instrument_token** | integer | NO | - |
| **segment** | text | YES | - |
| **lot_size** | integer | YES | - |
| **is_index** | boolean | YES | `false` |
| **is_active** | boolean | YES | `true` |
| **is_index_constituent** | boolean | YES | `false` |
| **created_at** | timestamp with time zone | YES | `now()` |
| **updated_at** | timestamp with time zone | YES | `now()` |

## Schema: `sys`

### Table: `app_logs`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('sys.app_logs_id_seq'::regclass)` |
| **history_id** | integer | YES | - |
| **level** | character varying | NO | - |
| **message** | text | NO | - |
| **module** | text | YES | - |
| **timestamp** | timestamp with time zone | YES | `now()` |
| **metadata** | jsonb | YES | - |

### Table: `broker_configs`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **provider** | text | NO | - |
| **skip_rows** | integer | YES | `0` |
| **header_row** | integer | YES | `0` |
| **created_at** | timestamp without time zone | YES | `CURRENT_TIMESTAMP` |
| **updated_at** | timestamp without time zone | YES | `CURRENT_TIMESTAMP` |
| **skip_cols** | integer | YES | `0` |

### Table: `csv_mappings`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('sys.csv_mappings_id_seq'::regclass)` |
| **provider** | text | NO | - |
| **csv_column** | text | NO | - |
| **db_column** | text | NO | - |
| **is_required** | boolean | YES | `true` |
| **default_value** | text | YES | - |
| **data_type** | text | YES | `'text'::text` |

### Table: `job_history`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('sys.job_history_id_seq'::regclass)` |
| **job_name** | text | NO | - |
| **start_time** | timestamp with time zone | YES | `now()` |
| **end_time** | timestamp with time zone | YES | - |
| **status** | text | YES | - |
| **details** | text | YES | - |
| **created_at** | timestamp with time zone | YES | `now()` |
| **log_path** | text | YES | - |
| **duration_seconds** | numeric | YES | - |
| **exit_message** | text | YES | - |
| **output_summary** | text | YES | - |
| **pid** | integer | YES | - |

### Table: `job_triggers`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('sys.job_triggers_id_seq'::regclass)` |
| **job_name** | text | NO | - |
| **params** | jsonb | YES | `'{}'::jsonb` |
| **triggered_by** | text | YES | `'system'::text` |
| **triggered_at** | timestamp with time zone | YES | `now()` |
| **processed_at** | timestamp with time zone | YES | - |
| **status** | text | YES | `'PENDING'::text` |
| **execution_id** | uuid | YES | - |
| **error_message** | text | YES | - |

### Table: `scanners`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('sys.scanners_id_seq'::regclass)` |
| **name** | text | NO | - |
| **description** | text | YES | - |
| **source_universe** | text | YES | `'Nifty 50'::text` |
| **logic_config** | jsonb | NO | - |
| **schedule_cron** | text | YES | - |
| **last_run_at** | timestamp with time zone | YES | - |
| **last_match_count** | integer | YES | `0` |
| **last_run_stats** | jsonb | YES | `'{}'::jsonb` |
| **created_at** | timestamp with time zone | YES | `now()` |
| **updated_at** | timestamp with time zone | YES | `now()` |
| **is_active** | boolean | YES | `true` |

### Table: `scheduled_jobs`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('sys.scheduled_jobs_id_seq'::regclass)` |
| **name** | text | NO | - |
| **description** | text | YES | - |
| **command** | text | NO | - |
| **schedule_cron** | text | NO | - |
| **is_enabled** | boolean | YES | `true` |
| **max_retries** | integer | YES | `0` |
| **timeout_sec** | integer | YES | `3600` |
| **last_run_at** | timestamp with time zone | YES | - |
| **next_run_at** | timestamp with time zone | YES | - |
| **created_at** | timestamp with time zone | YES | `now()` |
| **updated_at** | timestamp with time zone | YES | `now()` |

### Table: `service_status`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **service_name** | text | NO | - |
| **last_heartbeat** | timestamp with time zone | YES | - |
| **status** | text | YES | - |
| **info** | jsonb | YES | - |

## Schema: `timescaledb_experimental`

### Table: `policies`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **relation_name** | name | YES | - |
| **relation_schema** | name | YES | - |
| **schedule_interval** | interval | YES | - |
| **proc_schema** | name | YES | - |
| **proc_name** | name | YES | - |
| **config** | jsonb | YES | - |
| **hypertable_schema** | name | YES | - |
| **hypertable_name** | name | YES | - |

## Schema: `timescaledb_information`

### Table: `chunk_columnstore_settings`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable** | regclass | YES | - |
| **chunk** | regclass | YES | - |
| **segmentby** | text | YES | - |
| **orderby** | text | YES | - |
| **index** | jsonb | YES | - |

### Table: `chunk_compression_settings`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable** | regclass | YES | - |
| **chunk** | regclass | YES | - |
| **segmentby** | text | YES | - |
| **orderby** | text | YES | - |
| **index** | jsonb | YES | - |

### Table: `chunks`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable_schema** | name | YES | - |
| **hypertable_name** | name | YES | - |
| **chunk_schema** | name | YES | - |
| **chunk_name** | name | YES | - |
| **primary_dimension** | name | YES | - |
| **primary_dimension_type** | regtype | YES | - |
| **range_start** | timestamp with time zone | YES | - |
| **range_end** | timestamp with time zone | YES | - |
| **range_start_integer** | bigint | YES | - |
| **range_end_integer** | bigint | YES | - |
| **is_compressed** | boolean | YES | - |
| **chunk_tablespace** | name | YES | - |
| **chunk_creation_time** | timestamp with time zone | YES | - |

### Table: `compression_settings`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable_schema** | name | YES | - |
| **hypertable_name** | name | YES | - |
| **attname** | name | YES | - |
| **segmentby_column_index** | smallint | YES | - |
| **orderby_column_index** | smallint | YES | - |
| **orderby_asc** | boolean | YES | - |
| **orderby_nullsfirst** | boolean | YES | - |

### Table: `continuous_aggregates`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable_schema** | name | YES | - |
| **hypertable_name** | name | YES | - |
| **view_schema** | name | YES | - |
| **view_name** | name | YES | - |
| **view_owner** | name | YES | - |
| **materialized_only** | boolean | YES | - |
| **compression_enabled** | boolean | YES | - |
| **materialization_hypertable_schema** | name | YES | - |
| **materialization_hypertable_name** | name | YES | - |
| **view_definition** | text | YES | - |
| **finalized** | boolean | YES | - |

### Table: `dimensions`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable_schema** | name | YES | - |
| **hypertable_name** | name | YES | - |
| **dimension_number** | bigint | YES | - |
| **column_name** | name | YES | - |
| **column_type** | regtype | YES | - |
| **dimension_type** | text | YES | - |
| **time_interval** | interval | YES | - |
| **integer_interval** | bigint | YES | - |
| **integer_now_func** | name | YES | - |
| **num_partitions** | smallint | YES | - |

### Table: `hypertable_columnstore_settings`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable** | regclass | YES | - |
| **segmentby** | text | YES | - |
| **orderby** | text | YES | - |
| **compress_interval_length** | text | YES | - |
| **index** | jsonb | YES | - |

### Table: `hypertable_compression_settings`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable** | regclass | YES | - |
| **segmentby** | text | YES | - |
| **orderby** | text | YES | - |
| **compress_interval_length** | text | YES | - |
| **index** | jsonb | YES | - |

### Table: `hypertables`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable_schema** | name | YES | - |
| **hypertable_name** | name | YES | - |
| **owner** | name | YES | - |
| **num_dimensions** | smallint | YES | - |
| **num_chunks** | bigint | YES | - |
| **compression_enabled** | boolean | YES | - |
| **tablespaces** | ARRAY | YES | - |
| **primary_dimension** | name | YES | - |
| **primary_dimension_type** | regtype | YES | - |

### Table: `job_errors`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **job_id** | integer | YES | - |
| **proc_schema** | text | YES | - |
| **proc_name** | text | YES | - |
| **pid** | integer | YES | - |
| **start_time** | timestamp with time zone | YES | - |
| **finish_time** | timestamp with time zone | YES | - |
| **sqlerrcode** | text | YES | - |
| **err_message** | text | YES | - |

### Table: `job_history`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | bigint | YES | - |
| **job_id** | integer | YES | - |
| **succeeded** | boolean | YES | - |
| **proc_schema** | text | YES | - |
| **proc_name** | text | YES | - |
| **pid** | integer | YES | - |
| **start_time** | timestamp with time zone | YES | - |
| **finish_time** | timestamp with time zone | YES | - |
| **config** | jsonb | YES | - |
| **sqlerrcode** | text | YES | - |
| **err_message** | text | YES | - |

### Table: `job_stats`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **hypertable_schema** | name | YES | - |
| **hypertable_name** | name | YES | - |
| **job_id** | integer | YES | - |
| **last_run_started_at** | timestamp with time zone | YES | - |
| **last_successful_finish** | timestamp with time zone | YES | - |
| **last_run_status** | text | YES | - |
| **job_status** | text | YES | - |
| **last_run_duration** | interval | YES | - |
| **next_start** | timestamp with time zone | YES | - |
| **total_runs** | bigint | YES | - |
| **total_successes** | bigint | YES | - |
| **total_failures** | bigint | YES | - |

### Table: `jobs`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **job_id** | integer | YES | - |
| **application_name** | name | YES | - |
| **schedule_interval** | interval | YES | - |
| **max_runtime** | interval | YES | - |
| **max_retries** | integer | YES | - |
| **retry_period** | interval | YES | - |
| **proc_schema** | name | YES | - |
| **proc_name** | name | YES | - |
| **owner** | regrole | YES | - |
| **scheduled** | boolean | YES | - |
| **fixed_schedule** | boolean | YES | - |
| **config** | jsonb | YES | - |
| **next_start** | timestamp with time zone | YES | - |
| **initial_start** | timestamp with time zone | YES | - |
| **hypertable_schema** | name | YES | - |
| **hypertable_name** | name | YES | - |
| **check_schema** | name | YES | - |
| **check_name** | name | YES | - |

## Schema: `trading`

### Table: `daily_pnl`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('trading.daily_pnl_id_seq'::regclass)` |
| **date** | date | NO | - |
| **realized_pnl** | numeric | YES | `0` |
| **unrealized_pnl** | numeric | YES | `0` |
| **charges** | numeric | YES | `0` |
| **net_pnl** | numeric | YES | `0` |
| **created_at** | timestamp with time zone | YES | `now()` |
| **account_id** | text | YES | `'default'::text` |

### Table: `orders`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **order_id** | text | NO | - |
| **exchange_order_id** | text | YES | - |
| **symbol** | text | NO | - |
| **exchange** | text | YES | - |
| **txn_type** | text | YES | - |
| **quantity** | integer | YES | - |
| **price** | numeric | YES | - |
| **status** | text | YES | - |
| **order_timestamp** | timestamp with time zone | YES | - |
| **average_price** | numeric | YES | - |
| **filled_quantity** | integer | YES | - |
| **variety** | text | YES | - |
| **validity** | text | YES | - |
| **product** | text | YES | - |
| **tag** | text | YES | - |
| **status_message** | text | YES | - |
| **created_at** | timestamp with time zone | YES | `now()` |
| **account_id** | text | YES | `'default'::text` |

### Table: `portfolio`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('trading.portfolio_id_seq'::regclass)` |
| **date** | date | NO | - |
| **symbol** | text | NO | - |
| **total_quantity** | numeric | NO | - |
| **average_price** | numeric | NO | - |
| **invested_value** | numeric | NO | - |
| **current_value** | numeric | YES | - |
| **pnl** | numeric | YES | - |
| **created_at** | timestamp with time zone | YES | `now()` |
| **account_id** | text | YES | `'default'::text` |
| **strategy_name** | text | YES | `'Open'::text` |

### Table: `portfolio_view`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **symbol** | text | YES | - |
| **net_quantity** | numeric | YES | - |
| **average_price** | numeric | YES | - |
| **invested_value** | numeric | YES | - |
| **current_value** | numeric | YES | - |
| **pnl** | numeric | YES | - |
| **snapshot_date** | date | YES | - |

### Table: `positions`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('trading.positions_id_seq'::regclass)` |
| **date** | date | NO | - |
| **symbol** | text | NO | - |
| **exchange** | text | YES | - |
| **product** | text | YES | - |
| **quantity** | integer | YES | - |
| **average_price** | numeric | YES | - |
| **last_price** | numeric | YES | - |
| **pnl** | numeric | YES | - |
| **m2m** | numeric | YES | - |
| **realised** | numeric | YES | - |
| **unrealised** | numeric | YES | - |
| **value** | numeric | YES | - |
| **created_at** | timestamp with time zone | YES | `now()` |
| **account_id** | text | YES | `'default'::text` |

### Table: `scanner_results`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **id** | integer | NO | `nextval('trading.scanner_results_id_seq'::regclass)` |
| **scanner_id** | integer | YES | - |
| **run_date** | timestamp with time zone | NO | - |
| **symbol** | text | NO | - |
| **match_data** | jsonb | NO | - |
| **created_at** | timestamp with time zone | YES | `now()` |

### Table: `trades`

| Column | Type | Nullable | Default |
| :--- | :--- | :--- | :--- |
| **trade_id** | bigint | NO | `nextval('trading.trades_trade_id_seq'::regclass)` |
| **broker_order_id** | text | YES | - |
| **symbol** | text | NO | - |
| **exchange_code** | text | YES | `'NSE'::text` |
| **transaction_type** | text | NO | - |
| **quantity** | integer | NO | - |
| **price** | numeric | NO | - |
| **holder_name** | text | YES | `'Primary'::text` |
| **strategy_name** | text | YES | `'Manual'::text` |
| **trade_date** | timestamp with time zone | YES | `now()` |
| **created_at** | timestamp with time zone | YES | `now()` |
| **broker_name** | text | YES | `'Zerodha'::text` |
| **isin** | text | YES | - |
| **product_type** | text | NO | `'CNC'::text` |
| **total_charges** | numeric | YES | `0` |
| **net_amount** | numeric | YES | - |
| **currency** | text | YES | `'INR'::text` |
| **notes** | text | YES | - |
| **account_id** | text | YES | `'default'::text` |
| **exchange** | text | YES | - |
| **txn_type** | text | YES | - |
| **fees** | numeric | YES | `0` |
| **source** | text | YES | - |
| **external_trade_id** | text | YES | - |
| **order_id** | text | YES | - |
| **segment** | text | YES | - |
| **series** | text | YES | - |

