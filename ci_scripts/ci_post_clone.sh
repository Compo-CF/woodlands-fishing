#!/bin/sh
# Xcode Cloud ci_post_clone.sh
#
# Apple's Xcode Cloud runs this script after cloning the repository and
# before it tries to build. Because we don't check in the .xcodeproj
# (XcodeGen generates it from project.yml on demand), we use this hook
# to install XcodeGen and produce the project file. Without this, the
# Xcode Cloud build can't find anything to compile.

set -e

echo "🔧 Installing XcodeGen via Homebrew..."
brew install xcodegen

echo "📐 Generating WoodlandsFishing.xcodeproj from project.yml..."
xcodegen generate

echo "✅ Xcode project ready for Xcode Cloud build."
