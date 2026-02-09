"use client";

import { useState, useEffect, Suspense, useMemo, useCallback } from "react";
import { useSearchParams } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import { LayoutDashboard, Activity, AlertTriangle, ChevronDown, ChevronRight, Zap, TrendingUp, TrendingDown } from "lucide-react";
import { FinancialChart } from "@/components/FinancialChart";
import { CandlestickData, LineData, HistogramData, SeriesMarker, Time } from 'lightweight-charts';

interface IndexPoint {
    Date: string;
    Open: number;
    High: number;
    Low: number;
    Close: number;
    Volume: number;
    UBB?: number;
    LBB?: number;
    SMA_30?: number;
    BB_Width?: number;
    ATR_14?: number;
}

function VisualizeIndexContent() {
    const searchParams = useSearchParams();
    const symbol = searchParams.get("symbol");

    const [plotData, setPlotData] = useState<IndexPoint[]>([]);
    const [hoveredData, setHoveredData] = useState<IndexPoint | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [isDrilldownExpanded, setIsDrilldownExpanded] = useState(true);

    useEffect(() => {
        if (!symbol) {
            setError("No symbol provided");
            setLoading(false);
            return;
        }

        async function loadData() {
            try {
                const res = await fetch("/api/sectors/visualize", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ symbol, years: 2 })
                });
                const data = await res.json();

                if (res.ok && data.plot_data) {
                    setPlotData(data.plot_data);
                } else {
                    setError(data.error || "Failed to fetch data");
                }
            } catch (e) {
                setError("Connection failed");
            } finally {
                setLoading(false);
            }
        }
        loadData();
    }, [symbol]);

    const chartData = useMemo(() => {
        const candlesticks: CandlestickData<Time>[] = [];
        const ubb: LineData<Time>[] = [];
        const lbb: LineData<Time>[] = [];
        const volumes: HistogramData<Time>[] = [];
        const markers: SeriesMarker<Time>[] = [];

        plotData.forEach((d) => {
            const time = d.Date as Time;
            candlesticks.push({ time, open: d.Open, high: d.High, low: d.Low, close: d.Close });
            if (d.UBB) ubb.push({ time, value: d.UBB });
            if (d.LBB) lbb.push({ time, value: d.LBB });
            volumes.push({
                time,
                value: d.Volume,
                color: d.Close >= d.Open ? '#22c55e44' : '#ef444444'
            });
        });

        return { candlesticks, ubb, lbb, volumes, markers };
    }, [plotData]);

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
            <p className="text-xs font-black tracking-widest uppercase">Fetching Index Data...</p>
        </div>
    );

    if (error) return (
        <div className="h-screen w-full flex flex-col items-center justify-center bg-black text-red-500 gap-4">
            <AlertTriangle size={32} />
            <p className="font-bold">{error}</p>
        </div>
    );

    const latest = plotData.length > 0 ? plotData[plotData.length - 1] : null;
    const isPositive = latest && plotData.length >= 2 ? latest.Close >= plotData[plotData.length - 2].Close : true;

    return (
        <div className="h-screen w-full bg-[#09090b] text-zinc-100 flex flex-col overflow-hidden font-sans">
            <header className="h-16 px-6 border-b border-zinc-800 flex items-center justify-between bg-[#09090b]/80 backdrop-blur-md z-30">
                <div className="flex items-center gap-4">
                    <div className="p-2 bg-blue-600 rounded-lg text-white">
                        <Activity size={18} />
                    </div>
                    <div>
                        <h1 className="text-xl font-black tracking-tight">{symbol}</h1>
                        <p className="text-[10px] font-black text-zinc-500 uppercase tracking-widest mt-0.5">Index Performance Visualizer • Weekly View</p>
                    </div>
                </div>

                <div className="flex gap-4 items-center">
                    <div className="flex flex-col items-end">
                        <span className="text-[9px] font-black text-zinc-500 tracking-widest leading-none mb-1 uppercase">Current Value</span>
                        <div className="flex items-baseline gap-2">
                            <span className="text-xl font-black tabular-nums leading-none">₹{latest ? latest.Close.toLocaleString() : "---"}</span>
                            {latest && (
                                <span className={`text-xs font-bold ${isPositive ? 'text-green-500' : 'text-red-500'}`}>
                                    {isPositive ? <TrendingUp size={12} className="inline mr-1" /> : <TrendingDown size={12} className="inline mr-1" />}
                                    {plotData.length >= 2 ? (((latest.Close - plotData[plotData.length - 2].Close) / plotData[plotData.length - 2].Close) * 100).toFixed(2) : "0.00"}%
                                </span>
                            )}
                        </div>
                    </div>
                </div>
            </header>

            <main className="flex-1 flex overflow-hidden">
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
                            </div>
                        ) : (
                            <div className="flex items-center gap-2 text-zinc-700">
                                <Zap size={10} />
                                <span className="text-[9px] font-black uppercase tracking-[0.2em]">Live Data Engine • 2 Year History</span>
                            </div>
                        )}
                        <span className="text-[10px] font-black text-zinc-500 tracking-widest">{hoveredData ? hoveredData.Date : "Interactive Chart"}</span>
                    </div>

                    <div className="flex-1 min-h-0 min-w-0 pr-4">
                        <FinancialChart
                            data={chartData.candlesticks}
                            upperBB={chartData.ubb}
                            lowerBB={chartData.lbb}
                            volume={chartData.volumes}
                            onCrosshairMove={handleCrosshairMove}
                        />
                    </div>
                </section>

                <aside className="flex-[3] flex flex-col p-4 bg-zinc-950/50 overflow-y-auto custom-scrollbar">
                    <div className={`flex flex-col bg-zinc-900 border border-zinc-800 rounded-xl overflow-hidden ${isDrilldownExpanded ? 'flex-1' : 'shrink-0'}`}>
                        <button
                            onClick={() => setIsDrilldownExpanded(!isDrilldownExpanded)}
                            className="p-4 flex items-center justify-between hover:bg-zinc-800 transition-colors"
                        >
                            <div className="flex items-center gap-2">
                                <Activity size={14} className="text-blue-500" />
                                <h3 className="text-[10px] font-black uppercase tracking-widest text-zinc-400">Technical Breakdown</h3>
                            </div>
                            {isDrilldownExpanded ? <ChevronDown size={14} /> : <ChevronRight size={14} />}
                        </button>

                        <AnimatePresence>
                            {isDrilldownExpanded && (
                                <motion.div
                                    initial={{ height: 0, opacity: 0 }}
                                    animate={{ height: "auto", opacity: 1 }}
                                    exit={{ height: 0, opacity: 0 }}
                                    className="p-4 pt-0 space-y-6 overflow-y-auto"
                                >
                                    {!hoveredData ? (
                                        <div className="py-12 text-center opacity-30 flex flex-col items-center">
                                            <Zap size={24} className="mb-2" />
                                            <p className="text-[9px] font-black uppercase tracking-widest">Move crosshair for details</p>
                                        </div>
                                    ) : (
                                        <div className="space-y-4">
                                            <div className="space-y-3">
                                                <h4 className="text-[10px] font-black uppercase text-zinc-500 border-b border-zinc-800 pb-1">Volatility Indicators</h4>
                                                {[
                                                    { label: "Bollinger Upper", val: hoveredData.UBB },
                                                    { label: "Bollinger Lower", val: hoveredData.LBB },
                                                    { label: "BB Width %", val: hoveredData.BB_Width ? (hoveredData.BB_Width * 100).toFixed(2) + "%" : "N/A" }
                                                ].map((item, i) => (
                                                    <div key={i} className="flex justify-between items-center">
                                                        <span className="text-[11px] font-bold text-zinc-400">{item.label}</span>
                                                        <span className="text-xs font-black tabular-nums">
                                                            {typeof item.val === 'number' ? `₹${item.val.toLocaleString()}` : item.val}
                                                        </span>
                                                    </div>
                                                ))}
                                            </div>

                                            <div className="space-y-3 pt-4">
                                                <h4 className="text-[10px] font-black uppercase text-zinc-500 border-b border-zinc-800 pb-1">Trend Signal</h4>
                                                <div className="flex justify-between items-center">
                                                    <span className="text-[11px] font-bold text-zinc-400">SMA (30)</span>
                                                    <span className="text-xs font-black tabular-nums">₹{hoveredData.SMA_30?.toLocaleString() || "---"}</span>
                                                </div>
                                                <div className="bg-zinc-800/50 p-3 rounded-lg flex flex-col items-center justify-center">
                                                    <span className="text-[9px] font-black text-zinc-500 uppercase mb-1">Position vs SMA</span>
                                                    <span className={`text-sm font-black ${hoveredData.Close > (hoveredData.SMA_30 || 0) ? 'text-green-500' : 'text-red-500'}`}>
                                                        {hoveredData.Close > (hoveredData.SMA_30 || 0) ? 'ABOVE TREND' : 'BELOW TREND'}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    )}
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

export default function VisualizeIndexPage() {
    return (
        <Suspense fallback={<div className="h-screen w-full bg-black" />}>
            <VisualizeIndexContent />
        </Suspense>
    );
}
