// Modified Tweak.xm for Unbound iOS Loader with Revenge Next Bundle Support
// This file integrates the RevengeCompatibilityLayer into the main Unbound loader

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RevengeCompatibilityLayer.h"
#import "NativeBridge.h"
#import "FileSystem.h"
#import "Logger.h"
#import "Settings.h"

// Discord application bundle identifier
static NSString *const DISCORD_BUNDLE_ID = @"com.hammerandchisel.discord";

// Configuration keys for Revenge integration
static NSString *const REVENGE_ENABLED_KEY = @"revenge_enabled";
static NSString *const REVENGE_AUTO_LOAD_KEY = @"revenge_auto_load";
static NSString *const REVENGE_COMPATIBILITY_MODE_KEY = @"revenge_compatibility_mode";

@interface UnboundTweak : NSObject
+ (void)initializeUnboundWithRevenge;
+ (void)handleDiscordLaunch;
+ (void)setupRevengeIntegration;
@end

@implementation UnboundTweak

+ (void)initializeUnboundWithRevenge {
    [Logger info:@"[UnboundTweak] Initializing Unbound with Revenge Next Bundle support"];
    
    // Initialize standard Unbound components first
    [self initializeStandardUnbound];
    
    // Check if Revenge integration is enabled
    if ([[Settings sharedInstance] boolForKey:REVENGE_ENABLED_KEY defaultValue:NO]) {
        [self setupRevengeIntegration];
    }
}

+ (void)initializeStandardUnbound {
    [Logger info:@"[UnboundTweak] Initializing standard Unbound components"];
    
    // Initialize core Unbound systems
    [[FileSystem sharedInstance] initialize];
    [[NativeBridge sharedInstance] initialize];
    
    // Load Unbound's main bundle
    [self loadUnboundBundle];
}

+ (void)loadUnboundBundle {
    [Logger info:@"[UnboundTweak] Loading Unbound main bundle"];
    
    // Standard Unbound bundle loading logic would go here
    // This is conceptual as the actual implementation would depend on
    // the specific structure of the Unbound iOS loader
    
    NSString *unboundBundlePath = @"/var/mobile/Documents/Unbound/bundle.js";
    if ([FileSystem exists:unboundBundlePath]) {
        // Load and execute Unbound's JavaScript bundle
        [self executeJavaScriptBundle:unboundBundlePath];
    } else {
        [Logger error:@"[UnboundTweak] Unbound bundle not found at: %@", unboundBundlePath];
    }
}

+ (void)executeJavaScriptBundle:(NSString *)bundlePath {
    [Logger info:@"[UnboundTweak] Executing JavaScript bundle: %@", bundlePath];
    
    // This would execute the JavaScript bundle in Discord's WebView context
    // Implementation would depend on how Unbound currently handles JS execution
    
    NSString *jsCode = [NSString stringWithContentsOfFile:bundlePath 
                                                 encoding:NSUTF8StringEncoding 
                                                    error:nil];
    if (jsCode) {
        // Execute JavaScript in Discord's context
        [self evaluateJavaScript:jsCode];
    }
}

+ (void)evaluateJavaScript:(NSString *)jsCode {
    // This would evaluate JavaScript in Discord's WebView
    // The actual implementation would hook into Discord's JavaScript engine
    [Logger info:@"[UnboundTweak] Evaluating JavaScript code (length: %lu)", jsCode.length];
}

+ (void)setupRevengeIntegration {
    [Logger info:@"[UnboundTweak] Setting up Revenge Next Bundle integration"];
    
    // Initialize the Revenge compatibility layer
    RevengeCompatibilityLayer *revengeLayer = [RevengeCompatibilityLayer sharedInstance];
    
    // Extend native bridge for Revenge compatibility
    [revengeLayer extendNativeBridgeForRevenge];
    
    // Load Revenge bundle if auto-load is enabled
    if ([[Settings sharedInstance] boolForKey:REVENGE_AUTO_LOAD_KEY defaultValue:YES]) {
        NSError *error;
        BOOL success = [revengeLayer loadRevengeBundleWithError:&error];
        
        if (success) {
            [Logger info:@"[UnboundTweak] Revenge Next Bundle loaded successfully"];
        } else {
            [Logger error:@"[UnboundTweak] Failed to load Revenge Next Bundle: %@", error.localizedDescription];
        }
    }
}

