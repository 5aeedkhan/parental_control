import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Input } from "./ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { Clock, Phone, MessageSquare, Bell, Search, Filter, AlertTriangle, Eye, Calendar } from "lucide-react";
import { useState } from "react";

const activityTimeline = [
  {
    time: "14:45",
    type: "app",
    activity: "Instagram",
    duration: "15m",
    details: "Viewed 23 posts, 5 stories",
    riskLevel: "medium",
    riskTags: ["excessive_usage"]
  },
  {
    time: "14:30",
    type: "message",
    activity: "WhatsApp",
    details: "Message from unknown number: +1-555-0123",
    riskLevel: "high",
    riskTags: ["unknown_contact", "suspicious_content"]
  },
  {
    time: "14:15",
    type: "call",
    activity: "Phone Call",
    duration: "5m",
    details: "Incoming call from Mom",
    riskLevel: "low",
    riskTags: []
  },
  {
    time: "14:00",
    type: "app",
    activity: "YouTube",
    duration: "30m",
    details: "Watched 'Study Tips for Teens'",
    riskLevel: "low",
    riskTags: []
  },
  {
    time: "13:30",
    type: "notification",
    activity: "Discord",
    details: "New message in 'School Friends' server",
    riskLevel: "medium",
    riskTags: ["social_interaction"]
  },
  {
    time: "13:15",
    type: "app",
    activity: "TikTok",
    duration: "45m",
    details: "Viewed 156 videos",
    riskLevel: "high",
    riskTags: ["excessive_usage", "inappropriate_content"]
  },
  {
    time: "12:45",
    type: "message",
    activity: "Instagram DM",
    details: "Message flagged for cyberbullying content",
    riskLevel: "high",
    riskTags: ["cyberbullying", "harmful_content"]
  },
  {
    time: "12:30",
    type: "app",
    activity: "Khan Academy",
    duration: "1h 15m",
    details: "Completed Math lesson: Algebra Basics",
    riskLevel: "low",
    riskTags: []
  }
];

const callLogs = [
  { time: "14:15", contact: "Mom", duration: "5m 23s", type: "incoming", status: "answered" },
  { time: "12:30", contact: "Dad", duration: "2m 45s", type: "outgoing", status: "answered" },
  { time: "11:45", contact: "Unknown (+1-555-0123)", duration: "0s", type: "incoming", status: "missed" },
  { time: "Yesterday 19:30", contact: "Best Friend Sarah", duration: "25m 12s", type: "outgoing", status: "answered" },
];

const messageLogs = [
  {
    time: "14:30",
    platform: "WhatsApp",
    contact: "Unknown (+1-555-0123)",
    preview: "Hey, want to meet up after school?",
    riskLevel: "high",
    flagged: true
  },
  {
    time: "13:45",
    platform: "Instagram",
    contact: "@classmate_jenny",
    preview: "Did you finish the homework?",
    riskLevel: "low",
    flagged: false
  },
  {
    time: "12:45",
    platform: "Instagram",
    contact: "@unknown_user123",
    preview: "You're so stupid, nobody likes you...",
    riskLevel: "high",
    flagged: true
  },
  {
    time: "12:30",
    platform: "Discord",
    contact: "School Friends Server",
    preview: "Anyone want to study together?",
    riskLevel: "low",
    flagged: false
  }
];

const notifications = [
  { time: "14:50", app: "Instagram", type: "like", content: "Jenny liked your photo" },
  { time: "14:45", app: "WhatsApp", type: "message", content: "New message from Unknown" },
  { time: "14:30", app: "YouTube", type: "upload", content: "New video from Study Channel" },
  { time: "14:15", app: "Calendar", type: "reminder", content: "Math homework due tomorrow" },
];

