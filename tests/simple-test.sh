#!/usr/bin/env bash
###############################################
#                                             #
# First simple test script for ACME-DNS-INWX. #
# Try to add and delete 100 random records.   #
#                                             #
# Example: simple-test.sh fnx.li ns1.fnx.li   #
#                                             #
###############################################

set -euf -o pipefail
cd "$(dirname "$(readlink -f "$0")")"

DOMAIN=${1-}; NS=${2-DEFAULT}
SCRIPT=${3-../scripts/acme-dns-inwx}
WAIT_DNS=60; WAIT_CACHE=301; WAIT_NEXT=10
CHALLENGE_PREFIX="_acme-challenge"

if [[ "$DOMAIN" == "" ]]; then echo "Usage: $0 <domain> [<primary-nameserver> [<path-to-script>]]" 1>&2; exit 1
elif [[ ! -x "$SCRIPT" ]]; then echo "Invalid path to script: $SCRIPT" 1>&2; exit 1; fi
if [[ "$NS" == "DEFAULT" ]]; then NS=; else NS="@$NS"; fi

tmpfile=`mktemp`; logfile=`mktemp`
echo "Logfile for errors: ${logfile}"

function status
{
	pre=${1-UNKNOWN}; msg=${2-}; ext=${3-}
	if [[ "$ext" != "" ]]; then ext=": $ext"; fi
	echo -ne "\r$(date +%H:%M:%S) [$pre] $msg$ext"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

for i in {1..100}
do
	# \n
	echo

	# Get random values for hostname and TXT record data.
	hostname="test-$(printf '%05d' "$RANDOM")-$(printf '%05d' "$RANDOM").$DOMAIN"
	txtvalue="test-$RANDOM-$RANDOM-$RANDOM-$(date +%Y%m%d-%H%M%S)"

	# Try to add the DNS record.
	status "${YELLOW}ADD RR${RESET}" "$hostname"
	return=0; "$SCRIPT" "$hostname" "$txtvalue" 1>/dev/null 2>>"$logfile" || return=$? && :

	if [[ "$return" != "0" ]]
	then
		status "${RED}ADD RR${RESET}" "$hostname" "Failed!  (could not create or update DNS-RR)"
		continue
	fi

	# Wait for the primary NS to update its zone...
	status "${YELLOW}WAIT#1${RESET}" "$hostname"
	sleep "$WAIT_DNS"

	# Check the DNS record.
	status "${YELLOW}CHK #1${RESET}" "$hostname"
	return=0; dig +short "TXT" "$CHALLENGE_PREFIX.$hostname" "$NS" 1>"$tmpfile" 2>/dev/null || return=$? && :

	if [[ "$return" != "0" || "$(cat "$tmpfile")" != "\"$txtvalue\"" ]]
	then
		status "${RED}CHK #1${RESET}" "$hostname" "Failed!  (value not found in DNS)"
		continue
	fi

	# Try to delete the DNS record.
	status "${YELLOW}DEL RR${RESET}" "$hostname"
	return=0; "$SCRIPT" "$hostname" 1>/dev/null 2>>"$logfile" || return=$? && :

	if [[ "$return" != "0" ]]
	then
		status "${RED}DEL RR${RESET}" "$hostname" "Failed!  (could not delete DNS-RR)"
		continue
	fi

	# Wait for the DNS cache to expire...
	status "${YELLOW}WAIT#2${RESET}" "$hostname"
	sleep "$WAIT_CACHE"

	# Check the DNS record.
	status "${YELLOW}CHK #2${RESET}" "$hostname"
	return=0; dig +short "TXT" "$CHALLENGE_PREFIX.$hostname" "${NS}" 1>"$tmpfile" 2>/dev/null || return=$? && :

	if [[ "$return" != "0" || "$(cat "$tmpfile")" != "" ]]
	then
		status "${RED}CHK #2${RESET}" "$hostname" "Failed!  (record still exists)"
		continue
	fi

	# Wait for the next test run...
	status "${GREEN}  OK  ${RESET}" "$hostname" "Success!"
	sleep "$WAIT_NEXT"

done

if [[ "0$(stat --printf="%s" "$logfile")" == "00" ]]
then
	echo -e "\n\nDeleting empty logfile: $logfile"
	rm -f "$logfile"
else
	echo -e "\n\nLogfile is not empty: $logfile"
fi

rm -f "$tmpfile"
