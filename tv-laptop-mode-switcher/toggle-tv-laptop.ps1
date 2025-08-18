# Windows 11 için TV ve Laptop modu geçiş scripti

# System.Drawing.Common kütüphanesini yükle
Add-Type -AssemblyName System.Drawing

# Mevcut arka plan resmini al ve yedekle
$themePath = "$env:APPDATA\Microsoft\Windows\Themes"
$script:wallpaperBackup = "$themePath\TranscodedWallpaper_Backup.jpg"
$script:wallpaperPath = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallPaper" -ErrorAction SilentlyContinue).WallPaper
if (-not $script:wallpaperPath -or -not (Test-Path $script:wallpaperPath)) {
    $script:wallpaperPath = "$themePath\TranscodedWallpaper"
}
# Aynı dosya değilse yedekle
if ((Test-Path $script:wallpaperPath) -and $script:wallpaperPath -ne $script:wallpaperBackup) {
    Copy-Item -Path $script:wallpaperPath -Destination $script:wallpaperBackup -Force -ErrorAction SilentlyContinue
    Write-Host "Wallpaper yedeklendi: $script:wallpaperBackup"
} else {
    Write-Host "Yedekleme gerekli değil veya wallpaper bulunamadı."
}

# SystemParametersInfo API'sini tanımla
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@

# TV Modu: Siyah arka plan ve otomatik gizlenen görev çubuğu
function Set-TVMode {
    # Siyah arka planı registry ile ayarla
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallPaper" -Value ""
    Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name "Background" -Value "0 0 0"
    [Wallpaper]::SystemParametersInfo(20, 0, "", 3) | Out-Null

    # Görev çubuğunu otomatik gizle
    $settings = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" -Name "Settings" -ErrorAction SilentlyContinue
    if ($settings) {
        $settingsBytes = $settings.Settings
        $settingsBytes[8] = 3  # Otomatik gizleme için 3
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" -Name "Settings" -Value $settingsBytes
    }

    # Değişiklikleri uygula
    Stop-Process -Name "explorer" -Force
    Write-Host "TV Modu etkinleştirildi: Siyah arka plan ve otomatik gizlenen görev çubuğu."
}

# Laptop Modu: Yedeklenen arka plan resmi ve sabit görev çubuğu
function Set-LaptopMode {
    # Yedeklenen arka plan resmini geri yükle
    if (Test-Path $script:wallpaperBackup) {
        Write-Host "Yedek wallpaper geri yükleniyor: $script:wallpaperBackup"
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallPaper" -Value $script:wallpaperBackup
        [Wallpaper]::SystemParametersInfo(20, 0, $script:wallpaperBackup, 3) | Out-Null
    } else {
        Write-Host "Yedek wallpaper bulunamadı, varsayılan Windows wallpaper'ı kullanılıyor."
        $defaultWallpaper = "C:\Windows\Web\Wallpaper\Windows\img0.jpg"
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallPaper" -Value $defaultWallpaper
        [Wallpaper]::SystemParametersInfo(20, 0, $defaultWallpaper, 3) | Out-Null
    }

    # Görev çubuğunu sabit yap
    $settings = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" -Name "Settings" -ErrorAction SilentlyContinue
    if ($settings) {
        $settingsBytes = $settings.Settings
        $settingsBytes[8] = 2  # Sabit görev çubuğu için 2
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" -Name "Settings" -Value $settingsBytes
    }

    # Değişiklikleri uygula
    Stop-Process -Name "explorer" -Force
    Write-Host "Laptop Modu etkinleştirildi: Mevcut arka plan resmi ($script:wallpaperBackup) ve sabit görev çubuğu."
}

# Mevcut modu algıla
$currentMode = "Unknown"
$settings = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" -Name "Settings" -ErrorAction SilentlyContinue
if ($settings) {
    $settingsBytes = $settings.Settings
    if ($settingsBytes[8] -eq 3) {
        $currentMode = "TV"
    } elseif ($settingsBytes[8] -eq 2) {
        $currentMode = "Laptop"
    }
}

# Modu tersine çevir
if ($currentMode -eq "TV") {
    Write-Host "Mevcut mod: TV. Laptop Modu'na geçiliyor."
    Set-LaptopMode
} elseif ($currentMode -eq "Laptop") {
    Write-Host "Mevcut mod: Laptop. TV Modu'na geçiliyor."
    Set-TVMode
} else {
    Write-Host "Mevcut mod algılanamadı. Varsayılan olarak TV Modu'na geçiliyor."
    Set-TVMode
}