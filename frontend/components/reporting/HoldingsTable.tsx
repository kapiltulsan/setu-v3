"use client";

interface Holding {
    symbol: string;
    total_quantity: number;
    average_price: number;
    invested_value: number;
    current_value: number; // Might be 0 if no live data
    pnl: number; // Might be 0
}

export default function HoldingsTable({ holdings }: { holdings: Holding[] }) {
    if (!holdings || holdings.length === 0) {
        return <div className="p-8 text-center text-zinc-500">No holdings found for this account.</div>;
    }

    return (
        <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl overflow-hidden shadow-sm">
            <div className="overflow-x-auto">
                <table className="w-full text-sm text-left">
                    <thead className="text-xs text-zinc-500 uppercase bg-zinc-50 dark:bg-zinc-800/50 border-b border-zinc-200 dark:border-zinc-800">
                        <tr>
                            <th className="px-6 py-3 font-medium">Symbol</th>
                            <th className="px-6 py-3 font-medium text-right">Qty</th>
                            <th className="px-6 py-3 font-medium text-right">Avg Price</th>
                            <th className="px-6 py-3 font-medium text-right">Invested</th>
                            {/* <th className="px-6 py-3 font-medium text-right">Current Value</th> 
                  Hiding Current/P&L cols for now as they might be 0 until market data syncs 
                  Actually, user wants Reporting Panel, so showing 0 is better than hiding?
                  Let's show them.
              */}
                            <th className="px-6 py-3 font-medium text-right">Last Price</th>
                            <th className="px-6 py-3 font-medium text-right">Current</th>
                            <th className="px-6 py-3 font-medium text-right">P&L</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-zinc-100 dark:divide-zinc-800">
                        {holdings.map((row) => {
                            const isProfit = (row.current_value - row.invested_value) >= 0;
                            const pnlClass = isProfit ? "text-emerald-600 dark:text-emerald-400" : "text-rose-600 dark:text-rose-400";

                            // Calculate implicit last price if current_value exists
                            const lastPrice = row.total_quantity > 0 && row.current_value > 0
                                ? row.current_value / row.total_quantity
                                : 0;

                            const pnlAbs = row.current_value > 0 ? (row.current_value - row.invested_value) : 0;
                            const pnlPct = row.invested_value > 0 ? (pnlAbs / row.invested_value * 100) : 0;

                            return (
                                <tr key={row.symbol} className="bg-white dark:bg-zinc-900 hover:bg-zinc-50 dark:hover:bg-zinc-800/50 transition-colors">
                                    <td className="px-6 py-4 font-medium text-zinc-900 dark:text-zinc-100">
                                        {row.symbol}
                                    </td>
                                    <td className="px-6 py-4 text-right text-zinc-600 dark:text-zinc-400">
                                        {row.total_quantity}
                                    </td>
                                    <td className="px-6 py-4 text-right text-zinc-600 dark:text-zinc-400">
                                        {row.average_price.toFixed(2)}
                                    </td>
                                    <td className="px-6 py-4 text-right text-zinc-600 dark:text-zinc-400 font-medium">
                                        {row.invested_value.toLocaleString('en-IN', { maximumFractionDigits: 0 })}
                                    </td>
                                    <td className="px-6 py-4 text-right text-zinc-600 dark:text-zinc-400">
                                        {lastPrice > 0 ? lastPrice.toFixed(2) : "-"}
                                    </td>
                                    <td className="px-6 py-4 text-right text-zinc-600 dark:text-zinc-400 font-medium">
                                        {row.current_value > 0 ? row.current_value.toLocaleString('en-IN', { maximumFractionDigits: 0 }) : "-"}
                                    </td>
                                    <td className={`px-6 py-4 text-right font-medium ${pnlClass}`}>
                                        {row.current_value > 0 ? (
                                            <span>
                                                {pnlAbs > 0 ? "+" : ""}{pnlAbs.toLocaleString('en-IN', { maximumFractionDigits: 0 })}
                                                <span className="text-xs opacity-75 ml-1">({pnlPct.toFixed(2)}%)</span>
                                            </span>
                                        ) : "-"}
                                    </td>
                                </tr>
                            );
                        })}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
