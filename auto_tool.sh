#!/bin/bash

# Global Variable


declare -A trusted_circles
trusted_circles[0]=10203
trusted_circles[1]=10021
trusted_circles[2]=11318
trusted_circles[3]=2
trusted_circles[4]=11141
trusted_circles[5]=1
trusted_circles[6]=10749
trusted_circles[7]=10821
trusted_circles[8]=10983
trusted_circles[9]=10977
trusted_circles[10]=10982
trusted_circles[11]=11159
trusted_circles[12]=10086
trusted_circles[13]=11274
trusted_circles[14]=11247
trusted_circles[15]=11053
trusted_circles[16]=10980
trusted_circles[17]=10981
trusted_circles[18]=10979
trusted_circles[19]=10978
trusted_circles[20]=11196
trusted_circles[21]=146
trusted_circles[22]=145
trusted_circles[23]=187



name=([1]="AVIATION TIC" [2]="EDUCATION TIC" [3]="ENERGY TIC" [4]="FINANCIAL SERVICES TIC" [5]="GULF REGION" [6]="High Tech TIC" [7]="Insurance" [8]="NEOCC" [9]="OSINT News & Other Reports" [10]="OSINT Threat Reports" [11]="OSINT Vulnerability Reports" [12]="RANSOMEWARE SEA" [13]="Retail and Hospitality TIC" [14]="SEA-ISAC" [15]="TITAN" [16]="Twitter - APT" [17]="Twitter - Compromised Accounts" [18]="Twitter - Compromised Sites" [19]="Twitter - Malware" [20]="Twitter - Social Engineering & Phishing", [21]="UIS-TC" [22]="Anomali Curated OSINT" [23]="Anomali Labs Premium" [24]="Sixgill Darkfeed Freemium")


declare -A threshold
threshold['bot_ip']=100
threshold['brute_ip']=100
threshold['c2_domain']=20
threshold['c2_ip']=20
threshold['c2_url']=20
threshold['compromised_ip']=50
threshold['exploit_ip']=20
threshold['fraud_domain']=20
threshold['fraud_email']=20
threshold['fraud_url']=20
threshold['mal_domain']=20
threshold['mal_email']=30
threshold['mal_ip']=50
threshold['mal_md5']=30
threshold['mal_url']=20
threshold['phish_domain']=50
threshold['phish_email']=30
threshold['phish_md5']=30
threshold['phish_url']=100
threshold['scan_ip']=1
threshold['spam_ip']=300


finance_keyword=("banking" "bank")
energy_keyword=("energy")


recipient="phamnhuthehuy@gmail.com"


num_source=24
#num_source=24
url="https://api.threatstream.com/api/v2/intelligence/"
import_url="https://api.threatstream.com/api/v1/intelligence/import/"
header="Authorization: apikey bao@vcyber.io:be940bed8354e2774fa5c5c76cca21174d4b169c"
RED='\033[0;31m'
NOCOLOR='\033[0m'
LIGHTBLUE='\033[1;34m'
LIGHTGREEN='\033[1;32m'
Cyan='\033[0;36m'





echo "===========================************=============================="
echo -e "${RED}▇▇       ▇▇   ▇▇▇▇▇▇▇  ▇▇      ▇▇  ▇▇▇▇▇▇▇▇   ▇▇▇▇▇▇▇▇   ▇▇▇▇▇▇▇"
echo -e "${RED}▇▇       ▇▇ ▇▇      ▇   ▇▇    ▇▇   ▇▇     ▇▇  ▇▇         ▇▇     ▇▇"
echo -e "${RED} ▇▇     ▇▇ ▇▇            ▇▇  ▇▇    ▇▇     ▇▇  ▇▇         ▇▇    ▇▇"
echo -e "${RED}  ▇▇   ▇▇  ▇▇             ▇▇▇▇     ▇▇▇▇▇▇▇▇▇  ▇▇▇▇▇▇▇▇   ▇▇▇▇▇▇"
echo -e "${RED}   ▇▇ ▇▇    ▇▇             ▇▇      ▇▇     ▇▇  ▇▇         ▇▇  ▇▇"
echo -e "${RED}    ▇▇▇      ▇▇    ▇       ▇▇      ▇▇     ▇▇  ▇▇         ▇▇   ▇▇"
echo -e "${RED}     ▇        ▇▇▇▇▇▇       ▇▇      ▇▇▇▇▇▇▇▇   ▇▇▇▇▇▇▇▇   ▇▇    ▇▇"
echo -e "${Cyan}v3.1 by __phamhuy${NOCOLOR}"
echo "===========================************=============================="



