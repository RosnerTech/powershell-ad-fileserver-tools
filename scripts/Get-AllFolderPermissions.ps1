$diretorioBase = "D:\DADOS"
$arquivoTXT = "$diretorioBase\PermissoesPastas.txt"
$arquivoCSV = "$diretorioBase\PermissoesPastas.csv"
$dadosCSV = @()

Clear-Content -Path $arquivoTXT -ErrorAction SilentlyContinue

# Obtém todas as pastas e subpastas
$pastas = Get-ChildItem -Path $diretorioBase -Directory -Recurse

foreach ($pasta in $pastas) {
    $caminho = $pasta.FullName
    Add-Content -Path $arquivoTXT -Value "Pasta: $caminho"
    Add-Content -Path $arquivoTXT -Value "----------------------------------------"

    try {
        $acl = Get-Acl -Path $caminho

        foreach ($entrada in $acl.Access) {
            $identidade = $entrada.IdentityReference
            $permissao = $entrada.FileSystemRights
            $tipo = $entrada.AccessControlType

            Add-Content -Path $arquivoTXT -Value "$identidade | $permissao | $tipo"

            $dadosCSV += [PSCustomObject]@{
                Pasta        = $caminho
                Identidade   = $identidade
                Permissao    = $permissao
                TipoDeAcesso = $tipo
            }
        }
    } catch {
        Add-Content -Path $arquivoTXT -Value "Erro ao acessar ACL da pasta: $caminho"
        $dadosCSV += [PSCustomObject]@{
            Pasta        = $caminho
            Identidade   = "Erro"
            Permissao    = ""
            TipoDeAcesso = ""
        }
    }

    Add-Content -Path $arquivoTXT -Value "`n"
}

# Exporta para CSV
$dadosCSV | Export-Csv -Path $arquivoCSV -NoTypeInformation -Encoding UTF8

Write-Host "Relatórios gerados:"
Write-Host "- TXT: $arquivoTXT"
Write-Host "- CSV: $arquivoCSV"
