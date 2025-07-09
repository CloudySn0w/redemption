# Unbound iOS Loader - Revenge Next Bundle Integration

This document provides detailed information about the Revenge Next Bundle integration with the Unbound iOS Loader.

# Clarification
*This program was written entirely by an AI. As such I cannot guarantee whatsoever that this program will work, I am passionate about this but there is obviosuly only so far you can go with AI. If you know how to fix this / improve PLEASE make a PR.*

## Overview

This modified version of the Unbound iOS Loader includes a comprehensive compatibility layer that enables loading and executing the Revenge Next Bundle on iOS devices. The integration addresses the fundamental challenges of cross-platform compatibility between Android-focused Revenge Next Bundle and iOS-focused Unbound Loader.

## Key Components

### 1. RevengeCompatibilityLayer (.x/.h)

The core compatibility layer that handles:
- **Hermes Bytecode Loading**: Manages loading and execution of Revenge Next's Hermes bytecode
- **Metro Patching**: Implements Revenge's Metro bundler modifications for iOS
- **Native Bridge Extensions**: Provides Revenge-specific native method implementations
- **Plugin System Integration**: Bridges Revenge plugins with Unbound's plugin system
- **Theme System Compatibility**: Handles Revenge theme application through Unbound's theme system

### 2. Modified Tweak.xm

Enhanced main tweak file that:
- Integrates the Revenge compatibility layer into Unbound's initialization process
- Hooks into Discord's WebView for JavaScript injection
- Extends the native bridge for Revenge-specific calls
- Adds Revenge-specific settings to Unbound's configuration system
- Monitors for conflicts between Unbound and Revenge functionality

### 3. Enhanced Build System

- **Modified Makefile**: Includes Revenge compatibility flags and dependencies
- **Updated Control File**: Reflects the enhanced package with Revenge support
- **Build Targets**: Provides development, release, and debug build configurations

## Installation

### Prerequisites

1. **Jailbroken iOS Device** (iOS 14.0+)
2. **Theos Development Environment** (for building from source)
3. **ElleKit** (dependency for tweak runtime)
4. **Discord iOS App** (target application)

### Building from Source

```bash
# Clone the repository
git clone <repository-url>
cd unbound-ios-loader-revenge

# Build the package
make package

# Install on device
make install
```

### Pre-built Installation

1. Add the Unbound repository to your package manager
2. Install "Unbound iOS Loader (Revenge Compatible)"
3. Respring your device
4. Configure Revenge integration in Unbound settings

## Configuration

### Enabling Revenge Integration

1. Open Unbound settings in Discord
2. Navigate to "Advanced" → "Revenge Integration"
3. Enable "Revenge Next Bundle Support"
4. Configure auto-loading preferences
5. Restart Discord

### Configuration Files

- **Revenge Bundle**: Place in `/var/mobile/Documents/Unbound/revenge-bundle/`
- **Configuration**: `/var/mobile/Documents/Unbound/revenge-config.json`

Example configuration:
```json
{
    "version": "1.0.0",
    "platform": "ios",
    "compatibility_mode": true,
    "metro_patches": true,
    "native_bridge": true,
    "auto_load": true,
    "debug_logging": false
}
```

## Technical Implementation

### Hermes Bytecode Handling

The compatibility layer implements several strategies for handling Revenge's Hermes bytecode:

1. **Direct Execution** (if Hermes is available on iOS)
2. **Bytecode Transpilation** (converting to standard JavaScript)
3. **Simulation Mode** (for testing and development)

### Metro Patching Strategy

Revenge Next Bundle heavily modifies Discord's Metro bundler. Our implementation:

1. **Intercepts Metro Functions**: Hooks into `__d`, `__r`, `importDefault`, `importAll`
2. **Applies Revenge Patches**: Replicates the effects of Revenge's `_internal.ts`
3. **Maintains Compatibility**: Ensures Unbound's existing Metro modifications continue to work
4. **Conflict Resolution**: Manages execution order to prevent conflicts

### Native Bridge Extensions

Extended native methods for Revenge compatibility:

- `RevengeLogger.nativeLoggingHook`: Handles Revenge's native logging
- `RevengeFileSystem.readRevengeFile`: File system operations for Revenge assets
- `RevengeThemes.applyRevengeTheme`: Theme application through Unbound's system
- `RevengePlugins.loadPlugin`: Plugin loading and management

## Limitations and Known Issues

### Current Limitations

1. **Hermes Bytecode**: Full Hermes engine integration not implemented
2. **Android-Specific Features**: Some Revenge features may not work on iOS
3. **Performance**: Compatibility layer may introduce overhead
4. **Plugin Compatibility**: Not all Revenge plugins may work correctly

### Known Issues

1. **Metro Conflicts**: Potential conflicts with complex Metro modifications
2. **Memory Usage**: Increased memory usage due to dual bundle loading
3. **Stability**: Beta-level stability, may cause crashes in some scenarios

### Workarounds

- **Simulation Mode**: Use for testing without full Hermes integration
- **Selective Loading**: Disable problematic Revenge features
- **Debug Logging**: Enable for troubleshooting issues

## Development

### Building for Development

```bash
# Development build with debug logging
make debug

# Clean build
make clean

# Test installation
make test
```

### Debugging

Enable debug logging in configuration:
```json
{
    "debug_logging": true
}
```

View logs:
```bash
# Real-time log monitoring
tail -f /var/log/syslog | grep Unbound

# Or use Console app on macOS with connected device
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Implement changes with proper logging
4. Test thoroughly on multiple iOS versions
5. Submit pull request with detailed description

## Security Considerations

### Permissions

The enhanced loader requires additional permissions:
- File system access for Revenge bundle storage
- Extended native bridge capabilities
- WebView JavaScript injection rights

### Privacy

- No additional data collection beyond standard Unbound functionality
- Revenge bundle execution is sandboxed within Discord's context
- Native bridge calls are logged for security auditing

## Support

### Getting Help

1. **Documentation**: Check this README
2. **Logs**: Enable debug logging and check system logs
3. **Community**: Join Lumi/Kettu Discord Server
4. **Issues**: Report bugs on GitHub repository

### Reporting Issues

When reporting issues, include:
- iOS version and device model
- Discord version
- Revenge bundle version (if applicable)
- System logs with debug logging enabled
- Steps to reproduce the issue

## License

This project maintains the same license as the original Unbound iOS Loader (GPL-3.0). The Revenge compatibility layer is provided as an extension under the same terms.

## Disclaimer

This is an experimental integration. Use at your own risk. The developers are not responsible for any damage to your device or Discord account. Always backup your device before installation.

## Changelog

### Version 1.0.0-revenge
- Initial Revenge Next Bundle compatibility implementation
- RevengeCompatibilityLayer for cross-platform bridging
- Enhanced native bridge with Revenge-specific methods
- Metro patching compatibility layer
- Configuration system for Revenge integration
- Debug logging and monitoring capabilities

## Future Plans

- Full Hermes engine integration
- Improved plugin compatibility
- Performance optimizations
- Expanded theme system integration
- Better error handling and recovery
- Automated testing framework
