import React from 'react';
import Link from 'next/link';
import { BarChart2 } from 'lucide-react';

const BacktestTileCard = () => {
    return (
        <Link href="/backtest" className="col-span-12 md:col-span-4 lg:col-span-3 group">
            <div className="h-full bg-zinc-50 dark:bg-zinc-900/50 rounded-3xl p-6 border border-zinc-200 dark:border-zinc-800 flex flex-col justify-center items-center text-center transition-all hover:bg-zinc-100 dark:hover:bg-zinc-800/50 hover:border-blue-500/30">
                <div className="w-16 h-16 bg-blue-100 dark:bg-blue-900/20 rounded-2xl flex items-center justify-center text-blue-600 dark:text-blue-400 mb-4 group-hover:scale-110 transition-transform duration-300">
                    <BarChart2 size={32} />
                </div>

                <h3 className="text-lg font-bold text-zinc-800 dark:text-zinc-100 mb-2">Backtesting</h3>
                <p className="text-sm text-zinc-500 dark:text-zinc-400">
                    Verify strategies on historical data before going live.
                </p>

                <div className="mt-4 text-xs font-semibold text-blue-600 dark:text-blue-400 flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity translate-y-2 group-hover:translate-y-0">
                    Open Engine &rarr;
                </div>
            </div>
        </Link>
    );
};

export default BacktestTileCard;
