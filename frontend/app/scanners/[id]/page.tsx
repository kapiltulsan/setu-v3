
"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { ScannerDetail } from "@/types/scanner";
import Link from "next/link";
import { explainCondition, LogicCondition } from "@/components/scanner-builder";

export default function ScannerDetailsPage() {
    const { id } = useParams();
    const router = useRouter();
    const [data, setData] = useState<ScannerDetail | null>(null);
    const [loading, setLoading] = useState(true);
    const [running, setRunning] = useState(false);

    useEffect(() => {
        if (!id) return;
        fetch(`/api/scanners/${id}`)
            .then((res) => res.json())
            .then((data) => {
                setData(data);
                setLoading(false);
            })
            .catch((err) => {
                console.error(err);
                setLoading(false);
            });
    }, [id]);

    const runScanner = async () => {
        setRunning(true);
        try {
            const res = await fetch(`/api/scanners/${id}/run`, { method: "POST" });
            const json = await res.json();
            alert(json.message);
        } catch (err) {
            alert("Failed to trigger scan");
        } finally {
            setRunning(false);
        }
    };

    if (loading) return <div className="p-6">Loading details...</div>;
    if (!data) return <div className="p-6">Scanner not found.</div>;

    // Parse Logic
    let logic = data.config.logic_config || {};
    if (typeof logic === 'string') {
        try { logic = JSON.parse(logic); } catch (e) { }
    }
    const universe = logic.universe || [];
    const primary = (logic.primary_filter || []) as LogicCondition[];
    const refiner = (logic.refiner || []) as LogicCondition[];

    return (
        <div className="p-6">
            {/* Header */}
            <div className="flex justify-between items-start mb-6 border-b pb-4">
                <div>
                    <Link href="/scanners" className="text-sm text-blue-600 mb-2 block">&larr; Back to Scanners</Link>
                    <h1 className="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-700 to-indigo-600">
                        {data.config.name}
                    </h1>
                    <p className="text-gray-600 mt-1">{data.config.description}</p>
                </div>
                <div className="flex gap-2">
                    <Link
                        href={`/scanners/${id}/edit`}
                        className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded transition"
                    >
                        Edit Logic
                    </Link>
                    <button
                        onClick={runScanner}
                        disabled={running}
                        className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded shadow transition flex items-center gap-2"
                    >
                        {running ? "Starting..." : "Run Now"}
                    </button>
                </div>
            </div>

            {/* Metrics Grid */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <div className="bg-white p-4 rounded-lg shadow-sm border border-gray-200">
                    <p className="text-xs text-gray-500 uppercase font-semibold">Source</p>
                    <p className="text-xl font-medium text-gray-900">{data.config.source_universe}</p>
                </div>
                <div className="bg-white p-4 rounded-lg shadow-sm border border-gray-200">
                    <p className="text-xs text-gray-500 uppercase font-semibold">Schedule</p>
                    <p className="text-xl font-medium text-gray-900">{data.config.schedule_cron || "Manual"}</p>
                </div>
                <div className="bg-white p-4 rounded-lg shadow-sm border border-gray-200">
                    <p className="text-xs text-gray-500 uppercase font-semibold">Last Execution</p>
                    <p className="text-xl font-medium text-gray-900">
                        {data.config.last_run_at ? new Date(data.config.last_run_at).toLocaleString() : "Never"}
                    </p>
                </div>
            </div>

            {/* Strategy Configuration */}
            <div className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden mb-8">
                <div className="px-6 py-4 border-b border-gray-200 bg-gray-50 flex justify-between items-center">
                    <h3 className="font-semibold text-gray-800">Strategy Configuration</h3>
                    {data.config.last_run_stats && (
                        <div className="flex items-center gap-2 text-xs font-mono bg-white px-3 py-1 rounded border border-gray-200 shadow-sm">
                            <span className="text-blue-600 font-bold" title="Universe Size">{data.config.last_run_stats.universe ?? '-'}</span>
                            <span className="text-gray-400">→</span>
                            <span className="text-indigo-600 font-bold" title="After Primary Filter">{data.config.last_run_stats.primary ?? '-'}</span>
                            <span className="text-gray-400">→</span>
                            <span className="text-purple-600 font-bold" title="Final Matches">{data.config.last_run_stats.refiner ?? '-'}</span>
                        </div>
                    )}
                </div>
                <div className="p-6 grid grid-cols-1 md:grid-cols-3 gap-6 relative">
                    {/* Funnel Arrows Overlay (Desktop only) */}
                    <div className="hidden md:block absolute top-1/2 left-1/3 -translate-y-1/2 -translate-x-1/2 text-gray-200 z-0">
                        <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 5l7 7-7 7M5 5l7 7-7 7" /></svg>
                    </div>
                    <div className="hidden md:block absolute top-1/2 left-2/3 -translate-y-1/2 -translate-x-1/2 text-gray-200 z-0">
                        <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 5l7 7-7 7M5 5l7 7-7 7" /></svg>
                    </div>

                    {/* Universe */}
                    <div className="relative z-10 bg-white/80">
                        <div className="flex justify-between items-center mb-2">
                            <h4 className="text-sm font-bold text-blue-800 uppercase tracking-wide">Layer 1: Universe</h4>
                            {data.config.last_run_stats?.universe !== undefined && (
                                <span className="text-xs bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full font-bold">{data.config.last_run_stats.universe}</span>
                            )}
                        </div>
                        <div className="bg-blue-50 p-3 rounded text-sm text-blue-900 border border-blue-100 min-h-[60px]">
                            {universe.length > 0 ? universe.join(", ") : "No Universe Selected"}
                        </div>
                    </div>

                    {/* Primary */}
                    <div className="relative z-10 bg-white/80">
                        <div className="flex justify-between items-center mb-2">
                            <h4 className="text-sm font-bold text-indigo-800 uppercase tracking-wide">Layer 2: Primary Filters</h4>
                            {data.config.last_run_stats?.primary !== undefined && (
                                <span className="text-xs bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded-full font-bold">{data.config.last_run_stats.primary} passed</span>
                            )}
                        </div>
                        {primary.length === 0 ? <p className="text-gray-400 italic text-sm">None</p> : (
                            <ul className="space-y-2">
                                {primary.map((c, i) => (
                                    <li key={i} className="bg-indigo-50 p-2 rounded text-sm text-indigo-900 border border-indigo-100">
                                        {explainCondition(c)}
                                    </li>
                                ))}
                            </ul>
                        )}
                    </div>

                    {/* Refiner */}
                    <div className="relative z-10 bg-white/80">
                        <div className="flex justify-between items-center mb-2">
                            <h4 className="text-sm font-bold text-purple-800 uppercase tracking-wide">Layer 3: Refiner</h4>
                            {data.config.last_run_stats?.refiner !== undefined && (
                                <span className="text-xs bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full font-bold">{data.config.last_run_stats.refiner} confirmed</span>
                            )}
                        </div>
                        {refiner.length === 0 ? <p className="text-gray-400 italic text-sm">None</p> : (
                            <ul className="space-y-2">
                                {refiner.map((c, i) => (
                                    <li key={i} className="bg-purple-50 p-2 rounded text-sm text-purple-900 border border-purple-100">
                                        {explainCondition(c)}
                                    </li>
                                ))}
                            </ul>
                        )}
                    </div>
                </div>
            </div>

            {/* Latest Results Table */}
            <div className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden mb-8">
                <div className="px-6 py-4 border-b border-gray-200 bg-gray-50">
                    <h3 className="font-semibold text-gray-800">Latest Results</h3>
                </div>

                {data.latest_results.length === 0 ? (
                    <div className="p-6 text-center text-gray-500">
                        No stocks matched in the last run (or never run).
                    </div>
                ) : (
                    <div className="overflow-x-auto">
                        <table className="min-w-full divide-y divide-gray-200">
                            <thead className="bg-gray-50">
                                <tr>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Symbol</th>
                                    {/* Dynamically render headers based on first match data */}
                                    {Object.keys(data.latest_results[0].match_data).map(key => (
                                        <th key={key} className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">{key}</th>
                                    ))}
                                    <th className="px-6 py-3 text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody className="bg-white divide-y divide-gray-200">
                                {data.latest_results.map((result, idx) => (
                                    <tr key={idx} className="hover:bg-gray-50 transition">
                                        <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-blue-600">
                                            {result.symbol}
                                        </td>
                                        {Object.values(result.match_data).map((val: any, vIdx) => (
                                            <td key={vIdx} className="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                                {typeof val === 'number' ? val.toFixed(2) : val}
                                            </td>
                                        ))}
                                        <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                            <button className="text-indigo-600 hover:text-indigo-900">Chart</button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>

            {/* History (Optional simple list for now) */}
            <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 className="font-semibold text-gray-800 mb-4">Execution History</h3>
                <ul className="space-y-2">
                    {data.history.map((h, i) => (
                        <li key={i} className="flex justify-between text-sm py-2 border-b last:border-0 border-gray-100">
                            <span className="text-gray-600">{new Date(h.run_date).toLocaleString()}</span>
                            <span className="font-medium">{h.matches} Matches</span>
                        </li>
                    ))}
                    {data.history.length === 0 && <li className="text-gray-500 italic">No history available.</li>}
                </ul>
            </div>

        </div>
    );
}