export function ActivityMonitoring() {
  const [timeFilter, setTimeFilter] = useState("today");
  const [activityFilter, setActivityFilter] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");

  const filteredActivities = activityTimeline.filter(activity => {
    const matchesSearch = activity.activity.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         activity.details.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesType = activityFilter === "all" || activity.type === activityFilter;
    return matchesSearch && matchesType;
  });

  const getRiskColor = (level: string) => {
    switch (level) {
      case "high": return "destructive";
      case "medium": return "secondary";
      case "low": return "outline";
      default: return "outline";
    }
  };

  const getActivityIcon = (type: string) => {
    switch (type) {
      case "call": return Phone;
      case "message": return MessageSquare;
      case "notification": return Bell;
      default: return Clock;
    }
  };

  return (
    <div className="flex flex-col gap-4 p-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Activity Monitoring</h1>
        <Button size="sm" variant="outline">
          <Eye className="h-4 w-4 mr-2" />
          Live View
        </Button>
      </div>

      {/* Filters */}
      <Card>
        <CardContent className="p-4 space-y-3">
          <div className="flex items-center gap-2">
            <Search className="h-4 w-4 text-muted-foreground" />
            <Input 
              placeholder="Search activities..." 
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="flex-1"
            />
          </div>
          
          <div className="flex gap-2">
            <Select value={timeFilter} onValueChange={setTimeFilter}>
              <SelectTrigger className="w-32">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="today">Today</SelectItem>
                <SelectItem value="week">This Week</SelectItem>
                <SelectItem value="month">This Month</SelectItem>
              </SelectContent>
            </Select>
            
            <Select value={activityFilter} onValueChange={setActivityFilter}>
              <SelectTrigger className="w-32">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Types</SelectItem>
                <SelectItem value="app">Apps</SelectItem>
                <SelectItem value="call">Calls</SelectItem>
                <SelectItem value="message">Messages</SelectItem>
                <SelectItem value="notification">Notifications</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardContent>
      </Card>

      {/* Tabs */}
      <Tabs defaultValue="timeline" className="w-full">
        <TabsList className="grid w-full grid-cols-4">
          <TabsTrigger value="timeline">Timeline</TabsTrigger>
          <TabsTrigger value="calls">Calls</TabsTrigger>
          <TabsTrigger value="messages">Messages</TabsTrigger>
          <TabsTrigger value="notifications">Notifications</TabsTrigger>
        </TabsList>

        <TabsContent value="timeline" className="space-y-3">
          {filteredActivities.map((activity, index) => {
            const IconComponent = getActivityIcon(activity.type);
            return (
              <Card key={index} className={activity.riskLevel === "high" ? "border-red-200" : ""}>
                <CardContent className="p-4">
                  <div className="flex items-start justify-between">
                    <div className="flex items-start gap-3">
                      <div className="w-10 h-10 bg-muted rounded-lg flex items-center justify-center">
                        <IconComponent className="h-4 w-4" />
                      </div>
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <h3 className="font-medium">{activity.activity}</h3>
                          <Badge variant={getRiskColor(activity.riskLevel)}>
                            {activity.riskLevel}
                          </Badge>
                          {activity.duration && (
                            <span className="text-sm text-muted-foreground">• {activity.duration}</span>
                          )}
                        </div>
                        <p className="text-sm text-muted-foreground mb-2">{activity.details}</p>
                        
                        {activity.riskTags.length > 0 && (
                          <div className="flex flex-wrap gap-1">
                            {activity.riskTags.map((tag, tagIndex) => (
                              <Badge key={tagIndex} variant="outline" className="text-xs">
                                {tag.replace("_", " ")}
                              </Badge>
                            ))}
                          </div>
                        )}
                      </div>
                    </div>
                    
                    <div className="text-right">
                      <p className="text-sm text-muted-foreground">{activity.time}</p>
                      {activity.riskLevel === "high" && (
                        <Button size="sm" variant="outline" className="mt-2">
                          Review
                        </Button>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </TabsContent>

        <TabsContent value="calls" className="space-y-3">
          {callLogs.map((call, index) => (
            <Card key={index}>
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                      <Phone className="h-4 w-4 text-blue-600" />
                    </div>
                    <div>
                      <h3 className="font-medium">{call.contact}</h3>
                      <div className="flex items-center gap-2 text-sm text-muted-foreground">
                        <span>{call.time}</span>
                        <span>•</span>
                        <span>{call.type}</span>
                        <span>•</span>
                        <span>{call.duration}</span>
                      </div>
                    </div>
                  </div>
                  
                  <Badge variant={call.status === "answered" ? "default" : "secondary"}>
                    {call.status}
                  </Badge>
                </div>
              </CardContent>
            </Card>
          ))}
        </TabsContent>

        <TabsContent value="messages" className="space-y-3">
          {messageLogs.map((message, index) => (
            <Card key={index} className={message.flagged ? "border-red-200 bg-red-50" : ""}>
              <CardContent className="p-4">
                <div className="flex items-start justify-between">
                  <div className="flex items-start gap-3">
                    <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                      <MessageSquare className="h-4 w-4 text-green-600" />
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-1">
                        <h3 className="font-medium">{message.platform}</h3>
                        {message.flagged && (
                          <AlertTriangle className="h-4 w-4 text-red-600" />
                        )}
                      </div>
                      <p className="text-sm text-muted-foreground mb-1">{message.contact}</p>
                      <p className="text-sm bg-white p-2 rounded border italic">
                        "{message.preview}"
                      </p>
                    </div>
                  </div>
                  
                  <div className="text-right">
                    <p className="text-sm text-muted-foreground mb-2">{message.time}</p>
                    <Badge variant={getRiskColor(message.riskLevel)}>
                      {message.riskLevel}
                    </Badge>
                    {message.flagged && (
                      <div className="flex gap-1 mt-2">
                        <Button size="sm" variant="outline">Acknowledge</Button>
                        <Button size="sm" variant="destructive">Report</Button>
                      </div>
                    )}
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </TabsContent>

        <TabsContent value="notifications" className="space-y-3">
          {notifications.map((notification, index) => (
            <Card key={index}>
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-orange-100 rounded-lg flex items-center justify-center">
                      <Bell className="h-4 w-4 text-orange-600" />
                    </div>
                    <div>
                      <h3 className="font-medium">{notification.app}</h3>
                      <p className="text-sm text-muted-foreground">{notification.content}</p>
                    </div>
                  </div>
                  
                  <div className="text-right">
                    <p className="text-sm text-muted-foreground">{notification.time}</p>
                    <Badge variant="outline">{notification.type}</Badge>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </TabsContent>
      </Tabs>

      {/* Activity Summary */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Calendar className="h-5 w-5" />
            Today's Summary
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 gap-4">
            <div className="text-center">
              <div className="text-2xl font-semibold">47</div>
              <p className="text-sm text-muted-foreground">Total Activities</p>
            </div>
            <div className="text-center">
              <div className="text-2xl font-semibold text-red-600">3</div>
              <p className="text-sm text-muted-foreground">High Risk Events</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}