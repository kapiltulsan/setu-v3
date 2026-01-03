"use client";

interface SummaryData {
    total_invested: number;
    current_value: number;
    pnl_absolute: number;
    pnl_percent: number;
}

export default function PortfolioSummary({ data }: { data: SummaryData | null }) {
    if (!data) return null;

    const isProfit = data.pnl_absolute >= 0;
    const pnlColor = isProfit ? "text-emerald-500" : "text-rose-500";
    const pnlIcon = isProfit ? "▲" : "▼";

    return (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">

            {/* Total Invested */}
            <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-6 shadow-sm">
                <h3 className="text-zinc-500 dark:text-zinc-400 text-sm font-medium uppercase tracking-wider">
                    Total Invested
                </h3>
                <p className="mt-2 text-3xl font-bold text-zinc-900 dark:text-white">
                    ₹{data.total_invested.toLocaleString('en-IN', { maximumFractionDigits: 0 })}
                </p>
            </div>

            {/* Current Value */}
            <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-6 shadow-sm">
                <h3 className="text-zinc-500 dark:text-zinc-400 text-sm font-medium uppercase tracking-wider">
                    Current Value
                </h3>
                <p className="mt-2 text-3xl font-bold text-zinc-900 dark:text-white">
                    ₹{data.current_value.toLocaleString('en-IN', { maximumFractionDigits: 0 })}
                </p>
            </div>

            {/* P&L */}
            <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-6 shadow-sm">
                <h3 className="text-zinc-500 dark:text-zinc-400 text-sm font-medium uppercase tracking-wider">
                    Profit / Loss
                </h3>
                <div className="flex items-baseline mt-2 space-x-2">
                    <p className={`text-3xl font-bold ${pnlColor}`}>
                        {data.pnl_absolute >= 0 ? "+" : ""}{data.pnl_absolute.toLocaleString('en-IN', { maximumFractionDigits: 0 })}
                    </p>
                    <span className={`text-sm font-medium bg-zinc-100 dark:bg-zinc-800 px-2 py-1 rounded-full ${pnlColor}`}>
                        {pnlIcon} {data.pnl_percent}%
                    </span>
                </div>
            </div>

        </div>
    );
}
