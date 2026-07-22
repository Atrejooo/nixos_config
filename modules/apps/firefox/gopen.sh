
#!/usr/bin/env bash

set -e

usage() {
    echo "Usage: gopen [remote-name]"
    echo "  remote-name: Name of the remote (default: origin)"
    echo "Example: gopen"
    echo "Example: gopen origin"
    echo "Example: gopen upstream"
}

# Function to convert Git URL to web URL
convert_git_url_to_web() {
    local url="$1"
    
    # Remove .git suffix if present
    url="${url%.git}"
    
    # Convert SSH URL to HTTPS URL
    # Format: git@github.com:user/repo -> https://github.com/user/repo
    if [[ "$url" == git@*:* ]]; then
        # Extract host and path
        local host_path="${url#git@}"
        local host="${host_path%:*}"
        local path="${host_path#*:}"
        url="https://${host}/${path}"
    fi
    
    echo "$url"
}

main() {
    local remote_name="${1:-origin}"
    
    # is a Git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not a Git repository" >&2
        exit 1
    fi
    
    # Get the remote URL
    local remote_url
    if ! remote_url=$(git remote get-url "$remote_name" 2>/dev/null); then
        echo "Error: Remote '$remote_name' not found" >&2
        echo "Available remotes:" >&2
        git remote
        exit 1
    fi
    
    # Convert to web URL
    local web_url
    web_url=$(convert_git_url_to_web "$remote_url")
    
    echo "Opening: $web_url"
    
    firefox "$web_url" > /dev/null 2> /dev/null & disown
}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]
    then
    usage
    exit 0
fi

main "$@"
