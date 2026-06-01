<#
.SYNOPSIS
    Claude Code Toolkit 一键部署脚本
.DESCRIPTION
    将 toolkit 中的模板、记忆条目部署到目标项目。
    模板文件：覆盖（CLAUDE.md、settings）
    记忆文件：新文件添加，已有文件比较时间戳后决定是否更新
.PARAMETER ProjectPath
    目标项目的绝对路径（必需）
.PARAMETER MemoryOnly
    仅部署记忆条目，不创建/覆盖项目模板文件
.PARAMETER Slug
    项目的短标识符（默认取 ProjectPath 最后一级目录名）
.PARAMETER Force
    强制覆盖已存在的 CLAUDE.md
.EXAMPLE
    .\deploy.ps1 -ProjectPath "D:\Projects\my-app"
.EXAMPLE
    .\deploy.ps1 -ProjectPath "D:\Projects\my-app" -MemoryOnly
.EXAMPLE
    .\deploy.ps1 -ProjectPath "D:\Projects\my-app" -Slug "shared-memory"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [switch]$MemoryOnly,

    [string]$Slug,

    [switch]$Force
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ---------------------------------------------------------------------------
# 辅助函数
# ---------------------------------------------------------------------------

function Write-Step {
    param([string]$Message)
    Write-Host "  [$([char]0x2713)] $Message" -ForegroundColor Green
}

function Write-Skip {
    param([string]$Message)
    Write-Host "  [$([char]0x2192)] $Message (跳过)" -ForegroundColor Yellow
}

function Write-Warn {
    param([string]$Message)
    Write-Host "  [!] $Message" -ForegroundColor Magenta
}

function Write-Backup {
    param([string]$Path)
    Write-Host "      (备份: $Path.bak)" -ForegroundColor DarkGray
}

# ---------------------------------------------------------------------------
# 参数处理
# ---------------------------------------------------------------------------

# 规范化项目路径
$ProjectPath = [System.IO.Path]::GetFullPath($ProjectPath)
$ProjectName = Split-Path -Leaf $ProjectPath

if (-not $Slug) {
    # 默认 slug：目录名转小写、空格和特殊字符转连字符
    $Slug = $ProjectName -replace '[^\w\d-]', '-' -replace '-+', '-'
    $Slug = $Slug.Trim('-')
}

$memoryDestRoot = "$env:USERPROFILE\.claude\projects\$Slug\memory"

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host " Claude Code Toolkit 部署" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  目标项目 : $ProjectPath"
Write-Host "  项目标识 : $Slug"
Write-Host "  记忆目录 : $memoryDestRoot"
Write-Host "-------------------------------------" -ForegroundColor DarkGray
Write-Host ""

# ---------------------------------------------------------------------------
# 第 1 步：创建目录
# ---------------------------------------------------------------------------

Write-Host "[1/4] 创建目录结构" -ForegroundColor Cyan

if (-not (Test-Path $ProjectPath)) {
    New-Item -ItemType Directory -Path $ProjectPath -Force | Out-Null
    Write-Step "创建项目目录: $ProjectPath"
} else {
    Write-Skip "项目目录已存在: $ProjectPath"
}

$claudeDir = Join-Path $ProjectPath ".claude"
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
    Write-Step "创建 .claude 目录"
} else {
    Write-Skip ".claude 目录已存在"
}

if (-not (Test-Path $memoryDestRoot)) {
    New-Item -ItemType Directory -Path $memoryDestRoot -Force | Out-Null
    Write-Step "创建记忆目录: $memoryDestRoot"
} else {
    Write-Skip "记忆目录已存在"
}

# ---------------------------------------------------------------------------
# 第 2 步：部署项目模板（除非 -MemoryOnly）
# ---------------------------------------------------------------------------

Write-Host ""
Write-Host "[2/4] 部署项目模板" -ForegroundColor Cyan

if ($MemoryOnly) {
    Write-Skip "MemoryOnly 模式，跳过模板部署"
} else {
    # --- CLAUDE.md ---
    $templateClaudeMd = Join-Path $scriptDir "templates\CLAUDE-md-template.md"
    $targetClaudeMd = Join-Path $ProjectPath "CLAUDE.md"

    if (Test-Path $targetClaudeMd) {
        if ($Force) {
            Copy-Item $targetClaudeMd -Destination "$targetClaudeMd.bak" -Force
            Write-Backup $targetClaudeMd
            Copy-Item $templateClaudeMd -Destination $targetClaudeMd -Force
            Write-Step "CLAUDE.md 已覆盖（--Force）"
        } else {
            Write-Skip "CLAUDE.md 已存在（使用 --Force 强制覆盖）"
        }
    } else {
        Copy-Item $templateClaudeMd -Destination $targetClaudeMd
        Write-Step "CLAUDE.md 已创建（请根据项目修改占位符）"
    }

    # --- settings.local.json ---
    $templateSettings = Join-Path $scriptDir "templates\settings-template.json"
    $targetSettings = Join-Path $claudeDir "settings.local.json"

    if (Test-Path $targetSettings) {
        Write-Skip "settings.local.json 已存在"
    } else {
        Copy-Item $templateSettings -Destination $targetSettings
        Write-Step "settings.local.json 已创建"
    }

    # --- .gitignore ---
    $gitignore = Join-Path $ProjectPath ".gitignore"
    if (-not (Test-Path $gitignore)) {
        @"
# Claude Code
.claude/settings.local.json
.claude/worktrees/

# Python
__pycache__/
*.pyc
.venv/
*.egg-info/
dist/
build/

# OS
.DS_Store
Thumbs.db
"@ | Out-File -FilePath $gitignore -Encoding UTF8
        Write-Step ".gitignore 已创建"
    } else {
        Write-Skip ".gitignore 已存在"
    }
}

