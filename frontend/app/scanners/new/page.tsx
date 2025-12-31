
"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import ScannerBuilder, { LogicCondition } from "@/components/scanner-builder";

export default function NewScannerPage() {
    const router = useRouter();
    const [formData, setFormData] = useState({
        name: "",
        description: "",
        source_universe: "Nifty 50",
        schedule_cron: "0 18 * * *", // Default daily at 6 PM
    });
    const [logic, setLogic] = useState<LogicCondition[]>([]);
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setSaving(true);
        setError(null);

        const payload = {
            ...formData,
            logic_config: logic
        };

        try {
            const res = await fetch("/api/scanners", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload)
            });

            if (!res.ok) {
                const errData = await res.json();
                throw new Error(errData.error || "Failed to create scanner");
            }

            const data = await res.json();
            alert(`Scanner Created! ID: ${data.id}`);
            router.push("/scanners");

        } catch (err: any) {
            setError(err.message);
            setSaving(false);
        }
    };

    return (
        <div className="max-w-3xl mx-auto p-6">
            <h1 className="text-2xl font-bold mb-6">Create New Scanner</h1>

            {error && (
                <div className="bg-red-50 border-l-4 border-red-500 p-4 mb-6">
                    <p className="text-red-700">{error}</p>
                </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-6">
                {/* Step 1: Basic Info */}
                <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                    <h2 className="text-lg font-medium text-gray-900 mb-4">1. Basic Information</h2>
                    <div className="grid grid-cols-1 gap-6">
                        <div>
                            <label className="block text-sm font-medium text-gray-700">Scanner Name</label>
                            <input
                                type="text"
                                required
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2 border"
                                value={formData.name}
                                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                                placeholder="e.g. Nifty 50 Momentum"
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700">Description</label>
                            <input
                                type="text"
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2 border"
                                value={formData.description}
                                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700">Source Universe</label>
                            <select
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2 border"
                                value={formData.source_universe}
                                onChange={(e) => setFormData({ ...formData, source_universe: e.target.value })}
                            >
                                <option value="Nifty 50">Nifty 50</option>
                                <option value="Nifty Bank">Nifty Bank</option>
                                <option value="Nifty 500">Nifty 500</option>
                                <option value="ALL">All NSE Equity</option>
                            </select>
                        </div>
                    </div>
                </div>

                {/* Step 2: Logic Builder */}
                <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                    <h2 className="text-lg font-medium text-gray-900 mb-4">2. Logic Rules</h2>
                    <ScannerBuilder value={logic} onChange={setLogic} />
                </div>

                {/* Step 3: Schedule */}
                <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                    <h2 className="text-lg font-medium text-gray-900 mb-4">3. Scheduling</h2>
                    <div className="flex items-center gap-4">
                        <div className="flex-1">
                            <label className="block text-sm font-medium text-gray-700">Cron Schedule</label>
                            <input
                                type="text"
                                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2 border"
                                value={formData.schedule_cron}
                                onChange={(e) => setFormData({ ...formData, schedule_cron: e.target.value })}
                                placeholder="0 18 * * *"
                            />
                            <p className="text-xs text-gray-500 mt-1">Default: Daily at 6:00 PM</p>
                        </div>
                    </div>
                </div>

                <div className="flex justify-end gap-3">
                    <button
                        type="button"
                        onClick={() => router.back()}
                        className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm hover:bg-gray-50"
                    >
                        Cancel
                    </button>
                    <button
                        type="submit"
                        disabled={saving}
                        className="px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50"
                    >
                        {saving ? "Saving..." : "Create Scanner"}
                    </button>
                </div>

            </form>
        </div>
    );
}
