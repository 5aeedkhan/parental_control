import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Switch } from "./ui/switch";
import { Badge } from "./ui/badge";
import { Alert, AlertDescription } from "./ui/alert";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "./ui/dialog";
import { Lock, WifiOff, AlertTriangle, Smartphone, Play, Pause, RotateCcw, Volume2, VolumeX, MapPin } from "lucide-react";
import { useState } from "react";

const deviceStatus = {
  isOnline: true,
  isLocked: false,
  internetPaused: false,
  soundMuted: false,
  location: "Emma's School",
  batteryLevel: 78,
  lastSeen: "2 minutes ago"
};

const quickActions = [
  {
    id: "lock",
    title: "Lock Device",
    description: "Instantly lock the device screen",
    icon: Lock,
    action: "lock",
    color: "red",
    confirmationRequired: true
  },
  {
    id: "internet",
    title: "Pause Internet",
    description: "Temporarily disable internet access",
    icon: WifiOff,
    action: "pauseInternet",
    color: "orange",
    confirmationRequired: true
  },
  {
    id: "locate",
    title: "Send Location Alert",
    description: "Request current location immediately",
    icon: MapPin,
    action: "requestLocation",
    color: "blue",
    confirmationRequired: false
  },
  {
    id: "sound",
    title: "Play Alert Sound",
    description: "Play loud sound to locate device",
    icon: Volume2,
    action: "playSound",
    color: "green",
    confirmationRequired: false
  }
];

const sosAlerts = [
  {
    id: 1,
    type: "emergency",
    message: "Emergency button pressed",
    time: "2 days ago",
    location: "Home",
    status: "resolved"
  },
  {
    id: 2,
    type: "panic",
    message: "Panic mode activated",
    time: "1 week ago",
    location: "School",
    status: "resolved"
  }
];

const scheduledActions = [
  {
    id: 1,
    action: "Internet Pause",
    time: "21:00",
    duration: "Until 07:00",
    days: ["Mon", "Tue", "Wed", "Thu", "Fri"],
    enabled: true
  },
  {
    id: 2,
    action: "Device Lock",
    time: "22:30",
    duration: "Until 06:30",
    days: ["Every day"],
    enabled: true
  }
];

