import React from 'react';
import Link from 'next/link';

const ScannerTileCard = () => {
    return (
        <Link href="/scanners" className="col-span-12 md:col-span-4 lg:col-span-3 group">
            <div className="h-full bg-zinc-50 dark:bg-zinc-900/50 rounded-3xl p-6 border border-zinc-200 dark:border-zinc-800 flex flex-col justify-center items-center text-center transition-all hover:bg-zinc-100 dark:hover:bg-zinc-800/50 hover:border-blue-500/30">
                <div className="w-16 h-16 bg-blue-100 dark:bg-blue-900/20 rounded-2xl flex items-center justify-center text-blue-600 dark:text-blue-400 mb-4 group-hover:scale-110 transition-transform duration-300">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-8 h-8">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
                    </svg>
                </div>

                <h3 className="text-lg font-bold text-zinc-800 dark:text-zinc-100 mb-2">Stock Scanners</h3>
                <p className="text-sm text-zinc-500 dark:text-zinc-400">
                    Create and run technical screeners on Nifty 50 & 500.
                </p>

                <div className="mt-4 text-xs font-semibold text-blue-600 dark:text-blue-400 flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity translate-y-2 group-hover:translate-y-0">
                    Launch Scanner &rarr;
                </div>
            </div>
        </Link>
    );
};

export default ScannerTileCard;
