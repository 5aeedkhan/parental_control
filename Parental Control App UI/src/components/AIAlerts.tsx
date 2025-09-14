import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Alert, AlertDescription } from "./ui/alert";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { AlertTriangle, Shield, Eye, MessageCircle, User, Clock, CheckCircle } from "lucide-react";

const aiAlerts = [
  {
    id: 1,
    type: "cyberbullying",
    severity: "high",
    source: "Instagram DM",
    title: "Potential cyberbullying detected",
    description: "Harsh language and threats detected in messages from @unknown_user123",
    context: "\"You're so stupid, nobody likes you...\"",
    time: "2 hours ago",
    recommendations: ["Block the user", "Report to platform", "Talk to Emma about the incident"],
    status: "new"
  },
  {
    id: 2,
    type: "sensitive_content",
    severity: "medium",
    source: "YouTube",
    title: "Inappropriate content viewed",
    description: "Video containing mature themes was watched",
    context: "Video: \"Teen Drama Series - Episode 15\"",
    time: "4 hours ago",
    recommendations: ["Review content filters", "Discuss media consumption", "Update age restrictions"],
    status: "new"
  },
  {
    id: 3,
    type: "risky_contact",
    severity: "high",
    source: "WhatsApp",
    title: "Unknown contact attempting communication",
    description: "New contact with limited profile information trying to connect",
    context: "Contact: +1 (555) 123-4567 - No profile picture, limited info",
    time: "6 hours ago",
    recommendations: ["Block contact", "Review privacy settings", "Educate about stranger danger"],
    status: "acknowledged"
  },
  {
    id: 4,
    type: "screen_time",
    severity: "low",
    source: "System",
    title: "Unusual late-night activity",
    description: "Device usage detected between 11 PM and 1 AM",
    context: "Apps used: TikTok (45m), YouTube (30m)",
    time: "Yesterday",
    recommendations: ["Adjust bedtime schedule", "Enable night mode restrictions"],
    status: "resolved"
  }
];

const insights = [
  {
    title: "Communication Patterns",
    description: "Emma's messaging activity has increased 40% this week",
    trend: "up",
    severity: "low"
  },
  {
    title: "Content Consumption",
    description: "More mature content being accessed recently",
    trend: "up",
    severity: "medium"
  },
  {
    title: "Social Interactions",
    description: "New contacts added to social media accounts",
    trend: "stable",
    severity: "low"
  }
];

