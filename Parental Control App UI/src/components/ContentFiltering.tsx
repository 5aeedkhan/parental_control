import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Switch } from "./ui/switch";
import { Badge } from "./ui/badge";
import { Input } from "./ui/input";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { Alert, AlertDescription } from "./ui/alert";
import { Shield, Globe, Plus, X, Clock, AlertTriangle, Eye, Search } from "lucide-react";
import { useState } from "react";

const contentCategories = [
  { id: "adult", name: "Adult Content", description: "Explicit content, pornography", enabled: true, level: "strict" },
  { id: "violence", name: "Violence", description: "Violent content, gore", enabled: true, level: "moderate" },
  { id: "gambling", name: "Gambling", description: "Gambling sites, betting", enabled: true, level: "strict" },
  { id: "drugs", name: "Drugs & Alcohol", description: "Substance abuse content", enabled: true, level: "moderate" },
  { id: "social", name: "Social Media", description: "Social networking sites", enabled: false, level: "lenient" },
  { id: "gaming", name: "Gaming", description: "Online games, gaming sites", enabled: false, level: "lenient" },
  { id: "shopping", name: "Shopping", description: "E-commerce, online stores", enabled: false, level: "lenient" },
  { id: "news", name: "News & Politics", description: "News sites, political content", enabled: false, level: "lenient" },
];

const webAccessLogs = [
  { time: "14:30", site: "YouTube", category: "Entertainment", action: "allowed", duration: "25m" },
  { time: "14:05", site: "Instagram", category: "Social Media", action: "blocked", reason: "Time limit exceeded" },
  { time: "13:45", site: "Khan Academy", category: "Education", action: "allowed", duration: "45m" },
  { time: "13:20", site: "TikTok", category: "Social Media", action: "allowed", duration: "15m" },
  { time: "12:55", site: "inappropriate-site.com", category: "Adult", action: "blocked", reason: "Content filter" },
  { time: "12:30", site: "Minecraft.net", category: "Gaming", action: "allowed", duration: "30m" },
];

const customBlocklists = [
  { id: 1, name: "Gaming Sites", sites: ["twitch.tv", "steam.com", "roblox.com"], enabled: true },
  { id: 2, name: "Inappropriate Content", sites: ["example-bad-site.com", "another-blocked.net"], enabled: true },
  { id: 3, name: "Distraction Sites", sites: ["reddit.com", "9gag.com"], enabled: false },
];

