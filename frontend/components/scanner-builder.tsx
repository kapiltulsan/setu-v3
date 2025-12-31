
"use client";

import { useState } from "react";

// Types matching the JSON structure stored in DB
export interface LogicCondition {
    id: string;
    field: string;
    operator: string;
    value: string;
}

interface ScannerBuilderProps {
    value: LogicCondition[];
    onChange: (conditions: LogicCondition[]) => void;
}

const OPERATORS = [
    { value: ">", label: "Greater Than (>)" },
    { value: "<", label: "Less Than (<)" },
    { value: "=", label: "Equals (=)" },
    { value: "crosses_above", label: "Crosses Above" },
    { value: "crosses_below", label: "Crosses Below" },
];

const FIELDS = [
    { value: "Close", label: "Close Price" },
    { value: "Open", label: "Open Price" },
    { value: "High", label: "High Price" },
    { value: "Low", label: "Low Price" },
    { value: "Volume", label: "Volume" },
    { value: "RSI_14", label: "RSI (14)" },
    { value: "SMA_20", label: "SMA (20)" },
    { value: "SMA_50", label: "SMA (50)" },
    { value: "SMA_200", label: "SMA (200)" },
];

export default function ScannerBuilder({ value, onChange }: ScannerBuilderProps) {

    const addCondition = () => {
        const newCondition: LogicCondition = {
            id: Date.now().toString(),
            field: "Close",
            operator: ">",
            value: "0"
        };
        onChange([...value, newCondition]);
    };

    const updateCondition = (id: string, updates: Partial<LogicCondition>) => {
        onChange(value.map(c => c.id === id ? { ...c, ...updates } : c));
    };

    const removeCondition = (id: string) => {
        onChange(value.filter(c => c.id !== id));
    };

    return (
        <div className="space-y-4">
            <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
                <h3 className="text-sm font-semibold text-gray-700 mb-3 uppercase tracking-wider">Logic Definition</h3>

                {value.length === 0 && (
                    <p className="text-gray-500 text-sm mb-4 italic">No conditions added. The scanner will match everything.</p>
                )}

                <div className="space-y-3">
                    {value.map((condition) => (
                        <div key={condition.id} className="flex gap-3 items-center bg-white p-3 rounded border border-gray-200 shadow-sm">
                            <select
                                value={condition.field}
                                onChange={(e) => updateCondition(condition.id, { field: e.target.value })}
                                className="block w-1/3 rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2 border"
                            >
                                {FIELDS.map(f => <option key={f.value} value={f.value}>{f.label}</option>)}
                            </select>

                            <select
                                value={condition.operator}
                                onChange={(e) => updateCondition(condition.id, { operator: e.target.value })}
                                className="block w-1/4 rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2 border"
                            >
                                {OPERATORS.map(op => <option key={op.value} value={op.value}>{op.label}</option>)}
                            </select>

                            <input
                                type="text"
                                value={condition.value}
                                onChange={(e) => updateCondition(condition.id, { value: e.target.value })}
                                className="block w-1/3 rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm p-2 border"
                                placeholder="Value (e.g. 100 or SMA_50)"
                            />

                            <button
                                onClick={() => removeCondition(condition.id)}
                                className="text-red-500 hover:text-red-700 p-1"
                                title="Remove Condition"
                            >
                                &times;
                            </button>
                        </div>
                    ))}
                </div>

                <button
                    onClick={addCondition}
                    className="mt-4 text-sm text-blue-600 font-medium hover:text-blue-800 flex items-center gap-1"
                >
                    <span>+ Add Condition</span>
                </button>
            </div>
        </div>
    );
}
