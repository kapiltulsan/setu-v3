"use client";

import React, { useEffect, useRef } from 'react';
import {
    createChart,
    ColorType,
    IChartApi,
    CandlestickData,
    LineData,
    HistogramData,
    SeriesMarker,
    Time,
    CandlestickSeries,
    LineSeries,
    HistogramSeries,
    LineStyle,
    createSeriesMarkers,
    ISeriesMarkersPluginApi
} from 'lightweight-charts';

interface FinancialChartProps {
    data: CandlestickData<Time>[];
    upperBB?: LineData<Time>[];
    lowerBB?: LineData<Time>[];
    trailingStop?: LineData<Time>[];
    ema200?: LineData<Time>[];
    volume?: HistogramData<Time>[];
    markers?: SeriesMarker<Time>[];
    onCrosshairMove?: (params: any) => void;
}

export const FinancialChart: React.FC<FinancialChartProps> = ({
    data,
    upperBB,
    lowerBB,
    trailingStop,
    ema200,
    volume,
    markers,
    onCrosshairMove
}) => {
    const chartContainerRef = useRef<HTMLDivElement>(null);
    const chartRef = useRef<IChartApi | null>(null);
    const candlestickSeriesRef = useRef<any>(null);
    const upperBBSeriesRef = useRef<any>(null);
    const lowerBBSeriesRef = useRef<any>(null);
    const stopSeriesRef = useRef<any>(null);
    const ema200SeriesRef = useRef<any>(null);
    const volumeSeriesRef = useRef<any>(null);
    const initialZoomApplied = useRef(false);

    // 1. Initialization: Create chart and series once
    useEffect(() => {
        if (!chartContainerRef.current) return;

        const chart = createChart(chartContainerRef.current, {
            layout: {
                background: { type: ColorType.Solid, color: 'transparent' },
                textColor: '#94a3b8',
            },
            grid: {
                vertLines: { color: '#1e293b' },
                horzLines: { color: '#1e293b' },
            },
            crosshair: {
                mode: 1, // CrosshairMode.Normal
                vertLine: { labelBackgroundColor: '#334155' },
                horzLine: { labelBackgroundColor: '#334155' },
            },
            timeScale: {
                borderColor: '#1e293b',
                timeVisible: true,
                secondsVisible: false,
            },
            rightPriceScale: {
                borderColor: '#1e293b',
            },
            handleScroll: {
                mouseWheel: true,
                horzTouchDrag: true,
                vertTouchDrag: true,
            },
            handleScale: {
                axisPressedMouseMove: true,
                mouseWheel: true,
                pinch: true,
            }
        });

        const candlestickSeries = chart.addSeries(CandlestickSeries, {
            upColor: '#22c55e',
            downColor: '#ef4444',
            borderVisible: false,
            wickUpColor: '#22c55e',
            wickDownColor: '#ef4444',
        });

        chartRef.current = chart;
        candlestickSeriesRef.current = candlestickSeries;

        const handleResize = () => {
            if (chartContainerRef.current && chartRef.current) {
                chartRef.current.applyOptions({
                    width: chartContainerRef.current.clientWidth,
                    height: chartContainerRef.current.clientHeight,
                });
            }
        };
        window.addEventListener('resize', handleResize);

        return () => {
            window.removeEventListener('resize', handleResize);
            chart.remove();
            chartRef.current = null;
        };
    }, []);

    // 2. Data Updates: Update series when props change
    useEffect(() => {
        if (!chartRef.current || !candlestickSeriesRef.current || !data || data.length === 0) return;

        try {
            const chart = chartRef.current;
            candlestickSeriesRef.current.setData(data);

            // Bollinger Bands
            if (upperBB && upperBB.length > 0) {
                if (!upperBBSeriesRef.current) {
                    upperBBSeriesRef.current = chart.addSeries(LineSeries, {
                        color: '#3b82f6',
                        lineWidth: 1,
                        lineStyle: LineStyle.Dashed,
                        lastValueVisible: false,
                        priceLineVisible: false,
                    });
                }
                upperBBSeriesRef.current.setData(upperBB);
            } else if (upperBBSeriesRef.current) {
                chart.removeSeries(upperBBSeriesRef.current);
                upperBBSeriesRef.current = null;
            }

            if (lowerBB && lowerBB.length > 0) {
                if (!lowerBBSeriesRef.current) {
                    lowerBBSeriesRef.current = chart.addSeries(LineSeries, {
                        color: '#3b82f6',
                        lineWidth: 1,
                        lineStyle: LineStyle.Dashed,
                        lastValueVisible: false,
                        priceLineVisible: false,
                    });
                }
                lowerBBSeriesRef.current.setData(lowerBB);
            } else if (lowerBBSeriesRef.current) {
                chart.removeSeries(lowerBBSeriesRef.current);
                lowerBBSeriesRef.current = null;
            }

            // Trailing Stop
            if (trailingStop && trailingStop.length > 0) {
                if (!stopSeriesRef.current) {
                    stopSeriesRef.current = chart.addSeries(LineSeries, {
                        color: '#f59e0b',
                        lineWidth: 2,
                        lastValueVisible: true,
                        priceLineVisible: true,
                    });
                }
                stopSeriesRef.current.setData(trailingStop);
            } else if (stopSeriesRef.current) {
                chart.removeSeries(stopSeriesRef.current);
                stopSeriesRef.current = null;
            }

            // EMA 200
            if (ema200 && ema200.length > 0) {
                if (!ema200SeriesRef.current) {
                    ema200SeriesRef.current = chart.addSeries(LineSeries, {
                        color: '#facc15', // Yellow for EMA 200
                        lineWidth: 2,
                        lastValueVisible: false,
                        priceLineVisible: false,
                    });
                }
                ema200SeriesRef.current.setData(ema200);
            } else if (ema200SeriesRef.current) {
                chart.removeSeries(ema200SeriesRef.current);
                ema200SeriesRef.current = null;
            }

            // Volume
            if (volume && volume.length > 0) {
                if (!volumeSeriesRef.current) {
                    volumeSeriesRef.current = chart.addSeries(HistogramSeries, {
                        color: '#1e293b',
                        priceFormat: { type: 'volume' },
                        priceScaleId: '', // overlay
                    });
                    volumeSeriesRef.current.priceScale().applyOptions({
                        scaleMargins: { top: 0.8, bottom: 0 },
                    });
                }
                volumeSeriesRef.current.setData(volume);
            } else if (volumeSeriesRef.current) {
                chart.removeSeries(volumeSeriesRef.current);
                volumeSeriesRef.current = null;
            }

            // Markers
            if (markers && markers.length > 0 && candlestickSeriesRef.current) {
                if (typeof (candlestickSeriesRef.current as any).setMarkers === 'function') {
                    (candlestickSeriesRef.current as any).setMarkers(markers);
                }
            } else if (candlestickSeriesRef.current && typeof (candlestickSeriesRef.current as any).setMarkers === 'function') {
                (candlestickSeriesRef.current as any).setMarkers([]);
            }

            // Initial Zoom: Only apply once when data first arrives
            if (!initialZoomApplied.current && data.length > 0) {
                const barsToShow = Math.min(data.length, 52);
                const fromIndex = Math.max(0, data.length - barsToShow);

                chart.timeScale().setVisibleRange({
                    from: data[fromIndex].time,
                    to: data[data.length - 1].time,
                });
                initialZoomApplied.current = true;
            }
        } catch (err) {
            console.error("Chart data update failed:", err);
        }
    }, [data, upperBB, lowerBB, trailingStop, ema200, volume, markers]);

    // 3. Interactivity: Subscription
    useEffect(() => {
        if (!chartRef.current || !onCrosshairMove) return;

        const chart = chartRef.current;
        const handler = (param: any) => {
            try {
                if (param.time && candlestickSeriesRef.current) {
                    const price = param.seriesData.get(candlestickSeriesRef.current) as CandlestickData<Time>;
                    onCrosshairMove({
                        time: param.time,
                        price: price,
                        isMatch: !!price
                    });
                } else {
                    onCrosshairMove({ time: null, price: null, isMatch: false });
                }
            } catch (err) {
                // Ignore crosshair errors to prevent crash
            }
        };

        chart.subscribeCrosshairMove(handler);
        return () => chart.unsubscribeCrosshairMove(handler);
    }, [onCrosshairMove]);

    return <div ref={chartContainerRef} className="w-full h-full" />;
};
