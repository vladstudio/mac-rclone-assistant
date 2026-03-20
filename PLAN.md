# Rclone Assistant — Implementation Plan

Native macOS (Sequoia 15+) SwiftUI app. Thin GUI layer over `rclone` CLI. Swift Package Manager, no Xcode project.

## Structure

```
├── Package.swift
├── Info.plist
├── .gitignore
├── build.sh
├── install.sh
├── Sources/
│   ├── RcloneAssistantApp.swift      — @main App entry
│   ├── Models.swift                  — Provider/Option/Remote models
│   ├── RcloneService.swift           — CLI wrapper (Process)
│   ├── RcloneInstaller.swift         — Check/install rclone
│   ├── MainView.swift                — Remote list (start window)
│   ├── RemoteEditorView.swift        — Add/Edit remote
│   └── OptionFieldView.swift         — Single option → SwiftUI control
└── docs/                             — (existing provider docs)
```

## Steps

### 1. Project scaffolding
- Package.swift (macOS 15), Info.plist, .gitignore, build.sh, install.sh
- Verify: `swift build` succeeds, empty window shows

### 2. Models (parsed from `rclone config providers` JSON)
- ProviderDefinition { name, description, options[], hide }
- OptionDefinition { name, help, type, default, required, advanced, isPassword, examples[], providerFilter, exclusive }
- RemoteConfig { name, type, parameters: [String: String] }
- Verify: can decode rclone's actual JSON output

### 3. RcloneService (async, runs Process)
- findRclone() → path or nil
- listRemotes() → [RemoteConfig] (via `rclone config dump`)
- loadProviders() → [ProviderDefinition] (via `rclone config providers`)
- createRemote(name, type, params) (via `rclone config create`)
- updateRemote(name, params) (via `rclone config update`)
- deleteRemote(name) (via `rclone config delete`)
- authorize(backend) → runs `rclone authorize` (for OAuth providers)
- Verify: listRemotes returns existing remotes

### 4. RcloneInstaller
- Check PATH for rclone binary
- Fallback 1: `brew install rclone`
- Fallback 2: download from https://downloads.rclone.org/rclone-current-osx-arm64.zip, unzip, copy to /usr/local/bin
- UI: simple view with progress/status
- Verify: handles "rclone not found" gracefully

### 5. MainView (start window)
- List of remotes (name, type) loaded on appear
- Add Remote button
- Per-row: Edit, Delete (with confirmation), Rename
- Refresh on return from editor
- Verify: shows existing remotes

### 6. RemoteEditorView (add/edit remote)
- Mode: .add or .edit(existingRemote)
- Step 1 (add only): name field + storage type picker (searchable)
- Step 2: dynamic form from provider schema
  - Standard options shown by default
  - "Show Advanced" toggle for advanced options
  - S3-style provider filtering: if provider has a "provider" option with Examples, show it first, then filter subsequent options by their Provider field
- Save button → create or update via rclone CLI
- OAuth: detect if provider needs auth, show "Authorize" button → `rclone authorize <backend>`
- Verify: can add SFTP remote, can edit existing

### 7. OptionFieldView (rclone type → SwiftUI control)
- string → TextField
- string + isPassword → SecureField (with show/hide toggle)
- string + examples → Picker
- bool → Toggle
- int → TextField(.numeric)
- Duration / SizeSuffix / CommaSepList / SpaceSepList / etc → TextField + help label
- Tristate → Picker (Default / True / False)
- Help text as secondary label below each field
- Required fields marked

## OAuth Flow
1. User fills config fields (client_id etc. if custom)
2. Clicks "Authorize"
3. App runs `rclone authorize "<backend>"`
4. Rclone opens browser, user logs in
5. Rclone prints token JSON to stdout
6. App captures token, stores as `token` parameter

## Deferred
- Config password management
- release.sh
- App icon
