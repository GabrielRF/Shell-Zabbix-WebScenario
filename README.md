# Shell-Zabbix-WebScenario

This shell script will create a web scenario on a specific host and a trigger to check if a website is available.

__You must have a host created before using this script!__ 

## Usage:
```
# chmod +x Shell-Zabbix-WebScenario.sh
$ ./Shell-Zabbix-WebScenario.sh 'web address' 'string' 'scenario/trigger name' 'hostid' 'hostname' 'username' 'password' 'api'
```

##### `web address`
Web page to be tested. Zabbix will check for http response `200` and a string, chosen below.
##### `string`
After checking for http responde `200`, Zabbix will look for this string on the web page.
##### `scenario/trigger name`
Scenario and trigger name.
##### `hostid`
Host ID that Zabbix add the Scenario and the Trigger. To find it, open your host on the Zabbix web interface and check its id on the URL.

For example:
`https://myzabbix.mydomain.com/hosts.php?form=update&hostid=12345&groupid=1`, the host id is `12345`.
##### `hostname`
Name of the host. Necessary to make the trigger work properly.
##### `username`
Zabbix user allowed to manage hosts
##### `password`
Zabbix user password
##### `api`
API location. 

To check if you have the correct url, open it. You should see a black page.
