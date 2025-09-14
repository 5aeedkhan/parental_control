import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Input } from "./ui/input";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { Alert, AlertDescription } from "./ui/alert";
import { MessageSquare, AlertTriangle, Eye, Search, Shield, Flag, Check, X } from "lucide-react";
import { useState } from "react";

const flaggedMessages = [
  {
    id: 1,
    platform: "Instagram",
    contact: "@unknown_user123",
    time: "2 hours ago",
    preview: "You're so stupid, nobody likes you. Why don't you just...",
    fullMessage: "You're so stupid, nobody likes you. Why don't you just disappear from school? Everyone thinks you're a loser.",
    riskLevel: "high",
    riskTags: ["cyberbullying", "harmful_content", "threats"],
    status: "new",
    aiConfidence: 95
  },
  {
    id: 2,
    platform: "WhatsApp",
    contact: "Unknown (+1-555-0123)",
    time: "4 hours ago",
    preview: "Hey, want to meet up after school? I have something cool...",
    fullMessage: "Hey, want to meet up after school? I have something cool to show you. Don't tell your parents about this.",
    riskLevel: "high",
    riskTags: ["stranger_contact", "secretive_behavior", "meetup_request"],
    status: "new",
    aiConfidence: 87
  },
  {
    id: 3,
    platform: "Discord",
    contact: "Gaming Server #general",
    time: "6 hours ago",
    preview: "Wow you're really bad at this game. Maybe you should quit...",
    fullMessage: "Wow you're really bad at this game. Maybe you should quit gaming forever. You're embarrassing yourself.",
    riskLevel: "medium",
    riskTags: ["cyberbullying", "gaming_harassment"],
    status: "acknowledged",
    aiConfidence: 78
  },
  {
    id: 4,
    platform: "TikTok",
    contact: "@randomuser456",
    time: "1 day ago",
    preview: "Nice video! You look really pretty. Want to chat privately?",
    fullMessage: "Nice video! You look really pretty. Want to chat privately? I can teach you some cool dance moves.",
    riskLevel: "medium",
    riskTags: ["inappropriate_contact", "private_chat_request"],
    status: "resolved",
    aiConfidence: 82
  }
];

const conversationHistory = [
  {
    platform: "WhatsApp",
    contact: "Best Friend Sarah",
    lastMessage: "Can't wait for the sleepover tomorrow!",
    time: "10m ago",
    messageCount: 15,
    riskLevel: "low"
  },
  {
    platform: "Instagram",
    contact: "@classmate_jenny",
    lastMessage: "Did you finish the math homework?",
    time: "1h ago",
    messageCount: 8,
    riskLevel: "low"
  },
  {
    platform: "Discord",
    contact: "Study Group",
    lastMessage: "Meeting at library at 3pm",
    time: "2h ago",
    messageCount: 23,
    riskLevel: "low"
  },
  {
    platform: "Instagram",
    contact: "@unknown_user123",
    lastMessage: "You're so stupid, nobody likes you...",
    time: "2h ago",
    messageCount: 3,
    riskLevel: "high"
  }
];

const socialMediaActivity = [
  {
    platform: "Instagram",
    activity: "Posted a photo",
    time: "1h ago",
    content: "Study session with friends #homework",
    engagement: "12 likes, 3 comments",
    riskLevel: "low"
  },
  {
    platform: "TikTok",
    activity: "Received comment",
    time: "3h ago",
    content: "Nice dance! You're really good at this",
    engagement: "From @randomuser456",
    riskLevel: "medium"
  },
  {
    platform: "Instagram",
    activity: "New follower",
    time: "5h ago",
    content: "@suspicious_account started following you",
    engagement: "0 posts, 3 followers",
    riskLevel: "high"
  }
];

