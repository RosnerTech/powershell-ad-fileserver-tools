$raiz = "D:\DADOS\"
$data = Get-Date -Format "yyyyMMdd_HHmmss"
$relatorioAntesTXT = "$raiz\Relatorio_Permissoes_ANTES_$data.txt"
$relatorioAntesCSV = "$raiz\Relatorio_Permissoes_ANTES_$data.csv"
$relatorioDepoisTXT = "$raiz\Relatorio_Permissoes_DEPOIS_$data.txt"
$relatorioDepoisCSV = "$raiz\Relatorio_Permissoes_DEPOIS_$data.csv"

function GerarRelatorio($pastas, $arquivoTXT, $arquivoCSV) {
    $dados = @()
    foreach ($pasta in $pastas) {
        $acl = Get-Acl -Path $pasta.FullName
        Add-Content -Path $arquivoTXT -Value "Pasta: $($pasta.FullName)"
        Add-Content -Path $arquivoTXT -Value "----------------------------------------"
        foreach ($entrada in $acl.Access) {
            $linha = "$($entrada.IdentityReference) | $($entrada.FileSystemRights) | $($entrada.AccessControlType)"
            Add-Content -Path $arquivoTXT -Value $linha
            $dados += [PSCustomObject]@{
                Pasta        = $pasta.FullName
                Identidade   = $entrada.IdentityReference
                Permissao    = $entrada.FileSystemRights
                TipoDeAcesso = $entrada.AccessControlType
            }
        }
        Add-Content -Path $arquivoTXT -Value "`n"
    }
    $dados | Export-Csv -Path $arquivoCSV -NoTypeInformation -Encoding UTF8
}

# Coleta subpastas
$subpastas = Get-ChildItem -Path $raiz -Directory -Recurse

# Relatório ANTES
GerarRelatorio -pastas $subpastas -arquivoTXT $relatorioAntesTXT -arquivoCSV $relatorioAntesCSV

# ACL da raiz
$aclRaiz = Get-Acl -Path $raiz

# Sincroniza permissões
foreach ($pasta in $subpastas) {
    try {
        $novaACL = New-Object System.Security.AccessControl.DirectorySecurity
        foreach ($regra in $aclRaiz.Access) {
            $novaACL.AddAccessRule($regra)
        }

        # Garante acesso para Administradores
        $temAdmin = $aclRaiz.Access | Where-Object { $_.IdentityReference -match "Administradores|Administrator" }
        if (-not $temAdmin) {
            $regraAdmin = New-Object System.Security.AccessControl.FileSystemAccessRule(
                "Administradores", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
            )
            $novaACL.AddAccessRule($regraAdmin)
        }

        $novaACL.SetAccessRuleProtection($true, $false)
        Set-Acl -Path $pasta.FullName -AclObject $novaACL

        Write-Host "✅ Permissões sincronizadas: $($pasta.FullName)"
    } catch {
        Write-Host "❌ Erro em: $($pasta.FullName)"
    }
}

# Relatório DEPOIS
GerarRelatorio -pastas $subpastas -arquivoTXT $relatorioDepoisTXT -arquivoCSV $relatorioDepoisCSV

Write-Host "Relatórios gerados:"
Write-Host "- Antes: $relatorioAntesTXT / $relatorioAntesCSV"
Write-Host "- Depois: $relatorioDepoisTXT / $relatorioDepoisCSV"