# ---------------------------------------------------------------------------
# 第 3 步：部署记忆条目
# ---------------------------------------------------------------------------

Write-Host ""
Write-Host "[3/4] 部署记忆条目" -ForegroundColor Cyan

$memorySourceDir = Join-Path $scriptDir "memory"
$memoryFiles = Get-ChildItem -Path $memorySourceDir -File -Exclude "MEMORY.md"

$added = 0
$updated = 0
$skipped = 0

foreach ($file in $memoryFiles) {
    $destPath = Join-Path $memoryDestRoot $file.Name

    if (-not (Test-Path $destPath)) {
        # 新文件：直接拷贝
        Copy-Item $file.FullName -Destination $destPath
        Write-Step "新增: $($file.Name)"
        $added++
    } else {
        # 已存在：比较修改时间
        if ($file.LastWriteTime -gt (Get-Item $destPath).LastWriteTime) {
            Copy-Item $destPath -Destination "$destPath.bak" -Force
            Write-Backup $destPath
            Copy-Item $file.FullName -Destination $destPath -Force
            Write-Step "更新: $($file.Name)"
            $updated++
        } else {
            Write-Skip "相同或更新: $($file.Name)"
            $skipped++
        }
    }
}

# --- MEMORY.md 索引合并 ---
$sourceMemoryMd = Join-Path $memorySourceDir "MEMORY.md"
$destMemoryMd = Join-Path $memoryDestRoot "MEMORY.md"

if (-not (Test-Path $destMemoryMd)) {
    Copy-Item $sourceMemoryMd -Destination $destMemoryMd
    Write-Step "MEMORY.md 索引已创建"
} else {
    # 读取两边的行
    $sourceLines = Get-Content $sourceMemoryMd | Where-Object { $_ -match '^\s*-\s+\[' }
    $destContent = Get-Content $destMemoryMd
    $destLines = $destContent | Where-Object { $_ -match '^\s*-\s+\[' }

    $newLines = @()
    foreach ($line in $sourceLines) {
        # 提取链接目标文件名作为唯一标识
        if ($line -match '\]\(([^)]+)\)') {
            $linkTarget = $Matches[1]
            $alreadyExists = ($destLines | Where-Object { $_ -match [regex]::Escape($linkTarget) }).Count -gt 0
            if (-not $alreadyExists) {
                $newLines += $line
            }
        }
    }

    if ($newLines.Count -gt 0) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
        $insertMarker = "# Memory Index"
        $newContent = @()
        $inserted = $false

        foreach ($line in $destContent) {
            $newContent += $line
            if (-not $inserted -and $line.Trim() -eq $insertMarker) {
                # 在索引标题后插入新条目
                foreach ($nl in $newLines) {
                    $newContent += $nl
                }
                $newContent += ""  # 空行分隔
                $inserted = $true
            }
        }

        if (-not $inserted) {
            # 没有找到标题，追加到末尾
            $newContent += ""
            $newContent += "## 由 toolkit 添加 ($timestamp)"
            foreach ($nl in $newLines) {
                $newContent += $nl
            }
        }

        $newContent | Out-File -FilePath $destMemoryMd -Encoding UTF8
        Write-Warn "MEMORY.md 已合并 $($newLines.Count) 个新条目"
    } else {
        Write-Skip "MEMORY.md 无新条目"
    }
}

# ---------------------------------------------------------------------------
# 第 4 步：总结
# ---------------------------------------------------------------------------

Write-Host ""
Write-Host "[4/4] 部署完成" -ForegroundColor Cyan
Write-Host ""
Write-Host "-------------------------------------" -ForegroundColor DarkGray
Write-Host " 模板文件 :" -ForegroundColor White
if (-not $MemoryOnly) {
    Write-Host "   CLAUDE.md                  $ProjectPath\CLAUDE.md"
    Write-Host "   settings.local.json        $claudeDir\settings.local.json"
    Write-Host "   .gitignore                 $gitignore"
}
Write-Host " 记忆条目 : $added 新增, $updated 更新, $skipped 跳过"
Write-Host " 记忆路径 : $memoryDestRoot"
Write-Host "-------------------------------------" -ForegroundColor DarkGray
Write-Host ""

# 如果不是 MemoryOnly 模式，给出下一步提示
if (-not $MemoryOnly) {
    Write-Host "下一步：" -ForegroundColor Yellow
    Write-Host "  1. 编辑 $ProjectPath\CLAUDE.md，将占位符替换为项目实际内容"
    Write-Host "  2. 根据项目修改 $claudeDir\settings.local.json"
    Write-Host "  3. 运行 'git init' 初始化版本控制（如需要）"
    Write-Host ""
}
