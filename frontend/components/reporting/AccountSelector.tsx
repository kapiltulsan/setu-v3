"use client";

import { useEffect, useState } from "react";

interface Account {
    id: string;
    label: string;
    user: string;
    type: string;
}

interface AccountSelectorProps {
    selectedAccountId: string | null;
    onSelect: (accountId: string) => void;
}

export default function AccountSelector({ selectedAccountId, onSelect }: AccountSelectorProps) {
    const [accounts, setAccounts] = useState<Account[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch("/api/config/accounts")
            .then((res) => res.json())
            .then((data) => {
                setAccounts(data);
                if (data.length > 0 && !selectedAccountId) {
                    // Auto-select first one if none selected
                    onSelect(data[0].id);
                }
                setLoading(false);
            })
            .catch((err) => {
                console.error("Failed to fetch accounts", err);
                setLoading(false);
            });
    }, []);

    if (loading) return <div className="text-sm text-gray-500">Loading accounts...</div>;

    return (
        <div className="flex items-center space-x-2">
            <label htmlFor="account-select" className="text-sm font-medium text-gray-700 dark:text-gray-300">
                Account:
            </label>
            <select
                id="account-select"
                value={selectedAccountId || ""}
                onChange={(e) => onSelect(e.target.value)}
                className="block w-64 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm bg-white dark:bg-zinc-800 dark:border-zinc-700 dark:text-gray-200 p-2 border"
            >
                {accounts.map((acc) => (
                    <option key={acc.id} value={acc.id}>
                        {acc.label}
                    </option>
                ))}
            </select>
        </div>
    );
}
