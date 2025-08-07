$diretorioBase = "D:\DADOS"
$arquivoTXT = "$diretorioBase\PermissoesPastas.txt"
$arquivoCSV = "$diretorioBase\PermissoesPastas.csv"
$dadosCSV = @()

Clear-Content -Path $arquivoTXT -ErrorAction SilentlyContinue
$pastas = Get-ChildItem -Path $diretorioBase -Directory

foreach ($pasta in $pastas) {
    $caminho = $pasta.FullName
    Add-Content -Path $arquivoTXT -Value "Pasta: $caminho"
    Add-Content -Path $arquivoTXT -Value "----------------------------------------"

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

    Add-Content -Path $arquivoTXT -Value "`n"
}

$dadosCSV | Export-Csv -Path $arquivoCSV -NoTypeInformation -Encoding UTF8
