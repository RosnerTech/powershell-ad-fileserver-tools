Import-Module ActiveDirectory

$caminhoCSV = "D:\DADOS\UsuariosPorGrupo.csv"
$caminhoTXT = "D:\DADOS\UsuariosPorGrupo.txt"
$listaUsuarios = @()

Clear-Content -Path $caminhoTXT -ErrorAction SilentlyContinue
$grupos = Get-ADGroup -Filter *

foreach ($grupo in $grupos) {
    Add-Content -Path $caminhoTXT -Value "Grupo: $($grupo.Name)"
    Add-Content -Path $caminhoTXT -Value "----------------------------------------"

    try {
        $membros = Get-ADGroupMember -Identity $grupo.DistinguishedName -Recursive | Where-Object { $_.objectClass -eq 'user' }

        foreach ($usuario in $membros) {
            $dadosUsuario = Get-ADUser -Identity $usuario.SamAccountName -Properties Name, SamAccountName
            Add-Content -Path $caminhoTXT -Value "Nome: $($dadosUsuario.Name) | Conta: $($dadosUsuario.SamAccountName)"

            $listaUsuarios += [PSCustomObject]@{
                Grupo = $grupo.Name
                Nome  = $dadosUsuario.Name
                Conta = $dadosUsuario.SamAccountName
            }
        }
    } catch {
        Add-Content -Path $caminhoTXT -Value "Erro ao acessar membros do grupo: $($grupo.Name)"
        $listaUsuarios += [PSCustomObject]@{
            Grupo = $grupo.Name
            Nome  = "Erro ao acessar membros"
            Conta = ""
        }
    }

    Add-Content -Path $caminhoTXT -Value "`n"
}

$listaUsuarios | Export-Csv -Path $caminhoCSV -NoTypeInformation -Encoding UTF8
