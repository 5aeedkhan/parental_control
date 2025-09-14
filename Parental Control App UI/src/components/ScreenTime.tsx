import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Switch } from "./ui/switch";
import { Calendar } from "./ui/calendar";
import { Badge } from "./ui/badge";
import { Separator } from "./ui/separator";
import { Clock, Plus, Edit, AlertCircle, Calendar as CalendarIcon } from "lucide-react";
import { useState } from "react";

const scheduleData = [
  { day: "Monday", start: "07:00", end: "20:00", limit: "6h", status: "active" },
  { day: "Tuesday", start: "07:00", end: "20:00", limit: "6h", status: "active" },
  { day: "Wednesday", start: "07:00", end: "20:00", limit: "6h", status: "active" },
  { day: "Thursday", start: "07:00", end: "20:00", limit: "6h", status: "active" },
  { day: "Friday", start: "07:00", end: "21:00", limit: "7h", status: "active" },
  { day: "Saturday", start: "09:00", end: "22:00", limit: "8h", status: "active" },
  { day: "Sunday", start: "09:00", end: "21:00", limit: "7h", status: "violated" },
];

const todayUsage = [
  { app: "Instagram", time: "2h 15m", limit: "1h 30m", status: "exceeded" },
  { app: "YouTube", time: "1h 45m", limit: "2h", status: "normal" },
  { app: "TikTok", time: "45m", limit: "1h", status: "normal" },
  { app: "Minecraft", time: "30m", limit: "1h", status: "normal" },
];

export function ScreenTime() {
  const [selectedDate, setSelectedDate] = useState<Date | undefined>(new Date());

  return (
    <div className="flex flex-col gap-4 p-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Screen Time</h1>
        <Button size="sm">
          <Plus className="h-4 w-4 mr-2" />
          Add Rule
        </Button>
      </div>

      {/* Today's Summary */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Clock className="h-5 w-5" />
            Today's Usage
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="text-center mb-4">
            <div className="text-3xl font-semibold">4h 23m</div>
            <p className="text-muted-foreground">of 6h daily limit</p>
            <div className="w-full bg-muted rounded-full h-2 mt-2">
              <div className="bg-orange-500 h-2 rounded-full w-3/4"></div>
            </div>
          </div>
          
          <div className="space-y-3">
            {todayUsage.map((item, index) => (
              <div key={index} className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 bg-muted rounded-lg flex items-center justify-center">
                    <span className="text-xs">{item.app[0]}</span>
                  </div>
                  <div>
                    <p className="font-medium">{item.app}</p>
                    <p className="text-sm text-muted-foreground">{item.time}</p>
                  </div>
                </div>
                <div className="text-right">
                  <Badge variant={item.status === "exceeded" ? "destructive" : "secondary"}>
                    {item.status === "exceeded" ? "Exceeded" : "On Track"}
                  </Badge>
                  <p className="text-xs text-muted-foreground mt-1">Limit: {item.limit}</p>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Weekly Schedule */}
      <Card>
        <CardHeader>
          <CardTitle>Weekly Schedule</CardTitle>
          <p className="text-sm text-muted-foreground">Set device usage hours and daily limits</p>
        </CardHeader>
        <CardContent className="space-y-3">
          {scheduleData.map((day, index) => (
            <div key={index}>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 rounded-full bg-blue-500"></div>
                    <span className="font-medium">{day.day}</span>
                  </div>
                  {day.status === "violated" && (
                    <AlertCircle className="h-4 w-4 text-red-500" />
                  )}
                </div>
                <div className="flex items-center gap-3">
                  <div className="text-sm text-muted-foreground">
                    {day.start} - {day.end}
                  </div>
                  <Badge variant="outline">{day.limit}</Badge>
                  <Button size="sm" variant="ghost">
                    <Edit className="h-4 w-4" />
                  </Button>
                </div>
              </div>
              {index < scheduleData.length - 1 && <Separator className="mt-3" />}
            </div>
          ))}
        </CardContent>
      </Card>

      {/* Override Options */}
      <Card>
        <CardHeader>
          <CardTitle>Override Options</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="font-medium">Emergency Override</p>
              <p className="text-sm text-muted-foreground">Allow unlimited access for emergencies</p>
            </div>
            <Switch />
          </div>
          
          <Separator />
          
          <div className="flex items-center justify-between">
            <div>
              <p className="font-medium">Study Mode</p>
              <p className="text-sm text-muted-foreground">Extended time for educational apps</p>
            </div>
            <Switch />
          </div>
          
          <Separator />
          
          <div className="space-y-3">
            <p className="font-medium">Extra Time Requests</p>
            <div className="space-y-2">
              <div className="flex items-center justify-between p-3 bg-muted rounded-lg">
                <div>
                  <p className="text-sm font-medium">Request for +30 minutes</p>
                  <p className="text-xs text-muted-foreground">For homework completion</p>
                </div>
                <div className="flex gap-2">
                  <Button size="sm" variant="outline">Deny</Button>
                  <Button size="sm">Approve</Button>
                </div>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Calendar View */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <CalendarIcon className="h-5 w-5" />
            Usage Calendar
          </CardTitle>
        </CardHeader>
        <CardContent>
          <Calendar
            mode="single"
            selected={selectedDate}
            onSelect={setSelectedDate}
            className="rounded-md border"
          />
          <div className="mt-4 flex items-center gap-4 text-sm">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-green-500 rounded-full"></div>
              <span>Under limit</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-orange-500 rounded-full"></div>
              <span>Near limit</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 bg-red-500 rounded-full"></div>
              <span>Exceeded</span>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}