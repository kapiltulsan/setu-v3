"use client";

import { useState, useEffect, use } from "react";
import { useRouter } from "next/navigation";
import ScannerBuilder, { LogicCondition, explainCondition } from "@/components/scanner-builder";

export default function EditScannerPage({ params }: { params: Promise<{ id: string }> }) {
    const router = useRouter();
    const { id: scannerId } = use(params);

    // Form State
    const [name, setName] = useState("");
    const [description, setDescription] = useState("");
    const [scheduleCron, setScheduleCron] = useState("0 18 * * *");

    // 3-Layer Logic State
    const [universe, setUniverse] = useState<string[]>([]);
    const [primaryFilter, setPrimaryFilter] = useState<LogicCondition[]>([]);
    const [refiner, setRefiner] = useState<LogicCondition[]>([]);

    // Data Sources
    const [availableIndices, setAvailableIndices] = useState<string[]>([]);
    const [loadingIndices, setLoadingIndices] = useState(true);
    const [universeCount, setUniverseCount] = useState<number>(0);
    const [isCalculating, setIsCalculating] = useState(false);
    const [loadingScanner, setLoadingScanner] = useState(true);

    // Filter UI State
    const [searchTerm, setSearchTerm] = useState("");
    const [isDropdownOpen, setIsDropdownOpen] = useState(false);

    // UI Status
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [showExplanation, setShowExplanation] = useState(false);

    // 1. Fetch Indices
    useEffect(() => {
        fetch("/api/indices")
            .then(res => res.json())
            .then(data => {
                setAvailableIndices(data);
                setLoadingIndices(false);
            })
            .catch(err => {
                console.error("Failed to load indices", err);
                setLoadingIndices(false);
            });
    }, []);

    // 2. Fetch Scanner Details
    useEffect(() => {
        if (!scannerId) return;

        setLoadingScanner(true);
        fetch(`/api/scanners/${scannerId}`)
            .then(res => {
                if (!res.ok) throw new Error("Scanner not found");
                return res.json();
            })
            .then(data => {
                const config = data.config;
                setName(config.name);
                setDescription(config.description || "");
                setScheduleCron(config.schedule_cron || "0 18 * * *");

                // Parse Logic Config
                let logic = config.logic_config || {};
                if (typeof logic === 'string') {
                    try { logic = JSON.parse(logic); } catch (e) { console.error("JSON Parse Error", e); }
                }

                setUniverse(logic.universe || []);
                setPrimaryFilter(logic.primary_filter || []);
                setRefiner(logic.refiner || []);

                setLoadingScanner(false);
            })
            .catch(err => {
                setError("Failed to load scanner details: " + err.message);
                setLoadingScanner(false);
            });
    }, [scannerId]);

    // Calculate Universe Size when selection changes
    useEffect(() => {
        if (universe.length === 0) {
            setUniverseCount(0);
            return;
        }

        const timer = setTimeout(() => {
            setIsCalculating(true);
            fetch("/api/universe/count", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ universe })
            })
                .then(res => res.json())
                .then(data => {
                    setUniverseCount(data.count);
                    setIsCalculating(false);
                })
                .catch(err => {
                    console.error("Count failed", err);
                    setIsCalculating(false);
                });
        }, 500);

        return () => clearTimeout(timer);
    }, [universe]);

    const toggleIndex = (idx: string) => {
        setUniverse(prev =>
            prev.includes(idx) ? prev.filter(i => i !== idx) : [...prev, idx]
        );
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setSaving(true);
        setError(null);

        if (universe.length === 0) {
            setError("Please select at least one Universe (Layer 1).");
            setSaving(false);
            return;
        }

        const logicConfig = {
            universe: universe,
            primary_filter: primaryFilter,
            refiner: refiner
        };

        const payload = {
            name,
            description,
            source_universe: universe.join(", "),
            logic_config: logicConfig,
            schedule_cron: scheduleCron
        };

        try {
            const res = await fetch(`/api/scanners/${scannerId}`, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload)
            });

            if (!res.ok) {
                const errData = await res.json();
                throw new Error(errData.error || "Failed to update scanner");
            }

            // Success feedback
            alert("Scanner updated successfully!");
            router.push("/scanners");

        } catch (err: any) {
            setError(err.message);
            setSaving(false);
        }
    };

    if (loadingScanner) {
        return (
            <div className="flex items-center justify-center min-h-screen">
                <div className="text-xl text-gray-500">Loading scanner details...</div>
            </div>
        );
    }

    return (
        <div className="max-w-4xl mx-auto p-6 pb-20">
            <div className="flex items-center justify-between mb-8">
                <h1 className="text-3xl font-bold text-gray-900">Edit Scanner</h1>
                <button
                    onClick={() => router.back()}
                    className="text-gray-600 hover:text-gray-900"
                >
                    &times; Cancel
                </button>
            </div>

            {error && (
                <div className="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded-r">
                    <p className="text-red-700 font-medium">{error}</p>
                </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-8">

                {/* 0. Meta Info */}
                <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-200">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">Scanner Name</label>
                            <input
                                type="text"
                                required
                                className="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2.5 border"
                                value={name}
                                onChange={(e) => setName(e.target.value)}
                                placeholder="e.g. Nifty 50 Momentum Alpha"
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-semibold text-gray-700 mb-1">Schedule (Cron)</label>
                            <input
                                type="text"
                                className="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2.5 border"
                                value={scheduleCron}
                                onChange={(e) => setScheduleCron(e.target.value)}
                                placeholder="0 18 * * *"
                            />
                            <p className="text-xs text-gray-500 mt-1">Default: Daily at 6:00 PM</p>
                        </div>
                        <div className="md:col-span-2">
                            <label className="block text-sm font-semibold text-gray-700 mb-1">Description</label>
                            <input
                                type="text"
                                className="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2.5 border"
                                value={description}
                                onChange={(e) => setDescription(e.target.value)}
                                placeholder="Brief description of logic..."
                            />
                        </div>
                    </div>
                </div>

                {/* LAYER 1: UNIVERSE */}
                <div className="bg-white rounded-xl shadow-sm border border-gray-200">
                    <div className="bg-blue-50 px-6 py-4 border-b border-blue-100 rounded-t-xl">
                        <h2 className="text-lg font-bold text-blue-900">Layer 1: Define Stock Universe</h2>
                        <p className="text-sm text-blue-700">Select the pool of stocks to start with (Source from Index_Source)</p>
                    </div>
                    <div className="p-6">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                            {/* Left Side: Search & Selection */}
                            <div>
                                <label className="block text-sm font-semibold text-gray-700 mb-2">Search & Add Indices</label>
                                <div className="relative">
                                    <input
                                        type="text"
                                        className="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2.5 border"
                                        placeholder="Type to search (e.g. NIFTY)..."
                                        value={searchTerm}
                                        onChange={(e) => setSearchTerm(e.target.value)}
                                        onFocus={() => setIsDropdownOpen(true)}
                                        onBlur={() => setTimeout(() => setIsDropdownOpen(false), 200)}
                                    />

                                    {/* Dropdown Results */}
                                    {isDropdownOpen && (
                                        <div className="absolute z-50 mt-1 w-full bg-white shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm">
                                            {loadingIndices ? (
                                                <div className="relative cursor-default select-none py-2 px-4 text-gray-700">Loading...</div>
                                            ) : (
                                                availableIndices
                                                    .filter(idx => !universe.includes(idx) && idx.toLowerCase().includes(searchTerm.toLowerCase()))
                                                    .concat(!universe.includes("ALL") && "ALL".includes(searchTerm.toUpperCase()) ? ["ALL"] : [])
                                                    .map((idx) => (
                                                        <div
                                                            key={idx}
                                                            className="cursor-pointer select-none relative py-2 pl-3 pr-9 hover:bg-blue-50 text-gray-900"
                                                            onMouseDown={(e) => {
                                                                e.preventDefault();
                                                                toggleIndex(idx);
                                                                setSearchTerm("");
                                                            }}
                                                        >
                                                            <span className="block truncate">{idx}</span>
                                                        </div>
                                                    ))
                                            )}
                                            {availableIndices.filter(idx => !universe.includes(idx) && idx.toLowerCase().includes(searchTerm.toLowerCase())).length === 0 && (
                                                <div className="relative cursor-default select-none py-2 px-4 text-gray-500">
                                                    No matching available indices found.
                                                </div>
                                            )}
                                        </div>
                                    )}
                                </div>
                                <p className="text-xs text-gray-500 mt-2">
                                    Start typing to see available indices from the database.
                                </p>
                            </div>

                            {/* Right Side: Selected List */}
                            <div className="bg-gray-50 rounded-lg p-4 border border-gray-200">
                                <div className="flex justify-between items-center mb-3">
                                    <label className="block text-sm font-semibold text-gray-700">Selected Indices</label>
                                    <span className="text-xs font-medium text-gray-500 bg-white px-2 py-1 rounded border">
                                        Count: {universe.length}
                                    </span>
                                </div>

                                <div className="flex flex-wrap gap-2 min-h-[40px]">
                                    {universe.map(idx => (
                                        <span key={idx} className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800 shadow-sm border border-blue-200">
                                            {idx}
                                            <button
                                                type="button"
                                                onClick={() => toggleIndex(idx)}
                                                className="flex-shrink-0 ml-1.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-blue-600 hover:bg-blue-200 hover:text-red-500 focus:outline-none transition-colors"
                                                title="Remove"
                                            >
                                                <span className="sr-only">Remove {idx}</span>
                                                <svg className="h-3 w-3" fill="currentColor" viewBox="0 0 20 20">
                                                    <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                                                </svg>
                                            </button>
                                        </span>
                                    ))}
                                    {universe.length === 0 && (
                                        <span className="text-gray-400 text-sm italic py-2 w-full text-center">
                                            No indices selected yet. Use the search to add.
                                        </span>
                                    )}
                                </div>
                            </div>
                        </div>

                        <div className="mt-4 text-sm text-gray-500 text-right">
                            Target Universe: <strong>{isCalculating ? "Calculating..." : universeCount} Unique Scrips</strong>
                        </div>
                    </div>
                </div>

                {/* LAYER 2: PRIMARY FILTER */}
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    <div className="bg-indigo-50 px-6 py-4 border-b border-indigo-100">
                        <h2 className="text-lg font-bold text-indigo-900">Layer 2: Primary Filter (Mandatory)</h2>
                        <p className="text-sm text-indigo-700">Coarse sieve to filter out noise (e.g. Price &gt; 100, SMA Trend)</p>
                    </div>
                    <div className="p-6">
                        <ScannerBuilder value={primaryFilter} onChange={setPrimaryFilter} />
                    </div>
                </div>

                {/* LAYER 3: REFINER */}
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    <div className="bg-purple-50 px-6 py-4 border-b border-purple-100">
                        <h2 className="text-lg font-bold text-purple-900">Layer 3: Strategy Signals (Optional)</h2>
                        <p className="text-sm text-purple-700">Fine sieve for specific entry signals (e.g. RSI Crossover)</p>
                    </div>
                    <div className="p-6">
                        <ScannerBuilder value={refiner} onChange={setRefiner} />
                    </div>
                </div>

                {/* Actions */}
                <div className="flex items-center justify-end gap-4 pt-6 border-t border-gray-200">
                    <button
                        type="button"
                        onClick={() => router.back()}
                        className="px-6 py-3 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg shadow-sm hover:bg-gray-50"
                    >
                        Cancel
                    </button>
                    <button
                        type="submit"
                        disabled={saving}
                        className="px-6 py-3 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-lg shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 flex items-center gap-2"
                    >
                        {saving ? (
                            <>
                                <svg className="animate-spin h-4 w-4 text-white" fill="none" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
                                Saving...
                            </>
                        ) : (
                            "Update Scanner"
                        )}
                    </button>
                </div>
            </form>

            {/* FLOATING ACTION BUTTON */}
            <button
                onClick={() => setShowExplanation(true)}
                className="fixed bottom-8 right-8 bg-indigo-600 hover:bg-indigo-700 text-white rounded-full p-4 shadow-lg z-50 transition-transform hover:scale-110 flex items-center gap-2"
                title="Explain Rules"
            >
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M12 18v-5.25m0 0a6.01 6.01 0 001.5-.189m-1.5.189a6.01 6.01 0 01-1.5-.189m3.75 7.478a12.06 12.06 0 01-4.5 0m3.75 2.383a14.406 14.406 0 01-3 0M14.25 18v-.192c0-.983.658-1.823 1.508-2.316a7.5 7.5 0 10-7.517 0c.85.493 1.509 1.333 1.509 2.316V18" />
                </svg>
                <span className="font-semibold hidden md:inline">Explain Rules</span>
            </button>

            {/* EXPLANATION MODAL */}
            {showExplanation && (
                <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
                    <div className="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[80vh] overflow-y-auto">
                        <div className="p-6 border-b border-gray-100 flex justify-between items-center sticky top-0 bg-white">
                            <h3 className="text-xl font-bold text-gray-800">Scanner Logic Explained</h3>
                            <button onClick={() => setShowExplanation(false)} className="text-gray-400 hover:text-gray-600">
                                <span className="sr-only">Close</span>
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="w-6 h-6">
                                    <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
                                </svg>
                            </button>
                        </div>

                        <div className="p-6 space-y-6">
                            {/* Layer 1: Universe */}
                            <div className="flex gap-4">
                                <div className="flex-shrink-0 w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold">1</div>
                                <div>
                                    <h4 className="font-semibold text-gray-900">Universe Selection</h4>
                                    <p className="text-gray-600 mt-1">
                                        Scan will check all stocks in <span className="font-medium text-blue-700">{universe.length > 0 ? universe.join(", ") : "Empty Selection"}</span>.
                                    </p>
                                </div>
                            </div>

                            {/* Layer 2: Primary Filter */}
                            <div className="flex gap-4">
                                <div className="flex-shrink-0 w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold">2</div>
                                <div>
                                    <h4 className="font-semibold text-gray-900">Primary Filters (Mandatory)</h4>
                                    {primaryFilter.length === 0 ? (
                                        <p className="text-gray-400 italic mt-1">No mandatory conditions set.</p>
                                    ) : (
                                        <ul className="mt-2 space-y-2">
                                            {primaryFilter.map((c, i) => (
                                                <li key={i} className="text-gray-700 bg-gray-50 p-2 rounded border border-gray-100 flex gap-2">
                                                    <span className="text-blue-500 font-bold">•</span>
                                                    <span>{explainCondition(c)}</span>
                                                </li>
                                            ))}
                                        </ul>
                                    )}
                                </div>
                            </div>

                            {/* Layer 3: Refiner */}
                            <div className="flex gap-4">
                                <div className="flex-shrink-0 w-8 h-8 rounded-full bg-purple-100 text-purple-600 flex items-center justify-center font-bold">3</div>
                                <div>
                                    <h4 className="font-semibold text-gray-900">Refinement Filter (Optional)</h4>
                                    {refiner.length === 0 ? (
                                        <p className="text-gray-400 italic mt-1">No refinement conditions set.</p>
                                    ) : (
                                        <ul className="mt-2 space-y-2">
                                            {refiner.map((c, i) => (
                                                <li key={i} className="text-gray-700 bg-purple-50 p-2 rounded border border-purple-100 flex gap-2">
                                                    <span className="text-purple-500 font-bold">•</span>
                                                    <span>{explainCondition(c)}</span>
                                                </li>
                                            ))}
                                        </ul>
                                    )}
                                </div>
                            </div>
                        </div>

                        <div className="p-6 bg-gray-50 border-t border-gray-100 text-center">
                            <button
                                onClick={() => setShowExplanation(false)}
                                className="bg-gray-800 text-white px-6 py-2 rounded-lg hover:bg-gray-900 font-medium"
                            >
                                Got it
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
