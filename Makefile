ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = redemption

redemption_FILES = sources/Tweak.xm \
                            sources/FileSystem.m \
                            sources/Logger.m \
                            sources/NativeBridge.x \
                            sources/Plugins.m \
                            sources/Settings.m \
                            sources/Themes.x \
                            sources/Recovery.x \
                            sources/Fonts.x \
                            sources/Misc.x \
                            RevengeCompatibilityLayer.x

redemption_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
redemption_CCFLAGS = -std=c++17
redemption_LDFLAGS = -lc++

# Framework dependencies
redemption_FRAMEWORKS = UIKit Foundation CoreFoundation JavaScriptCore WebKit

# Private framework dependencies (if needed)
redemption_PRIVATE_FRAMEWORKS = 

# Additional libraries
redemption_LIBRARIES = 

# Bundle filter for Discord
redemption_FILTER = com.hammerandchisel.discord

# Install location
redemption_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS_MAKE_PATH)/tweak.mk

# Custom build flags for Revenge compatibility
ADDITIONAL_CFLAGS = -DREVENGE_COMPATIBILITY_ENABLED=1 \
                   -DHERMES_BYTECODE_SUPPORT=1 \
                   -DMETRO_PATCHING_ENABLED=1

# Add custom flags to compilation
redemption_CFLAGS += $(ADDITIONAL_CFLAGS)

# Post-build actions
after-install::
	install.exec "killall -9 Discord || true"
	install.exec "uicache -p /Applications/Discord.app || true"

# Clean target
clean::
	rm -rf $(THEOS_OBJ_DIR)
	rm -rf packages/*

# Package information
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

# Development build target
dev: clean all package install

# Release build target  
release: clean
	$(MAKE) FINALPACKAGE=1 package

# Debug build with additional logging
debug: clean
	$(MAKE) DEBUG=1 ADDITIONAL_CFLAGS="$(ADDITIONAL_CFLAGS) -DDEBUG_LOGGING=1" all package install

# Test target for validation
test: install
	@echo "Testing Unbound with Revenge compatibility..."
	@echo "Please launch Discord and check the logs for successful initialization"

# Documentation generation (if needed)
docs:
	@echo "Generating documentation for Revenge compatibility layer..."
	@echo "See Context.md for detailed information about the integration"

.PHONY: dev release debug test docs
