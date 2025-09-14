import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Progress } from "./ui/progress";
import { Alert, AlertDescription } from "./ui/alert";
import { Button } from "./ui/button";
import { BarChart, Bar, XAxis, YAxis, ResponsiveContainer, PieChart, Pie, Cell } from "recharts";
import { Shield, Clock, MapPin, AlertTriangle, Smartphone, Wifi, WifiOff } from "lucide-react";

const dailyUsageData = [
  { day: "Mon", hours: 4.2 },
  { day: "Tue", hours: 3.8 },
  { day: "Wed", hours: 5.1 },
  { day: "Thu", hours: 3.5 },
  { day: "Fri", hours: 6.2 },
  { day: "Sat", hours: 7.8 },
  { day: "Sun", hours: 6.5 }
];

const appUsageData = [
  { name: "Games", value: 45, color: "#FF6B6B" },
  { name: "Social", value: 25, color: "#4ECDC4" },
  { name: "Education", value: 20, color: "#45B7D1" },
  { name: "Other", value: 10, color: "#96CEB4" }
];

export function Dashboard() {
  return (
    <div className="flex flex-col gap-6 p-4 pb-24 bg-gradient-to-br from-slate-50 to-blue-50 min-h-screen">
      {/* Header */}
      <div className="pt-2">
        <div className="flex items-center justify-between mb-2">
          <div>
            <h1 className="text-3xl font-bold text-slate-900">Good morning, Sarah</h1>
            <p className="text-slate-600 text-lg">Here's what's happening with Emma's device</p>
          </div>
          <div className="flex items-center gap-2 bg-green-100 px-3 py-2 rounded-full">
            <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
            <span className="text-sm font-semibold text-green-700">Online</span>
          </div>
        </div>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-2 gap-4">
        <Card className="border-0 shadow-lg bg-gradient-to-br from-blue-500 to-blue-600 text-white">
          <CardHeader className="pb-3">
            <CardTitle className="text-sm text-blue-100 flex items-center gap-2">
              <Clock className="h-4 w-4" />
              Today's Screen Time
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-3xl font-bold mb-3">4h 23m</div>
            <div className="w-full bg-blue-400/30 rounded-full h-2 mb-2">
              <div className="bg-white h-2 rounded-full w-3/4"></div>
            </div>
            <p className="text-xs text-blue-100">75% of daily limit (6h)</p>
          </CardContent>
        </Card>

        <Card className="border-0 shadow-lg bg-gradient-to-br from-green-500 to-green-600 text-white">
          <CardHeader className="pb-3">
            <CardTitle className="text-sm text-green-100 flex items-center gap-2">
              <MapPin className="h-4 w-4" />
              Current Location
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-lg font-bold mb-1">Emma's School</div>
            <div className="flex items-center gap-1 mb-2">
              <Shield className="h-3 w-3" />
              <span className="text-xs font-semibold">Safe Zone</span>
            </div>
            <p className="text-xs text-green-100">Updated 2m ago</p>
          </CardContent>
        </Card>
      </div>

      {/* AI Alerts */}
      <Alert className="border-0 bg-gradient-to-r from-red-500 to-pink-500 text-white shadow-lg">
        <AlertTriangle className="h-5 w-5 text-white" />
        <AlertDescription className="text-white font-medium">
          <strong>2 new alerts:</strong> Potential cyberbullying detected in Instagram messages. 
          <Button variant="link" className="p-0 h-auto text-white underline ml-1 font-semibold">View details</Button>
        </AlertDescription>
      </Alert>

      {/* Weekly Usage Chart */}
      <Card className="border-0 shadow-lg">
        <CardHeader className="pb-4">
          <CardTitle className="text-xl font-bold text-slate-900">Weekly Screen Time</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="h-52">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={dailyUsageData}>
                <XAxis 
                  dataKey="day" 
                  axisLine={false} 
                  tickLine={false}
                  tick={{ fill: '#64748B', fontSize: 12, fontWeight: 500 }}
                />
                <YAxis hide />
                <Bar 
                  dataKey="hours" 
                  fill="url(#colorGradient)" 
                  radius={[8, 8, 0, 0]}
                />
                <defs>
                  <linearGradient id="colorGradient" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="#4F46E5" />
                    <stop offset="100%" stopColor="#7C3AED" />
                  </linearGradient>
                </defs>
              </BarChart>
            </ResponsiveContainer>
          </div>
        </CardContent>
      </Card>

      {/* App Usage Breakdown */}
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">App Categories Today</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-4">
            <div className="h-32 w-32">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={appUsageData}
                    cx="50%"
                    cy="50%"
                    innerRadius={25}
                    outerRadius={50}
                    dataKey="value"
                  >
                    {appUsageData.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                </PieChart>
              </ResponsiveContainer>
            </div>
            <div className="flex-1 space-y-2">
              {appUsageData.map((item) => (
                <div key={item.name} className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <div 
                      className="w-3 h-3 rounded-full" 
                      style={{ backgroundColor: item.color }}
                    />
                    <span className="text-sm">{item.name}</span>
                  </div>
                  <span className="text-sm text-muted-foreground">{item.value}%</span>
                </div>
              ))}
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Device Status */}
      <Card>
        <CardHeader>
          <CardTitle className="text-lg">Device Status</CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Smartphone className="h-4 w-4 text-blue-600" />
              <span className="text-sm">Emma's iPhone</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 bg-green-500 rounded-full"></div>
              <span className="text-sm text-green-600">Active</span>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <p className="text-muted-foreground">Battery</p>
              <p className="font-medium">78%</p>
            </div>
            <div>
              <p className="text-muted-foreground">Data Usage</p>
              <p className="font-medium">2.3 GB</p>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Quick Actions */}
      <Card className="border-0 shadow-lg">
        <CardHeader className="pb-4">
          <CardTitle className="text-xl font-bold text-slate-900">Quick Actions</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 gap-4">
            <Button className="h-14 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white shadow-lg font-semibold justify-start gap-3 rounded-xl">
              <Shield className="h-5 w-5" />
              Lock Device
            </Button>
            <Button className="h-14 bg-gradient-to-r from-orange-500 to-orange-600 hover:from-orange-600 hover:to-orange-700 text-white shadow-lg font-semibold justify-start gap-3 rounded-xl">
              <WifiOff className="h-5 w-5" />
              Pause Internet
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}