
"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { ScannerConfig } from "@/types/scanner";

export default function ScannersPage() {
    const [scanners, setScanners] = useState<ScannerConfig[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch("/api/scanners")
            .then((res) => res.json())
            .then((data) => {
                setScanners(data);
                setLoading(false);
            })
            .catch((err) => {
                console.error("Failed to load scanners", err);
                setLoading(false);
            });
    }, []);

    return (
        <div className="p-6">
            <div className="flex justify-between items-center mb-6">
                <div className="flex items-center gap-4">
                    <Link href="/" className="bg-gray-100 hover:bg-gray-200 text-gray-700 p-2 rounded-full transition" title="Back to Dashboard">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor" className="w-5 h-5">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18" />
                        </svg>
                    </Link>
                    <h1 className="text-2xl font-bold">Stock Scanners</h1>
                </div>
                <Link
                    href="/scanners/new"
                    className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded shadow transition"
                >
                    + Create New Scanner
                </Link>
            </div>

            {loading ? (
                <div className="text-gray-500">Loading scanners...</div>
            ) : scanners.length === 0 ? (
                <div className="text-center py-10 bg-gray-50 rounded-lg border border-dashed border-gray-300">
                    <p className="text-gray-500 mb-4">No scanners found.</p>
                    <Link href="/scanners/new" className="text-blue-600 hover:underline">
                        Create your first scanner
                    </Link>
                </div>
            ) : (
                <div className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
                    <div className="overflow-x-auto">
                        <table className="min-w-full divide-y divide-gray-200">
                            <thead className="bg-gray-50">
                                <tr>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Scanner Name</th>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Source</th>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Schedule</th>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Last Run</th>
                                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Matches</th>
                                    <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody className="bg-white divide-y divide-gray-200">
                                {scanners.map((scanner) => (
                                    <tr key={scanner.id} className="hover:bg-gray-50 transition">
                                        <td className="px-6 py-4 whitespace-nowrap">
                                            <div className="flex items-center">
                                                <span className={`h-2.5 w-2.5 rounded-full mr-3 ${scanner.is_active ? 'bg-green-500' : 'bg-gray-300'}`} title={scanner.is_active ? "Active" : "Inactive"}></span>
                                                <div>
                                                    <div className="text-sm font-medium text-gray-900">{scanner.name}</div>
                                                    <div className="text-xs text-gray-500">{scanner.description}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            {scanner.source_universe}
                                        </td>
                                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 font-mono">
                                            {scanner.schedule_cron || "Manual"}
                                        </td>
                                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            {scanner.last_run_at ? new Date(scanner.last_run_at).toLocaleString() : "Never"}
                                        </td>
                                        <td className="px-6 py-4 whitespace-nowrap text-sm">
                                            {scanner.last_match_count !== undefined ? (
                                                <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${scanner.last_match_count > 0 ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}`}>
                                                    {scanner.last_match_count}
                                                </span>
                                            ) : (
                                                <span className="text-gray-400">--</span>
                                            )}
                                        </td>
                                        <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                            <Link
                                                href={`/scanners/${scanner.id}`}
                                                className="text-blue-600 hover:text-blue-900 mr-4"
                                            >
                                                Details
                                            </Link>
                                            <Link
                                                href={`/scanners/${scanner.id}/edit`}
                                                className="text-gray-400 hover:text-gray-600 cursor-not-allowed" // Disabled for now until edit page exists or just link to it
                                                onClick={(e) => e.preventDefault()} // Soft disable
                                            >
                                                Edit
                                            </Link>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            )}
        </div>
    );
}
