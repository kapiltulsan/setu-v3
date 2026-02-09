"use client";

import { useState, useEffect } from "react";

interface FilterBarProps {
    onFilterChange: (filters: { member: string; broker: string; strategy: string }) => void;
    initialStrategy?: string;
}

export default function FilterBar({ onFilterChange, initialStrategy = "Open" }: FilterBarProps) {
    const [members, setMembers] = useState<string[]>([]);
    const [brokers, setBrokers] = useState<string[]>([]);
    const [strategies, setStrategies] = useState<string[]>([]);

    const [selectedMember, setSelectedMember] = useState("All");
    const [selectedBroker, setSelectedBroker] = useState("All");
    const [selectedStrategy, setSelectedStrategy] = useState(initialStrategy);

    useEffect(() => {
        // Fetch filter options
        const fetchOptions = async () => {
            try {
                const [stratRes, brokerRes, accRes] = await Promise.all([
                    fetch("/api/strategies"),
                    fetch("/api/config/brokers"),
                    fetch("/api/config/accounts")
                ]);

                const stratData = await stratRes.json();
                setStrategies(["All", ...stratData.map((s: any) => s.name)]);

                const brokerData = await brokerRes.json();
                setBrokers(["All", ...brokerData]);

                const accData = await accRes.json();
                const memberList = Array.from(new Set(accData.map((a: any) => a.user))) as string[];
                setMembers(["All", ...memberList]);
            } catch (err) {
                console.error("Failed to fetch filter options", err);
            }
        };
        fetchOptions();
    }, []);

    useEffect(() => {
        onFilterChange({
            member: selectedMember,
            broker: selectedBroker,
            strategy: selectedStrategy
        });
    }, [selectedMember, selectedBroker, selectedStrategy]);

    return (
        <div className="flex flex-wrap gap-4 items-end bg-white dark:bg-zinc-900 p-4 rounded-xl border border-zinc-200 dark:border-zinc-800 shadow-sm">
            <div className="flex-1 min-w-[150px]">
                <label className="block text-xs font-semibold text-zinc-500 uppercase mb-1">Member</label>
                <select
                    value={selectedMember}
                    onChange={(e) => setSelectedMember(e.target.value)}
                    className="w-full px-3 py-2 rounded-lg border border-zinc-300 dark:border-zinc-700 bg-white dark:bg-zinc-800 text-sm outline-none focus:ring-2 focus:ring-blue-500"
                >
                    {members.map(m => <option key={m} value={m}>{m}</option>)}
                </select>
            </div>

            <div className="flex-1 min-w-[150px]">
                <label className="block text-xs font-semibold text-zinc-500 uppercase mb-1">Broker</label>
                <select
                    value={selectedBroker}
                    onChange={(e) => setSelectedBroker(e.target.value)}
                    className="w-full px-3 py-2 rounded-lg border border-zinc-300 dark:border-zinc-700 bg-white dark:bg-zinc-800 text-sm outline-none focus:ring-2 focus:ring-blue-500"
                >
                    {brokers.map(b => <option key={b} value={b}>{b}</option>)}
                </select>
            </div>

            <div className="flex-1 min-w-[150px]">
                <label className="block text-xs font-semibold text-zinc-500 uppercase mb-1">Strategy</label>
                <select
                    value={selectedStrategy}
                    onChange={(e) => setSelectedStrategy(e.target.value)}
                    className="w-full px-3 py-2 rounded-lg border border-zinc-300 dark:border-zinc-700 bg-white dark:bg-zinc-800 text-sm outline-none focus:ring-2 focus:ring-blue-500"
                >
                    {strategies.map(s => <option key={s} value={s}>{s}</option>)}
                </select>
            </div>
        </div>
    );
}