export function RemoteControls() {
  const [selectedAction, setSelectedAction] = useState<string | null>(null);
  const [isExecuting, setIsExecuting] = useState(false);
  const [showConfirmation, setShowConfirmation] = useState(false);

  const executeAction = async (actionId: string) => {
    setIsExecuting(true);
    
    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      // Update device status based on action
      switch (actionId) {
        case "lock":
          console.log("Device locked");
          break;
        case "pauseInternet":
          console.log("Internet paused");
          break;
        case "requestLocation":
          console.log("Location requested");
          break;
        case "playSound":
          console.log("Alert sound played");
          break;
      }
      
      setShowConfirmation(false);
      setSelectedAction(null);
    } catch (error) {
      console.error("Action failed:", error);
    } finally {
      setIsExecuting(false);
    }
  };

  const handleActionClick = (action: any) => {
    if (action.confirmationRequired) {
      setSelectedAction(action.id);
      setShowConfirmation(true);
    } else {
      executeAction(action.id);
    }
  };

  return (
    <div className="flex flex-col gap-4 p-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Remote Controls</h1>
        <Badge variant={deviceStatus.isOnline ? "default" : "destructive"}>
          {deviceStatus.isOnline ? "Online" : "Offline"}
        </Badge>
      </div>

      {/* Device Status */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Smartphone className="h-5 w-5" />
            Emma's iPhone
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <p className="text-sm text-muted-foreground">Status</p>
              <div className="flex items-center gap-2">
                <div className={`w-2 h-2 rounded-full ${deviceStatus.isOnline ? "bg-green-500" : "bg-red-500"}`}></div>
                <span className="font-medium">{deviceStatus.isOnline ? "Online" : "Offline"}</span>
              </div>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Battery</p>
              <p className="font-medium">{deviceStatus.batteryLevel}%</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Location</p>
              <p className="font-medium">{deviceStatus.location}</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Last Seen</p>
              <p className="font-medium">{deviceStatus.lastSeen}</p>
            </div>
          </div>

          <div className="space-y-3 pt-3 border-t">
            <div className="flex items-center justify-between">
              <span className="text-sm">Device Locked</span>
              <Badge variant={deviceStatus.isLocked ? "destructive" : "outline"}>
                {deviceStatus.isLocked ? "Locked" : "Unlocked"}
              </Badge>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm">Internet Access</span>
              <Badge variant={deviceStatus.internetPaused ? "destructive" : "default"}>
                {deviceStatus.internetPaused ? "Paused" : "Active"}
              </Badge>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Quick Actions */}
      <Card>
        <CardHeader>
          <CardTitle>Quick Actions</CardTitle>
          <p className="text-sm text-muted-foreground">Instantly control the device remotely</p>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 gap-3">
            {quickActions.map((action) => {
              const IconComponent = action.icon;
              return (
                <Button
                  key={action.id}
                  variant="outline"
                  className="h-auto p-4 flex flex-col gap-2"
                  onClick={() => handleActionClick(action)}
                  disabled={!deviceStatus.isOnline || isExecuting}
                >
                  <div className={`w-8 h-8 rounded-lg bg-${action.color}-100 flex items-center justify-center`}>
                    <IconComponent className={`h-4 w-4 text-${action.color}-600`} />
                  </div>
                  <div className="text-center">
                    <p className="font-medium text-sm">{action.title}</p>
                    <p className="text-xs text-muted-foreground">{action.description}</p>
                  </div>
                </Button>
              );
            })}
          </div>
        </CardContent>
      </Card>

      {/* SOS Alerts */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <AlertTriangle className="h-5 w-5" />
            SOS Alerts
          </CardTitle>
        </CardHeader>
        <CardContent>
          {sosAlerts.length === 0 ? (
            <div className="text-center py-8 text-muted-foreground">
              <AlertTriangle className="h-12 w-12 mx-auto mb-4 text-green-500" />
              <p>No emergency alerts</p>
              <p className="text-sm">Your child hasn't triggered any SOS alerts</p>
            </div>
          ) : (
            <div className="space-y-3">
              {sosAlerts.map((alert) => (
                <div key={alert.id} className="flex items-center justify-between p-3 bg-muted rounded-lg">
                  <div>
                    <p className="font-medium">{alert.message}</p>
                    <p className="text-sm text-muted-foreground">
                      {alert.time} • {alert.location}
                    </p>
                  </div>
                  <Badge variant={alert.status === "resolved" ? "outline" : "destructive"}>
                    {alert.status}
                  </Badge>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Scheduled Actions */}
      <Card>
        <CardHeader>
          <CardTitle>Scheduled Actions</CardTitle>
          <p className="text-sm text-muted-foreground">Automatic controls based on schedule</p>
        </CardHeader>
        <CardContent className="space-y-3">
          {scheduledActions.map((schedule) => (
            <div key={schedule.id} className="flex items-center justify-between p-3 bg-muted rounded-lg">
              <div>
                <p className="font-medium">{schedule.action}</p>
                <p className="text-sm text-muted-foreground">
                  {schedule.time} - {schedule.duration}
                </p>
                <p className="text-xs text-muted-foreground">
                  {schedule.days.join(", ")}
                </p>
              </div>
              <Switch checked={schedule.enabled} />
            </div>
          ))}
          
          <Button variant="outline" className="w-full">
            <Play className="h-4 w-4 mr-2" />
            Add Schedule
          </Button>
        </CardContent>
      </Card>

      {/* Emergency Instructions */}
      <Alert>
        <AlertTriangle className="h-4 w-4" />
        <AlertDescription>
          <strong>Emergency Mode:</strong> In case of emergency, your child can press and hold the power button 5 times to send an immediate SOS alert with location.
        </AlertDescription>
      </Alert>

      {/* Confirmation Dialog */}
      <Dialog open={showConfirmation} onOpenChange={setShowConfirmation}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Confirm Action</DialogTitle>
            <DialogDescription>
              {selectedAction && (() => {
                const action = quickActions.find(a => a.id === selectedAction);
                return `Are you sure you want to ${action?.title.toLowerCase()}? This action will take effect immediately.`;
              })()}
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setShowConfirmation(false)} disabled={isExecuting}>
              Cancel
            </Button>
            <Button 
              onClick={() => selectedAction && executeAction(selectedAction)} 
              disabled={isExecuting}
            >
              {isExecuting ? "Executing..." : "Confirm"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}