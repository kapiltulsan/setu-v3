"use client";

import React, { useEffect, useState } from 'react';
import { TrendingUp, TrendingDown, RefreshCw, AlertTriangle } from 'lucide-react';

interface PortfolioSummary {
    total_invested: number;
    current_value: number;
    pnl_absolute: number;
    pnl_percent: number;
}

const LiveMetricsCard = () => {
    const [data, setData] = useState<PortfolioSummary | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(false);

    const fetchData = async () => {
        try {
            setLoading(true);
            setError(false);
            const res = await fetch('/api/portfolio/summary');
            if (!res.ok) throw new Error('Network response was not ok');

            const json = await res.json();
            // Start of Selection
            if (json.summary) {
                setData(json.summary);
            } else {
                // Fallback/Mock if empty
                setData({
                    total_invested: 0,
                    current_value: 0,
                    pnl_absolute: 0,
                    pnl_percent: 0
                })
            }
        } catch (err) {
            console.error(err);
            setError(true);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchData();
        const interval = setInterval(fetchData, 30000); // Poll every 30s
        return () => clearInterval(interval);
    }, []);

    if (loading && !data) {
        return (
            <div className="col-span-12 md:col-span-6 lg:col-span-3 bg-white dark:bg-zinc-900 rounded-3xl p-6 border border-zinc-200 dark:border-zinc-800 shadow-sm animate-pulse flex flex-col justify-between">
                <div className="h-4 bg-zinc-200 dark:bg-zinc-800 rounded w-1/3 mb-4"></div>
                <div className="h-8 bg-zinc-200 dark:bg-zinc-800 rounded w-2/3 mb-2"></div>
                <div className="h-10 bg-zinc-200 dark:bg-zinc-800 rounded w-full"></div>
            </div>
        );
    }

    if (error && !data) {
        return (
            <div className="col-span-12 md:col-span-6 lg:col-span-3 bg-red-50 dark:bg-red-900/10 rounded-3xl p-6 border border-red-100 dark:border-red-900/30 flex flex-col justify-center items-center text-center">
                <AlertTriangle className="text-red-500 mb-2" />
                <span className="text-red-500 font-medium">System Offline</span>
                <p className="text-xs text-red-400 mt-1">Connecting to Setu V3...</p>
                <button onClick={fetchData} className="mt-4 px-4 py-2 bg-white dark:bg-red-900/30 text-red-500 rounded-full text-xs font-semibold hover:bg-red-50 transition-colors">
                    Retry
                </button>
            </div>
        )
    }

    const isPositive = (data?.pnl_absolute || 0) >= 0;

    return (
        <div className="col-span-12 md:col-span-6 lg:col-span-3 bg-zinc-900 dark:bg-black rounded-3xl p-6 border border-zinc-800 dark:border-zinc-800 shadow-xl flex flex-col justify-between relative overflow-hidden">
            {/* Background Glow */}
            <div className={`absolute top-0 right-0 w-32 h-32 bg-${isPositive ? 'emerald' : 'rose'}-500/10 blur-[50px] rounded-full`}></div>

            <div className="flex justify-between items-start z-10">
                <div>
                    <h3 className="text-zinc-400 text-sm font-medium mb-1">Total Portfolio Value</h3>
                    <div className="text-3xl font-bold text-white tracking-tight">
                        ₹{data?.current_value.toLocaleString('en-IN', { maximumFractionDigits: 0 })}
                    </div>
                </div>
                <div className={`flex items-center gap-1 px-2 py-1 rounded-full text-xs font-bold ${isPositive ? 'bg-emerald-500/20 text-emerald-400' : 'bg-rose-500/20 text-rose-400'}`}>
                    {isPositive ? <TrendingUp size={12} /> : <TrendingDown size={12} />}
                    {data?.pnl_percent}%
                </div>
            </div>

            <div className="mt-6 z-10">
                <div className="flex justify-between items-end">
                    <div className="flex flex-col">
                        <span className="text-zinc-500 text-xs">Invested</span>
                        <span className="text-zinc-300 font-semibold">₹{data?.total_invested.toLocaleString('en-IN', { maximumFractionDigits: 0 })}</span>
                    </div>
                    <div className="flex flex-col items-end">
                        <span className="text-zinc-500 text-xs">P&L</span>
                        <span className={`font-semibold ${isPositive ? 'text-emerald-400' : 'text-rose-400'}`}>
                            {isPositive ? '+' : ''}₹{data?.pnl_absolute.toLocaleString('en-IN', { maximumFractionDigits: 0 })}
                        </span>
                    </div>
                </div>

                {/* Progress Bar */}
                <div className="w-full bg-zinc-800 rounded-full h-1.5 mt-3 overflow-hidden">
                    <div
                        className={`h-full rounded-full ${isPositive ? 'bg-gradient-to-r from-emerald-600 to-emerald-400' : 'bg-gradient-to-r from-rose-600 to-rose-400'}`}
                        style={{ width: '100%' }} // Dynamic width could be implemented based on goal
                    ></div>
                </div>
            </div>
        </div>
    );
};

export default LiveMetricsCard;
