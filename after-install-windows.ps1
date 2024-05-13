# ref: https://ciromota.tec.br/crie-scripts-de-pos-instalacao-com-o-winget/

# Como medida de segurança se faz necessário liberar a execução de scripts, 
# neste caso execute Set-ExecutionPolicy unrestricted para liberá-la 
# e ao final Set-ExecutionPolicy restricted para travar a execução de scripts de terceiros. 
# Jamais permita a execução de scripts de terceiros livremente.


# Alguns ajustes podem ser pré-configurados para um melhor aproveitamento como a possibilidade de ter ou não telemetria, 
# a linguagem padrão, se queremos ou não que a ferramenta faça ou não a atualização das fontes (semelhante ao apt update) dentre outras. 
# Digite em uma janela do PowerShell (admin) o comando winget settings onde será aberto um arquivo .json e bastará então alguns ajustes simples como estes:

# {
#     "source": {
#         "autoUpdateIntervalInMinutes": 30
#     },

#     "installBehavior": {
#         "preferences": {
#             "locale": [ "pt-BR" ]
#         }
#     },

#     "visual": {
#         "progressBar": "retro"
#     },

#     "telemetry": {
#         "disable": true
#    	},

# }


if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Write-Output "Installando apps"

# procurando apps 'winget search vscode'

# edge XPFFTQ037JWMHS ou Microsoft.Edge

$apps = @(
@{name = "Google.Chrome" } # nessa lista vai o Id do app
@{name = "RARLab.WinRAR" }
@{name = "DriverPack" }
@{name = "Microsoft.WindowsTerminal" }
@{name = "AnyDeskSoftwareGmbH.AnyDesk" }
);

Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing: " $app.name
        winget install -e -h --silent --accept-source-agreements --accept-package-agreements --id $app.name 
    }
    else {
        Write-host "Skipping: " $app.name " (already installed)"
    }
}

Write-Output "Instalacao finalizada."
Read-Host "Pressione qualquer tecla para encerrar."