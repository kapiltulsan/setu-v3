"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import AccountSelector from "@/components/reporting/AccountSelector";
import PortfolioSummary from "@/components/reporting/PortfolioSummary";
import HoldingsTable from "@/components/reporting/HoldingsTable";
import FileUploader from "@/components/reporting/FileUploader";
import FilterBar from "@/components/reporting/FilterBar";
import ConnectionStatus from "@/components/reporting/ConnectionStatus";

export default function ReportingPage() {
    const [selectedAccountId, setSelectedAccountId] = useState<string | null>(null);
    const [data, setData] = useState<any>(null);
    const [loading, setLoading] = useState(false);
    const [refreshKey, setRefreshKey] = useState(0);
    const [accountsWithIssues, setAccountsWithIssues] = useState<any[]>([]);

    const [filters, setFilters] = useState({ member: "All", broker: "All", strategy: "Open" });
    const [isTokenValid, setIsTokenValid] = useState(true);

    useEffect(() => {
        const params = new URLSearchParams();
        if (selectedAccountId) params.append("account_id", selectedAccountId);
        if (filters.strategy !== "All") params.append("strategy_name", filters.strategy);
        params.append("t", refreshKey.toString());

        setLoading(true);
        fetch(`/api/portfolio/summary?${params.toString()}`)
            .then((res) => res.json())
            .then((json) => {
                setData(json);
                setLoading(false);
            })
            .catch((err) => {
                console.error("Error fetching portfolio summary:", err);
                setLoading(false);
            });
    }, [selectedAccountId, filters, refreshKey]);

    useEffect(() => {
        // Fetch global token status and identify operational accounts with issues
        const checkAllAccounts = async () => {
            try {
                const [accRes, tokenRes] = await Promise.all([
                    fetch("/api/config/accounts?all=true"),
                    fetch("/api/auth/verify?account_id=All")
                ]);
                const accounts = await accRes.json();
                const tokenData = await tokenRes.json();
                const allTokens = tokenData.all_tokens || {};

                const issues = accounts.filter((acc: any) => {
                    const status = allTokens[acc.credential_id];
                    return !status || !status.valid;
                });
                setAccountsWithIssues(issues);
            } catch (err) {
                console.error("Failed to check accounts", err);
            }
        };
        checkAllAccounts();
    }, [refreshKey]);

    return (
        <main className="min-h-screen bg-zinc-50 dark:bg-black p-4 md:p-8">
            <div className="max-w-7xl mx-auto space-y-6">

                {/* Header */}
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div>
                        <h1 className="text-2xl font-bold text-zinc-900 dark:text-white">Reporting Panel</h1>
                        <p className="text-zinc-500 dark:text-zinc-400">Track performance across your portfolios.</p>
                    </div>

                    <AccountSelector
                        selectedAccountId={selectedAccountId}
                        onSelect={setSelectedAccountId}
                    />
                </div>

                <hr className="border-zinc-200 dark:border-zinc-800" />

                <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div className="lg:col-span-2 space-y-6">
                        <FilterBar onFilterChange={setFilters} />

                        <ConnectionStatus
                            accountId={selectedAccountId}
                            broker={filters.broker !== "All" ? filters.broker : null}
                            onStatusChange={setIsTokenValid}
                        />

                        {loading && !data ? (
                            <div className="flex justify-center p-12">
                                <span className="text-zinc-500 animate-pulse">Loading portfolio data...</span>
                            </div>
                        ) : !isTokenValid && filters.broker !== "All" ? (
                            <div className="bg-white dark:bg-zinc-900 p-12 rounded-xl border border-dashed border-zinc-300 dark:border-zinc-700 text-center">
                                <p className="text-zinc-500">Please generate a valid token for {filters.broker} to view live data.</p>
                            </div>
                        ) : (
                            <>
                                <PortfolioSummary data={data?.summary} />
                                <HoldingsTable holdings={data?.holdings || []} />
                            </>
                        )}
                    </div>

                    <div className="space-y-6">
                        <FileUploader
                            accountId={selectedAccountId}
                            onUploadSuccess={() => setRefreshKey(k => k + 1)}
                        />

                        <div className="bg-white dark:bg-zinc-900 p-6 rounded-xl border border-zinc-200 dark:border-zinc-800 shadow-sm">
                            <h4 className="text-sm font-bold text-zinc-900 dark:text-white mb-4">System Alerts</h4>
                            <div className="space-y-4">
                                <div className="p-3 bg-blue-50 dark:bg-blue-900/10 rounded-lg border border-blue-100 dark:border-blue-800">
                                    <h5 className="text-xs font-bold text-blue-800 dark:text-blue-300 mb-1">Portfolio Strategy</h5>
                                    <p className="text-[10px] text-zinc-600 dark:text-zinc-400">
                                        Segments are defaulted to "Open". Use the Strategy Management page to create custom buckets.
                                    </p>
                                </div>

                                <div className="p-3 bg-zinc-50 dark:bg-zinc-800/50 rounded-lg border border-zinc-200 dark:border-zinc-700">
                                    <h5 className="text-xs font-bold text-zinc-700 dark:text-zinc-300 mb-2 underline">Global Connectivity</h5>
                                    {accountsWithIssues.length > 0 ? (
                                        <div className="space-y-1">
                                            <p className="text-[10px] text-red-600 dark:text-red-400 mb-1">
                                                The following accounts require attention:
                                            </p>
                                            <ul className="list-disc list-inside text-[10px] text-zinc-700 dark:text-zinc-300">
                                                {accountsWithIssues.map((acc) => (
                                                    <li key={acc.id}>
                                                        {acc.broker} ({acc.user || acc.id})
                                                    </li>
                                                ))}
                                            </ul>
                                            <Link href="/strategies" className="text-[10px] text-blue-600 hover:underline">
                                                Manage Strategies →
                                            </Link>
                                        </div>
                                    ) : (
                                        <p className="text-[10px] text-zinc-500 dark:text-zinc-400">
                                            All configured accounts are connected.
                                        </p>
                                    )}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    );
}
