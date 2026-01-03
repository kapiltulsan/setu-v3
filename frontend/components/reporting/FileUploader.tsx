"use client";

import { useState } from "react";
import { Upload, CheckCircle, AlertTriangle } from "lucide-react";

export default function FileUploader({ accountId, onUploadSuccess }: { accountId: string | null, onUploadSuccess: () => void }) {
    const [file, setFile] = useState<File | null>(null);
    const [broker, setBroker] = useState("ZERODHA");
    const [uploading, setUploading] = useState(false);
    const [msg, setMsg] = useState<{ type: 'success' | 'error', text: string } | null>(null);

    const handleUpload = async () => {
        if (!file || !accountId) return;

        setUploading(true);
        setMsg(null);

        const formData = new FormData();
        formData.append("file", file);
        formData.append("account_id", accountId);
        formData.append("source", broker);

        try {
            const res = await fetch("/api/upload/zerodha", {
                method: "POST",
                body: formData,
            });

            const json = await res.json();

            if (res.ok) {
                setMsg({ type: 'success', text: json.message || "Upload successful!" });
                setFile(null);
                onUploadSuccess();
            } else {
                setMsg({ type: 'error', text: json.error || "Upload failed." });
            }
        } catch (e) {
            setMsg({ type: 'error', text: "Network error occurred." });
        } finally {
            setUploading(false);
        }
    };

    if (!accountId) return null;

    return (
        <div className="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl p-6 shadow-sm mb-6">
            <h3 className="text-zinc-900 dark:text-white font-medium mb-4 flex items-center gap-2">
                <Upload size={18} /> Import Trades
            </h3>

            <div className="flex flex-col md:flex-row gap-4 items-end">
                <div className="w-full md:w-1/4">
                    <label className="block text-xs text-zinc-500 mb-1 font-medium">BROKER</label>
                    <select
                        value={broker}
                        onChange={(e) => setBroker(e.target.value)}
                        className="block w-full text-sm bg-zinc-50 dark:bg-zinc-800 border-zinc-200 dark:border-zinc-700 rounded-lg p-2.5 outline-none focus:ring-2 focus:ring-indigo-500"
                    >
                        <option value="ZERODHA">Kite (Zerodha)</option>
                        <option value="DHAN">Dhan</option>
                        <option value="UPSTOX">Upstox</option>
                        <option value="ANGELONE">Angel One</option>
                    </select>
                </div>

                <div className="w-full md:w-auto flex-1">
                    <label className="block text-xs text-zinc-500 mb-1 font-medium">TRADEBOOK CSV</label>
                    <input
                        type="file"
                        accept=".csv"
                        onChange={(e) => setFile(e.target.files?.[0] || null)}
                        className="block w-full text-sm text-zinc-500
              file:mr-4 file:py-2 file:px-4
              file:rounded-full file:border-0
              file:text-sm file:font-semibold
              file:bg-indigo-50 file:text-indigo-700
              hover:file:bg-indigo-100"
                    />
                </div>

                <button
                    onClick={handleUpload}
                    disabled={!file || uploading}
                    className="px-6 py-2 bg-indigo-600 text-white rounded-lg text-sm font-medium hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed whitespace-nowrap h-[42px]"
                >
                    {uploading ? "Uploading..." : "Upload CSV"}
                </button>
            </div>

            {msg && (
                <div className={`mt-4 p-3 rounded-lg text-sm flex items-center gap-2 ${msg.type === 'success' ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-900/20 dark:text-emerald-400' : 'bg-red-50 text-red-700 dark:bg-red-900/20 dark:text-red-400'
                    }`}>
                    {msg.type === 'success' ? <CheckCircle size={16} /> : <AlertTriangle size={16} />}
                    {msg.text}
                </div>
            )}
        </div>
    );
}
