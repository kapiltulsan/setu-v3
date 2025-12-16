import React from 'react';

const TechStackCard = () => {
    return (
        <div className="col-span-12 md:col-span-4 lg:col-span-3 bg-zinc-50 dark:bg-zinc-900/50 rounded-3xl p-6 border border-zinc-200 dark:border-zinc-800 flex flex-col justify-center items-center text-center">
            <h3 className="text-sm uppercase tracking-wider text-zinc-500 font-semibold mb-6">Powered By</h3>

            <div className="grid grid-cols-2 gap-6 w-full max-w-[200px]">
                {/* Python */}
                <div className="flex flex-col items-center gap-2 group">
                    <div className="w-12 h-12 bg-blue-500/10 rounded-xl flex items-center justify-center text-blue-500 group-hover:scale-110 transition-transform">
                        <span className="font-bold text-xl">Py</span>
                    </div>
                    <span className="text-xs font-medium text-zinc-600 dark:text-zinc-400">Python</span>
                </div>

                {/* Flask */}
                <div className="flex flex-col items-center gap-2 group">
                    <div className="w-12 h-12 bg-zinc-500/10 rounded-xl flex items-center justify-center text-zinc-700 dark:text-zinc-300 group-hover:scale-110 transition-transform">
                        <span className="font-bold text-xl">F</span>
                    </div>
                    <span className="text-xs font-medium text-zinc-600 dark:text-zinc-400">Flask</span>
                </div>

                {/* Next.js */}
                <div className="flex flex-col items-center gap-2 group">
                    <div className="w-12 h-12 bg-black/5 dark:bg-white/10 rounded-xl flex items-center justify-center text-black dark:text-white group-hover:scale-110 transition-transform">
                        <span className="font-bold text-xl">N</span>
                    </div>
                    <span className="text-xs font-medium text-zinc-600 dark:text-zinc-400">Next.js</span>
                </div>

                {/* Raspberry Pi */}
                <div className="flex flex-col items-center gap-2 group">
                    <div className="w-12 h-12 bg-rose-500/10 rounded-xl flex items-center justify-center text-rose-500 group-hover:scale-110 transition-transform">
                        <span className="font-bold text-xl">Pi</span>
                    </div>
                    <span className="text-xs font-medium text-zinc-600 dark:text-zinc-400">Pi 5</span>
                </div>
            </div>
        </div>
    );
};

export default TechStackCard;
