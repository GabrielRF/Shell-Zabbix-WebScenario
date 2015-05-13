ADDRESS=$1
STRING=$2
NAME=$3
HOSTID=$4
HOSTNAME=$5
USERNAME=$6
PASSWORD=$7
API=$8

if [ -z "$HOSTNAME" ]; 
	then echo "Usage: addhost.sh <hostname> <ip>"
	exit
fi

if [ -z "$IP" ];
	then IP=0.0.0.0
fi

echo IP - $IP

jsonval() {
prop='sessionid'
json=`curl --noproxy zabbix.interlegis.leg.br -i -X POST -H 'Content-Type: application/json-rpc' -d "
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

echo $AUTH_TOKEN
echo '---------------------------------------------------'
echo $NAME $ADDRESS

json2=`curl --noproxy zabbix.interlegis.leg.br -i -X POST -H 'Content-Type: application/json-rpc' -d "
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
echo "temp3:"
echo ${temp3##*|}

HTTPTESTIDS=$temp3

json3=`curl --noproxy zabbix.interlegis.leg.br -i -X POST -H 'Content-Type: application/json-rpc' -d "
{
	\"jsonrpc\":\"2.0\",
	\"method\":\"trigger.create\",
	\"params\":{
		\"description\":\"$NAME\",
		\"expression\":\"{PortalModelo:web.test.fail[$NAME].last(0)}=0\",
		\"dependencies\": []
	},
	\"auth\":\"$AUTH_TOKEN\",
	\"id\": 1
}" $API`

temp4=`echo $json3`
echo '---------------------------------------------------'
echo ${temp4##*|}
