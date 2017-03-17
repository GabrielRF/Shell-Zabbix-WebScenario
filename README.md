# Shell-Zabbix-WebScenario

This shell script will create a web scenario on a specific host and a trigger to check if a website is available.

## Usage:
```
# chmod +x Shell-Zabbix-WebScenario.sh
$ ./Shell-Zabbix-WebScenario.sh 'web address' 'string' 'scenario/trigger name' 'hostid' 'hostname' 'username' 'password' 'api'
```

##### `web address`
Zabbix test will run on this page.
##### `string`
The test will look for code '200' and the string present here do make sure everything is ok.
##### `scenario/trigger name`
Scenario name. Will be also used as Trigger name.
##### `hostid`
Host ID that Zabbix will save the Scenario and Trigger.
##### `hostname`
Name of the host
##### `username`
Zabbix user allowed to manage hosts
##### `password`
Zabbix user password
##### `api`
API location. 
