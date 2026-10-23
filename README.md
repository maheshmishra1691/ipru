# Git and GitHub setup for the office laptop

Official Windows installers, copied here because the office laptop blocks normal downloads. Nothing in this folder is modified.

Use this on a **Windows 64-bit** laptop. Sign in to GitHub in the browser first. This repository is private.

## On the office laptop

1. Open https://github.com/maheshmishra1691/ipru and sign in as `maheshmishra1691`.
2. Click the green **Code** button, then **Download ZIP**.
3. Unzip the download. You should see a `windows` folder.
4. Open the `windows` folder and double-click **`setup-office-laptop.bat`**.
5. When GitHub Desktop’s installer opens, click through it. It installs for your user only.
6. A command window opens with Git and GitHub CLI ready. Sign in once:

```bat
gh auth login
```

Choose GitHub.com, HTTPS, and login with a browser.

## If a program install is allowed

Double-click `windows\Git-2.56.0.3-64-bit.exe` and accept the defaults. That installs Git for every user, including Git Bash. You can still run `setup-office-laptop.bat` for GitHub CLI and GitHub Desktop.

## If you cannot download the ZIP

Copy the whole `ipru` folder from this Mac onto a USB drive, then run `windows\setup-office-laptop.bat` on the office laptop.

## What is included

| File | What it is |
|---|---|
| `Git-2.56.0.3-64-bit.exe` | Git for Windows 2.56.0.3 installer |
| `PortableGit-2.56.0.3-64-bit.7z.exe` | Same Git, no administrator rights. The setup script uses this. |
| `gh_2.103.0_windows_amd64.zip` | GitHub CLI 2.103.0 (`gh`) |
| `desktop\GitHubDesktopSetup-x64.exe.001`–`.003` | GitHub Desktop 3.6.7, split so GitHub accepts the upload. The setup script joins these back together. |

GitHub Desktop’s single installer is 226 MB. GitHub rejects files over 100 MB, so it is stored as three parts.

## If Git Bash says `gh: command not found`

Git is on the system PATH. `gh` is not, until this is run once inside Git Bash. Close Git Bash afterwards and open it again.

```bash
GHZIP=$(find "$HOME/Downloads" "$HOME/Desktop" "$HOME" -name "gh_2.103.0_windows_amd64.zip" 2>/dev/null | head -n 1)
echo "Using $GHZIP"
mkdir -p "$HOME/GitHubTools/gh"
tar -xf "$GHZIP" -C "$HOME/GitHubTools/gh"
export PATH="$PATH:$HOME/GitHubTools/gh/bin"
grep -q 'GitHubTools/gh/bin' "$HOME/.bashrc" 2>/dev/null || echo 'export PATH="$PATH:$HOME/GitHubTools/gh/bin"' >> "$HOME/.bashrc"
gh --version
```

`gh version 2.103.0` means it worked.

## After setup

Open a new Git Bash window, or open **Git and GitHub Prompt** on the Desktop.

Check the tools:

```bash
git --version
gh --version
```

Clone a repository:

```bat
gh repo clone maheshmishra1691/ipru
```

## Source and licenses

These are the official releases, unchanged.

- Git for Windows 2.56.0.3 (GPL-2.0). Source: https://github.com/git-for-windows/git/releases/tag/v2.56.0.windows.3
- GitHub CLI 2.103.0 (MIT). Source: https://github.com/cli/cli/releases/tag/v2.103.0
- GitHub Desktop 3.6.7 (MIT). Source: https://github.com/desktop/desktop/releases/tag/release-3.6.7

SHA-256 checksums are in `windows\CHECKSUMS.txt`.