export function ContentFiltering() {
  const [newBlocklistName, setNewBlocklistName] = useState("");
  const [newSite, setNewSite] = useState("");
  const [activeBlocklist, setActiveBlocklist] = useState<number | null>(null);

  const addBlocklist = () => {
    if (newBlocklistName.trim()) {
      // Add new blocklist logic here
      setNewBlocklistName("");
    }
  };

  const addSiteToBlocklist = (blocklistId: number) => {
    if (newSite.trim()) {
      // Add site to blocklist logic here
      setNewSite("");
      setActiveBlocklist(null);
    }
  };

  return (
    <div className="flex flex-col gap-4 p-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Content Filtering</h1>
        <Button size="sm" variant="outline">
          <Shield className="h-4 w-4 mr-2" />
          Safe Mode
        </Button>
      </div>

      {/* Quick Status */}
      <Alert className="border-green-200 bg-green-50">
        <Shield className="h-4 w-4 text-green-600" />
        <AlertDescription className="text-green-800">
          <strong>Protection Active:</strong> 5 content categories blocked, safe browsing enabled
        </AlertDescription>
      </Alert>

      {/* Tabs */}
      <Tabs defaultValue="categories" className="w-full">
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="categories">Categories</TabsTrigger>
          <TabsTrigger value="logs">Web Access</TabsTrigger>
          <TabsTrigger value="blocklists">Blocklists</TabsTrigger>
        </TabsList>

        <TabsContent value="categories" className="space-y-3">
          {/* Safe Browsing */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Globe className="h-5 w-5" />
                Safe Browsing
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">DNS-based Protection</p>
                  <p className="text-sm text-muted-foreground">Block malicious sites and phishing</p>
                </div>
                <Switch defaultChecked />
              </div>
              
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">HTTPS Filtering</p>
                  <p className="text-sm text-muted-foreground">Inspect encrypted traffic</p>
                </div>
                <Switch defaultChecked />
              </div>
            </CardContent>
          </Card>

          {/* Content Categories */}
          <div className="space-y-3">
            {contentCategories.map((category) => (
              <Card key={category.id}>
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-1">
                        <h3 className="font-medium">{category.name}</h3>
                        <Badge variant={category.enabled ? "default" : "secondary"}>
                          {category.level}
                        </Badge>
                      </div>
                      <p className="text-sm text-muted-foreground">{category.description}</p>
                    </div>
                    
                    <div className="flex items-center gap-3">
                      <Switch checked={category.enabled} />
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </TabsContent>

        <TabsContent value="logs" className="space-y-3">
          {/* Filter Controls */}
          <Card>
            <CardContent className="p-4">
              <div className="flex items-center gap-2">
                <Search className="h-4 w-4 text-muted-foreground" />
                <Input 
                  placeholder="Search web access logs..." 
                  className="flex-1"
                />
                <Button size="sm" variant="outline">Today</Button>
              </div>
            </CardContent>
          </Card>

          {/* Access Logs */}
          {webAccessLogs.map((log, index) => (
            <Card key={index}>
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-muted rounded-lg flex items-center justify-center">
                      <Globe className="h-4 w-4" />
                    </div>
                    <div>
                      <h3 className="font-medium">{log.site}</h3>
                      <div className="flex items-center gap-2 text-sm text-muted-foreground">
                        <span>{log.time}</span>
                        <span>•</span>
                        <span>{log.category}</span>
                        {log.duration && (
                          <>
                            <span>•</span>
                            <span>{log.duration}</span>
                          </>
                        )}
                      </div>
                    </div>
                  </div>
                  
                  <div className="text-right">
                    <Badge variant={log.action === "allowed" ? "default" : "destructive"}>
                      {log.action}
                    </Badge>
                    {log.reason && (
                      <p className="text-xs text-muted-foreground mt-1">{log.reason}</p>
                    )}
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </TabsContent>

        <TabsContent value="blocklists" className="space-y-3">
          {/* Add New Blocklist */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Plus className="h-4 w-4" />
                Add Custom Blocklist
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex gap-2">
                <Input
                  placeholder="Blocklist name"
                  value={newBlocklistName}
                  onChange={(e) => setNewBlocklistName(e.target.value)}
                />
                <Button onClick={addBlocklist}>Add</Button>
              </div>
            </CardContent>
          </Card>

          {/* Existing Blocklists */}
          {customBlocklists.map((blocklist) => (
            <Card key={blocklist.id}>
              <CardContent className="p-4">
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <div>
                      <h3 className="font-medium">{blocklist.name}</h3>
                      <p className="text-sm text-muted-foreground">
                        {blocklist.sites.length} sites blocked
                      </p>
                    </div>
                    
                    <div className="flex items-center gap-2">
                      <Switch checked={blocklist.enabled} />
                      <Button 
                        size="sm" 
                        variant="outline"
                        onClick={() => setActiveBlocklist(
                          activeBlocklist === blocklist.id ? null : blocklist.id
                        )}
                      >
                        {activeBlocklist === blocklist.id ? "Close" : "Edit"}
                      </Button>
                    </div>
                  </div>

                  {activeBlocklist === blocklist.id && (
                    <div className="space-y-3 pt-3 border-t">
                      <div className="flex gap-2">
                        <Input
                          placeholder="Add website (e.g., example.com)"
                          value={newSite}
                          onChange={(e) => setNewSite(e.target.value)}
                        />
                        <Button 
                          size="sm" 
                          onClick={() => addSiteToBlocklist(blocklist.id)}
                        >
                          Add
                        </Button>
                      </div>
                      
                      <div className="space-y-2">
                        {blocklist.sites.map((site, index) => (
                          <div key={index} className="flex items-center justify-between p-2 bg-muted rounded">
                            <span className="text-sm">{site}</span>
                            <Button size="sm" variant="ghost">
                              <X className="h-3 w-3" />
                            </Button>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          ))}
        </TabsContent>
      </Tabs>

      {/* Filter Statistics */}
      <Card>
        <CardHeader>
          <CardTitle>Today's Protection Stats</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 gap-4 text-center">
            <div>
              <div className="text-2xl font-semibold text-red-600">15</div>
              <p className="text-sm text-muted-foreground">Sites Blocked</p>
            </div>
            <div>
              <div className="text-2xl font-semibold text-green-600">127</div>
              <p className="text-sm text-muted-foreground">Safe Sites Visited</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}