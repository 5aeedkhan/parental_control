import { useState } from "react";
import { Button } from "./ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Badge } from "./ui/badge";
import { Shield, MapPin, Bell, Camera, Mic, Phone, MessageSquare, Calendar, Eye, Lock, ChevronRight, Check } from "lucide-react";

interface OnboardingProps {
  onComplete: () => void;
}

const onboardingSteps = [
  {
    id: "welcome",
    title: "Welcome to FamilyGuard",
    subtitle: "Your child's digital safety companion",
    description: "FamilyGuard helps you create a safe digital environment for your child while respecting their privacy and promoting healthy device habits.",
    icon: Shield,
    color: "blue"
  },
  {
    id: "features",
    title: "Comprehensive Protection",
    subtitle: "Everything you need in one app",
    description: "Monitor screen time, track location, filter content, and detect potential risks with AI-powered alerts.",
    icon: Eye,
    color: "green"
  },
  {
    id: "privacy",
    title: "Privacy First",
    subtitle: "Your family's data stays secure",
    description: "All data is encrypted and stored securely. You control what's monitored and can adjust settings anytime.",
    icon: Lock,
    color: "purple"
  }
];

const permissions = [
  {
    id: "location",
    title: "Location Access",
    description: "Track your child's location and set up safe zones",
    icon: MapPin,
    required: true,
    granted: false
  },
  {
    id: "notifications",
    title: "Notifications",
    description: "Receive alerts about important activities",
    icon: Bell,
    required: true,
    granted: false
  },
  {
    id: "camera",
    title: "Camera Access",
    description: "Monitor camera usage and detect inappropriate content",
    icon: Camera,
    required: false,
    granted: false
  },
  {
    id: "microphone",
    title: "Microphone Access",
    description: "Monitor voice calls and voice messages",
    icon: Mic,
    required: false,
    granted: false
  },
  {
    id: "contacts",
    title: "Contacts Access",
    description: "Monitor communication with unknown contacts",
    icon: Phone,
    required: false,
    granted: false
  },
  {
    id: "messages",
    title: "Messages Access",
    description: "Scan messages for cyberbullying and inappropriate content",
    icon: MessageSquare,
    required: true,
    granted: false
  },
  {
    id: "calendar",
    title: "Calendar Access",
    description: "Integrate with family schedules and school hours",
    icon: Calendar,
    required: false,
    granted: false
  }
];

