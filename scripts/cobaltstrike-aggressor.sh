


# Start the headless aggressor and enable auto-start after a reboot
chmod u+x /root/aggressor/start-aggressor.sh
systemctl enable aggressor
systemctl start aggressor

# End
touch /tmp/cobaltstrike-aggressor.done