+ (void)handleDiscordLaunch {
    [Logger info:@"[UnboundTweak] Discord application launched"];
    
    // Perform any post-launch initialization
    [self performPostLaunchSetup];
}

+ (void)performPostLaunchSetup {
    [Logger info:@"[UnboundTweak] Performing post-launch setup"];
    
    // If Revenge is loaded, ensure it's properly integrated
    RevengeCompatibilityLayer *revengeLayer = [RevengeCompatibilityLayer sharedInstance];
    if (revengeLayer.isRevengeLoaded) {
        // Execute any post-launch Revenge logic
        [self executeRevengePostLaunchLogic];
    }
    
    // Set up runtime monitoring
    [self setupRuntimeMonitoring];
}

+ (void)executeRevengePostLaunchLogic {
    [Logger info:@"[UnboundTweak] Executing Revenge post-launch logic"];
    
    RevengeCompatibilityLayer *revengeLayer = [RevengeCompatibilityLayer sharedInstance];
    
    // Execute Revenge's Hermes bytecode if not already done
    [revengeLayer executeHermesBytecode];
    
    // Apply any additional patches that need to happen after Discord is fully loaded
    [self applyPostLaunchPatches];
}

+ (void)applyPostLaunchPatches {
    [Logger info:@"[UnboundTweak] Applying post-launch patches"];
    
    // This would apply any patches that need to happen after Discord's UI is loaded
    // For example, theme applications, UI modifications, etc.
}

+ (void)setupRuntimeMonitoring {
    [Logger info:@"[UnboundTweak] Setting up runtime monitoring"];
    
    // Set up monitoring for crashes, conflicts, or other issues
    // This could include monitoring for Metro conflicts between Unbound and Revenge
    
    // Monitor for JavaScript errors
    [self setupJavaScriptErrorMonitoring];
    
    // Monitor for native bridge conflicts
    [self setupNativeBridgeMonitoring];
}

+ (void)setupJavaScriptErrorMonitoring {
    [Logger info:@"[UnboundTweak] Setting up JavaScript error monitoring"];
    
    // This would set up error handlers to catch conflicts between
    // Unbound and Revenge JavaScript execution
}

+ (void)setupNativeBridgeMonitoring {
    [Logger info:@"[UnboundTweak] Setting up native bridge monitoring"];
    
    // Monitor for conflicts in native method calls between Unbound and Revenge
}

@end

#pragma mark - Discord Application Hooks

// Hook into Discord's application lifecycle
%hook UIApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    
    // Check if this is Discord
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleId isEqualToString:DISCORD_BUNDLE_ID]) {
        [Logger info:@"[Tweak] Discord application detected, initializing Unbound with Revenge support"];
        [UnboundTweak initializeUnboundWithRevenge];
    }
    
    return result;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    %orig;
    
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleId isEqualToString:DISCORD_BUNDLE_ID]) {
        [UnboundTweak handleDiscordLaunch];
    }
}

%end

#pragma mark - WebView Hooks for JavaScript Injection

// Hook into WebView to inject our JavaScript modifications
%hook WKWebView

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    // Intercept JavaScript evaluation to inject our modifications
    NSString *modifiedJS = [self injectUnboundAndRevengeModifications:javaScriptString];
    %orig(modifiedJS, completionHandler);
}

%new
- (NSString *)injectUnboundAndRevengeModifications:(NSString *)originalJS {
    // This would inject both Unbound and Revenge modifications into Discord's JavaScript
    
    NSMutableString *modifiedJS = [originalJS mutableCopy];
    
    // Inject Unbound modifications
    [modifiedJS appendString:[self getUnboundInjectionCode]];
    
    // Inject Revenge compatibility layer if enabled
    RevengeCompatibilityLayer *revengeLayer = [RevengeCompatibilityLayer sharedInstance];
    if (revengeLayer.isRevengeLoaded) {
        [modifiedJS appendString:[self getRevengeInjectionCode]];
    }
    
    return modifiedJS;
}

