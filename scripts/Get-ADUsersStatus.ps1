Import-Module ActiveDirectory

$caminhoCSV = "D:\DADOS\UsuariosAtivos.csv"
$caminhoTXT = "D:\DADOS\UsuariosAtivos.txt"
$usuarios = Get-ADUser -Filter * -Properties Name, SamAccountName, Enabled

Clear-Content -Path $caminhoTXT -ErrorAction SilentlyContinue
$dadosCSV = @()

foreach ($usuario in $usuarios) {
    $status = if ($usuario.Enabled) { "Ativo" } else { "Inativo" }
    Add-Content -Path $caminhoTXT -Value "Nome: $($usuario.Name) | Conta: $($usuario.SamAccountName) | Status: $status"

    $dadosCSV += [PSCustomObject]@{
        Nome   = $usuario.Name
        Conta  = $usuario.SamAccountName
        Status = $status
    }
}

$dadosCSV | Export-Csv -Path $caminhoCSV -NoTypeInformation -Encoding UTF8
