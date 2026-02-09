"use client";

import { useState, useEffect } from "react";

interface Strategy {
    id: number;
    name: string;
    description: string;
}

export default function StrategiesPage() {
    const [strategies, setStrategies] = useState<Strategy[]>([]);
    const [loading, setLoading] = useState(true);
    const [newName, setNewName] = useState("");
    const [newDesc, setNewDesc] = useState("");
    const [error, setError] = useState("");

    const fetchStrategies = async () => {
        try {
            const res = await fetch("/api/strategies");
            const data = await res.json();
            setStrategies(data);
        } catch (err) {
            console.error("Failed to fetch strategies", err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchStrategies();
    }, []);

    const handleAdd = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!newName) {
            setError("Name is required");
            return;
        }
        setError("");
        try {
            const res = await fetch("/api/strategies", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ name: newName, description: newDesc }),
            });
            if (!res.ok) {
                const errorData = await res.json();
                throw new Error(errorData.error || "Failed to add strategy");
            }
            setNewName("");
            setNewDesc("");
            fetchStrategies();
        } catch (err: any) {
            setError(err.message);
        }
    };

    const handleDelete = async (name: string) => {
        if (!confirm(`Are you sure you want to delete strategy "${name}"?`)) return;
        try {
            const res = await fetch(`/api/strategies/${name}`, {
                method: "DELETE",
            });
            if (!res.ok) {
                const errorData = await res.json();
                throw new Error(errorData.error || "Failed to delete strategy");
            }
            fetchStrategies();
        } catch (err: any) {
            alert(err.message);
        }
    };

    return (
        <main className="min-h-screen bg-zinc-50 dark:bg-black p-4 md:p-8">
            <div className="max-w-4xl mx-auto space-y-8">
                <div>
                    <h1 className="text-2xl font-bold text-zinc-900 dark:text-white">Strategy Management</h1>
                    <p className="text-zinc-500 dark:text-zinc-400">Define and maintain custom strategy categories for your portfolio.</p>
                </div>

                {/* Add Strategy Form */}
                <section className="bg-white dark:bg-zinc-900 p-6 rounded-xl border border-zinc-200 dark:border-zinc-800 shadow-sm">
                    <h2 className="text-lg font-semibold mb-4 text-zinc-900 dark:text-white">Add New Strategy</h2>
                    <form onSubmit={handleAdd} className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div className="md:col-span-1">
                            <label className="block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-1">Name</label>
                            <input
                                type="text"
                                value={newName}
                                onChange={(e) => setNewName(e.target.value)}
                                className="w-full px-4 py-2 rounded-lg border border-zinc-300 dark:border-zinc-700 bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white focus:ring-2 focus:ring-blue-500 outline-none"
                                placeholder="e.g. Momentum"
                            />
                        </div>
                        <div className="md:col-span-1">
                            <label className="block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-1">Description</label>
                            <input
                                type="text"
                                value={newDesc}
                                onChange={(e) => setNewDesc(e.target.value)}
                                className="w-full px-4 py-2 rounded-lg border border-zinc-300 dark:border-zinc-700 bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white focus:ring-2 focus:ring-blue-500 outline-none"
                                placeholder="(Optional)"
                            />
                        </div>
                        <div className="md:flex items-end">
                            <button
                                type="submit"
                                className="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 rounded-lg transition-colors"
                            >
                                Add Strategy
                            </button>
                        </div>
                    </form>
                    {error && <p className="mt-2 text-sm text-red-500 font-medium">{error}</p>}
                </section>

                {/* Strategy List */}
                <section className="overflow-hidden bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 shadow-sm">
                    <table className="w-full text-left">
                        <thead className="bg-zinc-50 dark:bg-zinc-800/50">
                            <tr>
                                <th className="px-6 py-4 text-sm font-semibold text-zinc-900 dark:text-white">Strategy Name</th>
                                <th className="px-6 py-4 text-sm font-semibold text-zinc-900 dark:text-white">Description</th>
                                <th className="px-6 py-4 text-sm font-semibold text-zinc-900 dark:text-white text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-zinc-200 dark:divide-zinc-800">
                            {loading ? (
                                <tr>
                                    <td colSpan={3} className="px-6 py-12 text-center text-zinc-500 animate-pulse">Loading strategies...</td>
                                </tr>
                            ) : strategies.length === 0 ? (
                                <tr>
                                    <td colSpan={3} className="px-6 py-12 text-center text-zinc-500">No strategies defined yet.</td>
                                </tr>
                            ) : (
                                strategies.map((s) => (
                                    <tr key={s.id} className="hover:bg-zinc-50 dark:hover:bg-zinc-800/30 transition-colors">
                                        <td className="px-6 py-4">
                                            <span className={`px-2 py-1 rounded text-xs font-bold uppercase tracking-wider ${s.name === 'Open' ? 'bg-zinc-100 text-zinc-600 dark:bg-zinc-800 dark:text-zinc-400' : 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-300'}`}>
                                                {s.name}
                                            </span>
                                        </td>
                                        <td className="px-6 py-4 text-sm text-zinc-600 dark:text-zinc-400">{s.description || '-'}</td>
                                        <td className="px-6 py-4 text-right">
                                            {s.name !== 'Open' && (
                                                <button
                                                    onClick={() => handleDelete(s.name)}
                                                    className="text-red-600 hover:text-red-700 text-sm font-medium transition-colors"
                                                >
                                                    Delete
                                                </button>
                                            )}
                                        </td>
                                    </tr>
                                ))
                            )}
                        </tbody>
                    </table>
                </section>
            </div>
        </main>
    );
}
