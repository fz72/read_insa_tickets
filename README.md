# read_insa_tickets
Read Deutschlandticket from deutschlandticket.insa.de

Create a file with credentials for simpler usage:
kvpid=HSB (Example)
aboid=12345
email=mail@example.com

The list of supported provides can be requested by curl:
curl --compressed -s -H "accept: content/json" https://deutschlandticket.insa.de/srv/dtick_srv/kvp/list | jq
