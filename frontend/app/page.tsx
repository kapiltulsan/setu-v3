import AssetAllocationChart from "@/components/dashboard/AssetAllocationChart";
import HeroCard from "@/components/dashboard/HeroCard";
import LiveMetricsCard from "@/components/dashboard/LiveMetricsCard";
import ScannerTileCard from "@/components/dashboard/ScannerTileCard";
import TechStackCard from "@/components/dashboard/TechStackCard";
import BacktestTileCard from "@/components/dashboard/BacktestTileCard";


export default function Home() {
  return (
    <main className="min-h-screen bg-zinc-50 dark:bg-black p-4 md:p-8 font-[family-name:var(--font-geist-sans)]">
      <div className="max-w-7xl mx-auto">

        {/* Header / Nav could go here */}

        <div className="grid grid-cols-12 gap-4 md:gap-6">

          {/* Row 1 */}
          <HeroCard />
          <LiveMetricsCard />
          <TechStackCard />

          {/* Row 2 */}
          <AssetAllocationChart />
          <ScannerTileCard />
          <BacktestTileCard />

          {/* Placeholder for future cards (Logs, Heatmap etc) */}



        </div>

      </div>
    </main>
  );
}
