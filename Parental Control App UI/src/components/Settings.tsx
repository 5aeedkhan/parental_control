import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Switch } from "./ui/switch";
import { Badge } from "./ui/badge";
import { Separator } from "./ui/separator";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { Settings as SettingsIcon, Shield, Users, Bell, Eye, HelpCircle, LogOut, ChevronRight, Lock, Globe, Smartphone } from "lucide-react";

const parentAccounts = [
  {
    id: 1,
    name: "Sarah Johnson",
    email: "sarah@email.com",
    role: "Primary Parent",
    permissions: ["all"],
    avatar: "S"
  },
  {
    id: 2,
    name: "Mike Johnson",
    email: "mike@email.com",
    role: "Secondary Parent",
    permissions: ["monitoring", "alerts"],
    avatar: "M"
  }
];

const privacySettings = [
  { id: "location", title: "Location Tracking", description: "Track device location", enabled: true },
  { id: "messages", title: "Message Monitoring", description: "Scan messages for risks", enabled: true },
  { id: "calls", title: "Call Monitoring", description: "Monitor phone calls", enabled: false },
  { id: "apps", title: "App Usage Tracking", description: "Track app usage and time", enabled: true },
  { id: "web", title: "Web Activity", description: "Monitor browsing history", enabled: true },
  { id: "ai", title: "AI Analysis", description: "Use AI for risk detection", enabled: true }
];

const notificationSettings = [
  { id: "alerts", title: "Security Alerts", description: "High-risk activities", enabled: true },
  { id: "violations", title: "Rule Violations", description: "Screen time and app limits", enabled: true },
  { id: "location", title: "Location Updates", description: "Safe zone entries/exits", enabled: true },
  { id: "weekly", title: "Weekly Reports", description: "Summary of activity", enabled: true },
  { id: "emergency", title: "Emergency Alerts", description: "SOS and panic situations", enabled: true }
];

