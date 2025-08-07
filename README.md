# 🧰 PowerShell AD & File Server Toolkit

🔧 Scripts PowerShell para automatizar tarefas administrativas em servidores Windows com Active Directory e File Server. Foco em **relatórios de usuários, grupos e permissões**, além de sincronização de ACL.

---

## 📂 Scripts Disponíveis

| Script                        | Descrição |
|------------------------------|-----------|
| `Get-ADUsersStatus.ps1`      | 🔍 Lista todos os usuários do AD e indica se estão Ativos ou Inativos |
| `Get-ADGroupsAndMembers.ps1` | 👥 Lista todos os grupos do AD e os membros de cada grupo |
| `Get-FolderPermissions.ps1`  | 📁 Gera relatório das permissões de pastas no nível superior |
| `Get-AllFolderPermissions.ps1` | 🧱 Gera relatório completo das permissões de pastas e subpastas |
| `Sync-FolderPermissions.ps1` | 🔄 Sincroniza permissões das subpastas com base na pasta raiz |

---

## ⚙️ Requisitos

- PowerShell 5.x ou superior
- Permissões administrativas
- Módulo `ActiveDirectory` (para scripts do AD)

---

## 💡 Recomendações

- Execute com PowerShell em modo **Administrador**
- Use um diretório central (ex: `D:\DADOS`) para armazenar os relatórios
- Agende execuções periódicas para manter controle de alterações

---

## 🤝 Contribuições

Sinta-se à vontade para contribuir com melhorias, novos scripts ou correções via Pull Request. 🚀

---

## 👤 Autor

Desenvolvido por **Rosner Pelaes Nascimento**  

🔗 <a href="https://blog.rosnertech.com.br/" target="_blank">Blog Técnico</a>  
💼 <a href="https://br.linkedin.com/in/rosner-pelaes-nascimento" target="_blank">LinkedIn</a>  
📺 <a href="https://www.youtube.com/channel/UCik9XQ-ymobqhDOa9_aye-g" target="_blank">YouTube - Rosner Tech</a>
