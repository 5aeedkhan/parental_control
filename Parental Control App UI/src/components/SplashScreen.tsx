import { useEffect, useState } from "react";
import { Shield, Heart } from "lucide-react";

interface SplashScreenProps {
  onComplete: () => void;
}

export function SplashScreen({ onComplete }: SplashScreenProps) {
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setProgress(prev => {
        if (prev >= 100) {
          clearInterval(timer);
          setTimeout(onComplete, 500);
          return 100;
        }
        return prev + 2;
      });
    }, 50);

    return () => clearInterval(timer);
  }, [onComplete]);

  return (
    <div className="min-h-screen min-h-dvh bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 flex flex-col items-center justify-center p-8 relative overflow-hidden">
      {/* Background Pattern */}
      <div className="absolute inset-0 opacity-10">
        <div className="absolute top-1/4 left-1/4 w-32 h-32 bg-white rounded-full blur-3xl"></div>
        <div className="absolute bottom-1/4 right-1/4 w-24 h-24 bg-white rounded-full blur-2xl"></div>
        <div className="absolute top-1/2 right-1/3 w-16 h-16 bg-white rounded-full blur-xl"></div>
      </div>

      <div className="text-center space-y-12 relative z-10">
        {/* Logo */}
        <div className="relative animate-pulse">
          <div className="w-32 h-32 bg-white/20 backdrop-blur-xl rounded-[2rem] flex items-center justify-center shadow-2xl border border-white/30">
            <Shield className="h-16 w-16 text-white drop-shadow-lg" />
          </div>
          <div className="absolute -top-3 -right-3 w-12 h-12 bg-gradient-to-br from-pink-400 to-red-500 rounded-full flex items-center justify-center shadow-lg border-4 border-white/50">
            <Heart className="h-6 w-6 text-white" />
          </div>
        </div>

        {/* App Name */}
        <div className="space-y-4">
          <h1 className="text-5xl font-bold text-white drop-shadow-lg">FamilyGuard</h1>
          <p className="text-xl text-white/90 font-medium">Protecting what matters most</p>
        </div>

        {/* Loading Progress */}
        <div className="w-80 space-y-4">
          <div className="w-full bg-white/20 rounded-full h-3 backdrop-blur-sm">
            <div 
              className="bg-gradient-to-r from-white to-white/80 h-3 rounded-full transition-all duration-300 ease-out shadow-lg"
              style={{ width: `${progress}%` }}
            />
          </div>
          <p className="text-lg text-white/80 font-medium">Setting up secure environment...</p>
        </div>

        {/* Version */}
        <p className="text-sm text-white/60 font-medium">Version 2.1.0</p>
      </div>
    </div>
  );
}