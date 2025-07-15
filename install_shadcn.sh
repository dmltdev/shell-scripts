#!/bin/bash
# Script to install all shadcn/ui components using pnpm

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

if ! command -v pnpm &> /dev/null; then
    print_error "pnpm is not installed. Please install pnpm first."
    exit 1
fi

if [ ! -f "components.json" ]; then
    print_error "components.json not found. Please run 'pnpm dlx shadcn-ui@latest init' first."
    exit 1
fi

print_status "Starting shadcn/ui components installation..."

components=(
    "accordion"
    "alert"
    "alert-dialog"
    "aspect-ratio"
    "avatar"
    "badge"
    "breadcrumb"
    "button"
    "calendar"
    "card"
    "carousel"
    "chart"
    "checkbox"
    "collapsible"
    "combobox"
    "command"
    "context-menu"
    "data-table"
    "date-picker"
    "dialog"
    "drawer"
    "dropdown-menu"
    "form"
    "hover-card"
    "input"
    "input-otp"
    "label"
    "menubar"
    "navigation-menu"
    "pagination"
    "popover"
    "progress"
    "radio-group"
    "resizable"
    "scroll-area"
    "select"
    "separator"
    "sheet"
    "skeleton"
    "slider"
    "sonner"
    "switch"
    "table"
    "tabs"
    "textarea"
    "toast"
    "toggle"
    "toggle-group"
    "tooltip"
)

total_components=${#components[@]}
installed_count=0
failed_count=0
failed_components=()

print_status "Found ${total_components} components to install"

for component in "${components[@]}"; do
    print_status "Installing ${component}... ($(($installed_count + $failed_count + 1))/${total_components})"
    
    if pnpm dlx shadcn@latest add "${component}" --yes; then
        print_success "✓ ${component} installed successfully"
        ((installed_count++))
    else
        print_warning "✗ Failed to install ${component}"
        ((failed_count++))
        failed_components+=("${component}")
    fi
    
    sleep 0.5
done

echo ""
print_status "=== Installation Summary ==="
print_success "Successfully installed: ${installed_count}/${total_components} components"

if [ ${failed_count} -gt 0 ]; then
    print_warning "Failed to install: ${failed_count}/${total_components} components"
    print_warning "Failed components: ${failed_components[*]}"
    echo ""
    print_status "You can try to install failed components manually:"
    for failed_component in "${failed_components[@]}"; do
        echo "  pnpm dlx shadcn@latest add ${failed_component}"
    done
fi

echo ""
if [ ${failed_count} -eq 0 ]; then
    print_success "🎉 All shadcn/ui components installed successfully!"
    exit 0
else
    print_warning "⚠️  Installation completed with some failures. Check the summary above."
    exit 1
fi