%new
- (NSString *)getUnboundInjectionCode {
    // Return JavaScript code that sets up Unbound's environment
    return @"
        // Unbound initialization code
        if (typeof window.Unbound === 'undefined') {
            window.Unbound = {
                version: '1.0.0',
                platform: 'ios',
                loader: 'unbound-ios',
                revenge_compatibility: true
            };
        }
    ";
}

%new
- (NSString *)getRevengeInjectionCode {
    // Return JavaScript code that sets up Revenge compatibility
    return @"
        // Revenge Next Bundle compatibility layer
        if (typeof window.Revenge === 'undefined') {
            window.Revenge = {
                version: '1.0.0-compatibility',
                platform: 'ios-via-unbound',
                compatibility_mode: true,
                metro: {
                    patched: true,
                    compatibility_layer: true
                }
            };
            
            // Set up Revenge globals that the bundle expects
            window.__BUILD_ENV__ = 'production';
            window.__BUILD_FLAG_LOG_PROMISE_REJECTIONS__ = false;
            
            // Set up Metro compatibility functions
            window.__revenge_metro_define = function(factory, id, deps) {
                // Redirect to Unbound's Metro handling
                if (window.Unbound && window.Unbound.metro) {
                    return window.Unbound.metro.define(factory, id, deps);
                }
            };
        }
    ";
}

%end

#pragma mark - Native Bridge Extensions

// Extend the existing NativeBridge to handle Revenge-specific calls
%hook NativeBridge

- (id)callNativeMethod:(NSString *)moduleName method:(NSString *)methodName arguments:(NSArray *)arguments {
    // Check if this is a Revenge-specific call
    if ([moduleName hasPrefix:@"Revenge"]) {
        RevengeCompatibilityLayer *revengeLayer = [RevengeCompatibilityLayer sharedInstance];
        
        if ([moduleName isEqualToString:@"RevengeLogger"]) {
            return [revengeLayer handleNativeLogging:arguments];
        } else if ([moduleName isEqualToString:@"RevengeFileSystem"]) {
            return [revengeLayer handleRevengeFileRead:arguments];
        } else if ([moduleName isEqualToString:@"RevengeThemes"]) {
            return [revengeLayer handleRevengeThemeApplication:arguments];
        }
    }
    
    // Fall back to original implementation for non-Revenge calls
    return %orig;
}

%end

#pragma mark - Settings Integration

// Add Revenge-specific settings to Unbound's settings system
%hook Settings

- (void)loadDefaultSettings {
    %orig;
    
    // Add Revenge-specific default settings
    [self setBool:NO forKey:REVENGE_ENABLED_KEY];
    [self setBool:YES forKey:REVENGE_AUTO_LOAD_KEY];
    [self setBool:YES forKey:REVENGE_COMPATIBILITY_MODE_KEY];
}

%new
- (void)enableRevengeIntegration:(BOOL)enabled {
    [self setBool:enabled forKey:REVENGE_ENABLED_KEY];
    
    if (enabled) {
        [Logger info:@"[Settings] Revenge integration enabled"];
        [UnboundTweak setupRevengeIntegration];
    } else {
        [Logger info:@"[Settings] Revenge integration disabled"];
        [[RevengeCompatibilityLayer sharedInstance] unloadRevengeBundle];
    }
}

%new
- (BOOL)isRevengeIntegrationEnabled {
    return [self boolForKey:REVENGE_ENABLED_KEY defaultValue:NO];
}

%new
- (NSDictionary *)getRevengeStatus {
    return [[RevengeCompatibilityLayer sharedInstance] getRevengeStatus];
}

%end

#pragma mark - Constructor

%ctor {
    [Logger info:@"[Tweak] Unbound iOS Loader with Revenge Next Bundle support loaded"];
    
    // Perform any early initialization that needs to happen before Discord launches
    [Logger info:@"[Tweak] Tweak constructor executed"];
}

