"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import {
    LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, ReferenceLine, AreaChart, Area
} from "recharts";
import { ArrowLeft, Play, BarChart2, Calendar, TrendingUp, AlertTriangle } from "lucide-react";

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
    const [plotData, setPlotData] = useState<any[]>([]);
    const [error, setError] = useState<string | null>(null);

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
        setPlotData([]);

        const payload: any = {};
        if (mode === "single") {
            payload.symbol = symbol;
        } else {
            payload.all_indices = allIndices;
            payload.universe = selectedUniverse;
        }

        try {
            const res = await fetch("/api/backtest/volatility-squeeze", {
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

    const loadPlot = async (trade: any) => {
        setSelectedTrade(trade);
        try {
            const res = await fetch("/api/backtest/volatility-squeeze/plot", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ symbol: trade.Symbol || symbol, entry_date: trade.Entry_Date })
            });
            const data = await res.json();
            if (res.ok) {
                // Format date for chart
                const formattedData = data.plot_data.map((item: any) => ({
                    ...item,
                    DateShort: formatDate(item.Date)
                }));
                setPlotData(formattedData);
            }
        } catch (e) {
            console.error("Failed to load plot data", e);
        }
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
                    <h2 className="text-lg font-bold text-blue-900 dark:text-blue-100 mb-2 flex items-center gap-2">
                        <TrendingUp size={20} className="text-blue-500" /> Strategy Overview: Volatility Squeeze Breakout
                    </h2>
                    <p className="text-sm text-blue-800 dark:text-blue-200/70 leading-relaxed mb-4">
                        This strategy identifies periods of low volatility (the "Squeeze") followed by a high-momentum breakout. It enters when price closes above the Upper Bollinger Band with a significant volume surge, provided Bollinger Bands were at their narrowest for the recent window. Risk is managed locally using an <strong>ATR-based Chandelier Trailing Stop</strong>.
                    </p>
                    <div className="flex flex-wrap gap-4 text-[10px] font-black uppercase tracking-widest text-blue-600 dark:text-blue-400 bg-blue-100/50 dark:bg-blue-900/20 w-fit px-4 py-2 rounded-2xl">
                        <span>Assumption: $100,000 Portfolio</span>
                        <span className="opacity-30">|</span>
                        <span>$10,000 Capital / Trade</span>
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

                    <div className="flex-1 w-full max-w-[200px]">
                        <label className="block text-sm font-semibold text-zinc-500 mb-2">Strategy</label>
                        <select className="w-full bg-zinc-50 dark:bg-zinc-800 border-none rounded-2xl px-4 py-3 text-lg font-bold focus:ring-2 focus:ring-blue-500 outline-none appearance-none">
                            <option>Volatility Squeeze</option>
                        </select>
                    </div>
                    <button
                        onClick={runBacktest}
                        disabled={loading}
                        className="w-full md:w-auto bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white px-8 py-3.5 rounded-2xl font-bold flex items-center justify-center gap-2 transition-all hover:scale-[1.02] active:scale-95 shadow-lg shadow-blue-500/20"
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
                                { label: "Total PnL ($)", value: `$${results.metrics.Total_PnL_Value.toLocaleString(undefined, { maximumFractionDigits: 0 })}`, icon: <TrendingUp className={results.metrics.Total_PnL_Value >= 0 ? "text-green-500" : "text-red-500"} /> },
                                { label: "CAGR", value: `${results.metrics.CAGR.toFixed(1)}%`, icon: <BarChart2 className="text-blue-500" /> },
                                { label: "Win Rate", value: `${results.metrics.Win_Rate.toFixed(1)}%`, icon: <div className="text-green-500 font-black text-[10px]">WIN</div> },
                                { label: "Max Drawdown", value: `${results.metrics.Max_Drawdown.toFixed(1)}%`, icon: <AlertTriangle className="text-red-500" /> },
                                { label: "Trades", value: results.metrics.Total_Trades, icon: <Calendar className="text-zinc-400" /> },
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

                        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
                            {/* Trade Log */}
                            <div className="lg:col-span-12 bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-3xl overflow-hidden shadow-sm flex flex-col">
                                <div className="p-6 border-b border-zinc-100 dark:border-zinc-800 flex justify-between items-center">
                                    <h2 className="text-xl font-bold">Comprehensive Trade Log</h2>
                                    <div className="text-[10px] font-black uppercase tracking-widest text-zinc-400 bg-zinc-100 dark:bg-zinc-800 px-3 py-1 rounded-full">
                                        {results.trade_log.length} Trades found
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
                                                        <div className="font-bold text-zinc-800 dark:text-zinc-200">{trade.Entry_Price.toFixed(1)}</div>
                                                        <div className="text-[9px] text-zinc-400 opacity-70">→ {trade.Exit_Price.toFixed(1)}</div>
                                                    </td>
                                                    <td className={`px-6 py-4 text-right font-black tabular-nums ${trade.PnL_Percent > 0 ? 'text-green-500' : 'text-red-500'}`}>
                                                        {trade.PnL_Percent > 0 ? "+" : ""}${trade.PnL_Value?.toLocaleString(undefined, { maximumFractionDigits: 0 })}
                                                    </td>
                                                    <td className={`px-6 py-4 text-right font-black tabular-nums ${trade.PnL_Percent > 0 ? 'text-green-500' : 'text-red-500'}`}>
                                                        {trade.PnL_Percent > 0 ? "+" : ""}{trade.PnL_Percent.toFixed(2)}%
                                                    </td>
                                                    <td className="px-6 py-4 text-right font-bold text-zinc-500 tabular-nums">
                                                        {trade.Holding_Period_Days}d
                                                    </td>
                                                    <td className={`px-6 py-4 text-right font-black tabular-nums ${trade.CAGR > 0 ? 'text-green-500' : 'text-red-500'}`}>
                                                        {trade.CAGR > 0 ? "+" : ""}{trade.CAGR.toFixed(1)}%
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
                                                    <td className={`px-6 py-5 text-right tabular-nums ${results.metrics.Total_PnL_Value >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                                                        ${results.metrics.Total_PnL_Value.toLocaleString(undefined, { maximumFractionDigits: 0 })}
                                                    </td>
                                                    <td className={`px-6 py-5 text-right tabular-nums ${results.metrics.Average_PnL >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                                                        AVG: {results.metrics.Average_PnL.toFixed(2)}%
                                                    </td>
                                                    <td className="px-6 py-5 text-right tabular-nums text-zinc-500">
                                                        {results.trade_log.reduce((acc: number, t: any) => acc + (t.Holding_Period_Days || 0), 0)}d Total
                                                    </td>
                                                    <td className={`px-6 py-5 text-right tabular-nums ${results.metrics.CAGR >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                                                        Portfolio: {results.metrics.CAGR.toFixed(1)}%
                                                    </td>
                                                    <td></td>
                                                </tr>
                                            </tfoot>
                                        )}
                                    </table>
                                </div>
                            </div>

                            {/* Chart */}
                            <div className="lg:col-span-7 space-y-4">
                                <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 p-6 rounded-3xl shadow-sm h-full min-h-[400px] flex flex-col">
                                    <div className="flex justify-between items-center mb-6">
                                        <h2 className="text-xl font-bold flex items-center gap-2">
                                            Visual Check {selectedTrade && <span className="text-sm font-normal text-zinc-500">({formatDate(selectedTrade.Entry_Date)})</span>}
                                        </h2>
                                        {!selectedTrade && <span className="text-xs text-zinc-400 italic">Select a trade from the log to visualize</span>}
                                    </div>

                                    <div className="flex-1 w-full relative">
                                        {plotData.length > 0 ? (
                                            <ResponsiveContainer width="100%" height="100%">
                                                <LineChart data={plotData}>
                                                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E5E7EB" />
                                                    <XAxis dataKey="DateShort" tick={{ fontSize: 10 }} tickLine={false} axisLine={false} />
                                                    <YAxis
                                                        domain={['auto', 'auto']}
                                                        orientation="right"
                                                        tick={{ fontSize: 10 }}
                                                        tickLine={false}
                                                        axisLine={false}
                                                        tickFormatter={(val) => val.toFixed(0)}
                                                    />
                                                    <Tooltip
                                                        contentStyle={{ borderRadius: '16px', border: 'none', boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)' }}
                                                        itemStyle={{ fontWeight: 'bold' }}
                                                    />
                                                    <Legend />

                                                    {/* Bollinger Bands Shading */}
                                                    <Line type="monotone" dataKey="UBB" stroke="#93C5FD" strokeDasharray="5 5" dot={false} strokeWidth={1} name="Upper Band" />
                                                    <Line type="monotone" dataKey="LBB" stroke="#93C5FD" strokeDasharray="5 5" dot={false} strokeWidth={1} name="Lower Band" />

                                                    {/* Price */}
                                                    <Line type="monotone" dataKey="Close" stroke="#1F2937" strokeWidth={3} dot={false} animationDuration={1000} name="Price" />

                                                    {/* Trailing Stop */}
                                                    <Line type="stepAfter" dataKey="Trailing_Stop" stroke="#EF4444" strokeWidth={2} dot={false} strokeDasharray="4 4" name="Trail Stop" />

                                                    {/* Highlight Entry/Exit */}
                                                    <ReferenceLine x={formatDate(selectedTrade.Entry_Date)} stroke="#3B82F6" label={{ position: 'top', value: 'Entry', fill: '#3B82F6', fontSize: 10, fontWeight: 'bold' }} strokeDasharray="3 3" />
                                                    <ReferenceLine x={formatDate(selectedTrade.Exit_Date)} stroke="#EF4444" label={{ position: 'top', value: 'Exit', fill: '#EF4444', fontSize: 10, fontWeight: 'bold' }} strokeDasharray="3 3" />
                                                </LineChart>
                                            </ResponsiveContainer>
                                        ) : (
                                            <div className="absolute inset-0 flex flex-col items-center justify-center text-zinc-300 gap-4">
                                                <BarChart2 size={64} strokeWidth={1} />
                                                <p className="font-bold text-lg">Trade Visualization</p>
                                            </div>
                                        )}
                                    </div>

                                    {plotData.length > 0 && (
                                        <div className="mt-4 grid grid-cols-2 gap-2 text-[10px] font-bold uppercase text-zinc-400">
                                            <div className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-blue-500"></span> Entry Signal</div>
                                            <div className="flex items-center gap-1"><span className="w-2 h-2 rounded-full bg-red-500"></span> Trailing Stop</div>
                                        </div>
                                    )}
                                </div>
                            </div>
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
}