export function AIAlerts() {
  const newAlerts = aiAlerts.filter(alert => alert.status === "new");
  const acknowledgedAlerts = aiAlerts.filter(alert => alert.status === "acknowledged");
  const resolvedAlerts = aiAlerts.filter(alert => alert.status === "resolved");

  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case "high": return "destructive";
      case "medium": return "secondary";
      case "low": return "outline";
      default: return "outline";
    }
  };

  const getSeverityIcon = (type: string) => {
    switch (type) {
      case "cyberbullying": return MessageCircle;
      case "sensitive_content": return Eye;
      case "risky_contact": return User;
      case "screen_time": return Clock;
      default: return AlertTriangle;
    }
  };

  return (
    <div className="flex flex-col gap-4 p-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">AI Alerts</h1>
        <Button size="sm" variant="outline">Settings</Button>
      </div>

      {/* Summary Alert */}
      {newAlerts.length > 0 && (
        <Alert className="border-red-200 bg-red-50">
          <AlertTriangle className="h-4 w-4 text-red-600" />
          <AlertDescription className="text-red-800">
            <strong>{newAlerts.length} new alerts</strong> require your attention. 
            {newAlerts.filter(a => a.severity === "high").length > 0 && 
              ` ${newAlerts.filter(a => a.severity === "high").length} are high priority.`
            }
          </AlertDescription>
        </Alert>
      )}

      {/* AI Insights */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Shield className="h-5 w-5" />
            AI Insights
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          {insights.map((insight, index) => (
            <div key={index} className="flex items-start justify-between p-3 bg-muted/50 rounded-lg">
              <div>
                <h4 className="font-medium">{insight.title}</h4>
                <p className="text-sm text-muted-foreground">{insight.description}</p>
              </div>
              <Badge variant={getSeverityColor(insight.severity)}>
                {insight.severity}
              </Badge>
            </div>
          ))}
        </CardContent>
      </Card>

      {/* Alerts Tabs */}
      <Tabs defaultValue="new" className="w-full">
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="new">
            New
            {newAlerts.length > 0 && (
              <Badge variant="destructive" className="ml-2 h-5 w-5 p-0 text-xs">
                {newAlerts.length}
              </Badge>
            )}
          </TabsTrigger>
          <TabsTrigger value="acknowledged">Acknowledged</TabsTrigger>
          <TabsTrigger value="resolved">Resolved</TabsTrigger>
        </TabsList>

        <TabsContent value="new" className="space-y-3">
          {newAlerts.length === 0 ? (
            <Card>
              <CardContent className="p-8 text-center">
                <div className="text-muted-foreground">
                  <CheckCircle className="h-12 w-12 mx-auto mb-4 text-green-500" />
                  <h3 className="font-medium mb-2">No new alerts</h3>
                  <p className="text-sm">All alerts have been reviewed</p>
                </div>
              </CardContent>
            </Card>
          ) : (
            newAlerts.map((alert) => {
              const IconComponent = getSeverityIcon(alert.type);
              return (
                <Card key={alert.id} className="border-l-4 border-l-red-500">
                  <CardContent className="p-4">
                    <div className="space-y-3">
                      <div className="flex items-start justify-between">
                        <div className="flex items-start gap-3">
                          <div className="w-10 h-10 bg-red-100 rounded-lg flex items-center justify-center">
                            <IconComponent className="h-5 w-5 text-red-600" />
                          </div>
                          <div>
                            <h3 className="font-medium">{alert.title}</h3>
                            <p className="text-sm text-muted-foreground">{alert.source} • {alert.time}</p>
                          </div>
                        </div>
                        <Badge variant={getSeverityColor(alert.severity)}>
                          {alert.severity}
                        </Badge>
                      </div>

                      <p className="text-sm">{alert.description}</p>

                      <div className="p-3 bg-muted rounded-lg">
                        <p className="text-sm font-medium mb-1">Context:</p>
                        <p className="text-sm text-muted-foreground italic">"{alert.context}"</p>
                      </div>

                      <div>
                        <p className="text-sm font-medium mb-2">Recommended Actions:</p>
                        <ul className="space-y-1">
                          {alert.recommendations.map((rec, index) => (
                            <li key={index} className="text-sm text-muted-foreground flex items-center gap-2">
                              <div className="w-1.5 h-1.5 bg-muted-foreground rounded-full"></div>
                              {rec}
                            </li>
                          ))}
                        </ul>
                      </div>

                      <div className="flex gap-2 pt-2">
                        <Button size="sm" variant="outline">
                          Acknowledge
                        </Button>
                        <Button size="sm">
                          Take Action
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              );
            })
          )}
        </TabsContent>

        <TabsContent value="acknowledged" className="space-y-3">
          {acknowledgedAlerts.map((alert) => {
            const IconComponent = getSeverityIcon(alert.type);
            return (
              <Card key={alert.id} className="border-l-4 border-l-orange-500">
                <CardContent className="p-4">
                  <div className="flex items-start justify-between">
                    <div className="flex items-start gap-3">
                      <div className="w-10 h-10 bg-orange-100 rounded-lg flex items-center justify-center">
                        <IconComponent className="h-5 w-5 text-orange-600" />
                      </div>
                      <div>
                        <h3 className="font-medium">{alert.title}</h3>
                        <p className="text-sm text-muted-foreground">{alert.source} • {alert.time}</p>
                        <p className="text-sm mt-1">{alert.description}</p>
                      </div>
                    </div>
                    <Button size="sm" variant="outline">
                      Mark Resolved
                    </Button>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </TabsContent>

        <TabsContent value="resolved" className="space-y-3">
          {resolvedAlerts.map((alert) => {
            const IconComponent = getSeverityIcon(alert.type);
            return (
              <Card key={alert.id} className="border-l-4 border-l-green-500 opacity-75">
                <CardContent className="p-4">
                  <div className="flex items-start justify-between">
                    <div className="flex items-start gap-3">
                      <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                        <IconComponent className="h-5 w-5 text-green-600" />
                      </div>
                      <div>
                        <h3 className="font-medium">{alert.title}</h3>
                        <p className="text-sm text-muted-foreground">{alert.source} • {alert.time}</p>
                        <p className="text-sm mt-1">{alert.description}</p>
                      </div>
                    </div>
                    <Badge variant="outline" className="bg-green-50 text-green-700">
                      Resolved
                    </Badge>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </TabsContent>
      </Tabs>

      {/* AI Settings */}
      <Card>
        <CardHeader>
          <CardTitle>AI Detection Settings</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-2 gap-3">
            <Button variant="outline" className="justify-start gap-2">
              <MessageCircle className="h-4 w-4" />
              Cyberbullying
            </Button>
            <Button variant="outline" className="justify-start gap-2">
              <Eye className="h-4 w-4" />
              Content Filter
            </Button>
            <Button variant="outline" className="justify-start gap-2">
              <User className="h-4 w-4" />
              Contact Safety
            </Button>
            <Button variant="outline" className="justify-start gap-2">
              <Clock className="h-4 w-4" />
              Usage Patterns
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}