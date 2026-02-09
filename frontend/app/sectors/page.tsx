"use client";

import React, { useState, useEffect, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import {
    LayoutDashboard,
    Zap,
    TrendingUp,
    TrendingDown,
    Activity,
    Target,
    ArrowUpRight,
    Search,
    ChevronDown,
    ZapOff
} from 'lucide-react';

/**
 * TYPES
 */
interface SectorData {
    name: string;
    price: number;
    change: number;
    isSqueezing: boolean;
    momentum: string;
    trend: string;
    sparkline: number[];
}

/**
 * MOCK API HELPER
 */
const fetchSectorStatus = async (): Promise<SectorData[]> => {
    try {
        const response = await fetch('/api/sectors/status');
        if (!response.ok) throw new Error('API Failed');
        return await response.json();
    } catch (e) {
        console.error("Failed to fetch sector status:", e);
        return [];
    }
};

/**
 * SPARKLINE COMPONENT
 */
const Sparkline: React.FC<{ data: number[], color: string }> = ({ data, color }) => {
    const min = Math.min(...data);
    const max = Math.max(...data);
    const range = max - min;
    const width = 200;
    const height = 40;

    const points = data.map((val, i) => {
        const x = (i / (data.length - 1)) * width;
        const y = height - ((val - min) / range) * height;
        return `${x},${y}`;
    }).join(' ');

    return (
        <svg width="100%" height={height} viewBox={`0 0 ${width} ${height}`} preserveAspectRatio="none">
            <polyline
                fill="none"
                stroke={color}
                strokeWidth="2"
                strokeLinejoin="round"
                strokeLinecap="round"
                points={points}
            />
        </svg>
    );
};

/**
 * SECTOR CARD COMPONENT
 */
const SectorCard: React.FC<{ data: SectorData }> = ({ data }) => {
    const router = useRouter();
    const isPositive = data.change >= 0;
    const accentColor = isPositive ? '#22c55e' : '#ef4444';

    const handleClick = () => {
        // Redirect to index visualizer
        router.push(`/sectors/visualize?symbol=${encodeURIComponent(data.name)}`);
    };

    return (
        <div
            onClick={handleClick}
            className="group relative bg-zinc-900 border border-zinc-800 p-5 rounded-2xl hover:border-zinc-700 transition-all cursor-pointer hover:scale-[1.02] shadow-lg overflow-hidden"
        >
            {/* Background Glow for Squeeze */}
            {data.isSqueezing && (
                <div className="absolute inset-0 bg-red-500/5 animate-pulse pointer-events-none" />
            )}

            <div className="flex justify-between items-start mb-6">
                <div>
                    <h3 className="text-zinc-500 text-[10px] font-black uppercase tracking-widest mb-1">Index</h3>
                    <div className="text-lg font-black tracking-tighter text-zinc-100 group-hover:text-blue-400 transition-colors">
                        {data.name}
                    </div>
                </div>
                <div className="text-right">
                    <div className="text-lg font-black tabular-nums text-zinc-100">
                        ₹{data.price.toLocaleString(undefined, { maximumFractionDigits: 2 })}
                    </div>
                    <div className={`text-xs font-bold tabular-nums ${isPositive ? 'text-green-500' : 'text-red-500'}`}>
                        {isPositive ? '+' : ''}{data.change.toFixed(2)}%
                    </div>
                </div>
            </div>

            <div className={`mb-6 flex items-center gap-2 h-7`}>
                {data.isSqueezing ? (
                    <div className="flex items-center gap-2 bg-red-500/10 border border-red-500/20 px-3 py-1 rounded-full animate-pulse">
                        <div className="w-1.5 h-1.5 bg-red-500 rounded-full shadow-[0_0_8px_#ef4444]" />
                        <span className="text-[10px] font-black text-red-500 uppercase tracking-tighter">Squeeze Active</span>
                    </div>
                ) : (
                    <div className="flex items-center gap-2">
                        {data.momentum === "BULLISH" ? (
                            <span className="text-[10px] font-black text-green-500 uppercase flex items-center gap-1">
                                <TrendingUp size={12} /> Bullish Exp.
                            </span>
                        ) : (
                            <span className="text-[10px] font-black text-red-500 uppercase flex items-center gap-1">
                                <TrendingDown size={12} /> Bearish Exp.
                            </span>
                        )}
                    </div>
                )}
            </div>

            <div className="mt-auto opacity-70 group-hover:opacity-100 transition-opacity">
                <Sparkline data={data.sparkline} color={accentColor} />
            </div>

            <div className="mt-4 flex justify-between items-center text-zinc-600 text-[9px] font-bold uppercase tracking-widest">
                <span>20-Period Trend</span>
                <ArrowUpRight size={12} className="group-hover:translate-x-0.5 group-hover:-translate-y-0.5 transition-transform" />
            </div>
        </div>
    );
};

/**
 * MAIN PAGE
 */
export default function SectorRadarPage() {
    const [sectors, setSectors] = useState<SectorData[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedStrategy, setSelectedStrategy] = useState("Volatility Squeeze");
    const [isStrategyOpen, setIsStrategyOpen] = useState(false);

    const strategies = ["Volatility Squeeze", "Trend Reversal", "Gap Up/Down", "Mean Reversion"];

    useEffect(() => {
        fetchSectorStatus().then(data => {
            setSectors(data);
            setLoading(false);
        });
    }, []);

    const squeezeCount = useMemo(() => sectors.filter(s => s.isSqueezing).length, [sectors]);

    if (loading) {
        return (
            <div className="min-h-screen bg-black flex flex-col items-center justify-center gap-4">
                <div className="w-10 h-10 border-2 border-blue-500 border-t-transparent rounded-full animate-spin" />
                <p className="text-zinc-500 text-[10px] font-black uppercase tracking-[0.3em]">Mapping Market Breadth...</p>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-black text-zinc-100 p-6 md:p-12 selection:bg-blue-500/30">
            <div className="max-w-7xl mx-auto">
                {/* Header Area */}
                <header className="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-12">
                    <div>
                        <div className="flex items-center gap-3 mb-2">
                            <div className="p-2 bg-blue-600 rounded-xl text-white">
                                <Activity size={24} />
                            </div>
                            <h1 className="text-4xl font-black italic tracking-tighter">Sector Rotation Radar</h1>
                        </div>
                        <p className="text-zinc-500 font-bold uppercase text-[11px] tracking-widest pl-12 opacity-80">
                            Real-time Volatility Squeeze Scanner • Top-Down Index Analysis
                        </p>
                    </div>

                    <div className="flex gap-4 items-end">
                        <div className="relative">
                            <h3 className="text-zinc-500 text-[9px] font-black uppercase tracking-widest mb-1.5 ml-1">Active Strategy</h3>
                            <button
                                onClick={() => setIsStrategyOpen(!isStrategyOpen)}
                                className="bg-zinc-900 border border-zinc-800 px-4 py-2.5 rounded-2xl flex items-center justify-between gap-4 hover:border-zinc-700 transition-all min-w-[200px]"
                            >
                                <div className="flex items-center gap-2">
                                    <div className="p-1 bg-yellow-500/10 text-yellow-500 rounded-md">
                                        <Zap size={12} />
                                    </div>
                                    <span className="text-xs font-black tracking-tight">{selectedStrategy}</span>
                                </div>
                                <ChevronDown size={14} className={`text-zinc-600 transition-transform ${isStrategyOpen ? 'rotate-180' : ''}`} />
                            </button>

                            {isStrategyOpen && (
                                <div className="absolute top-full left-0 right-0 mt-2 bg-zinc-900 border border-zinc-800 rounded-2xl shadow-2xl overflow-hidden z-50 py-1">
                                    {strategies.map((strat) => (
                                        <button
                                            key={strat}
                                            onClick={() => {
                                                setSelectedStrategy(strat);
                                                setIsStrategyOpen(false);
                                            }}
                                            className={`w-full px-4 py-2 text-left text-xs font-bold hover:bg-zinc-800 transition-colors ${selectedStrategy === strat ? 'text-blue-400 bg-blue-500/5' : 'text-zinc-400'}`}
                                            disabled={strat !== "Volatility Squeeze"}
                                        >
                                            <div className="flex justify-between items-center">
                                                <span>{strat}</span>
                                                {strat !== "Volatility Squeeze" && <span className="text-[8px] bg-zinc-800 px-1.5 py-0.5 rounded text-zinc-600">SOON</span>}
                                            </div>
                                        </button>
                                    ))}
                                </div>
                            )}
                        </div>

                        <div className="bg-zinc-900 border border-zinc-800 px-6 py-3 rounded-2xl flex flex-col items-end">
                            <span className="text-zinc-500 text-[9px] font-black uppercase tracking-widest mb-1">Market State</span>
                            <div className="flex items-center gap-2">
                                <div className="w-2 h-2 bg-red-500 rounded-full animate-pulse shadow-[0_0_8px_#ef4444]" />
                                <span className="text-xl font-black tabular-nums">{squeezeCount} Sectors Squeezing</span>
                            </div>
                        </div>
                    </div>
                </header>

                {/* Metrics Bar */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
                    {[
                        { label: "Top Gainer", val: sectors.length ? sectors.reduce((prev, current) => (prev.change > current.change) ? prev : current).name : "N/A", icon: <TrendingUp size={14} className="text-green-500" /> },
                        { label: "High Momentum", val: sectors.length ? sectors.filter(s => s.momentum === "BULLISH").length + " Bulls" : "N/A", icon: <Zap size={14} className="text-blue-500" /> },
                        { label: "Scanner Health", val: "LIVE CONNECTION", icon: <Activity size={14} className="text-orange-500" /> }
                    ].map((metric, i) => (
                        <div key={metric.label} className="bg-zinc-900/50 border border-zinc-800/50 px-5 py-3 rounded-2xl flex items-center justify-between">
                            <span className="text-zinc-500 text-[9px] font-black uppercase tracking-widest">{metric.label}</span>
                            <div className="flex items-center gap-2">
                                <span className="text-xs font-black tracking-tight">{metric.val}</span>
                                {metric.icon}
                            </div>
                        </div>
                    ))}
                </div>

                {/* Main Grid */}
                <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-5">
                    {sectors.map(sector => (
                        <SectorCard key={sector.name} data={sector} />
                    ))}
                </div>

                {/* Footer Info */}
                <footer className="mt-16 text-center border-t border-zinc-900 pt-8">
                    <p className="text-zinc-700 text-[10px] font-black uppercase tracking-widest mb-4">
                        Volatility Squeeze = Bollinger Bands (20, 2) inside Keltner Channels (20, 1.5, EMA)
                    </p>
                    <div className="flex justify-center gap-8 text-zinc-800">
                        <div className="flex items-center gap-2">
                            <div className="w-1.5 h-1.5 bg-red-500 rounded-full" />
                            <span className="text-[9px] font-bold">ACTIVE SQUEEZE</span>
                        </div>
                        <div className="flex items-center gap-2">
                            <div className="w-3 h-[2px] bg-[#22c55e]" />
                            <span className="text-[9px] font-bold">20W BULLISH TREND</span>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
    );
}
