#!/bin/bash
# David Canillas Racero (Kartojal)
# Second script for offer better output messages in the spawned xterm terminal.

PLOT_DIR=$1
BURST_ID=$2
START_NONCE=$3
NONCES=$4
STAGGER_NONCES=$5
N_PLOTS=$6

create_log(){
    # Creamos un fichero de log para poder hacer debugging
    async_log='/tmp/gp-assistant.log'

    if [ -f ${async_log} ];
    then
        rm  ${async_log}
        touch ${async_log}
    else
        touch ${async_log}
    fi
}
cd_to_cryo_tool(){
CRYO_DIR="./bin"
cd ${CRYO_DIR}
}
check_plotter(){
 if [ "$PLOT_EXIT_STATUS" -eq 0 ] ;
        then
	    echo ""
            echo "Plot number "$x" with the start nonce "$START_NONCE" has been generated." | tee -a ${async_log} 
	    echo ""
            START_NONCE=$(( $START_NONCE + 1 + $NONCES ))
        else
	    echo ""
            echo "Error generating plot number "$x" with start nonce  "$START_NONCE", ask for support in http://www.burstforum.com or send email to burstcoin.es@gmail.com" | tee -a ${async_log} 
	    exit 1
            # Se sale con exit 1 para salir diréctamente del script, con código de error 1, no solo de la función.
        fi
if [ $x -eq $N_PLOTS ];
then
	echo "All plots are genererated succesfully in the directory \"${PLOT_DIR}\". Happy BURST mining from Kartojal." | tee -a ${async_log} 
	exit 0
fi
    }
plot(){ 


	echo "Starting the next plot, with start nonce "$START_NONCE" ." | tee -a ${async_log} 
	echo ""

 echo "Generating plot number ${x}." | tee -a ${async_log}
        ./gpuPlotGenerator generate direct "${PLOT_DIR}"/"${BURST_ID}"_"${START_NONCE}"_"${NONCES}"_"${STAGGER_NONCES}"  | tee -a ${async_log}
	# Debugging...
        PLOT_EXIT_STATUS="${PIPESTATUS[0]}"
}
#main

echo $PLOT_DIR
echo $BURST_ID
echo $START_NONCE
echo $NONCES
echo $STAGGER_NONCES
echo $N_PLOTS


create_log
cd_to_cryo_tool
for (( x=1 ; "$x" <= "$N_PLOTS"; x+=1 ));
do
   plot
   check_plotter
done

