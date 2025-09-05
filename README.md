# WinOps Maintenance Menu

Windows bilgisayarlar için **CMD tabanlı bakım ve onarım menüsü**.  
Hem **kurumsal BT yöneticileri** hem de **bireysel kullanıcılar** için uygundur.

-------------------------------------------------
🚀 Özellikler
-------------------------------------------------
🛠 Hızlı Düzeltme    → SFC + DISM + Temp temizliği  
🌐 Ağ Sıfırlama      → DNS / Winsock / TCP-IP reset  
📦 Uygulama Yönetimi → winget ile kur/güncelle/kaldır  
🧹 Derin Temizlik    → Disk Cleanup + bileşen temizliği  
🖥 Kurtarma Araçları → Güvenli Mod, Recovery, Adv. Boot  
📊 Teşhis & Raporlar → systeminfo, driverquery, gpresult  
⚡ Tek Tıkla Hepsi    → En sık kullanılan işlemler ardışık  
📝 Log Sistemi        → %SystemDrive%\WinOpsLogs altında  

-------------------------------------------------
👥 Kimler İçin?
-------------------------------------------------
👨‍💻 BT Ekipleri  → Çok sayıda cihaz için hızlı bakım  
🏠 Ev Kullanıcıları → Bilgisayarını hızlandırmak, sorun çözmek isteyen herkes  

-------------------------------------------------
📖 Kullanım
-------------------------------------------------
1. WinOps-Menu.cmd dosyasını indirin  
2. Sağ tıklayın → "Yönetici olarak çalıştır"  
3. Menüden seçim yapın  
4. Loglar: %SystemDrive%\WinOpsLogs  

-------------------------------------------------
🖼 Örnek Menü
-------------------------------------------------
[1] HIZLI Duzelt (SFC + DISM + Temp)  
[2] Ag Sifirlama (DNS/Winsock/TCP-IP)  
[3] Uygulamalari Guncelle (winget)  
[4] Derin Temizlik (cleanmgr/DISM)  
[5] Kurtarma Araclari (Guvenli Mod, Adv. Boot)  
[6] Teshis/Raporlar (systeminfo, gpresult)  
[7] Tek Tik: Hepsi  
[0] Cikis  

-------------------------------------------------
⚠️ Uyarılar
-------------------------------------------------
- Bazı işlemler geri alınamaz (ResetBase, cipher /w, systemreset)  
- Önce yedek alın  
- Kurumsal ortamlarda BT politikalarına uyun  

-------------------------------------------------
📜 Lisans
-------------------------------------------------
Bu proje MIT lisansı ile dağıtılmaktadır.
