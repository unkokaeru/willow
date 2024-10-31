#!/bin/bash -e

# This script takes care of:
# 1. Updating the version number in the rockspec file.
# 2. Generating a new changelog based on the commit history.
# 3. Committing the changes to the git repository.
# 4. Creating a new tag for the release.
# 5. Building the package.
# 6. Publishing the package to LuaRocks.

# The script takes the type of version to release ('major', 'minor', or 'patch') as an argument.

# Error codes:
# 1 - Uncommitted changes in the git repository
# 2 - Invalid version type
# 3 - Failed to update the rockspec file
# 4 - Failed to generate changelog
# 5 - Failed to pull the latest changes from the remote repository

# Function to bump the version number
bump_version() {
    local version="$1"
    local bump_type="$2"
    IFS='.' read -r major minor patch <<< "$version"

    case "$bump_type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo "Invalid bump type: $bump_type"
            exit 2
            ;;
    esac

    echo "$major.$minor.$patch"
}

# Check if the git repo has any uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    echo "There are uncommitted changes in the git repository. Please commit or stash them before releasing."
    exit 1
fi

# Check if an argument was passed
if [ -z "$1" ]; then
    echo "No version type supplied. Please specify 'major', 'minor', or 'patch'."
    exit 2
fi

# Validate the argument as a version type
if [[ "$1" != "major" && "$1" != "minor" && "$1" != "patch" ]]; then
    echo "Invalid version type. Please specify 'major', 'minor', or 'patch'."
    exit 2
fi

# Get the current version from the rockspec file
current_version=$(grep 'version =' willow-*.rockspec | sed -E 's/.*"([^"]+)".*/\1/')

# Generate a new changelog
echo "Generating a new changelog..."
gitchangelog > CHANGELOG.md
git add CHANGELOG.md
git commit -m "chore: update changelog"
echo "Changelog generated successfully."

# Update the version number in the rockspec file
echo "Updating the rockspec version number..."
new_version=$(bump_version "$current_version" "$1")  # Call the version bump function
sed -i "s/version = \"$current_version\"/version = \"$new_version\"/" willow-*.rockspec

# Commit the version bump to the git repository
echo "Committing version bump to the git repository..."
git add willow-*.rockspec
git commit -m "chore: bump version from $current_version to $new_version"
echo "Version bump committed successfully."

# Pull the latest changes from the remote repository
git config pull.rebase true  # Ensure that the pull is a rebase
echo "Pulling the latest changes from the remote repository..."
if ! git pull origin main; then
    echo "Failed to pull the latest changes from the remote repository."
    exit 5
fi

# Create a new tag and push it to the remote repository
echo "Creating a new tag for the release..."
git tag -a "v$new_version" -m "Release $new_version"
echo "Pushing the new tag to the remote repository..."
git push --follow-tags
echo "Release $new_version created successfully."

# Build the package for LuaRocks
echo "Building the package..."
luarocks build willow-*.rockspec
echo "Package built successfully."

# Publish the package to LuaRocks
if [ -z "$2" ]; then
    echo "No LUA_TOKEN provided. Skipping publish step."
else
    echo "Publishing the package to LuaRocks..."
    luarocks upload willow-*.rockspec --token="$2"
    echo "Package published to LuaRocks successfully."
fi