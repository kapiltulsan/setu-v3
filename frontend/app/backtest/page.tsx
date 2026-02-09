"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import {
    ComposedChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, ReferenceLine, Bar, Cell
} from "recharts";
import { motion, AnimatePresence } from "framer-motion";
import { ArrowLeft, Play, BarChart2, Calendar, TrendingUp, AlertTriangle, Download, X, TrendingDown, ChevronDown } from "lucide-react";

const Candlestick = (props: any) => null; // Cleanup placeholder

export default function BacktestPage() {
    const [mode, setMode] = useState<"single" | "universe">("single");
    const [symbol, setSymbol] = useState("RELIANCE");
    const [indices, setIndices] = useState<string[]>([]);
    const [selectedUniverse, setSelectedUniverse] = useState<string[]>([]);
    const [allIndices, setAllIndices] = useState(false);

    const [searchResults, setSearchResults] = useState<any[]>([]);
    const [showDropdown, setShowDropdown] = useState(false);

    const [loading, setLoading] = useState(false);
    const [results, setResults] = useState<any>(null);
    const [selectedTrade, setSelectedTrade] = useState<any>(null);
    const [years, setYears] = useState(5);
    const [error, setError] = useState<string | null>(null);

    const [selectedStrategy, setSelectedStrategy] = useState("Volatility Squeeze");
    const [isStrategyOpen, setIsStrategyOpen] = useState(false);
    const strategies = ["Volatility Squeeze", "EMA 200 + Supertrend", "Trend Reversal", "Gap Up/Down", "Mean Reversion"];

    useEffect(() => {
        fetch("/api/indices")
            .then(res => res.json())
            .then(setIndices)
            .catch(console.error);
    }, []);

    const formatDate = (dateString: string) => {
        if (!dateString) return "";
        const date = new Date(dateString);
        const day = String(date.getDate()).padStart(2, '0');
        const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
        const month = months[date.getMonth()];
        const year = date.getFullYear();
        return `${day}-${month}-${year}`;
    };

    const runBacktest = async () => {
        setLoading(true);
        setError(null);
        setResults(null);
        setSelectedTrade(null);

        const payload: any = { years };
        if (mode === "single") {
            payload.symbol = symbol;
        } else {
            payload.all_indices = allIndices;
            payload.universe = selectedUniverse;
        }

        try {
            const endpoint = selectedStrategy === "EMA 200 + Supertrend"
                ? "/api/backtest/ema-supertrend"
                : "/api/backtest/volatility-squeeze";

            const res = await fetch(endpoint, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload)
            });

            const data = await res.json();
            if (res.ok) {
                setResults(data);
            } else {
                setError(data.error || "Backtest failed");
            }
        } catch (e) {
            setError("Network error occurred");
        } finally {
            setLoading(false);
        }
    };

    const loadPlot = (trade: any) => {
        const symbolToUse = trade.Symbol || symbol;
        const params = new URLSearchParams({
            symbol: symbolToUse,
            entry_date: trade.Entry_Date,
            entry_price: trade.Entry_Price.toString(),
            exit_date: trade.Exit_Date,
            exit_price: trade.Exit_Price.toString(),
            pnl_pct: trade.PnL_Percent.toString(),
            pnl_val: (trade.PnL_Value || 0).toString(),
            cagr: trade.CAGR.toString(),
            strategy: selectedStrategy,
            years: years.toString()
        });
        window.open(`/backtest/visualize?${params.toString()}`, "_blank");
    };

    const downloadCSV = () => {
        if (!results || !results.trade_log) return;

        const headers = ["Symbol", "Entry Date", "Entry Price", "Exit Date", "Exit Price", "PnL %", "PnL Value", "Days", "CAGR", "Entry BB Width", "Entry Vol Ratio", "Entry SMA Dist %"];
        const rows = results.trade_log.map((t: any) => [
            t.Symbol || symbol,
            formatDate(t.Entry_Date),
            t.Entry_Price,
            formatDate(t.Exit_Date),
            t.Exit_Price,
            t.PnL_Percent?.toFixed(2) || "0.00",
            t.PnL_Value?.toFixed(0) || "0",
            t.Holding_Period_Days || 0,
            t.CAGR?.toFixed(1) || "0.0",
            t.Entry_BB_Width?.toFixed(4) || "N/A",
            t.Entry_Vol_Ratio?.toFixed(2) || "N/A",
            t.Entry_SMA_Dist_Pct?.toFixed(2) || "N/A"
        ]);

        const csvContent = [headers, ...rows].map(e => e.join(",")).join("\n");
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement("a");
        const url = URL.createObjectURL(blob);
        link.setAttribute("href", url);
        link.setAttribute("download", `backtest_${symbol || 'universe'}_${new Date().toISOString().split('T')[0]}.csv`);
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    };

    return (
        <div className="p-4 md:p-8 min-h-screen bg-zinc-50 dark:bg-black font-sans text-zinc-900 dark:text-zinc-100">
            <div className="max-w-7xl mx-auto">
                <div className="flex items-center gap-4 mb-8">
                    <Link href="/" className="p-2 bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-full hover:bg-zinc-100 dark:hover:bg-zinc-800 transition shadow-sm">
                        <ArrowLeft size={18} />
                    </Link>
                    <h1 className="text-3xl font-bold italic tracking-tight">Strategy Backtest</h1>
                </div>

                {/* Mode Toggle */}
                <div className="flex gap-2 mb-6 p-1 bg-zinc-200/50 dark:bg-zinc-900/50 rounded-2xl w-fit">
                    <button
                        onClick={() => setMode("single")}
                        className={`px-6 py-2 rounded-xl font-bold transition-all ${mode === 'single' ? 'bg-white dark:bg-zinc-800 text-blue-600 shadow-sm' : 'text-zinc-500 hover:text-zinc-800 dark:hover:text-zinc-200'}`}
                    >
                        Single Search
                    </button>
                    <button
                        onClick={() => setMode("universe")}
                        className={`px-6 py-2 rounded-xl font-bold transition-all ${mode === 'universe' ? 'bg-white dark:bg-zinc-800 text-blue-600 shadow-sm' : 'text-zinc-500 hover:text-zinc-800 dark:hover:text-zinc-200'}`}
                    >
                        Universe Selector
                    </button>
                </div>

                {/* Strategy Brief */}
                <div className="bg-blue-50 dark:bg-blue-900/10 border border-blue-100 dark:border-blue-900/30 p-6 rounded-3xl mb-8 shadow-sm">
                    {selectedStrategy === "Volatility Squeeze" ? (
                        <>
                            <h2 className="text-lg font-bold text-blue-900 dark:text-blue-100 mb-2 flex items-center gap-2">
                                <TrendingUp size={20} className="text-blue-500" /> Strategy Overview: Volatility Squeeze Breakout
                            </h2>
                            <p className="text-sm text-blue-800 dark:text-blue-200/70 leading-relaxed mb-4">
                                This strategy identifies periods of low volatility (the "Squeeze") followed by a high-momentum breakout. It enters when price closes above the Upper Bollinger Band with a significant volume surge, provided Bollinger Bands were at their narrowest for the recent window. Risk is managed locally using an <strong>ATR-based Chandelier Trailing Stop</strong>.
                            </p>
                        </>
                    ) : selectedStrategy === "EMA 200 + Supertrend" ? (
                        <>
                            <h2 className="text-lg font-bold text-blue-900 dark:text-blue-100 mb-2 flex items-center gap-2">
                                <TrendingUp size={20} className="text-blue-500" /> Strategy Overview: EMA 200 + Supertrend
                            </h2>
                            <p className="text-sm text-blue-800 dark:text-blue-200/70 leading-relaxed mb-4">
                                A trend-following strategy combining a long-term trend filter with a momentum indicator.
                                It enters <strong>Long</strong> when price is above EMA 200 and the Supertrend indicator turns bullish.
                                It enters <strong>Short</strong> when price is below EMA 200 and Supertrend becomes bearish.
                                Trades are exited as soon as the Supertrend changes direction.
                            </p>
                        </>
                    ) : (
                        <>
                            <h2 className="text-lg font-bold text-blue-900 dark:text-blue-100 mb-2 flex items-center gap-2">
                                <TrendingUp size={20} className="text-blue-500" /> coming Soon: {selectedStrategy}
                            </h2>
                            <p className="text-sm text-blue-800 dark:text-blue-200/70 leading-relaxed mb-4">
                                This strategy is currently under development. Stay tuned for updates!
                            </p>
                        </>
                    )}
                    <div className="flex flex-wrap gap-4 text-[10px] font-black uppercase tracking-widest text-blue-600 dark:text-blue-400 bg-blue-100/50 dark:bg-blue-900/20 w-fit px-4 py-2 rounded-2xl">
                        <span>Assumption: ₹1,00,000 Portfolio</span>
                        <span className="opacity-30">|</span>
                        <span>₹10,000 Capital / Trade</span>
                    </div>
                </div>

                {/* Input Controls */}
                <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 p-6 rounded-3xl mb-8 flex flex-col md:flex-row gap-4 items-end shadow-sm relative">
                    {mode === "single" ? (
                        <div className="flex-1 w-full relative">
                            <label className="block text-sm font-semibold text-zinc-500 mb-2">Symbol or Index Name</label>
                            <div className="relative">
                                <input
                                    type="text"
                                    value={symbol}
                                    onChange={(e) => {
                                        const val = e.target.value.toUpperCase();
                                        setSymbol(val);
                                        if (val.length > 1) {
                                            fetch(`/api/symbols?q=${encodeURIComponent(val)}`)
                                                .then(res => res.json())
                                                .then(data => {
                                                    setSearchResults(data);
                                                    setShowDropdown(true);
                                                })
                                                .catch(console.error);
                                        } else {
                                            setSearchResults([]);
                                            setShowDropdown(false);
                                        }
                                    }}
                                    onFocus={() => symbol.length > 1 && setShowDropdown(true)}
                                    onBlur={() => setTimeout(() => setShowDropdown(false), 200)}
                                    placeholder="RELIANCE, NIFTY 50..."
                                    className="w-full bg-zinc-50 dark:bg-zinc-800 border-none rounded-2xl px-4 py-3 text-lg font-bold focus:ring-2 focus:ring-blue-500 outline-none"
                                />
                                {showDropdown && searchResults.length > 0 && (
                                    <div className="absolute left-0 right-0 top-full mt-2 bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-2xl shadow-2xl overflow-hidden z-50">
                                        <div className="max-h-60 overflow-y-auto">
                                            {searchResults.map((res: any, idx: number) => (
                                                <div
                                                    key={idx}
                                                    onClick={() => {
                                                        setSymbol(res.value);
                                                        setSearchResults([]);
                                                        setShowDropdown(false);
                                                    }}
                                                    className="px-4 py-3 hover:bg-zinc-50 dark:hover:bg-zinc-800 cursor-pointer flex justify-between items-center border-b border-zinc-100 dark:border-zinc-800 last:border-0"
                                                >
                                                    <span className="font-bold">{res.label}</span>
                                                    <span className={`text-[10px] uppercase font-black px-2 py-0.5 rounded-md ${res.type === 'index' ? 'bg-orange-100 text-orange-600 dark:bg-orange-900/30' : 'bg-blue-100 text-blue-600 dark:bg-blue-900/30'}`}>
                                                        {res.type}
                                                    </span>
                                                </div>
                                            ))}
                                        </div>
                                    </div>
                                )}
                            </div>
                        </div>
                    ) : (
                        <div className="flex-2 w-full flex flex-col md:flex-row gap-4">
                            <div className="flex-1 min-w-[300px]">
                                <label className="block text-sm font-semibold text-zinc-500 mb-2">Select Indices</label>
                                <div className="flex flex-wrap gap-2 p-2 bg-zinc-50 dark:bg-zinc-800 rounded-2xl min-h-[52px]">
                                    {indices.map(idx => (
                                        <button
                                            key={idx}
                                            onClick={() => {
                                                if (selectedUniverse.includes(idx)) {
                                                    setSelectedUniverse(selectedUniverse.filter(i => i !== idx));
                                                } else {
                                                    setSelectedUniverse([...selectedUniverse, idx]);
                                                }
                                            }}
                                            className={`px-3 py-1 rounded-xl text-xs font-bold transition-all ${selectedUniverse.includes(idx) ? 'bg-blue-600 text-white' : 'bg-zinc-200 dark:bg-zinc-700 text-zinc-600'}`}
                                        >
                                            {idx}
                                        </button>
                                    ))}
                                </div>
                            </div>
                            <div className="flex items-center gap-2 px-4 py-3 bg-zinc-50 dark:bg-zinc-800 rounded-2xl cursor-pointer select-none" onClick={() => setAllIndices(!allIndices)}>
                                <input type="checkbox" checked={allIndices} onChange={() => { }} className="w-5 h-5 accent-blue-600" />
                                <span className="font-bold text-sm">All Universe</span>
                            </div>
                        </div>
                    )}

                    <div className="flex-1 w-full max-w-[150px]">
                        <label className="block text-sm font-semibold text-zinc-500 mb-2">Duration (Years)</label>
                        <select
                            value={years}
                            onChange={(e) => setYears(parseInt(e.target.value))}
                            className="w-full bg-zinc-50 dark:bg-zinc-800 border-none rounded-2xl px-4 py-3 text-lg font-bold focus:ring-2 focus:ring-blue-500 outline-none appearance-none"
                        >
                            {[1, 2, 3, 5, 8, 10].map(y => (
                                <option key={y} value={y}>{y} Years</option>
                            ))}
                        </select>
                    </div>

                    <div className="flex-1 w-full max-w-[200px] relative">
                        <label className="block text-sm font-semibold text-zinc-500 mb-2">Strategy</label>
                        <button
                            onClick={() => setIsStrategyOpen(!isStrategyOpen)}
                            className="w-full bg-zinc-50 dark:bg-zinc-800 border-none rounded-2xl px-4 py-3 text-left font-bold flex justify-between items-center group transition-all"
                        >
                            <span className="text-sm">{selectedStrategy}</span>
                            <ChevronDown size={14} className={`text-zinc-400 group-hover:text-zinc-200 transition-transform ${isStrategyOpen ? 'rotate-180' : ''}`} />
                        </button>

                        {isStrategyOpen && (
                            <div className="absolute top-full left-0 right-0 mt-2 bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-2xl shadow-2xl overflow-hidden z-[100] py-1">
                                {strategies.map((strat) => (
                                    <button
                                        key={strat}
                                        onClick={() => {
                                            setSelectedStrategy(strat);
                                            setIsStrategyOpen(false);
                                        }}
                                        className={`w-full px-4 py-2.5 text-left text-xs font-bold hover:bg-zinc-50 dark:hover:bg-zinc-800 transition-colors ${selectedStrategy === strat ? 'text-blue-600 bg-blue-50/50 dark:text-blue-400 dark:bg-blue-500/5' : 'text-zinc-500 dark:text-zinc-400'}`}
                                        disabled={strat !== "Volatility Squeeze" && strat !== "EMA 200 + Supertrend"}
                                    >
                                        <div className="flex justify-between items-center">
                                            <span>{strat}</span>
                                            {(strat !== "Volatility Squeeze" && strat !== "EMA 200 + Supertrend") && <span className="text-[8px] bg-zinc-100 dark:bg-zinc-800 px-1.5 py-0.5 rounded text-zinc-400 dark:text-zinc-600">SOON</span>}
                                        </div>
                                    </button>
                                ))}
                            </div>
                        )}
                    </div>
                    <button
                        onClick={runBacktest}
                        disabled={loading}
                        className={`w-full md:w-auto bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white px-8 py-3.5 rounded-2xl font-bold flex items-center justify-center gap-2 transition-all hover:scale-[1.02] active:scale-95 shadow-lg shadow-blue-500/20 ${selectedStrategy !== "Volatility Squeeze" && selectedStrategy !== "EMA 200 + Supertrend" ? "opacity-50 pointer-events-none" : ""}`}
                    >
                        {loading ? "Calculating..." : <><Play size={20} fill="currentColor" /> Run Backtest</>}
                    </button>
                </div>

                {error && (
                    <div className="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 p-4 rounded-2xl text-red-600 dark:text-red-400 mb-8 flex items-center gap-3">
                        <AlertTriangle size={20} />
                        <span className="font-medium">{error}</span>
                    </div>
                )}

                {results && (
                    <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
                        {/* Metrics Grid */}
                        <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
                            {[
                                { label: "Total PnL (₹)", value: `₹${(results?.metrics?.Total_PnL_Value ?? 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`, icon: <TrendingUp className={(results?.metrics?.Total_PnL_Value ?? 0) >= 0 ? "text-green-500" : "text-red-500"} /> },
                                { label: "CAGR", value: `${(results?.metrics?.CAGR ?? 0).toFixed(2)}%`, icon: <BarChart2 className="text-blue-500" /> },
                                { label: "Win Rate", value: `${(results?.metrics?.Win_Rate ?? 0).toFixed(2)}%`, icon: <div className="text-green-500 font-black text-[10px]">WIN</div> },
                                { label: "Max Drawdown", value: `${(results?.metrics?.Max_Drawdown ?? 0).toFixed(2)}%`, icon: <AlertTriangle className="text-red-500" /> },
                                { label: "Trades", value: results?.metrics?.Total_Trades ?? 0, icon: <Calendar className="text-zinc-400" /> },
                            ].map((m, i) => (
                                <div key={i} className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 p-6 rounded-3xl shadow-sm">
                                    <div className="flex justify-between items-center mb-4">
                                        <span className="text-zinc-500 text-[10px] font-black uppercase tracking-wider">{m.label}</span>
                                        {m.icon}
                                    </div>
                                    <div className="text-3xl font-black text-zinc-900 dark:text-zinc-100 tracking-tighter">{m.value}</div>
                                </div>
                            ))}
                        </div>

                        <div className="grid grid-cols-1 gap-8">
                            {/* Trade Log */}
                            <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-3xl overflow-hidden shadow-sm flex flex-col">
                                <div className="p-6 border-b border-zinc-100 dark:border-zinc-800 flex justify-between items-center">
                                    <h2 className="text-xl font-bold">Comprehensive Trade Log</h2>
                                    <div className="flex items-center gap-3">
                                        <div className="text-[10px] font-black uppercase tracking-widest text-zinc-400 bg-zinc-100 dark:bg-zinc-800 px-3 py-1 rounded-full">
                                            {results.trade_log.length} Trades found
                                        </div>
                                        <button
                                            onClick={downloadCSV}
                                            className="p-2 hover:bg-zinc-100 dark:hover:bg-zinc-800 rounded-xl transition text-zinc-500 hover:text-blue-600"
                                            title="Download CSV"
                                        >
                                            <Download size={18} />
                                        </button>
                                    </div>
                                </div>
                                <div className="overflow-x-auto">
                                    <table className="w-full text-left min-w-[1000px]">
                                        <thead className="bg-zinc-50 dark:bg-zinc-800/50 text-[10px] font-black uppercase text-zinc-400 tracking-widest sticky top-0">
                                            <tr>
                                                <th className="px-6 py-4">Symbol/Name</th>
                                                <th className="px-6 py-4">Period</th>
                                                <th className="px-6 py-4 text-right">Buy/Sell Price</th>
                                                <th className="px-6 py-4 text-right">Total PnL Value</th>
                                                <th className="px-6 py-4 text-right">% PnL</th>
                                                <th className="px-6 py-4 text-right">Days</th>
                                                <th className="px-6 py-4 text-right">CAGR</th>
                                                <th className="px-6 py-4"></th>
                                            </tr>
                                        </thead>
                                        <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800 text-xs">
                                            {results.trade_log.map((trade: any, idx: number) => (
                                                <tr
                                                    key={idx}
                                                    onClick={() => loadPlot(trade)}
                                                    className={`cursor-pointer transition group ${selectedTrade?.Entry_Date === trade.Entry_Date && selectedTrade?.Symbol === trade.Symbol ? 'bg-blue-50 dark:bg-blue-900/20' : 'hover:bg-zinc-50 dark:hover:bg-zinc-800/30'}`}
                                                >
                                                    <td className="px-6 py-4">
                                                        <div className="font-bold text-zinc-900 dark:text-zinc-100">{trade.Symbol || symbol}</div>
                                                    </td>
                                                    <td className="px-6 py-4">
                                                        <div className="font-bold text-[10px]">{formatDate(trade.Entry_Date)}</div>
                                                        <div className="text-[9px] text-zinc-400 opacity-70">to {formatDate(trade.Exit_Date)}</div>
                                                    </td>
                                                    <td className="px-6 py-4 text-right tabular-nums">
                                                        <div className="font-bold text-zinc-800 dark:text-zinc-200">{(trade.Entry_Price || 0).toFixed(2)}</div>
                                                        <div className="text-[9px] text-zinc-400 opacity-70">→ {(trade.Exit_Price || 0).toFixed(2)}</div>
                                                    </td>
                                                    <td className={`px-6 py-4 text-right font-black tabular-nums ${(trade.PnL_Percent || 0) > 0 ? 'text-green-500' : 'text-red-500'}`}>
                                                        {(trade.PnL_Percent || 0) > 0 ? "+" : ""}₹{(trade.PnL_Value || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                                                    </td>
                                                    <td className={`px-6 py-4 text-right font-black tabular-nums ${(trade.PnL_Percent || 0) > 0 ? 'text-green-500' : 'text-red-500'}`}>
                                                        {(trade.PnL_Percent || 0) > 0 ? "+" : ""}{(trade.PnL_Percent || 0).toFixed(2)}%
                                                    </td>
                                                    <td className="px-6 py-4 text-right font-bold text-zinc-500 tabular-nums">
                                                        {trade.Holding_Period_Days || 0}d
                                                    </td>
                                                    <td className={`px-6 py-4 text-right font-black tabular-nums ${(trade.CAGR || 0) > 0 ? 'text-green-500' : 'text-red-500'}`}>
                                                        {(trade.CAGR || 0) > 0 ? "+" : ""}{(trade.CAGR || 0).toFixed(2)}%
                                                    </td>
                                                    <td className="px-6 py-4 text-right w-10">
                                                        <span className="text-zinc-300 group-hover:translate-x-1 group-hover:text-blue-500 transition-all inline-block">&rarr;</span>
                                                    </td>
                                                </tr>
                                            ))}
                                            {results.trade_log.length === 0 && (
                                                <tr><td colSpan={8} className="p-10 text-center text-zinc-500 italic">No trades found for this symbol.</td></tr>
                                            )}
                                        </tbody>
                                        {results.trade_log.length > 0 && (
                                            <tfoot className="bg-zinc-100 dark:bg-zinc-800/80 border-t-2 border-zinc-200 dark:border-zinc-700 text-xs">
                                                <tr className="font-black">
                                                    <td className="px-6 py-5 uppercase tracking-tighter text-[10px] text-zinc-400">Total Portfolio Summary</td>
                                                    <td colSpan={2}></td>
                                                    <td className={`px-6 py-5 text-right tabular-nums ${(results?.metrics?.Total_PnL_Value ?? 0) >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                                                        ₹{(results?.metrics?.Total_PnL_Value ?? 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                                                    </td>
                                                    <td className={`px-6 py-5 text-right tabular-nums ${(results?.metrics?.Average_PnL ?? 0) >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                                                        AVG: {(results?.metrics?.Average_PnL ?? 0).toFixed(2)}%
                                                    </td>
                                                    <td className="px-6 py-5 text-right tabular-nums text-zinc-500">
                                                        {results.trade_log.reduce((acc: number, t: any) => acc + (t.Holding_Period_Days || 0), 0)}d Total
                                                    </td>
                                                    <td className={`px-6 py-5 text-right tabular-nums ${(results?.metrics?.CAGR ?? 0) >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                                                        Portfolio: {(results?.metrics?.CAGR ?? 0).toFixed(1)}%
                                                    </td>
                                                    <td></td>
                                                </tr>
                                            </tfoot>
                                        )}
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                )}
            </div>
        </div>
    );
}
