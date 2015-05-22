#! /bin/bash
 
noir='\e[0;30m'
gris='\e[1;30m'
rougefonce='\e[0;31m'
rose='\e[1;31m'
vertfonce='\e[0;32m'
vertclair='\e[1;32m'
orange='\e[0;33m'
jaune='\e[1;33m'
bleufonce='\e[0;34m'
bleuclair='\e[1;34m'
violetfonce='\e[0;35m'
violetclair='\e[1;35m'
cyanfonce='\e[0;36m'
cyanclair='\e[1;36m'
grisclair='\e[0;37m'
blanc='\e[1;37m'
 
neutre='\e[0;m'
 
_help() {
    printf "
RSIF for Recursive Search In Files
GNU/GPL v3
by Be Human (craft at ckdevelop.org)
 
Utilisation :
        rsif
        Search  :   <dirname> <file extension> <string to search> <*options (optional)>
       *options :   -n          :   just show the line numbers
                    -w          :   show only whole words
                    -nw or -wn  :   just show the line numbers && show only whole words
                    -r <replace>:   replace only whole words
                    -f <format> :   no color for file output
        Help:   -h
 
"
}
 
_search() {
    find $1 | grep "$2" | while read line; do
        if [ -f "$line" ]; then
            _type=`file "$line" | cut -d':' -f2 | grep "text"`
            if [ $? -eq 0 ]; then
                if [ "$4" == "-n" ]; then
                    _out=`cat "$line" | grep -n "$3" | cut -d':' -f1`
                    if [ -n "$_out" ] ; then
                        echo -e "IN ${cyanclair}$line${neutre} ${orange}{${neutre}"
                        echo -e ""
                        echo -e "$_out"
                        echo -e ""
                        echo -e "${orange}}${neutre}"
                        echo -e ""
                        echo -e ""
                    fi
                elif [ "$4" == "-w" ]; then
                    _out=`cat "$line" | grep -w -n "$3"`
                    if [ -n "$_out" ] ; then
                        echo -e "IN ${cyanclair}$line${neutre} ${orange}{${neutre}"
                        echo -e ""
                        echo -e "$_out"
                        echo -e ""
                        echo -e "${orange}}${neutre}"
                        echo -e ""
                        echo -e ""
                    fi
                elif [ "$4" == "-r" ]; then
                    echo -e "REPLACE $3 TO $5 IN $line"
                    sed -i "s/$3/$5/g" "$line"
 
                elif [[ "$4" == "-nw" || "$4" == "-wn" ]]; then
                    _out=`cat "$line" | grep -w -n "$3" | cut -d':' -f1`
                    if [ -n "$_out" ] ; then
                        echo -e "IN ${cyanclair}$line${neutre} ${orange}{${neutre}"
                        echo -e ""
                        echo -e "$_out"
                        echo -e ""
                        echo -e "${orange}}${neutre}"
                        echo -e ""
                        echo -e ""
                    fi
                elif [[ "$4" == "-f" ]]; then
                    _out=`cat "$line" | grep -ne "$3" | grep -v "$3[a-zA-Z0-9_]" | sed 's/[0-9]*: /\\r\\n&/g'`
                    if [[ -n "$_out" ]] ; then
                        echo "IN $line {"
                        echo ""
                        echo $_out
                        echo ""
                        echo "}"
                        echo ""
                        echo ""
                    fi
                else
                    _out=`cat "$line" | grep -n "$3"`
                    if [ -n "$_out" ] ; then
                        echo -e "IN ${cyanclair}$line${neutre} ${orange}{${neutre}"
                        echo -e ""
                        echo -e "$_out"
                        echo -e ""
                        echo -e "${orange}}${neutre}"
                        echo -e ""
                        echo -e ""
                    fi
                fi
            fi
        fi
    done
}
 
if [ "$1" == "-h" ];then
    _help
elif [ $# -ge 3 ]; then 
    if [ -d "$1" ]; then
        _search "$1" "$2" "$3" "$4" "$5"
    else
        echo -e "${rougefonce}[!] \"$1\" n'est pas un dossier [!]${neutre}"
        _help
    fi
else
    echo -e "${rougefonce}[!] Mauvais nombre d'arguments [!]${neutre}"
    _help
fi
