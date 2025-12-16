"use client";

import React, { useEffect, useState } from 'react';
import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip, Legend } from 'recharts';

interface Holding {
    symbol: string;
    invested_value: number;
    current_value: number;
}

const COLORS = ['#3b82f6', '#10b981', '#f59e0b', '#8b5cf6', '#ec4899', '#6366f1'];

const AssetAllocationChart = () => {
    const [data, setData] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const res = await fetch('/api/portfolio/summary');
                if (res.ok) {
                    const json = await res.json();
                    if (json.holdings) {
                        // Sort by Invested Value and take top 5
                        const sorted = [...json.holdings]
                            .sort((a: any, b: any) => b.invested_value - a.invested_value)
                            .slice(0, 5)
                            .map((h: any) => ({
                                name: h.symbol,
                                value: h.invested_value
                            }));
                        setData(sorted);
                    }
                }
            } catch (e) {
                console.error("Chart fetch error", e);
            } finally {
                setLoading(false);
            }
        };
        fetchData();
    }, []);

    if (loading) {
        return (
            <div className="col-span-12 md:col-span-6 lg:col-span-6 bg-white dark:bg-zinc-900 rounded-3xl p-6 border border-zinc-200 dark:border-zinc-800 shadow-sm flex items-center justify-center min-h-[300px]">
                <span className="text-zinc-400 animate-pulse">Loading Chart...</span>
            </div>
        );
    }

    if (data.length === 0) {
        return (
            <div className="col-span-12 md:col-span-6 lg:col-span-6 bg-white dark:bg-zinc-900 rounded-3xl p-6 border border-zinc-200 dark:border-zinc-800 shadow-sm flex items-center justify-center min-h-[300px]">
                <div className="text-center">
                    <p className="text-zinc-400 font-medium">No Assets Found</p>
                    <p className="text-zinc-500 text-sm mt-1">Upload your portfolio to see the breakdown.</p>
                </div>
            </div>
        );
    }

    return (
        <div className="col-span-12 md:col-span-6 lg:col-span-6 bg-white dark:bg-zinc-900 rounded-3xl p-6 border border-zinc-200 dark:border-zinc-800 shadow-sm flex flex-col">
            <h3 className="text-zinc-500 font-medium mb-4">Top Allocations</h3>
            <div className="h-[250px] w-full">
                <ResponsiveContainer width="100%" height="100%">
                    <PieChart>
                        <Pie
                            data={data}
                            cx="50%"
                            cy="50%"
                            innerRadius={60}
                            outerRadius={80}
                            paddingAngle={5}
                            dataKey="value"
                        >
                            {data.map((entry, index) => (
                                <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} strokeWidth={0} />
                            ))}
                        </Pie>
                        <Tooltip
                            contentStyle={{ backgroundColor: '#18181b', border: 'none', borderRadius: '8px', color: '#fff' }}
                            itemStyle={{ color: '#fff' }}
                            formatter={(value: number) => `₹${value.toLocaleString()}`}
                        />
                        <Legend iconType="circle" />
                    </PieChart>
                </ResponsiveContainer>
            </div>
        </div>
    );
};

export default AssetAllocationChart;
