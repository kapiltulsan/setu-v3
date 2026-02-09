"use client";

import { useState, useEffect } from "react";

interface ConnectionStatusProps {
    accountId: string | null;
    broker: string | null;
    onStatusChange?: (isValid: boolean) => void;
}

export default function ConnectionStatus({ accountId, broker, onStatusChange }: ConnectionStatusProps) {
    const [status, setStatus] = useState<{ valid: boolean; message: string; date?: string; id?: string; account_name?: string; broker?: string } | null>(null);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        const checkStatus = async () => {
            // If no account is selected, we do a global check or hide
            setLoading(true);
            try {
                const res = await fetch(`/api/auth/verify?account_id=${accountId || "All"}`);
                const data = await res.json();
                setStatus(data);
                onStatusChange?.(data.valid);
            } catch (err) {
                console.error("Connection check failed", err);
                setStatus({ valid: false, message: "Check failed" });
                onStatusChange?.(false);
            } finally {
                setLoading(false);
            }
        };

        checkStatus();
    }, [accountId]);

    if (!status && loading) return <div className="p-4 text-center animate-pulse text-zinc-500">Verifying Connectivity...</div>;
    if (!status) return null;

    const isGlobal = !accountId || accountId === "All";

    return (
        <div className={`flex items-center gap-3 p-4 rounded-xl border transition-all ${status.valid ? 'bg-green-50 border-green-200 dark:bg-green-900/10 dark:border-green-800' : 'bg-rose-50 border-rose-200 dark:bg-rose-900/10 dark:border-rose-800'}`}>
            <div className={`w-3 h-3 rounded-full ${loading ? 'bg-zinc-400 animate-pulse' : status.valid ? 'bg-green-500 shadow-[0_0_8px_rgba(34,197,94,0.5)]' : 'bg-rose-500 shadow-[0_0_8px_rgba(239,68,68,0.5)]'}`} />

            <div className="flex-1">
                <h3 className={`text-sm font-bold ${status.valid ? 'text-green-800 dark:text-green-300' : 'text-rose-800 dark:text-rose-300'}`}>
                    {loading ? "Checking Connectivity..." : status.valid ? "Connection Active" : "Action Required: Token Expired"}
                </h3>
                {!loading && (
                    <p className="text-xs text-zinc-500 dark:text-zinc-400 mt-0.5">
                        {status.valid
                            ? `${status.account_name || 'System'}: Connected since ${status.date || 'Live'}`
                            : `${status.account_name || 'Specific accounts'} require authentication to fetch live portfolio data.`}
                    </p>
                )}
            </div>

            {!loading && !status.valid && status.id && (
                <button
                    onClick={() => {
                        const path = status.broker === 'ANGEL_ONE' ? '/login_angel' : '/login';
                        window.location.href = `${path}/${status.id}`;
                    }}
                    className="px-4 py-2 bg-rose-600 hover:bg-rose-700 text-white text-xs font-bold rounded-lg transition-colors shadow-sm"
                >
                    Generate Token
                </button>
            )}
        </div>
    );
}
