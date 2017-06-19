ADDRESS=$1
STRING=$2
NAME=$3
HOSTID=$4
HOSTNAME=$5
USERNAME=$6
PASSWORD=$7
API=$8

if [ -z "$1" ];
        then echo "Script que adiciona um cenário web e uma trigger ao Zabbix."
        echo "Para ajuda, envie o parâmetro -h"
        exit
fi

if [ $1 = "-h" ]; 
	then echo "Usage: ./Shell-Zabbix-WebScenario2.sh 'Address' 'String to be found' 'Trigger and Web Scenario Name' 'Host id' 'Hostname' 'username' 'password' 'API url'"
	exit
fi

# echo '---------------- User login ----------------'
jsonval() {
prop='sessionid'
json=`curl -s -i -X POST -H 'Content-Type: application/json-rpc' -d "
{
	\"jsonrpc\": \"2.0\",
	\"method\": \"user.login\",
	\"params\": {
		\"user\": \"$USERNAME\",
		\"password\": \"$PASSWORD\",
		\"userData\":true
	}, 
	\"id\": 2
}" $API`

 temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop`
echo ${temp##*|}
}

AUTH_TOKEN=$(jsonval)

# echo
# echo '---------------- Http Test Create ----------------'
json2=`curl -s -i -X POST -H 'Content-Type: application/json-rpc' -d "
{
	\"jsonrpc\":\"2.0\",
	\"method\":\"httptest.create\",
	\"params\":{
		\"name\":\"$NAME\",
		\"hostid\":\"$HOSTID\",
		\"steps\":[{
			\"name\":\"$ADDRESS\",
			\"url\":\"$ADDRESS\",
			\"status_codes\":200,
			\"required\":\"$STRING\",
			\"no\":1
		}]
	},
	\"auth\":\"$AUTH_TOKEN\",
	\"id\":1
}" $API`

temp3=`echo '{"jsonrpc":"2.0","result":{"httptestids":["598"]},"id":1}' | python -c 'import sys, json; obj=json.load(sys.stdin); print obj["result"]["httptestids"][0]'`
# echo ${temp3##*|}

HTTPTESTIDS=$temp3

# echo '---------------- Trigger create ----------------'
json3=`curl -s -i -X POST -H 'Content-Type: application/json-rpc' -d "
{
	\"jsonrpc\":\"2.0\",
	\"method\":\"trigger.create\",
	\"params\":{
		\"description\":\"$NAME\",
		\"expression\":\"{$HOSTNAME:web.test.rspcode[$NAME,$ADDRESS].last(0)}<>200 and {$HOSTNAME:web.test.rspcode[$NAME,$ADDRESS].change(0)}=0\",
		\"dependencies\": []
	},
	\"auth\":\"$AUTH_TOKEN\",
	\"id\": 1
}" $API`

temp4=`echo $json3`
echo ${temp4##*|}
