import { useState, useEffect } from "react";
import { SplashScreen } from "./components/SplashScreen";
import { Onboarding } from "./components/Onboarding";
import { Auth } from "./components/Auth";
import { Dashboard } from "./components/Dashboard";
import { ScreenTime } from "./components/ScreenTime";
import { AppControl } from "./components/AppControl";
import { Location } from "./components/Location";
import { AIAlerts } from "./components/AIAlerts";
import { ContentFiltering } from "./components/ContentFiltering";
import { ActivityMonitoring } from "./components/ActivityMonitoring";
import { MessagingMonitoring } from "./components/MessagingMonitoring";
import { RemoteControls } from "./components/RemoteControls";
import { Settings } from "./components/Settings";
import { Home, Clock, Shield, MapPin, AlertTriangle, Filter, Activity, MessageSquare, Smartphone, Settings as SettingsIcon } from "lucide-react";

type AppState = "splash" | "onboarding" | "auth" | "main";

const navigationItems = [
  { id: "dashboard", label: "Home", icon: Home, component: Dashboard },
  { id: "screentime", label: "Screen Time", icon: Clock, component: ScreenTime },
  { id: "apps", label: "Apps", icon: Shield, component: AppControl },
  { id: "location", label: "Location", icon: MapPin, component: Location },
  { id: "alerts", label: "Alerts", icon: AlertTriangle, component: AIAlerts },
];

const moreItems = [
  { id: "content", label: "Content Filter", icon: Filter, component: ContentFiltering },
  { id: "activity", label: "Activity", icon: Activity, component: ActivityMonitoring },
  { id: "messages", label: "Messages", icon: MessageSquare, component: MessagingMonitoring },
  { id: "remote", label: "Remote Control", icon: Smartphone, component: RemoteControls },
  { id: "settings", label: "Settings", icon: SettingsIcon, component: Settings },
];

export default function App() {
  const [appState, setAppState] = useState<AppState>("splash");
  const [activeTab, setActiveTab] = useState("dashboard");
  const [showMoreMenu, setShowMoreMenu] = useState(false);
  const [user, setUser] = useState<any>(null);

  // Check for existing session on app load
  useEffect(() => {
    const checkSession = () => {
      const savedUser = localStorage.getItem("familyguard_user");
      const hasCompletedOnboarding = localStorage.getItem("familyguard_onboarding");
      
      if (savedUser && hasCompletedOnboarding) {
        setUser(JSON.parse(savedUser));
        setAppState("main");
      }
    };

    // Simulate initial app load delay
    setTimeout(checkSession, 2000);
  }, []);

  const handleSplashComplete = () => {
    const hasCompletedOnboarding = localStorage.getItem("familyguard_onboarding");
    if (hasCompletedOnboarding) {
      setAppState("auth");
    } else {
      setAppState("onboarding");
    }
  };

  const handleOnboardingComplete = () => {
    localStorage.setItem("familyguard_onboarding", "true");
    setAppState("auth");
  };

  const handleLogin = (userData: any) => {
    setUser(userData);
    localStorage.setItem("familyguard_user", JSON.stringify(userData));
    setAppState("main");
  };

  const handleLogout = () => {
    setUser(null);
    localStorage.removeItem("familyguard_user");
    setAppState("auth");
  };

  // Render different app states
  if (appState === "splash") {
    return <SplashScreen onComplete={handleSplashComplete} />;
  }

  if (appState === "onboarding") {
    return <Onboarding onComplete={handleOnboardingComplete} />;
  }

  if (appState === "auth") {
    return <Auth onLogin={handleLogin} />;
  }

  // Main app interface
  const allItems = [...navigationItems, ...moreItems];
  const ActiveComponent = allItems.find(item => item.id === activeTab)?.component || Dashboard;

  return (
    <div className="min-h-screen min-h-dvh bg-background relative overflow-hidden">
      {/* Status Bar Spacer */}
      <div className="h-0 lg:h-6"></div>
      
      {/* Main Content */}
      <main className="relative h-full">
        <ActiveComponent />
      </main>

      {/* Bottom Navigation */}
      <nav className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-xl border-t border-border/50 safe-area-pb">
        <div className="flex items-center justify-around px-1 py-2 pb-[max(8px,env(safe-area-inset-bottom))]">
          {navigationItems.map((item) => {
            const IconComponent = item.icon;
            const isActive = activeTab === item.id;
            
            return (
              <button
                key={item.id}
                onClick={() => {
                  setActiveTab(item.id);
                  setShowMoreMenu(false);
                }}
                className={`flex flex-col items-center gap-1 px-3 py-2 rounded-xl transition-all duration-200 relative no-select ${
                  isActive 
                    ? "text-white bg-primary shadow-lg transform scale-105" 
                    : "text-slate-600 hover:text-slate-900 hover:bg-slate-100 active:scale-95"
                }`}
              >
                <IconComponent className={`h-5 w-5 ${isActive ? "drop-shadow-sm" : ""}`} />
                <span className={`text-xs font-medium ${isActive ? "font-semibold" : ""}`}>
                  {item.label}
                </span>
                {item.id === "alerts" && (
                  <div className="absolute -top-1 -right-1 w-3 h-3 bg-red-500 border-2 border-white rounded-full animate-pulse"></div>
                )}
              </button>
            );
          })}
          
          {/* More Button */}
          <button
            onClick={() => setShowMoreMenu(!showMoreMenu)}
            className={`flex flex-col items-center gap-1 px-3 py-2 rounded-xl transition-all duration-200 no-select ${
              showMoreMenu || moreItems.some(item => item.id === activeTab)
                ? "text-white bg-primary shadow-lg transform scale-105" 
                : "text-slate-600 hover:text-slate-900 hover:bg-slate-100 active:scale-95"
            }`}
          >
            <SettingsIcon className="h-5 w-5" />
            <span className={`text-xs font-medium ${showMoreMenu || moreItems.some(item => item.id === activeTab) ? "font-semibold" : ""}`}>
              More
            </span>
          </button>
        </div>

        {/* More Menu */}
        {showMoreMenu && (
          <div className="absolute bottom-full left-0 right-0 bg-white/95 backdrop-blur-xl border-t border-border/50 p-4 rounded-t-3xl shadow-2xl">
            <div className="w-12 h-1 bg-slate-300 rounded-full mx-auto mb-4"></div>
            <div className="grid grid-cols-3 gap-3">
              {moreItems.map((item) => {
                const IconComponent = item.icon;
                const isActive = activeTab === item.id;
                
                return (
                  <button
                    key={item.id}
                    onClick={() => {
                      setActiveTab(item.id);
                      setShowMoreMenu(false);
                    }}
                    className={`flex flex-col items-center gap-3 p-4 rounded-2xl transition-all duration-200 no-select ${
                      isActive 
                        ? "text-white bg-primary shadow-lg" 
                        : "text-slate-600 hover:text-slate-900 hover:bg-slate-100 active:scale-95"
                    }`}
                  >
                    <div className={`w-12 h-12 rounded-xl flex items-center justify-center ${
                      isActive ? "bg-white/20" : "bg-slate-100"
                    }`}>
                      <IconComponent className={`h-6 w-6 ${isActive ? "text-white" : "text-slate-600"}`} />
                    </div>
                    <span className={`text-sm font-medium text-center leading-tight ${isActive ? "text-white font-semibold" : "text-slate-700"}`}>
                      {item.label}
                    </span>
                  </button>
                );
              })}
            </div>
          </div>
        )}
      </nav>
    </div>
  );
}