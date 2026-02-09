"use client";

import { useState, useEffect, Suspense, useMemo, useCallback } from "react";
import { useSearchParams } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import { LayoutDashboard, Target, Activity, AlertTriangle, ChevronDown, ChevronRight, Zap } from "lucide-react";
import { FinancialChart } from "@/components/FinancialChart";
import { CandlestickData, LineData, HistogramData, SeriesMarker, Time } from 'lightweight-charts';

/** * STRICT DATA TYPES
 */
interface TradePoint {
    Date: string;
    DateShort: string;
    Open: number;
    High: number;
    Low: number;
    Close: number;
    Volume: number;
    UBB?: number;
    LBB?: number;
    Trailing_Stop?: number;
    ATR_14?: number;
    ATR_x3?: number;
    Highest_High_20?: number;
}

interface TradeParams {
    symbol: string | null;
    entry_date: string | null;
    entry_price: number;
    exit_date: string | null;
    exit_price: number;
    pnl_pct: number;
    pnl_val: number;
    cagr: number;
    strategy: string | null;
    years: string;
}

function VisualizerContent() {
    const searchParams = useSearchParams();

    // Memoize params for stability with robust parsing
    const params = useMemo<TradeParams>(() => {
        const parseNum = (key: string) => {
            const val = searchParams.get(key);
            if (!val) return 0;
            const num = parseFloat(val.replace(/,/g, ''));
            return isNaN(num) ? 0 : num;
        };

        const parsedParams = {
            symbol: searchParams.get("symbol"),
            entry_date: searchParams.get("entry_date"),
            entry_price: parseNum("entry_price"),
            exit_date: searchParams.get("exit_date"),
            exit_price: parseNum("exit_price"),
            pnl_pct: parseNum("pnl_pct"),
            pnl_val: parseNum("pnl_val"),
            cagr: parseNum("cagr"),
            strategy: searchParams.get("strategy"),
            years: searchParams.get("years") || "5"
        };
        return parsedParams;
    }, [searchParams]);

    const [plotData, setPlotData] = useState<TradePoint[]>([]);
    const [hoveredData, setHoveredData] = useState<TradePoint | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [isLogExpanded, setIsLogExpanded] = useState(true);
    const [isDrilldownExpanded, setIsDrilldownExpanded] = useState(true);

    const formatDate = (dateString: string) => {
        if (!dateString) return "";
        const date = new Date(dateString);
        return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }).replace(/ /g, '-').toUpperCase();
    };

    useEffect(() => {
        if (!params.symbol || !params.entry_date) {
            setError("Missing URL Parameters");
            setLoading(false);
            return;
        }

        let isMounted = true;

        async function loadPlot() {
            setLoading(true);
            setError(null);
            try {
                const endpoint = params.strategy === "EMA 200 + Supertrend"
                    ? "/api/backtest/ema-supertrend/plot"
                    : "/api/backtest/volatility-squeeze/plot";

                const res = await fetch(endpoint, {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ symbol: params.symbol, entry_date: params.entry_date, years: parseInt(params.years) })
                });
                const data = await res.json();

                if (isMounted) {
                    if (res.ok && Array.isArray(data.plot_data)) {
                        const formatted = data.plot_data.map((item: any) => ({
                            ...item,
                            DateShort: formatDate(item.Date),
                            Open: Number(item.Open ?? item.open ?? 0),
                            High: Number(item.High ?? item.high ?? 0),
                            Low: Number(item.Low ?? item.low ?? 0),
                            Close: Number(item.Close ?? item.close ?? 0),
                            Volume: Number(item.Volume ?? item.volume ?? 0),
                            UBB: (item.UBB ?? item.ubb) ? Number(item.UBB ?? item.ubb) : null,
                            LBB: (item.LBB ?? item.lbb) ? Number(item.LBB ?? item.lbb) : null,
                            Trailing_Stop: (item.Trailing_Stop || item.trailing_stop) ? Number(item.Trailing_Stop ?? item.trailing_stop) : null,
                            Highest_High_20: Number(item.Highest_High_20 ?? item.highest_high_20 ?? 0),
                            ATR_14: Number(item.ATR_14 ?? item.atr_14 ?? 0),
                            ATR_x3: Number(item.ATR_x3 ?? item.atr_x3 ?? 0),
                        }));
                        setPlotData(formatted);
                    } else {
                        setError("Invalid Data Format Received");
                    }
                }
            } catch (e) {
                if (isMounted) setError("API Connection Failed");
            } finally {
                if (isMounted) setLoading(false);
            }
        }
        loadPlot();
        return () => { isMounted = false; };
    }, [params]);

    // --- TradingView Data Transformation ---
    const chartData = useMemo(() => {
        const candlesticks: CandlestickData<Time>[] = [];
        const ubb: LineData<Time>[] = [];
        const lbb: LineData<Time>[] = [];
        const stops: LineData<Time>[] = [];
        const ema200: LineData<Time>[] = [];
        const volumes: HistogramData<Time>[] = [];
        const markers: SeriesMarker<Time>[] = [];

        plotData.forEach((d) => {
            const time = d.Date as Time;

            candlesticks.push({
                time,
                open: d.Open,
                high: d.High,
                low: d.Low,
                close: d.Close,
            });

            if (d.UBB) ubb.push({ time, value: d.UBB });
            if (d.LBB) lbb.push({ time, value: d.LBB });

            // Map Supertrend for EMA strategy, or Chandelier Stop for Squeeze strategy
            const stopValue = params.strategy === "EMA 200 + Supertrend" ? (d as any).supertrend : d.Trailing_Stop;
            if (stopValue) stops.push({ time, value: stopValue });

            if ((d as any).EMA_200) ema200.push({ time, value: (d as any).EMA_200 });

            volumes.push({
                time,
                value: d.Volume,
                color: d.Close >= d.Open ? '#22c55e44' : '#ef444444'
            });

            // Markers
            if (d.Date === params.entry_date) {
                markers.push({
                    time,
                    position: 'belowBar',
                    color: '#22c55e',
                    shape: 'arrowUp',
                    text: 'ENTER',
                });
            }
            if (d.Date === params.exit_date) {
                markers.push({
                    time,
                    position: 'aboveBar',
                    color: '#ef4444',
                    shape: 'arrowDown',
                    text: 'EXIT',
                });
            }
        });

        return { candlesticks, ubb, lbb, stops, ema200, volumes, markers };
    }, [plotData, params.entry_date, params.exit_date, params.strategy]);

    // Synchronize hover state from chart crosshair
    const handleCrosshairMove = useCallback((params: any) => {
        if (!params.time) {
            setHoveredData(null);
            return;
        }
        const record = plotData.find(d => d.Date === params.time);
        if (record) setHoveredData(record);
    }, [plotData]);

    if (loading) return (
        <div className="h-screen w-full flex flex-col items-center justify-center bg-black gap-4 text-zinc-500">
            <div className="w-8 h-8 border-2 border-blue-500 border-t-transparent rounded-full animate-spin" />
            <p className="text-xs font-bold tracking-widest animate-pulse uppercase">Analyzing Market Data...</p>
        </div>
    );

    if (error) return (
        <div className="h-screen w-full flex flex-col items-center justify-center bg-black text-red-500 gap-4">
            <AlertTriangle size={32} />
            <p className="font-bold">{error}</p>
            <pre className="text-xs bg-zinc-900 p-4 rounded text-zinc-500">{JSON.stringify(params, null, 2)}</pre>
        </div>
    );

    return (
        <div className="h-screen w-full bg-[#09090b] text-zinc-100 flex flex-col overflow-hidden font-sans selection:bg-blue-500/30">
            <header className="h-16 px-6 border-b border-zinc-800 flex items-center justify-between bg-[#09090b]/80 backdrop-blur-md z-30">
                <div className="flex items-center gap-4">
                    <div className="p-2 bg-blue-600 rounded-lg text-white">
                        <LayoutDashboard size={18} />
                    </div>
                    <div>
                        <h1 className="text-lg font-black tracking-tight leading-none">{params.symbol} <span className="text-zinc-500 font-bold uppercase text-[10px] ml-2 tracking-widest">{params.strategy || "Volatility Squeeze"}</span></h1>
                        <p className="text-[10px] font-black text-zinc-500 uppercase tracking-tighter mt-1 opacity-60">Professional Visualizer • Execution Path</p>
                    </div>
                </div>

                <div className="flex gap-2">
                    {[
                        { label: "CAGR", val: `${params.cagr.toFixed(2)}%`, color: "text-blue-400" },
                        { label: "PnL %", val: `${params.pnl_pct.toFixed(2)}%`, color: params.pnl_pct >= 0 ? "text-green-500" : "text-red-500" },
                        { label: "PnL Val", val: `₹${params.pnl_val.toLocaleString()}`, color: params.pnl_val >= 0 ? "text-green-500" : "text-red-500" }
                    ].map((kpi, i) => (
                        <div key={i} className="px-3 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg flex flex-col items-end">
                            <span className="text-[9px] font-black text-zinc-500 tracking-widest leading-none mb-1">{kpi.label}</span>
                            <span className={`text-sm font-black tabular-nums leading-none ${kpi.color}`}>{kpi.val}</span>
                        </div>
                    ))}
                </div>
            </header>

            <main className="flex-1 flex overflow-hidden">
                {/* Left Pane: The Chart */}
                <section className="flex-[9] relative border-r border-zinc-900 bg-[#09090b] flex flex-col">
                    <div className="px-6 pt-4 h-12 flex items-center justify-between shrink-0">
                        {hoveredData ? (
                            <div className="flex gap-4">
                                {[
                                    { l: "O", v: hoveredData.Open },
                                    { l: "H", v: hoveredData.High },
                                    { l: "L", v: hoveredData.Low },
                                    { l: "C", v: hoveredData.Close }
                                ].map(x => (
                                    <div key={x.l} className="flex gap-1.5 items-baseline">
                                        <span className="text-[9px] font-bold text-zinc-600">{x.l}</span>
                                        <span className={`text-sm font-black tabular-nums ${hoveredData.Close >= hoveredData.Open ? 'text-green-500' : 'text-red-500'}`}>₹{x.v.toFixed(2)}</span>
                                    </div>
                                ))}
                                <div className="flex gap-1.5 items-baseline border-l border-zinc-800 pl-4 ml-2">
                                    <span className="text-[9px] font-bold text-zinc-600">VOL</span>
                                    <span className="text-sm font-black tabular-nums text-zinc-400">{hoveredData.Volume.toLocaleString()}</span>
                                </div>
                            </div>
                        ) : (
                            <div className="flex items-center gap-2 text-zinc-700">
                                <Zap size={10} />
                                <span className="text-[9px] font-black uppercase tracking-[0.2em]">TradingView Engine Active • {plotData.length} Intervals</span>
                            </div>
                        )}
                        <span className="text-[10px] font-black text-zinc-500 uppercase tracking-widest">{hoveredData ? hoveredData.DateShort : "Weekly Candles"}</span>
                    </div>

                    <div className="flex-1 min-h-0 min-w-0 pr-4">
                        <FinancialChart
                            data={chartData.candlesticks}
                            upperBB={chartData.ubb}
                            lowerBB={chartData.lbb}
                            trailingStop={chartData.stops}
                            ema200={chartData.ema200}
                            volume={chartData.volumes}
                            markers={chartData.markers}
                            onCrosshairMove={handleCrosshairMove}
                        />
                    </div>
                </section>

                {/* Right Pane: Sidebar */}
                <aside className="flex-[3] flex flex-col gap-4 p-4 bg-zinc-950/50 overflow-y-auto custom-scrollbar">
                    <div className="bg-zinc-900/50 border border-zinc-800 rounded-xl overflow-hidden flex flex-col shrink-0">
                        <button
                            onClick={() => setIsLogExpanded(!isLogExpanded)}
                            className="w-full flex items-center justify-between p-4 hover:bg-zinc-800/50 transition-colors"
                        >
                            <div className="flex items-center gap-2">
                                <Target size={14} className="text-blue-500" />
                                <h3 className="text-[10px] font-black uppercase tracking-widest text-zinc-400">Execution Log</h3>
                            </div>
                            {isLogExpanded ? <ChevronDown size={14} className="text-zinc-600" /> : <ChevronRight size={14} className="text-zinc-600" />}
                        </button>

                        <AnimatePresence initial={false}>
                            {isLogExpanded && (
                                <motion.div
                                    initial={{ height: 0, opacity: 0 }}
                                    animate={{ height: "auto", opacity: 1 }}
                                    exit={{ height: 0, opacity: 0 }}
                                    transition={{ duration: 0.2, ease: "easeInOut" }}
                                >
                                    <div className="p-4 pt-0 space-y-3 border-t border-zinc-800/50 mt-1">
                                        {[
                                            { label: "Entry", val: `₹${params.entry_price.toFixed(2)}`, date: formatDate(params.entry_date || "") },
                                            { label: "Exit", val: `₹${params.exit_price.toFixed(2)}`, date: formatDate(params.exit_date || "") },
                                            { label: "Trade PnL", val: `${params.pnl_pct.toFixed(2)}%`, date: "Net Return", highlight: true },
                                            { label: "Duration", val: params.years + " Years Window", date: "Weekly Timeframe" }
                                        ].map((row, i) => (
                                            <div key={i} className="flex justify-between items-start">
                                                <div>
                                                    <p className="text-[9px] font-bold text-zinc-500 uppercase">{row.label}</p>
                                                    <p className={`text-xs font-black tabular-nums ${row.highlight ? (params.pnl_pct >= 0 ? 'text-green-500' : 'text-red-500') : ''}`}>{row.val}</p>
                                                </div>
                                                <p className="text-[9px] font-bold text-zinc-600 text-right">{row.date}</p>
                                            </div>
                                        ))}
                                    </div>
                                </motion.div>
                            )}
                        </AnimatePresence>
                    </div>

                    <div className={`flex flex-col bg-zinc-900/50 border border-zinc-800 rounded-xl overflow-hidden transition-all duration-300 ${isDrilldownExpanded ? 'flex-1 min-h-0' : 'shrink-0'}`}>
                        <button
                            onClick={() => setIsDrilldownExpanded(!isDrilldownExpanded)}
                            className="p-4 flex items-center justify-between hover:bg-zinc-800/50 transition-colors"
                        >
                            <div className="flex items-center gap-2">
                                <Activity size={14} className="text-blue-500" />
                                <h3 className="text-[10px] font-black uppercase tracking-widest text-zinc-400">Technical Drilldown</h3>
                            </div>
                            <div className="flex items-center gap-3">
                                {isDrilldownExpanded ? <ChevronDown size={14} className="text-zinc-600" /> : <ChevronRight size={14} className="text-zinc-600" />}
                            </div>
                        </button>

                        <AnimatePresence initial={false}>
                            {isDrilldownExpanded && (
                                <motion.div
                                    className="flex-1 min-h-0 flex flex-col"
                                    initial={{ height: 0, opacity: 0 }}
                                    animate={{ height: "auto", opacity: 1 }}
                                    exit={{ height: 0, opacity: 0 }}
                                    transition={{ duration: 0.2, ease: "easeInOut" }}
                                >
                                    <div className="flex-1 overflow-y-auto p-4 pt-0 custom-scrollbar border-t border-zinc-800/50 mt-1">
                                        {!hoveredData ? (
                                            <div className="h-full py-12 flex flex-col items-center justify-center text-center opacity-30">
                                                <Activity size={32} className="mb-4" />
                                                <p className="text-[10px] font-black uppercase tracking-widest px-8">Move crosshair for level details</p>
                                            </div>
                                        ) : (
                                            <div className="space-y-6 pt-4">
                                                <div>
                                                    <h4 className="text-[9px] font-black uppercase text-blue-500 tracking-widest mb-3 border-l-2 border-blue-500 pl-2">Stop Loss Mechanics</h4>
                                                    <div className="space-y-4">
                                                        {[
                                                            { label: "Highest High (20)", val: hoveredData.Highest_High_20, desc: "Reference Level (A)" },
                                                            { label: "ATR (14)", val: hoveredData.ATR_14, desc: "Volatility Factor" },
                                                            { label: "ATR x 3", val: hoveredData.ATR_x3, desc: "Offset Amount (B)" }
                                                        ].map((item, i) => (
                                                            <div key={i} className="flex justify-between border-b border-zinc-800/50 pb-2">
                                                                <div>
                                                                    <p className="text-[10px] font-black text-zinc-300">{item.label}</p>
                                                                    <p className="text-[9px] font-bold text-zinc-600">{item.desc}</p>
                                                                </div>
                                                                <p className="text-xs font-black tabular-nums self-center">₹{item.val?.toFixed(2) || "---"}</p>
                                                            </div>
                                                        ))}

                                                        <div className="bg-blue-900/20 border border-blue-500/20 p-3 rounded-lg mt-2">
                                                            <div className="flex justify-between items-center mb-1">
                                                                <span className="text-[10px] font-black text-blue-400">Calculated Trail</span>
                                                                <span className="text-[9px] font-bold text-blue-600">A - B</span>
                                                            </div>
                                                            <div className="flex justify-between items-baseline">
                                                                <span className="text-[9px] font-bold text-zinc-500 font-mono">
                                                                    {hoveredData.Highest_High_20?.toFixed(2)} - {hoveredData.ATR_x3?.toFixed(2)}
                                                                </span>
                                                                <span className="text-lg font-black text-blue-100 tabular-nums">
                                                                    ₹{((hoveredData.Highest_High_20 ?? 0) - (hoveredData.ATR_x3 ?? 0)).toFixed(2)}
                                                                </span>
                                                            </div>
                                                        </div>

                                                        <div className="bg-zinc-800/50 border border-zinc-700/50 p-3 rounded-lg">
                                                            <div className="flex justify-between items-center mb-1">
                                                                <span className="text-[10px] font-black text-white">{params.strategy === "EMA 200 + Supertrend" ? "Supertrend Line" : "Active Trail Stop"}</span>
                                                                {params.strategy !== "EMA 200 + Supertrend" && (
                                                                    <span className={`text-[9px] font-bold px-1.5 py-0.5 rounded ${hoveredData.Trailing_Stop && hoveredData.Trailing_Stop > (hoveredData.Highest_High_20 ?? 0) - (hoveredData.ATR_x3 ?? 0)
                                                                        ? "bg-amber-500/10 text-amber-500"
                                                                        : "bg-green-500/10 text-green-500"
                                                                        }`}>
                                                                        {hoveredData.Trailing_Stop && hoveredData.Trailing_Stop > (hoveredData.Highest_High_20 ?? 0) - (hoveredData.ATR_x3 ?? 0)
                                                                            ? "LOCKED PREV" : "DYNAMIC"}
                                                                    </span>
                                                                )}
                                                            </div>
                                                            <p className="text-xl font-black tabular-nums tracking-tighter text-white">
                                                                ₹{(params.strategy === "EMA 200 + Supertrend" ? (hoveredData as any).supertrend : hoveredData.Trailing_Stop)?.toFixed(2) || "---"}
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>

                                                {params.strategy === "EMA 200 + Supertrend" && (
                                                    <div className="mt-4">
                                                        <h4 className="text-[9px] font-black uppercase text-amber-500 tracking-widest mb-3 border-l-2 border-amber-500 pl-2">Trend Filter</h4>
                                                        <div className="bg-zinc-800/30 border border-zinc-800 p-3 rounded-lg">
                                                            <div className="flex justify-between items-center mb-1">
                                                                <span className="text-[10px] font-black text-zinc-400">EMA 200</span>
                                                                <span className={`text-[9px] font-bold px-1.5 py-0.5 rounded ${hoveredData.Close > (hoveredData as any).EMA_200 ? "bg-green-500/10 text-green-400" : "bg-red-500/10 text-red-400"}`}>
                                                                    {hoveredData.Close > (hoveredData as any).EMA_200 ? "ABOVE" : "BELOW"}
                                                                </span>
                                                            </div>
                                                            <p className="text-lg font-black tabular-nums text-white">₹{(hoveredData as any).EMA_200?.toFixed(2)}</p>
                                                        </div>
                                                    </div>
                                                )}
                                            </div>
                                        )}
                                    </div>
                                </motion.div>
                            )}
                        </AnimatePresence>
                    </div>
                </aside>
            </main>

            <style jsx global>{`
                .custom-scrollbar::-webkit-scrollbar { width: 4px; }
                .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
                .custom-scrollbar::-webkit-scrollbar-thumb { background: #27272a; border-radius: 10px; }
            `}</style>
        </div>
    );
}

export default function VisualizerPage() {
    return (
        <Suspense fallback={
            <div className="h-screen w-full flex items-center justify-center bg-black">
                <div className="w-8 h-8 border-2 border-zinc-800 border-t-zinc-400 rounded-full animate-spin" />
            </div>
        }>
            <VisualizerContent />
        </Suspense>
    );
}