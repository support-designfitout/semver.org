#!/bin/bash
# Verification script to check for Vercel artifacts
# Usage: ./scripts/verify_no_vercel.sh

set -e

echo "🔍 Verifying Cloudflare-only deployment setup..."
echo "==============================================="

ISSUES_FOUND=false

# Check 1: No .vercel directory
echo "1. Checking for .vercel directory..."
if [ -d ".vercel" ]; then
    echo "   ❌ FAIL: .vercel directory found"
    ISSUES_FOUND=true
else
    echo "   ✅ PASS: No .vercel directory"
fi

# Check 2: No vercel.json
echo "2. Checking for vercel.json..."
if [ -f "vercel.json" ]; then
    echo "   ❌ FAIL: vercel.json found"
    ISSUES_FOUND=true
else
    echo "   ✅ PASS: No vercel.json"
fi

# Check 3: No Vercel environment variables in files (excluding security/policy files)
echo "3. Checking for VERCEL_* environment variables..."
VERCEL_REFS=$(grep -r "VERCEL_" . --exclude-dir=.git --exclude-dir=node_modules --exclude="SECURITY.md" --exclude-dir=".githooks" --exclude-dir=".github" --exclude="verify_no_vercel.sh" 2>/dev/null || true)
if [ -n "$VERCEL_REFS" ]; then
    echo "   ❌ FAIL: VERCEL_* environment variables found in non-policy files:"
    echo "$VERCEL_REFS" | sed 's/^/      /'
    ISSUES_FOUND=true
else
    echo "   ✅ PASS: No VERCEL_* environment variables (excluding policy files)"
fi

# Check 4: No vercel.app domains (excluding security/policy files)
echo "4. Checking for vercel.app domain references..."
VERCEL_DOMAINS=$(grep -r "\.vercel\.app" . --exclude-dir=.git --exclude-dir=node_modules --exclude="SECURITY.md" --exclude-dir=".githooks" --exclude-dir=".github" --exclude="verify_no_vercel.sh" 2>/dev/null || true)
if [ -n "$VERCEL_DOMAINS" ]; then
    echo "   ❌ FAIL: vercel.app domain references found in non-policy files:"
    echo "$VERCEL_DOMAINS" | sed 's/^/      /'
    ISSUES_FOUND=true
else
    echo "   ✅ PASS: No vercel.app domains (excluding policy files)"
fi

# Check 5: SECURITY.md exists and is correct
echo "5. Checking SECURITY.md..."
if [ ! -f "SECURITY.md" ]; then
    echo "   ❌ FAIL: SECURITY.md missing"
    ISSUES_FOUND=true
elif ! grep -q "Cloudflare Pages" SECURITY.md; then
    echo "   ❌ FAIL: SECURITY.md missing Cloudflare Pages policy"
    ISSUES_FOUND=true
else
    echo "   ✅ PASS: SECURITY.md is correct"
fi

# Check 6: Git hooks are configured
echo "6. Checking git hooks configuration..."
if git config --get core.hooksPath | grep -q ".githooks"; then
    echo "   ✅ PASS: Git hooks configured"
else
    echo "   ⚠️  WARNING: Git hooks not configured (run: git config core.hooksPath .githooks)"
fi

# Check 7: Required directories and files
echo "7. Checking required files..."
REQUIRED_FILES=(
    ".github/copilot-instructions.md"
    ".github/workflows/no-vercel-guard.yml"
    ".github/ISSUE_TEMPLATE/copilot-task.yml"
    ".githooks/pre-commit"
    ".githooks/pre-push"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file exists"
    else
        echo "   ❌ FAIL: $file missing"
        ISSUES_FOUND=true
    fi
done

# Final result
echo ""
echo "==============================================="
if [ "$ISSUES_FOUND" = true ]; then
    echo "🚫 VERIFICATION FAILED"
    echo "   Fix the issues above and run again."
    exit 1
else
    echo "✅ VERIFICATION PASSED"
    echo "   Repository is properly configured for Cloudflare-only deployment."
fi