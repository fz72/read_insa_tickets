# read_insa_tickets
Read Deutschlandticket from deutschlandticket.insa.de

# Usage

Download read_and_save_tickets.sh into a new folder.

Open a terminal in this folder.

chmod +x read_and_save_tickets.sh
./read_and_save_tickets.sh

Tickets qr code will be safed as image into the current folder.

Create a file with credentials for simpler usage:
kvpid=HSB (Example)
aboid=12345
email=mail@example.com

The list of supported provides can be requested by curl:
curl --compressed -s -H "accept: content/json" https://deutschlandticket.insa.de/srv/dtick_srv/kvp/list | jq
