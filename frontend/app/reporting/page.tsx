"use client";

import { useState, useEffect } from "react";
import AccountSelector from "@/components/reporting/AccountSelector";
import PortfolioSummary from "@/components/reporting/PortfolioSummary";
import HoldingsTable from "@/components/reporting/HoldingsTable";
import FileUploader from "@/components/reporting/FileUploader";

export default function ReportingPage() {
    const [selectedAccountId, setSelectedAccountId] = useState<string | null>(null);
    const [data, setData] = useState<any>(null);
    const [loading, setLoading] = useState(false);
    const [refreshKey, setRefreshKey] = useState(0);

    useEffect(() => {
        if (!selectedAccountId) return;

        setLoading(true);
        fetch(`/api/portfolio/summary?account_id=${selectedAccountId}&t=${refreshKey}`)
            .then((res) => res.json())
            .then((json) => {
                setData(json);
                setLoading(false);
            })
            .catch((err) => {
                console.error("Error fetching portfolio summary:", err);
                setLoading(false);
            });
    }, [selectedAccountId, refreshKey]);

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

                <FileUploader
                    accountId={selectedAccountId}
                    onUploadSuccess={() => setRefreshKey(k => k + 1)}
                />

                {/* Content */}
                {loading && !data ? (
                    <div className="flex justify-center p-12">
                        <span className="text-zinc-500 animate-pulse">Loading portfolio data...</span>
                    </div>
                ) : (
                    <>
                        <PortfolioSummary data={data?.summary} />
                        <HoldingsTable holdings={data?.holdings || []} />
                    </>
                )}

            </div>
        </main>
    );
}
