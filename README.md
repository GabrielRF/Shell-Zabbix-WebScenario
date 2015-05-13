#Shell-Zabbix-WebScenario

This shell script will create a web scenario on a specific host and a trigger to check if a website is available.

##Usage:
```
# chmod +x Shell-Zabbix-WebScenario.sh
$ ./Shell-Zabbix-WebScenario.sh 'web address' 'scenario/trigger name'
```

##Notes:
* Make sure the hostid is correct on line 51.
* Make sure the string Zabbix will check is corret on line 56.
