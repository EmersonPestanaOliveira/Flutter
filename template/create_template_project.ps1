# ============================================================
#  FLUTTER TEMPLATE GERADOR
# ============================================================

Clear-Host

Write-Host ""
Write-Host "====================================="
Write-Host " FLUTTER TEMPLATE GERADOR"
Write-Host "====================================="
Write-Host ""

# Verifica Flutter
try {
    flutter --version | Out-Null
} catch {
    Write-Host "Flutter não encontrado!" -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit
}

# Caminho
$dest = Read-Host "Informe o caminho do projeto"

if ([string]::IsNullOrWhiteSpace($dest)) {
    $dest = "$env:USERPROFILE\projetos"
}

if (!(Test-Path $dest)) {
    New-Item -ItemType Directory -Path $dest | Out-Null
}

Set-Location $dest

# Criar projeto
Write-Host ""
Write-Host "Criando projeto Flutter..."
flutter create template

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao criar projeto" -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit
}

Set-Location "template"

# Criar estrutura
Write-Host "Criando estrutura..."

$folders = @(
    "lib/core",
    "lib/core/di",
    "lib/core/network",
    "lib/core/router",
    "lib/design_system",
    "lib/features/login",
    "lib/features/home",
    "lib/features/dashboard",
    "lib/features/settings"
)

foreach ($f in $folders) {
    New-Item -ItemType Directory -Path $f -Force | Out-Null
}

Write-Host ""
Write-Host "====================================="
Write-Host "Projeto criado com sucesso!"
Write-Host "====================================="
Write-Host ""
Write-Host "Para rodar:"
Write-Host "cd template"
Write-Host "flutter run"
Write-Host ""

Read-Host "Pressione Enter para sair"