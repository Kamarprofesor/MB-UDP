source /etc/hysteria/core/scripts/path.sh

echo "Uninstalling MB-Udp..."

echo "Running uninstallation script..."
bash <(curl -fsSL https://get.hy2.sh/) --remove >/dev/null 2>&1

echo "Removing WARP"
python3 $CLI_PATH uninstall-warp

echo "Removing Hysteria folder..."
rm -rf /etc/hysteria >/dev/null 2>&1

echo "Deleting hysteria user..."
userdel -r hysteria >/dev/null 2>&1

echo "Removing systemd service files..."
rm -f /etc/systemd/system/multi-user.target.wants/hysteria-server.service >/dev/null 2>&1
rm -f /etc/systemd/system/multi-user.target.wants/hysteria-server@*.service >/dev/null 2>&1

echo "Reloading systemd daemon..."
systemctl daemon-reload >/dev/null 2>&1

echo "Removing cron jobs..."
(crontab -l | grep -v "python3 /etc/hysteria/core/cli.py traffic-status" | crontab -) >/dev/null 2>&1
(crontab -l | grep -v "/etc/hysteria/core/scripts/mb-udp/kick.sh" | crontab -) >/dev/null 2>&1
(crontab -l | grep -v "python3 /etc/hysteria/core/cli.py restart-mb-udp" | crontab -) >/dev/null 2>&1
(crontab -l | grep -v "python3 /etc/hysteria/core/cli.py backup-hysteria" | crontab -) >/dev/null 2>&1


echo "Removing alias 'mbudp' from .bashrc..."
sed -i '/alias mbudp=.*\/etc\/hysteria\/menu.sh/d' ~/.bashrc

echo "Stop/Disabling Hysteria TelegramBOT Service..."
systemctl stop hysteria-bot.service > /dev/null 2>&1
systemctl disable hysteria-bot.service > /dev/null 2>&1

echo "Stop/Disabling Singbox SubLink Service..."
systemctl stop singbox.service > /dev/null 2>&1
systemctl disable singbox.service > /dev/null 2>&1


echo "MB-Udp uninstalled!"
echo ""
