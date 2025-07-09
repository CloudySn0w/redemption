#import <Foundation/Foundation.h>

@interface RevengeCompatibilityLayer : NSObject

@property (nonatomic, readonly) BOOL isRevengeLoaded;
@property (nonatomic, strong) NSMutableDictionary *revengeModules;
@property (nonatomic, strong) NSMutableArray *metroPatches;
@property (nonatomic, strong) NSData *hermesBytecode;

// Original Metro function pointers (for restoration)
@property (nonatomic, assign) void *originalMetroDefine;
@property (nonatomic, assign) void *originalMetroRequire;
@property (nonatomic, assign) void *originalMetroImportDefault;
@property (nonatomic, assign) void *originalMetroImportAll;

+ (instancetype)sharedInstance;

#pragma mark - Bundle Loading
- (BOOL)loadRevengeBundleWithError:(NSError **)error;
- (NSDictionary *)loadRevengeConfiguration;
- (void)unloadRevengeBundle;

#pragma mark - Hermes Bytecode Handling
- (BOOL)loadHermesBytecode:(NSString *)bundlePath;
- (void)executeHermesBytecode;
- (void)evaluateJavaScriptFromBytecode:(NSData *)bytecode;
- (void)simulateRevengeExecution;

#pragma mark - Metro Compatibility Layer
- (void)initializeMetroCompatibilityLayer;
- (void)applyMetroPatches;
- (void)patchMetroDefine;
- (void)patchMetroRequire;
- (void)patchMetroImports;
- (void)simulateMetroPatching;

#pragma mark - Native Bridge Extensions
- (void)extendNativeBridgeForRevenge;
- (void)registerRevengeNativeMethods;
- (id)handleNativeLogging:(NSArray *)arguments;
- (id)handleRevengeFileRead:(NSArray *)arguments;
- (id)handleRevengeThemeApplication:(NSArray *)arguments;

#pragma mark - Plugin System Integration
- (void)simulatePluginLoading;
- (void)simulateThemeApplication;

#pragma mark - Preinit Execution
- (void)executeRevengePreinit;
- (void)applyEarlyPatches;
- (void)initializeRevengeGlobals;
- (void)setupMetroSubscriptions;

#pragma mark - Cleanup and Management
- (void)restoreOriginalMetroFunctions;
- (NSDictionary *)getRevengeStatus;

@end

