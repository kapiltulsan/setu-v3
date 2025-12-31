"use client";

import { useState } from "react";

// --- TYPES ---
export interface LogicCondition {
    id: string; // FE only
    // Left Side
    indicator: string;
    timeframe: string;
    length?: number;
    offset?: number;

    // Operator
    operator: string;

    // Right Side (Value OR Indicator)
    value?: number;
    right_indicator?: string;
    right_timeframe?: string;
    right_length?: number;
    right_offset?: number;
}

interface ScannerBuilderProps {
    value: LogicCondition[];
    onChange: (conditions: LogicCondition[]) => void;
}

// --- CONSTANTS ---
const TIMEFRAMES = [
    { value: "60m", label: "60 Min" },
    { value: "1d", label: "Day" },
    { value: "1w", label: "Week" },
    { value: "2w", label: "Fortnight" }, // Custom
    { value: "1mo", label: "Month" },
    { value: "3mo", label: "Quarter" },
    { value: "1y", label: "Year" }
];

const INDICATORS = [
    { value: "close", label: "Close" },
    { value: "open", label: "Open" },
    { value: "high", label: "High" },
    { value: "low", label: "Low" },
    { value: "volume", label: "Volume" },
    { value: "rsi", label: "RSI", hasLength: true, defaultLength: 14 },
    { value: "sma", label: "SMA", hasLength: true, defaultLength: 20 },
    { value: "ema", label: "EMA", hasLength: true, defaultLength: 20 },
    { value: "macd", label: "MACD Line", hasLength: false },
    { value: "macd_signal", label: "MACD Signal", hasLength: false },
    { value: "number", label: "Number" } // pseudo-indicator for right side
];

const OPERATORS = [
    { value: ">", label: "Greater than" },
    { value: "<", label: "Less than" },
    { value: "==", label: "Equals" },
    { value: ">=", label: "Greater than or equal to" },
    { value: "<=", label: "Less than or equal to" },
];

// ... existing imports ...

// --- HELPER: Explain Condition in English ---
export const explainCondition = (c: LogicCondition): string => {
    const timeframes: Record<string, string> = {
        "60m": "Hourly", "1d": "Daily", "1w": "Weekly",
        "2w": "Fortnightly", "1mo": "Monthly", "3mo": "Quarterly", "1y": "Yearly"
    };
    const tf = timeframes[c.timeframe] || c.timeframe;

    const indicators: Record<string, string> = {
        "close": "Closing Price", "open": "Opening Price",
        "high": "High Price", "low": "Low Price", "volume": "Volume",
        "rsi": "RSI", "sma": "Simple Moving Average", "ema": "Exponential Moving Average"
    };
    const ind = indicators[c.indicator] || c.indicator.toUpperCase();
    const indText = `${ind}${c.length ? ` (${c.length})` : ''}`;

    const ops: Record<string, string> = {
        ">": "higher than", "<": "lower than",
        "==": "exactly equal to", ">=": "at least", "<=": "at most"
    };
    const opText = ops[c.operator] || c.operator;

    let rightText = "";
    if (c.right_indicator === "number" || !c.right_indicator) {
        rightText = `${c.value}`;
    } else {
        const rTf = timeframes[c.right_timeframe || "1d"] || c.right_timeframe;
        const rInd = indicators[c.right_indicator] || c.right_indicator.toUpperCase();
        rightText = `the ${rTf || tf} ${rInd}${c.right_length ? ` (${c.right_length})` : ''}`;

        if (c.right_offset && c.right_offset > 0) {
            rightText += ` from ${c.right_offset} candles ago`;
        }
    }

    let prefix = `The ${tf} ${indText}`;
    if (c.offset && c.offset > 0) {
        prefix += ` (from ${c.offset} candles ago)`;
    }

    return `${prefix} is ${opText} ${rightText}.`;
};

