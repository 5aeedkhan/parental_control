import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Switch } from "./ui/switch";
import { Badge } from "./ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { Search, Clock, Shield, CheckCircle, XCircle, MoreVertical } from "lucide-react";
import { useState } from "react";

const installedApps = [
  { name: "Instagram", category: "Social", status: "blocked", timeLimit: "1h 30m", usage: "2h 15m", icon: "📷" },
  { name: "YouTube", category: "Entertainment", status: "limited", timeLimit: "2h", usage: "1h 45m", icon: "📺" },
  { name: "TikTok", category: "Social", status: "limited", timeLimit: "1h", usage: "45m", icon: "🎵" },
  { name: "Minecraft", category: "Games", status: "allowed", timeLimit: "1h", usage: "30m", icon: "🎮" },
  { name: "Khan Academy", category: "Education", status: "allowed", timeLimit: "Unlimited", usage: "25m", icon: "📚" },
  { name: "Duolingo", category: "Education", status: "allowed", timeLimit: "Unlimited", usage: "15m", icon: "🦉" },
  { name: "Snapchat", category: "Social", status: "blocked", timeLimit: "30m", usage: "0m", icon: "👻" },
  { name: "Discord", category: "Communication", status: "limited", timeLimit: "1h", usage: "20m", icon: "💬" },
];

const pendingRequests = [
  { name: "WhatsApp", category: "Communication", reason: "For group project communication", time: "2h ago", icon: "💬" },
  { name: "Spotify", category: "Music", reason: "For studying playlist", time: "4h ago", icon: "🎵" },
  { name: "Netflix", category: "Entertainment", reason: "Educational documentary", time: "1d ago", icon: "📺" },
];

export function AppControl() {
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("All");

  const filteredApps = installedApps.filter(app => {
    const matchesSearch = app.name.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = selectedCategory === "All" || app.category === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  const categories = ["All", ...new Set(installedApps.map(app => app.category))];

  return (
    <div className="flex flex-col gap-4 p-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">App Control</h1>
        <Button size="sm" variant="outline">Bulk Edit</Button>
      </div>

      {/* Search and Filter */}
      <div className="space-y-3">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search apps..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-10"
          />
        </div>
        
        <div className="flex gap-2 overflow-x-auto pb-2">
          {categories.map((category) => (
            <Button
              key={category}
              variant={selectedCategory === category ? "default" : "outline"}
              size="sm"
              onClick={() => setSelectedCategory(category)}
              className="whitespace-nowrap"
            >
              {category}
            </Button>
          ))}
        </div>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="installed" className="w-full">
        <TabsList className="grid w-full grid-cols-2">
          <TabsTrigger value="installed">Installed Apps</TabsTrigger>
          <TabsTrigger value="requests">
            Requests 
            {pendingRequests.length > 0 && (
              <Badge variant="destructive" className="ml-2 h-5 w-5 p-0 text-xs">
                {pendingRequests.length}
              </Badge>
            )}
          </TabsTrigger>
        </TabsList>

        <TabsContent value="installed" className="space-y-3">
          {filteredApps.map((app, index) => (
            <Card key={index}>
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-muted rounded-lg flex items-center justify-center text-lg">
                      {app.icon}
                    </div>
                    <div>
                      <h3 className="font-medium">{app.name}</h3>
                      <div className="flex items-center gap-2 text-sm text-muted-foreground">
                        <span>{app.category}</span>
                        <span>•</span>
                        <span>Today: {app.usage}</span>
                      </div>
                    </div>
                  </div>
                  
                  <div className="flex items-center gap-3">
                    <div className="text-right">
                      <Badge variant={
                        app.status === "allowed" ? "default" :
                        app.status === "limited" ? "secondary" : "destructive"
                      }>
                        {app.status === "allowed" ? "Allowed" :
                         app.status === "limited" ? "Limited" : "Blocked"}
                      </Badge>
                      <p className="text-xs text-muted-foreground mt-1">
                        Limit: {app.timeLimit}
                      </p>
                    </div>
                    <Switch 
                      checked={app.status !== "blocked"}
                      className="data-[state=checked]:bg-green-500"
                    />
                  </div>
                </div>

                {app.status === "limited" && (
                  <div className="mt-3 pt-3 border-t">
                    <div className="flex items-center justify-between text-sm">
                      <span>Time limit: {app.timeLimit}</span>
                      <Button size="sm" variant="ghost">
                        <Clock className="h-4 w-4 mr-1" />
                        Edit
                      </Button>
                    </div>
                    <div className="mt-2 w-full bg-muted rounded-full h-2">
                      <div 
                        className="bg-blue-500 h-2 rounded-full" 
                        style={{ width: `${Math.min((parseInt(app.usage) / parseInt(app.timeLimit)) * 100, 100)}%` }}
                      ></div>
                    </div>
                  </div>
                )}
              </CardContent>
            </Card>
          ))}
        </TabsContent>

        <TabsContent value="requests" className="space-y-3">
          {pendingRequests.length === 0 ? (
            <Card>
              <CardContent className="p-8 text-center">
                <div className="text-muted-foreground">
                  <CheckCircle className="h-12 w-12 mx-auto mb-4 text-green-500" />
                  <h3 className="font-medium mb-2">No pending requests</h3>
                  <p className="text-sm">All app requests have been reviewed</p>
                </div>
              </CardContent>
            </Card>
          ) : (
            pendingRequests.map((request, index) => (
              <Card key={index}>
                <CardContent className="p-4">
                  <div className="flex items-start justify-between">
                    <div className="flex items-start gap-3">
                      <div className="w-10 h-10 bg-muted rounded-lg flex items-center justify-center text-lg">
                        {request.icon}
                      </div>
                      <div>
                        <h3 className="font-medium">{request.name}</h3>
                        <p className="text-sm text-muted-foreground">{request.category}</p>
                        <p className="text-sm mt-1">{request.reason}</p>
                        <p className="text-xs text-muted-foreground mt-1">{request.time}</p>
                      </div>
                    </div>
                    
                    <div className="flex gap-2">
                      <Button size="sm" variant="outline">
                        <XCircle className="h-4 w-4 mr-1" />
                        Deny
                      </Button>
                      <Button size="sm">
                        <CheckCircle className="h-4 w-4 mr-1" />
                        Approve
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))
          )}
        </TabsContent>
      </Tabs>

      {/* Quick Actions */}
      <Card>
        <CardHeader>
          <CardTitle>Quick Actions</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 gap-3">
            <Button variant="outline" className="justify-start gap-2">
              <Shield className="h-4 w-4" />
              Block Category
            </Button>
            <Button variant="outline" className="justify-start gap-2">
              <Clock className="h-4 w-4" />
              Set Time Limits
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}