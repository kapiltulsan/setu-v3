
export interface ScannerConfig {
    id: number;
    name: string;
    description: string;
    source_universe: string;
    schedule_cron: string;
    is_active: boolean;
    last_run_at: string | null;
    last_match_count?: number;
}

export interface ScannerResult {
    symbol: string;
    match_data: Record<string, any>;
}

export interface ScannerDetail {
    config: ScannerConfig;
    history: { run_date: string; matches: number }[];
    latest_results: ScannerResult[];
}