PROGRESS_BAR_WIDTH=50  # progress bar length in characters

function draw_progress_bar {
  # Arguments: current value, max value, unit of measurement (optional)
  local __value=$1
  local __max=$2
  local __unit=${3:-""}  # if unit is not supplied, do not display it

  # Calculate percentage
  if (( $__max < 1 )); then __max=1; fi  # anti zero division protection
  local __percentage=$(( 100 - ($__max*100 - $__value*100) / $__max ))

  # Rescale the bar according to the progress bar width
  local __num_bar=$(( $__percentage * $PROGRESS_BAR_WIDTH / 100 ))

  # Draw progress bar
  printf "["
  for b in $(seq 1 $__num_bar); do printf "▇"; done
  for s in $(seq 1 $(( $PROGRESS_BAR_WIDTH - $__num_bar ))); do printf " "; done
  printf "] $__percentage%% ($__value / $__max $__unit)\r"
}



function check_directory {
	#check current dicectory of this working script itself
	dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)/$1"
	if [[ -d "$dir" ]]
	then
	    	echo ""
	else
		if [[ $1 = *"."* ]]; then
			touch $dir
		else
			mkdir $dir
		fi
	fi
}



function total_count {
	num=$(cat $1 | python3 -c "import sys,json; print(len(json.load(sys.stdin)['objects']))" )
	echo "Retrieved $num IOCs."
	if [[ $num -eq 0 ]]; then
		rm -f $1
	fi
}


function containsElement { # check if a string contains value of an array
	  local e match="$1"
	  shift
	  for e ; do  [[ $match = *"$e"* ]] && return 1; done
	  return 0
}


