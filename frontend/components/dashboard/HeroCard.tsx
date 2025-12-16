import React from 'react';
import { Terminal, Code, TrendingUp } from 'lucide-react';

const HeroCard = () => {
    return (
        <div className="col-span-12 md:col-span-8 lg:col-span-6 bg-white dark:bg-zinc-900 rounded-3xl p-8 border border-zinc-200 dark:border-zinc-800 shadow-sm flex flex-col justify-between relative overflow-hidden group">
            <div className="absolute top-0 right-0 p-8 opacity-10 group-hover:opacity-20 transition-opacity">
                <Code size={120} />
            </div>

            <div className="z-10">
                <h1 className="text-4xl md:text-5xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400 mb-4">
                    Kapil Tulsan
                </h1>
                <h2 className="text-xl md:text-2xl font-medium text-zinc-600 dark:text-zinc-400 mb-6 flex items-center gap-2">
                    <Terminal size={20} />
                    Software Engineer & Trader
                </h2>
                <p className="text-zinc-500 dark:text-zinc-500 max-w-lg leading-relaxed">
                    Building high-performance systems and managing automated financial portfolios with "Setu V3".
                    Focusing on scalable architecture and quantitative analysis.
                </p>
            </div>

            <div className="mt-8 flex gap-3">
                <span className="px-4 py-2 bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400 rounded-full text-sm font-medium border border-blue-100 dark:border-blue-900/50">
                    Full Stack
                </span>
                <span className="px-4 py-2 bg-emerald-50 dark:bg-emerald-900/20 text-emerald-600 dark:text-emerald-400 rounded-full text-sm font-medium border border-emerald-100 dark:border-emerald-900/50">
                    Algo Trading
                </span>
                <span className="px-4 py-2 bg-orange-50 dark:bg-orange-900/20 text-orange-600 dark:text-orange-400 rounded-full text-sm font-medium border border-orange-100 dark:border-orange-900/50">
                    IoT / Pi
                </span>
            </div>
        </div>
    );
};

export default HeroCard;