export function Onboarding({ onComplete }: OnboardingProps) {
  const [currentStep, setCurrentStep] = useState(0);
  const [permissionStates, setPermissionStates] = useState(permissions);

  const handlePermissionGrant = (permissionId: string) => {
    setPermissionStates(prev => 
      prev.map(p => p.id === permissionId ? { ...p, granted: true } : p)
    );
  };

  const requiredPermissions = permissionStates.filter(p => p.required);
  const allRequiredGranted = requiredPermissions.every(p => p.granted);

  if (currentStep < onboardingSteps.length) {
    const step = onboardingSteps[currentStep];
    const IconComponent = step.icon;

    return (
      <div className="min-h-screen min-h-dvh bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 flex flex-col relative overflow-hidden">
        {/* Background Pattern */}
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-1/4 left-1/4 w-32 h-32 bg-white rounded-full blur-3xl"></div>
          <div className="absolute bottom-1/4 right-1/4 w-24 h-24 bg-white rounded-full blur-2xl"></div>
        </div>

        {/* Progress Indicator */}
        <div className="p-6 pt-8 relative z-10">
          <div className="flex items-center justify-between mb-3">
            <span className="text-sm font-medium text-white/80">
              {currentStep + 1} of {onboardingSteps.length + 1}
            </span>
            <span className="text-sm font-medium text-white/80">
              {Math.round(((currentStep + 1) / (onboardingSteps.length + 1)) * 100)}%
            </span>
          </div>
          <div className="w-full bg-white/20 rounded-full h-3">
            <div 
              className="bg-white h-3 rounded-full transition-all duration-500 shadow-lg"
              style={{ width: `${((currentStep + 1) / (onboardingSteps.length + 1)) * 100}%` }}
            />
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 flex flex-col items-center justify-center p-8 relative z-10">
          <div className="text-center space-y-10 max-w-sm">
            {/* Icon */}
            <div className="w-24 h-24 bg-white/20 backdrop-blur-xl rounded-3xl flex items-center justify-center mx-auto shadow-2xl border border-white/30">
              <IconComponent className="h-12 w-12 text-white" />
            </div>

            {/* Text */}
            <div className="space-y-6">
              <h1 className="text-3xl font-bold text-white">{step.title}</h1>
              <p className="text-xl text-white/90 font-medium">{step.subtitle}</p>
              <p className="text-white/80 leading-relaxed text-lg">{step.description}</p>
            </div>
          </div>
        </div>

        {/* Navigation */}
        <div className="p-8 relative z-10">
          <div className="flex justify-between items-center">
            <Button 
              variant="ghost" 
              onClick={() => currentStep > 0 && setCurrentStep(currentStep - 1)}
              disabled={currentStep === 0}
              className="text-white hover:bg-white/20 font-semibold"
            >
              Back
            </Button>
            
            <div className="flex space-x-3">
              {onboardingSteps.map((_, index) => (
                <div
                  key={index}
                  className={`w-3 h-3 rounded-full transition-all duration-300 ${
                    index === currentStep ? 'bg-white scale-125' : 
                    index < currentStep ? 'bg-white/60' : 'bg-white/30'
                  }`}
                />
              ))}
            </div>

            <Button 
              onClick={() => setCurrentStep(currentStep + 1)}
              className="bg-white text-indigo-600 hover:bg-white/90 font-semibold px-6 rounded-xl shadow-lg"
            >
              Next
              <ChevronRight className="h-4 w-4 ml-1" />
            </Button>
          </div>
        </div>
      </div>
    );
  }

  // Permissions Step
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 flex flex-col">
      {/* Progress Indicator */}
      <div className="p-4">
        <div className="flex items-center justify-between mb-2">
          <span className="text-sm text-gray-600">
            {onboardingSteps.length + 1} of {onboardingSteps.length + 1}
          </span>
          <span className="text-sm text-gray-600">100%</span>
        </div>
        <div className="w-full bg-gray-200 rounded-full h-2">
          <div className="bg-gradient-to-r from-blue-500 to-purple-600 h-2 rounded-full w-full" />
        </div>
      </div>

      {/* Header */}
      <div className="p-8 text-center">
        <h1 className="text-2xl font-bold text-gray-900 mb-2">Grant Permissions</h1>
        <p className="text-gray-600">Allow FamilyGuard to protect your child effectively</p>
      </div>

      {/* Permissions List */}
      <div className="flex-1 px-4 pb-4 space-y-3 overflow-y-auto">
        {permissionStates.map((permission) => {
          const IconComponent = permission.icon;
          return (
            <Card key={permission.id} className="relative">
              <CardContent className="p-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                      <IconComponent className="h-5 w-5 text-blue-600" />
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center gap-2">
                        <h3 className="font-medium">{permission.title}</h3>
                        {permission.required && (
                          <Badge variant="destructive" className="text-xs">Required</Badge>
                        )}
                      </div>
                      <p className="text-sm text-gray-600">{permission.description}</p>
                    </div>
                  </div>
                  
                  <div className="flex items-center">
                    {permission.granted ? (
                      <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center">
                        <Check className="h-4 w-4 text-green-600" />
                      </div>
                    ) : (
                      <Button 
                        size="sm"
                        onClick={() => handlePermissionGrant(permission.id)}
                      >
                        Grant
                      </Button>
                    )}
                  </div>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>

      {/* Footer */}
      <div className="p-8">
        <Button 
          className="w-full" 
          size="lg"
          disabled={!allRequiredGranted}
          onClick={onComplete}
        >
          {allRequiredGranted ? "Continue to Setup" : `Grant ${requiredPermissions.filter(p => !p.granted).length} Required Permissions`}
        </Button>
        
        <p className="text-xs text-gray-500 text-center mt-4">
          You can change these permissions later in Settings
        </p>
      </div>
    </div>
  );
}