function fetching_config {
	while IFS='=' read  var value; do
		if [[ "$var" = "#"* ]];then
			echo ""
		elif [[ ${#var} -gt 1 ]]; then
			echo "$var=$value"
		fi
	done < <(cat "/home/thehuy/Desktop/vAuto.config")
}



#========================================

function automation {
	# retrieving ioc from threatstream
	retrieving_ioc
	retrieved_dir=$dir
	day_retrieve=$d
	# reporting
	convert_to_csv $retrieved_dir $day_retrieve
	import_dir=$p_dir
	
	#extracting ioc file
	extract_ioc_for_notification $retrieved_dir
	extracting_ioc_dir=$ext_file
	
	# notificating
	notificating $extracting_ioc_dir
	
	# cleaning extracting file
	rm -f $extracting_ioc_dir
	
	# cleaning Retrieved_TI directory
	rm -d -r $retrieved_dir	
	
	# importing
	import $p_dir
	
	#cleaning import directory
	rm -d -r $import_dir
	
	
}


function retrieving_ioc {
	dir_name="retrieved_TI_$(TZ=Asia/Ho_Chi_Minh date +'%F')"
	check_directory $dir_name
	echo "How long?"
	read d
	date=$(TZ=America/Danmarkshavn date +'%FT%T' --date="+$d days ago")
	echo "Enter search keyword for filtering?"
	read keyword
	counter=1
	while [[ $counter -le "${#name[@]}" ]]; do
		f_name="$dir/$counter.json"
		echo ""
		echo "======================================$counter========================================="
		echo "Retrieving Threat Intelligence from ${name[$counter]} ..."
		query="?country=VN&trustedcircles=${trusted_circles[$(($counter-1))]}&created_ts__gte=$date&status=active&tags.name__contains=$keyword"
		curl "$url$query" -H "$header" -o $f_name
		echo ""
		total_count $f_name ${name[$counter]}
		echo ""
		let counter+=1
	done
}



function import { #under construction
	for filename in $1/*.csv; do
		if [[ ! -e $filename ]]; then continue; fi
		if [[ $filename = *"gov"* ]]; then
			id=11394
		elif [[ $filename = *"fin"* ]]; then
			id=11396
		else
			id=11395
		fi
		type=$(echo $filename | cut -f6 -d\/ | cut -f3 -d\_)
		curl -X POST "$import_url"  -F "classification=private" -F "confidence=50" -F "file=@$filename" -F "threat_type=$type" -F "trustedcircles=$id"  -H "$header"
	done
}



function extract_ioc_for_notification {
	# preparing directory for extracting fle
	dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
	ext_file=$dir"/extracting_ioc.txt"
	if [[ ! -f  $ext_file ]]; then
		touch $ext_file
	fi
	# extracting
	cat $1"/"* | jq '.objects[] .itype'|cut -f2 -d\"  | sort | uniq -c  | awk -F " " '{print $2","$1}' > $ext_file
}


function notificating {
	notification=$(while IFS=',' read -r key value
			do
			     if [[ $value -ge ${threshold[$key]} ]]; then 
				echo "<p>Number of $key today is $value IOCs, Please check report for more details</p>" 
			     fi
			done < $1)

	sending_email "$notification" $1
}



function convert_to_csv { # iterating all json file from given directory
	echo "Reporting, Please wait..."
	dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
	p_dir=$dir"/import"
	if [[ ! -d  $p_dir ]]; then
		mkdir $p_dir
	fi
	#file for reporting
	f_name="report_$(TZ=Asia/Ho_Chi_Minh date +'%F' --date="+$2 days ago")_to_$(TZ=Asia/Ho_Chi_Minh date +'%F').csv"
	
	check_directory $f_name
	report_dir=$dir
	
	echo "No,Type,Threat_type,Itype,Status,Value,Severity,IOC_type,ThreatScore,Created_ts,Organization,Confidence,Source_reported_confidence" >> $report_dir
	
	for filename in $1/*.json; do
		if [[ ! -e "$filename" ]]; then continue; fi
		counter=0
		num=$(cat $filename 2>/dev/null | python3 -c "import sys,json; print(len(json.load(sys.stdin)['objects']))")		
		while [[ $counter -lt $num ]]; do
			obj=$(jq .objects[$counter] $filename)
			type=$(echo $obj | jq .type | cut -f2 -d\")
			threat_type=$(echo $obj | jq .threat_type | cut -f2 -d\")
			itype=$(echo $obj | jq .itype | cut -f2 -d\")
			status=$(echo $obj | jq .status | cut -f2 -d\")
			value=$(echo $obj | jq .value | cut -f2 -d\")
			severity=$(echo $obj | jq .meta.severity | cut -f2 -d\")
			tags=$( echo $obj | jq .tags[].name 2> /dev/null | cut -f2 -d\" | tr '\n' ',' | head -c -1)
			threat_score=$( echo $obj | jq .threatscore)
			created_ts=$( echo $obj | jq .created_ts | cut -f2 -d\" | cut -f1 -dT)
			org=$(echo $obj | jq .org | cut -f2 -d\")
			confidence=$(echo $obj | jq .confidence)
			s_conf=$(echo $obj | jq .source_reported_confidence)
			
			
			containsElement "$tags,$value" "${finance_keyword[@]}"
			fin=$?
			containsElement "$value,$value" "${energy_keyword[@]}"
			en=$?
			
			if [[ $fin -eq 1 ]]; then
				suffix="finance"
			elif [[ $en -eq 1 ]]; then
				suffix="energy"
			else
				suffix="gov"
			fi
			
			# for reporting
			echo $(($counter+1))","$type","$threat_type","$itype","$status","$value","$severity","$suffix","$threat_score","$created_ts","$org","$confidence","$s_conf >> $report_dir
			# creating structure file for importing
			if [[ $itype =  *"bot"* ]]; then
				f=$p_dir"/import_$(TZ=Asia/Ho_Chi_Minh date +'%F')_bot_$suffix.csv"
				if [[ -f "$f" ]]; then
					echo $value","$itype","$tags","$suffix","  >> $f
				else
					touch $f
					echo "value,itype,tags,private_tags,tlp" >> $f
				fi
			elif [[ $itype =  *"compromised"* ]]; then
				f=$p_dir"/import_$(TZ=Asia/Ho_Chi_Minh date +'%F')_compromised_$suffix.csv"
				if [[ -f "$f" ]]; then
					echo $value","$itype","$tags","$suffix","  >> $f
				else
					touch $f
					echo "value,itype,tags,private_tags,tlp" >> $f
				fi
			elif [[ $itype =  *"brute"* ]]; then
				f=$p_dir"/import_$(TZ=Asia/Ho_Chi_Minh date +'%F')_brute_$suffix.csv"
				if [[ -f "$f" ]]; then
					echo $value","$itype","$tags","$suffix","  >> $f
				else
					touch $f
					echo "value,itype,tags,private_tags,tlp" >> $f
				fi
			elif [[ $itype =  *"exploit"* ]]; then
				f=$p_dir"/import_$(TZ=Asia/Ho_Chi_Minh date +'%F')_exploit_$suffix.csv"
				if [[ -f "$f" ]]; then
					echo $value","$itype","$tags","$suffix","  >> $f
				else
					touch $f
					echo "value,itype,tags,private_tags,tlp" >> $f
				fi
			elif [[ $itype =  *"mal"* ]]; then
				f=$p_dir"/import_$(TZ=Asia/Ho_Chi_Minh date +'%F')_malware_$suffix.csv"
				if [[ -f "$f" ]]; then
					echo $value","$itype","$tags","$suffix","  >> $f
				else
					touch $f
					echo "value,itype,tags,private_tags,tlp" >> $f
				fi
			elif [[ $itype =  *"scan"* ]]; then
				f=$p_dir"/import_$(TZ=Asia/Ho_Chi_Minh date +'%F')_scan_$suffix.csv"
				if [[ -f "$f" ]]; then
					echo $value","$itype","$tags","$suffix","  >> $f
				else
					touch $f
					echo "value,itype,tags,private_tags,tlp" >> $f
				fi
			elif [[ $itype =  *"spam"* ]]; then
				f=$p_dir"/import_$(TZ=Asia/Ho_Chi_Minh date +'%F')_spam_$suffix.csv"
				if [[ -f "$f" ]]; then
					echo $value","$itype","$tags","$suffix","  >> $f
				else
					touch $f
					echo "value,itype,tags,private_tags,tlp" >> $f
				fi
			elif [[ $itype =  *"suspicious"* ]]; then
				f=$p_dir"/import_$(TZ=Asia/Ho_Chi_Minh date +'%F')_suspicious_$suffix.csv"
				if [[ -f "$f" ]]; then
					echo $value","$itype","$tags","$suffix","  >> $f
				else
					touch $f
					echo "value,itype,tags,private_tags,tlp" >> $f
				fi
			elif [[ $itype =  *"tor"* ]]; then
				f=$p_dir"/import_$(TZ=Asia/Ho_Chi_Minh date +'%F')_tor_$suffix.csv"
				if [[ -f "$f" ]]; then
					echo $value","$itype","$tags","$suffix","  >> $f
				else
					touch $f
					echo "value,itype,tags,private_tags,tlp" >> $f
				fi
			fi	
			converted_obj=$(($counter+1))
			draw_progress_bar $converted_obj $num "obj"
			let counter+=1
		done
	done
	echo "Done!"
	echo "[$report_dir] has been created successfully!"
	echo "====================================================================="	
	
}


function sending_email {
	table1=$(while IFS=',' read key value
		do
			printf "<tr>\n  <th> $key </th>\n  <td>$value</td>\n</tr>\n" 
		done < $2)

(echo "To: $recipient"
echo "Mime-Version: 1.0"
echo "Subject: Test HTML e-mail."
echo "Content-Type: text/html"
echo ""
echo "<html><body style='margin: 0; padding: 0;'>"
echo  "<table align='center' border='1' cellpadding='0' cellspacing='0' width='600'>"
echo " <tr>"
echo "	  <td align='center' bgcolor='#6E33FF' style='padding: 40px 0 30px 0;'  >"
echo "		<img src='https://vcyber.io/img/vcyber-logo.png' width='200' height='70' style='display: block;' />"
echo "	  </td>"
echo " </tr>"
echo " <tr>"
echo "	  <td bgcolor='#ffffff'>"
echo "		${1}"
echo " 	  </td>"
echo "</tr>"
echo "<tr>"
echo "	  <td bgcolor='#ee4c50'>"
echo "	  	<table border='1' cellpadding='0' cellspacing='0' style='padding; ' align='center' width='100%';>"
echo "			<thead width='100%';>"
echo "				<tr>"
echo "					<th>Itype</th>"
echo "					<th>Number of IOC</th>"
echo "				</tr>"
echo "			</thead>"
echo "			<tbody align='center' width='100%';>"
echo "				$table1"
echo "			</tbody>"
echo "		</table> "
echo "	  </td> "
echo " </tr>"
echo "</table>"
echo "</body></html>" ) | sendmail -t

}



function check_program {
	if ! command -v jq &> /dev/null
	then
	    echo "jq could not be found, install it first (check this for installation https://stedolan.github.io/jq/download/)"
	    exit
	fi
}



check_program
echo -e "${LIGHTBLUE}1. Automation (retrieving intelligence + reporting + importing to ThreatStream)"
echo -e "Enter option (1 or 2 only): ${LIGHTGREEN}"
read choice




if [[ $choice -eq 1 ]]; then
	automation
fi
	








