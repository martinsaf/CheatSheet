# Active Directory - Management Commands 🛠️

Essential PowerShell commands for managing Active Directory objects (Users, Groups, OUs).

**Prerequisite:** `ActiveDirectory`  module isntalled (RSAT or Domain Controller).

## 1. Structure Management (OUs) 

| Task | Command |
| :--- | :--- |
| **Create new OU** | `New-ADOrganizationalUnit -Name "NewOU" -Path "DC=lab,DC=local"` |
| **List OUs** | `Get-ADOrganizationalUnit -Filter *` |

## 2. User Management 👤

| Task | Command |
| :--- | :--- |
| **Create new user** | `New-ADUser -Name "Joao" -SamAccountName "joao" -UserPrincipalName "joao@lab.local" -Enabled $true -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)` |
| **List all users** | `Get-ADUser -Filter * -Properties * \| Format-Table Name, SamAccountName` |
| **Find specific user** | `Get-ADUser -Identity "carlos.silva" -Properties MemberOf` |
| **Check user groups** | `Get-ADUser -Identity "carlos.silva" -Properties MemberOf \| Select-Object -ExpandProperty MemberOf` |

## 3. Group Managament 👥

| Task | Command |
| :--- | :--- |
| **Create new group** | `New-ADGroup -Name "NewGroup" -GroupScope Global -Path "OU=Groups,DC=lab,DC=local"` |
| **Add user to group** | `Add-ADGroupMember -Identity "IT-Team" -Members "carlos.silva"` |
| **List group members** | `Get-ADGroupMember -Identity "IT-Team" \| Format-Table Name, SamAccountName` |
| **List all groups** | `Get-ADGroup -Filter * \| Format-Table Name, GroupScope` |

## 4. Context Tips 📝

- **Path:** Always define the correct `-Path` (e.g., `OU=Users,OU=IT,DC=lab,DC=local`) to avoid creating objects in the wrong container.
- **Scope:** Use `Global` for user groups within the same forest.
- **Security vs Distribution:** Use `Security` if the group is intended for assigning permissions (ACLs).
