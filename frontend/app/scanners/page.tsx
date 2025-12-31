
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

    const [deleteTarget, setDeleteTarget] = useState<ScannerConfig | null>(null);
    const [toast, setToast] = useState<{ type: 'success' | 'error' | 'info', message: string } | null>(null);

    const showToast = (type: 'success' | 'error' | 'info', message: string) => {
        setToast({ type, message });
        setTimeout(() => setToast(null), 3000);
    };

    const handleDelete = async () => {
        if (!deleteTarget) return;
        try {
            const res = await fetch(`/api/scanners/${deleteTarget.id}`, { method: "DELETE" });
            if (res.ok) {
                setScanners(prev => prev.filter(s => s.id !== deleteTarget.id));
                showToast("success", "Scanner deleted successfully");
            } else {
                const err = await res.json();
                showToast("error", err.error || "Failed to delete scanner");
            }
        } catch (e) {
            showToast("error", "Network error occurred");
        } finally {
            setDeleteTarget(null);
        }
    };

    const handleRun = async (id: number) => {
        showToast("info", "Starting scanner...");
        try {
            const res = await fetch(`/api/scanners/${id}/run`, { method: "POST" });
            if (res.ok) {
                showToast("success", "Scanner run successfully! Refreshing...");
                setTimeout(() => window.location.reload(), 1000);
            } else {
                showToast("error", "Run failed");
            }
        } catch (e) {
            showToast("error", "Network error on run");
        }
    };

    return (
        <div className="p-6 relative min-h-screen">
            {/* TOAST NOTIFICATION */}
            {toast && (
                <div className={`fixed top-4 right-4 z-50 px-4 py-3 rounded shadow-lg text-white font-medium flex items-center gap-2 animate-in slide-in-from-top-2 ${toast.type === 'success' ? 'bg-green-600' :
                    toast.type === 'error' ? 'bg-red-600' : 'bg-blue-600'
                    }`}>
                    {toast.type === 'success' && (
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clipRule="evenodd" /></svg>
                    )}
                    {toast.type === 'error' && (
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5"><path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z" clipRule="evenodd" /></svg>
                    )}
                    {toast.message}
                </div>
            )}

            {/* DELETE MODAL */}
            {deleteTarget && (
                <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
                    <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6 animate-in zoom-in-95">
                        <h3 className="text-lg font-bold text-gray-900 mb-2">Delete Scanner?</h3>
                        <p className="text-gray-600 mb-6">
                            Are you sure you want to delete <span className="font-semibold text-gray-900">"{deleteTarget.name}"</span>?
                            This action cannot be undone and will remove all associated results.
                        </p>
                        <div className="flex justify-end gap-3">
                            <button
                                onClick={() => setDeleteTarget(null)}
                                className="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded font-medium"
                            >
                                Cancel
                            </button>
                            <button
                                onClick={handleDelete}
                                className="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded font-medium shadow-sm"
                            >
                                Delete
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* HEADER */}
            {/* HEADER */}
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
            {/* CONTENT */}
            {loading ? (
                <div className="text-gray-500 text-center py-10">Loading scanners...</div>
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
                                            <div className="flex items-center justify-end gap-3">
                                                {/* Run Manually */}
                                                <button
                                                    onClick={() => handleRun(scanner.id)}
                                                    className="text-indigo-600 hover:text-indigo-900 p-1 hover:bg-indigo-50 rounded"
                                                    title="Run Now"
                                                >
                                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-5 h-5">
                                                        <path strokeLinecap="round" strokeLinejoin="round" d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z" />
                                                    </svg>
                                                </button>

                                                {/* Details / View */}
                                                <Link
                                                    href={`/scanners/${scanner.id}`}
                                                    className="text-blue-600 hover:text-blue-900 p-1 hover:bg-blue-50 rounded"
                                                    title="View Details & Results"
                                                >
                                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-5 h-5">
                                                        <path strokeLinecap="round" strokeLinejoin="round" d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z" />
                                                        <path strokeLinecap="round" strokeLinejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                    </svg>
                                                </Link>

                                                {/* Delete */}
                                                <button
                                                    onClick={() => setDeleteTarget(scanner)}
                                                    className="text-red-500 hover:text-red-700 p-1 hover:bg-red-50 rounded"
                                                    title="Delete Scanner"
                                                >
                                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-5 h-5">
                                                        <path strokeLinecap="round" strokeLinejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
                                                    </svg>
                                                </button>
                                            </div>
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