export default function ScannerBuilder({ value, onChange }: ScannerBuilderProps) {
    // ... existing component ...

    const addCondition = () => {
        const newCondition: LogicCondition = {
            id: Date.now().toString(),
            indicator: "close",
            timeframe: "1d",
            offset: 0,
            operator: ">",
            right_indicator: "number", // Default to value comparison
            right_timeframe: "1d",
            value: 100
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
                {value.length === 0 && (
                    <div className="text-center py-6 text-gray-400">
                        <p className="text-sm italic">No conditions defined.</p>
                        <button type="button" onClick={addCondition} className="mt-2 text-blue-600 hover:underline text-sm bold">+ Add Filter</button>
                    </div>
                )}

                <div className="space-y-3">
                    {value.map((condition, idx) => (
                        <div key={condition.id} className="flex flex-wrap gap-2 items-center bg-white p-3 rounded border border-gray-200 shadow-sm text-sm">
                            {/* Connector (AND) */}
                            {idx > 0 && <span className="font-bold text-gray-400 mr-2">AND</span>}
                            {idx === 0 && <span className="font-bold text-gray-400 mr-2">Passes if</span>}

                            {/* --- LEFT SIDE --- */}
                            <IndicatorPill
                                indicator={condition.indicator}
                                timeframe={condition.timeframe || "1d"}
                                length={condition.length}
                                offset={condition.offset}
                                onChange={(updates: any) => updateCondition(condition.id, updates)}
                            />

                            {/* --- OPERATOR --- */}
                            <select
                                value={condition.operator}
                                onChange={(e) => updateCondition(condition.id, { operator: e.target.value })}
                                className="bg-gray-100 border-none rounded py-1 px-2 text-gray-700 font-semibold cursor-pointer focus:ring-2 focus:ring-blue-300"
                            >
                                {OPERATORS.map(op => <option key={op.value} value={op.value}>{op.label}</option>)}
                            </select>

                            {/* --- RIGHT SIDE --- */}
                            {/* Toggle between Value and Indicator */}
                            {condition.right_indicator === "number" ? (
                                <div className="flex items-center gap-1 bg-green-50 text-green-700 font-medium px-2 py-1 rounded border border-green-200">
                                    <span className="text-xs text-green-500 uppercase tracking-tighter cursor-pointer hover:bg-green-100 px-1 rounded"
                                        onClick={() => updateCondition(condition.id, { right_indicator: "sma", right_timeframe: "1d", right_length: 20, value: undefined })}
                                    >
                                        Num
                                    </span>
                                    <input
                                        type="number"
                                        value={condition.value ?? 0}
                                        onChange={(e) => updateCondition(condition.id, { value: parseFloat(e.target.value) })}
                                        className="w-20 bg-transparent border-b border-green-300 focus:outline-none focus:border-green-600 text-center"
                                    />
                                </div>
                            ) : (
                                <IndicatorPill
                                    indicator={condition.right_indicator || "sma"}
                                    timeframe={condition.right_timeframe || "1d"}
                                    length={condition.right_length}
                                    offset={condition.right_offset}
                                    onChange={(updates: any) => {
                                        // Map generic updates to "right_" keys
                                        const rightUpdates: any = {};
                                        if (updates.indicator) rightUpdates.right_indicator = updates.indicator;
                                        if (updates.timeframe) rightUpdates.right_timeframe = updates.timeframe;
                                        if (updates.length !== undefined) rightUpdates.right_length = updates.length;
                                        if (updates.offset !== undefined) rightUpdates.right_offset = updates.offset;

                                        // Handle switching back to number
                                        if (updates.indicator === 'number') {
                                            updateCondition(condition.id, { right_indicator: 'number', value: 0 });
                                        } else {
                                            updateCondition(condition.id, rightUpdates);
                                        }
                                    }}
                                    isRightSide={true}
                                />
                            )}

                            {/* Remove */}
                            <button type="button" onClick={() => removeCondition(condition.id)} className="ml-auto text-gray-400 hover:text-red-500">
                                <span className="sr-only">Remove</span>
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
                                    <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z" />
                                </svg>
                            </button>
                        </div>
                    ))}

                    {value.length > 0 && (
                        <button
                            type="button"
                            onClick={addCondition}
                            className="bg-blue-600 hover:bg-blue-700 text-white text-sm px-4 py-2 rounded shadow-sm flex items-center gap-2"
                        >
                            <span>+ Add</span>
                        </button>
                    )}
                </div>
            </div>
        </div>
    );
}

// --- SUB-COMPONENT: PILL ---
const IndicatorPill = ({ indicator, timeframe, length, offset, onChange, isRightSide = false }: any) => {
    // Helper to find spec
    const spec = INDICATORS.find(i => i.value === indicator) || INDICATORS[0];
    const hasLength = spec.hasLength;

    const getOffsetLabel = (tf: string) => {
        if (!tf) return "Candles";
        if (tf === "60m") return "Hours";
        if (tf === "1w") return "Weeks";
        if (tf === "1mo") return "Months";
        if (tf === "1y") return "Years";
        return "Days";
    }

    const unitLabel = getOffsetLabel(timeframe);

    return (
        <div className={`flex items-center gap-1 px-2 py-1 rounded border ${isRightSide ? "bg-purple-50 text-purple-700 border-purple-200" : "bg-blue-50 text-blue-700 border-blue-200"}`}>
            {/* Timeframe Selector (Start of Pill) */}
            <select
                value={timeframe || "1d"}
                onChange={(e) => onChange({ timeframe: e.target.value })}
                className="bg-transparent font-bold text-xs uppercase tracking-wide cursor-pointer focus:outline-none appearance-none border-r border-current pr-1 mr-1"
                title="Select Period"
            >
                {TIMEFRAMES.map(tf => <option key={tf.value} value={tf.value}>{tf.label}</option>)}
            </select>

            {/* Indicator Name */}
            <select
                value={indicator}
                onChange={(e) => {
                    const newVal = e.target.value;
                    const newSpec = INDICATORS.find(i => i.value === newVal);
                    onChange({
                        indicator: newVal,
                        length: newSpec?.defaultLength // Reset length if changing type
                    });
                }}
                className="bg-transparent font-medium cursor-pointer focus:outline-none appearance-none"
            >
                {INDICATORS.map(i => <option key={i.value} value={i.value}>{i.label}</option>)}
            </select>

            {/* Params (Length) */}
            {hasLength && (
                <span className="flex items-center text-xs">
                    (
                    <input
                        type="number"
                        className="w-8 bg-transparent text-center border-b border-current focus:outline-none"
                        value={length || 14}
                        onChange={(e) => onChange({ length: parseInt(e.target.value) })}
                    />
                    )
                </span>
            )}

            {/* Offset (Lookback) */}
            <div className="relative group ml-1">
                <span className="text-xs opacity-70 cursor-pointer hover:opacity-100 border-b border-dotted border-current">
                    {offset > 0 ? `${offset} ${unitLabel} ago` : "Latest"}
                </span>
                {/* Hover input */}
                <div className="hidden group-hover:block absolute top-full left-0 z-50 bg-white shadow-lg p-2 rounded border w-36">
                    <label className="text-xs text-gray-500 block mb-1">{unitLabel} Ago:</label>
                    <input
                        type="number"
                        min="0"
                        value={offset || 0}
                        onChange={(e) => onChange({ offset: parseInt(e.target.value) })}
                        className="w-full border rounded px-1 text-sm text-gray-900 focus:ring-1 focus:ring-blue-500"
                    />
                </div>
            </div>
        </div>
    )
}
