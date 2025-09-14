import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Switch } from "./ui/switch";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { MapPin, Plus, Clock, Home, School, Shield, AlertTriangle } from "lucide-react";

const currentLocation = {
  name: "Emma's School",
  address: "123 Education St, City Center",
  coordinates: { lat: 40.7128, lng: -74.0060 },
  lastUpdated: "2 minutes ago",
  zone: "safe"
};

const safeZones = [
  { name: "Home", address: "456 Family Ave", radius: "100m", status: "active", icon: Home },
  { name: "School", address: "123 Education St", radius: "200m", status: "active", icon: School },
  { name: "Grandma's House", address: "789 Elder Rd", radius: "150m", status: "active", icon: Home },
  { name: "Library", address: "321 Book St", radius: "50m", status: "inactive", icon: School },
];

const locationHistory = [
  { time: "14:30", location: "Emma's School", duration: "6h 15m", status: "safe" },
  { time: "08:15", location: "Home", duration: "12h 30m", status: "safe" },
  { time: "19:45", location: "Unknown Location", duration: "15m", status: "alert" },
  { time: "17:30", location: "Soccer Field", duration: "2h", status: "safe" },
  { time: "15:00", location: "Emma's School", duration: "7h", status: "safe" },
];

const alerts = [
  { time: "Yesterday 19:45", message: "Left safe zone without notification", severity: "medium" },
  { time: "2 days ago", message: "Device turned off during school hours", severity: "high" },
];

export function Location() {
  return (
    <div className="flex flex-col gap-4 p-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Location</h1>
        <Button size="sm">
          <Plus className="h-4 w-4 mr-2" />
          Add Zone
        </Button>
      </div>

      {/* Current Location */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <MapPin className="h-5 w-5 text-green-600" />
            Current Location
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            <div className="flex items-start justify-between">
              <div>
                <h3 className="font-medium">{currentLocation.name}</h3>
                <p className="text-sm text-muted-foreground">{currentLocation.address}</p>
                <p className="text-xs text-muted-foreground mt-1">
                  Last updated: {currentLocation.lastUpdated}
                </p>
              </div>
              <Badge variant="default" className="bg-green-100 text-green-800">
                Safe Zone
              </Badge>
            </div>
            
            {/* Mock Map */}
            <div className="w-full h-40 bg-gradient-to-br from-blue-100 to-green-100 rounded-lg flex items-center justify-center relative overflow-hidden">
              <div className="absolute inset-0 opacity-20">
                <div className="grid grid-cols-8 grid-rows-6 h-full w-full">
                  {Array.from({ length: 48 }).map((_, i) => (
                    <div key={i} className="border border-gray-300"></div>
                  ))}
                </div>
              </div>
              <div className="relative z-10 flex flex-col items-center">
                <div className="w-4 h-4 bg-green-500 rounded-full animate-pulse"></div>
                <p className="text-xs font-medium mt-1">Emma's Location</p>
              </div>
              <div className="absolute top-2 left-2 text-xs text-muted-foreground">
                Street View
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Tabs */}
      <Tabs defaultValue="zones" className="w-full">
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="zones">Safe Zones</TabsTrigger>
          <TabsTrigger value="history">History</TabsTrigger>
          <TabsTrigger value="alerts">
            Alerts
            {alerts.length > 0 && (
              <Badge variant="destructive" className="ml-2 h-5 w-5 p-0 text-xs">
                {alerts.length}
              </Badge>
            )}
          </TabsTrigger>
        </TabsList>

        <TabsContent value="zones" className="space-y-3">
          {safeZones.map((zone, index) => {
            const IconComponent = zone.icon;
            return (
              <Card key={index}>
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                        <IconComponent className="h-5 w-5 text-blue-600" />
                      </div>
                      <div>
                        <h3 className="font-medium">{zone.name}</h3>
                        <p className="text-sm text-muted-foreground">{zone.address}</p>
                        <p className="text-xs text-muted-foreground">Radius: {zone.radius}</p>
                      </div>
                    </div>
                    
                    <div className="flex items-center gap-3">
                      <Badge variant={zone.status === "active" ? "default" : "secondary"}>
                        {zone.status}
                      </Badge>
                      <Switch checked={zone.status === "active"} />
                    </div>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </TabsContent>

        <TabsContent value="history" className="space-y-3">
          {locationHistory.map((entry, index) => (
            <Card key={index}>
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-muted rounded-lg flex items-center justify-center">
                      <Clock className="h-4 w-4" />
                    </div>
                    <div>
                      <h3 className="font-medium">{entry.location}</h3>
                      <p className="text-sm text-muted-foreground">
                        {entry.time} • Duration: {entry.duration}
                      </p>
                    </div>
                  </div>
                  
                  <Badge variant={
                    entry.status === "safe" ? "default" :
                    entry.status === "alert" ? "destructive" : "secondary"
                  }>
                    {entry.status === "safe" ? "Safe" : "Alert"}
                  </Badge>
                </div>
              </CardContent>
            </Card>
          ))}
        </TabsContent>

        <TabsContent value="alerts" className="space-y-3">
          {alerts.length === 0 ? (
            <Card>
              <CardContent className="p-8 text-center">
                <div className="text-muted-foreground">
                  <Shield className="h-12 w-12 mx-auto mb-4 text-green-500" />
                  <h3 className="font-medium mb-2">No location alerts</h3>
                  <p className="text-sm">Emma is staying within safe zones</p>
                </div>
              </CardContent>
            </Card>
          ) : (
            alerts.map((alert, index) => (
              <Card key={index} className="border-orange-200">
                <CardContent className="p-4">
                  <div className="flex items-start gap-3">
                    <AlertTriangle className="h-5 w-5 text-orange-600 mt-0.5" />
                    <div className="flex-1">
                      <p className="font-medium">{alert.message}</p>
                      <p className="text-sm text-muted-foreground">{alert.time}</p>
                    </div>
                    <Badge variant={alert.severity === "high" ? "destructive" : "secondary"}>
                      {alert.severity}
                    </Badge>
                  </div>
                </CardContent>
              </Card>
            ))
          )}
        </TabsContent>
      </Tabs>

      {/* Location Settings */}
      <Card>
        <CardHeader>
          <CardTitle>Location Settings</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="font-medium">Location Tracking</p>
              <p className="text-sm text-muted-foreground">Track device location in real-time</p>
            </div>
            <Switch defaultChecked />
          </div>
          
          <div className="flex items-center justify-between">
            <div>
              <p className="font-medium">Safe Zone Alerts</p>
              <p className="text-sm text-muted-foreground">Get notified when leaving safe zones</p>
            </div>
            <Switch defaultChecked />
          </div>
          
          <div className="flex items-center justify-between">
            <div>
              <p className="font-medium">Location History</p>
              <p className="text-sm text-muted-foreground">Keep 30 days of location data</p>
            </div>
            <Switch defaultChecked />
          </div>
        </CardContent>
      </Card>
    </div>
  );
}