export function MessagingMonitoring() {
  const [selectedMessage, setSelectedMessage] = useState<number | null>(null);
  const [searchQuery, setSearchQuery] = useState("");

  const handleAcknowledge = (messageId: number) => {
    // Handle acknowledge action
    console.log("Acknowledged message:", messageId);
  };

  const handleReport = (messageId: number) => {
    // Handle report action
    console.log("Reported message:", messageId);
  };

  const getRiskColor = (level: string) => {
    switch (level) {
      case "high": return "destructive";
      case "medium": return "secondary";
      case "low": return "outline";
      default: return "outline";
    }
  };

  const filteredMessages = flaggedMessages.filter(msg => 
    msg.contact.toLowerCase().includes(searchQuery.toLowerCase()) ||
    msg.platform.toLowerCase().includes(searchQuery.toLowerCase()) ||
    msg.preview.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="flex flex-col gap-4 p-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Messaging Monitor</h1>
        <Button size="sm" variant="outline">
          <Shield className="h-4 w-4 mr-2" />
          AI Settings
        </Button>
      </div>

      {/* Alert Summary */}
      {flaggedMessages.filter(m => m.status === "new").length > 0 && (
        <Alert className="border-red-200 bg-red-50">
          <AlertTriangle className="h-4 w-4 text-red-600" />
          <AlertDescription className="text-red-800">
            <strong>{flaggedMessages.filter(m => m.status === "new").length} new concerning messages</strong> detected. 
            {flaggedMessages.filter(m => m.riskLevel === "high" && m.status === "new").length > 0 && 
              ` ${flaggedMessages.filter(m => m.riskLevel === "high" && m.status === "new").length} require immediate attention.`
            }
          </AlertDescription>
        </Alert>
      )}

      {/* Search */}
      <Card>
        <CardContent className="p-4">
          <div className="flex items-center gap-2">
            <Search className="h-4 w-4 text-muted-foreground" />
            <Input 
              placeholder="Search messages and conversations..." 
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="flex-1"
            />
          </div>
        </CardContent>
      </Card>

      {/* Tabs */}
      <Tabs defaultValue="flagged" className="w-full">
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="flagged">
            Flagged Messages
            {flaggedMessages.filter(m => m.status === "new").length > 0 && (
              <Badge variant="destructive" className="ml-2 h-5 w-5 p-0 text-xs">
                {flaggedMessages.filter(m => m.status === "new").length}
              </Badge>
            )}
          </TabsTrigger>
          <TabsTrigger value="conversations">Conversations</TabsTrigger>
          <TabsTrigger value="social">Social Activity</TabsTrigger>
        </TabsList>

        <TabsContent value="flagged" className="space-y-3">
          {filteredMessages.length === 0 ? (
            <Card>
              <CardContent className="p-8 text-center">
                <div className="text-muted-foreground">
                  <Shield className="h-12 w-12 mx-auto mb-4 text-green-500" />
                  <h3 className="font-medium mb-2">No concerning messages</h3>
                  <p className="text-sm">AI monitoring hasn't detected any problematic content</p>
                </div>
              </CardContent>
            </Card>
          ) : (
            filteredMessages.map((message) => (
              <Card key={message.id} className={`${message.riskLevel === "high" ? "border-red-200" : ""} ${message.status === "new" ? "bg-red-50" : ""}`}>
                <CardContent className="p-4">
                  <div className="space-y-3">
                    <div className="flex items-start justify-between">
                      <div className="flex items-start gap-3">
                        <div className="w-10 h-10 bg-red-100 rounded-lg flex items-center justify-center">
                          <MessageSquare className="h-5 w-5 text-red-600" />
                        </div>
                        <div className="flex-1">
                          <div className="flex items-center gap-2 mb-1">
                            <h3 className="font-medium">{message.platform}</h3>
                            <Badge variant={getRiskColor(message.riskLevel)}>
                              {message.riskLevel} risk
                            </Badge>
                            <Badge variant="outline" className="text-xs">
                              {message.aiConfidence}% confidence
                            </Badge>
                          </div>
                          <p className="text-sm text-muted-foreground mb-1">
                            From: {message.contact} • {message.time}
                          </p>
                          
                          {/* Risk Tags */}
                          <div className="flex flex-wrap gap-1 mb-2">
                            {message.riskTags.map((tag, index) => (
                              <Badge key={index} variant="outline" className="text-xs bg-red-100 text-red-700">
                                {tag.replace("_", " ")}
                              </Badge>
                            ))}
                          </div>
                        </div>
                      </div>
                      
                      <div className="flex items-center gap-2">
                        <Badge variant={
                          message.status === "new" ? "destructive" :
                          message.status === "acknowledged" ? "secondary" : "outline"
                        }>
                          {message.status}
                        </Badge>
                        <Button 
                          size="sm" 
                          variant="ghost"
                          onClick={() => setSelectedMessage(
                            selectedMessage === message.id ? null : message.id
                          )}
                        >
                          <Eye className="h-4 w-4" />
                        </Button>
                      </div>
                    </div>

                    {/* Message Preview */}
                    <div className="p-3 bg-white rounded border">
                      <p className="text-sm italic">
                        "{selectedMessage === message.id ? message.fullMessage : message.preview}"
                      </p>
                    </div>

                    {/* Action Buttons */}
                    {message.status === "new" && (
                      <div className="flex gap-2 pt-2">
                        <Button 
                          size="sm" 
                          variant="outline"
                          onClick={() => handleAcknowledge(message.id)}
                        >
                          <Check className="h-4 w-4 mr-1" />
                          Acknowledge
                        </Button>
                        <Button 
                          size="sm" 
                          variant="destructive"
                          onClick={() => handleReport(message.id)}
                        >
                          <Flag className="h-4 w-4 mr-1" />
                          Report
                        </Button>
                      </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            ))
          )}
        </TabsContent>

        <TabsContent value="conversations" className="space-y-3">
          {conversationHistory.map((conversation, index) => (
            <Card key={index} className={conversation.riskLevel === "high" ? "border-red-200" : ""}>
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                      <MessageSquare className="h-4 w-4 text-blue-600" />
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <h3 className="font-medium">{conversation.platform}</h3>
                        <Badge variant={getRiskColor(conversation.riskLevel)}>
                          {conversation.riskLevel}
                        </Badge>
                      </div>
                      <p className="text-sm text-muted-foreground">{conversation.contact}</p>
                      <p className="text-sm mt-1 italic">"{conversation.lastMessage}"</p>
                    </div>
                  </div>
                  
                  <div className="text-right">
                    <p className="text-sm text-muted-foreground">{conversation.time}</p>
                    <p className="text-xs text-muted-foreground">{conversation.messageCount} messages</p>
                    <Button size="sm" variant="outline" className="mt-2">
                      View All
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </TabsContent>

        <TabsContent value="social" className="space-y-3">
          {socialMediaActivity.map((activity, index) => (
            <Card key={index} className={activity.riskLevel === "high" ? "border-red-200" : ""}>
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
                      <Eye className="h-4 w-4 text-purple-600" />
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <h3 className="font-medium">{activity.platform}</h3>
                        <Badge variant={getRiskColor(activity.riskLevel)}>
                          {activity.riskLevel}
                        </Badge>
                      </div>
                      <p className="text-sm text-muted-foreground">{activity.activity}</p>
                      <p className="text-sm mt-1">"{activity.content}"</p>
                      <p className="text-xs text-muted-foreground mt-1">{activity.engagement}</p>
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
          ))}
        </TabsContent>
      </Tabs>

      {/* Monitoring Statistics */}
      <Card>
        <CardHeader>
          <CardTitle>Today's Monitoring Stats</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <div className="text-2xl font-semibold">127</div>
              <p className="text-sm text-muted-foreground">Messages Scanned</p>
            </div>
            <div>
              <div className="text-2xl font-semibold text-red-600">4</div>
              <p className="text-sm text-muted-foreground">Flagged</p>
            </div>
            <div>
              <div className="text-2xl font-semibold text-green-600">98.2%</div>
              <p className="text-sm text-muted-foreground">Safe Content</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}