export function Settings() {
  return (
    <div className="flex flex-col gap-4 p-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Settings</h1>
        <Button size="sm" variant="outline">
          <LogOut className="h-4 w-4 mr-2" />
          Sign Out
        </Button>
      </div>

      {/* Tabs */}
      <Tabs defaultValue="account" className="w-full">
        <TabsList className="grid w-full grid-cols-4">
          <TabsTrigger value="account">Account</TabsTrigger>
          <TabsTrigger value="privacy">Privacy</TabsTrigger>
          <TabsTrigger value="notifications">Alerts</TabsTrigger>
          <TabsTrigger value="help">Help</TabsTrigger>
        </TabsList>

        <TabsContent value="account" className="space-y-4">
          {/* Primary Account */}
          <Card>
            <CardHeader>
              <CardTitle>Primary Account</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex items-center gap-3">
                <Avatar className="w-12 h-12">
                  <AvatarImage src="/placeholder-avatar.jpg" />
                  <AvatarFallback>S</AvatarFallback>
                </Avatar>
                <div className="flex-1">
                  <h3 className="font-medium">Sarah Johnson</h3>
                  <p className="text-sm text-muted-foreground">sarah@email.com</p>
                  <Badge variant="default" className="mt-1">Primary Parent</Badge>
                </div>
                <Button variant="outline" size="sm">
                  Edit Profile
                </Button>
              </div>
            </CardContent>
          </Card>

          {/* Multi-Parent Support */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Users className="h-5 w-5" />
                Parent Accounts
              </CardTitle>
              <p className="text-sm text-muted-foreground">Manage multiple parent access</p>
            </CardHeader>
            <CardContent className="space-y-3">
              {parentAccounts.map((parent) => (
                <div key={parent.id} className="flex items-center justify-between p-3 bg-muted rounded-lg">
                  <div className="flex items-center gap-3">
                    <Avatar>
                      <AvatarFallback>{parent.avatar}</AvatarFallback>
                    </Avatar>
                    <div>
                      <p className="font-medium">{parent.name}</p>
                      <p className="text-sm text-muted-foreground">{parent.email}</p>
                      <Badge variant="outline" className="text-xs">{parent.role}</Badge>
                    </div>
                  </div>
                  <Button variant="ghost" size="sm">
                    <ChevronRight className="h-4 w-4" />
                  </Button>
                </div>
              ))}
              
              <Button variant="outline" className="w-full">
                <Users className="h-4 w-4 mr-2" />
                Invite Parent
              </Button>
            </CardContent>
          </Card>

          {/* Child Devices */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Smartphone className="h-5 w-5" />
                Monitored Devices
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div className="flex items-center justify-between p-3 bg-muted rounded-lg">
                  <div>
                    <p className="font-medium">Emma's iPhone</p>
                    <p className="text-sm text-muted-foreground">iOS 17.2 • Online</p>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                    <span className="text-sm">Active</span>
                  </div>
                </div>
                
                <Button variant="outline" className="w-full">
                  <Smartphone className="h-4 w-4 mr-2" />
                  Add Device
                </Button>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="privacy" className="space-y-4">
          {/* Privacy Dashboard */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Shield className="h-5 w-5" />
                Privacy Dashboard
              </CardTitle>
              <p className="text-sm text-muted-foreground">Control what data is collected and how it's used</p>
            </CardHeader>
            <CardContent className="space-y-4">
              {privacySettings.map((setting, index) => (
                <div key={setting.id}>
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">{setting.title}</p>
                      <p className="text-sm text-muted-foreground">{setting.description}</p>
                    </div>
                    <Switch checked={setting.enabled} />
                  </div>
                  {index < privacySettings.length - 1 && <Separator className="mt-4" />}
                </div>
              ))}
            </CardContent>
          </Card>

          {/* Data Encryption */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Lock className="h-5 w-5" />
                Security & Encryption
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">End-to-End Encryption</p>
                  <p className="text-sm text-muted-foreground">All data encrypted in transit and at rest</p>
                </div>
                <Badge variant="default" className="bg-green-100 text-green-800">
                  Active
                </Badge>
              </div>
              
              <Separator />
              
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Two-Factor Authentication</p>
                  <p className="text-sm text-muted-foreground">Extra security for your account</p>
                </div>
                <Switch defaultChecked />
              </div>
              
              <Separator />
              
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Data Retention</p>
                  <p className="text-sm text-muted-foreground">Keep data for 30 days</p>
                </div>
                <Button variant="outline" size="sm">Configure</Button>
              </div>
            </CardContent>
          </Card>

          {/* Privacy Policy */}
          <Card>
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Privacy Policy</p>
                  <p className="text-sm text-muted-foreground">Last updated: March 2024</p>
                </div>
                <Button variant="ghost" size="sm">
                  <Globe className="h-4 w-4 mr-2" />
                  View
                </Button>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="notifications" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Bell className="h-5 w-5" />
                Notification Preferences
              </CardTitle>
              <p className="text-sm text-muted-foreground">Choose what alerts you want to receive</p>
            </CardHeader>
            <CardContent className="space-y-4">
              {notificationSettings.map((setting, index) => (
                <div key={setting.id}>
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">{setting.title}</p>
                      <p className="text-sm text-muted-foreground">{setting.description}</p>
                    </div>
                    <Switch checked={setting.enabled} />
                  </div>
                  {index < notificationSettings.length - 1 && <Separator className="mt-4" />}
                </div>
              ))}
            </CardContent>
          </Card>

          {/* Notification Methods */}
          <Card>
            <CardHeader>
              <CardTitle>Notification Methods</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Push Notifications</p>
                  <p className="text-sm text-muted-foreground">Instant alerts on your device</p>
                </div>
                <Switch defaultChecked />
              </div>
              
              <Separator />
              
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">Email Notifications</p>
                  <p className="text-sm text-muted-foreground">Send alerts to sarah@email.com</p>
                </div>
                <Switch defaultChecked />
              </div>
              
              <Separator />
              
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">SMS Alerts</p>
                  <p className="text-sm text-muted-foreground">Text messages for urgent alerts</p>
                </div>
                <Switch />
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="help" className="space-y-4">
          {/* Help Center */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <HelpCircle className="h-5 w-5" />
                Help Center
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <Button variant="outline" className="w-full justify-start">
                <HelpCircle className="h-4 w-4 mr-2" />
                Frequently Asked Questions
                <ChevronRight className="h-4 w-4 ml-auto" />
              </Button>
              
              <Button variant="outline" className="w-full justify-start">
                <Eye className="h-4 w-4 mr-2" />
                User Guide & Tutorials
                <ChevronRight className="h-4 w-4 ml-auto" />
              </Button>
              
              <Button variant="outline" className="w-full justify-start">
                <Users className="h-4 w-4 mr-2" />
                Contact Support
                <ChevronRight className="h-4 w-4 ml-auto" />
              </Button>
            </CardContent>
          </Card>

          {/* Educational Resources */}
          <Card>
            <CardHeader>
              <CardTitle>Educational Resources</CardTitle>
              <p className="text-sm text-muted-foreground">Learn about digital parenting</p>
            </CardHeader>
            <CardContent className="space-y-3">
              <div className="p-3 bg-blue-50 rounded-lg">
                <h4 className="font-medium text-blue-900">Digital Wellness Guide</h4>
                <p className="text-sm text-blue-700">Tips for healthy screen time habits</p>
              </div>
              
              <div className="p-3 bg-green-50 rounded-lg">
                <h4 className="font-medium text-green-900">Cyberbullying Prevention</h4>
                <p className="text-sm text-green-700">Protecting your child online</p>
              </div>
              
              <div className="p-3 bg-purple-50 rounded-lg">
                <h4 className="font-medium text-purple-900">Age-Appropriate Content</h4>
                <p className="text-sm text-purple-700">Setting content filters by age</p>
              </div>
            </CardContent>
          </Card>

          {/* App Information */}
          <Card>
            <CardContent className="p-4 space-y-3">
              <div className="text-center">
                <h3 className="font-medium">FamilyGuard</h3>
                <p className="text-sm text-muted-foreground">Version 2.1.0</p>
              </div>
              
              <div className="flex justify-center gap-4 text-sm text-muted-foreground">
                <Button variant="link" className="p-0 h-auto">Terms of Service</Button>
                <Button variant="link" className="p-0 h-auto">Privacy Policy</Button>
                <Button variant="link" className="p-0 h-auto">Contact Us</Button>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}