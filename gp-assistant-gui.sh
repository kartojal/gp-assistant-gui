#!/bin/bash
# Bash script for helping with GpuPlotGenerator linux parameters by Kartojal
zenity_yes_case(){
    case $? in
        0)
            return
            ;;
        1)
            exit 
            ;;
                
    esac
}
hello(){
    email="burstcoin.es@gmail.com"
    plotter="GpuPlotGenerator 4.0.1 by Cryo"
HELLO_USER=$(cat <<EOF
Welcome to the GpuPlotter Assistant 1.0 by Kartojal\n

This script will help you with GPU plotting in direct mode with ${plotter},
so you don\'t need to optimize it later. 

If you find some bugs, please, send me a email to \"${email}\".
EOF
)
    zenity --info --title="gp-assistant" --no-wrap --text="${HELLO_USER}"
    zenity_yes_case 
    zenity --question  --title="gp-assistant" --text="Now will start a few questions, needed for plotting."
    zenity_yes_case 
}
questions(){
    # Number of plots
    while [[ -z ${N_PLOTS} && ! ${N_PLOTS} =~ ^-?[0-9]+$ ]];
    do
        N_PLOTS=`zenity --entry  --title="gp-assistant" \
        --text="How many Plots do you want?" \
        --entry-text "1" `
        zenity_yes_case
    done

    # Plot size
    while [[ -z ${PLOT_SIZE} && ! ${PLOT_SIZE} =~ ^-?[0-9]+$ ]];
    do
        PLOT_SIZE=`zenity --entry  --title="gp-assistant" \
        --text="Enter plot size number in GBytes, less than 200 GB recommended" \
        --entry-text "200" `
        zenity_yes_case
    done

    TOTAL_SIZE=$(( $PLOT_SIZE * $N_PLOTS ))
    NONCES=$(( $PLOT_SIZE * 1024 * 1024 / 256 ))
    
    # Start nonce
    while [[ -z ${START_NONCE} && ! ${START_NONCE} =~ ^-?[0-9]+$ ]];
    do
        START_NONCE=`zenity --entry  --title="gp-assistant" \
        --text="Enter the start nonce, if is your first time, let it as zero" \
        --entry-text "0" `
        zenity_yes_case

    done

    # Burst ID
    while [[ -z ${BURST_ID} && ! ${BURST_ID} =~ ^-?[0-9]+$ ]];
    do
        BURST_ID=`zenity --entry  --title="gp-assistant" \
        --text="Enter your numerical Burst ID" \
        --entry-text "" `
        zenity_yes_case
    done

    # Cache size
    while [[ -z ${STAGGER} && ! ${STAGGER} =~ ^-?[0-9]+$ ]];
    do
        STAGGER=`zenity --entry  --title="gp-assistant" \
            --text="Enter the stagger RAM size in MBytes" \
        --entry-text "1024" `
        zenity_yes_case
    done
    STAGGER_NONCES=$(( $STAGGER * 4 ))
    # Plot directory path
    while [[ -z ${PLOT_DIR} && ! ${PLOT_DIR} =~ ^-?[0-9]+$ ]];
    do
        PLOT_DIR=`zenity --file-selection --directory --title="gp-assistant" `
        zenity_yes_case 
    done
}
diskspace(){
    FREEDISK=$(df ${PLOT_DIR} -k -BG  --output=avail | tail -1 | tr -d 'G' | tr -d ' ')
    if [ ${FREEDISK} -gt ${TOTAL_SIZE} ];
    then

        zenity --info --no-wrap --title="gp-assistant" --text="You have sufficient disk space for plotting\n in ${PLOT_DIR}, ${FREEDISK} GB of free space." 
        return
    else
        zenity --error  --title="gp-assistant" --text="ERROR, you don't have sufficient space left in your system. "
        exit 2
    fi

}
plot_previous() {
    zenity --question --title="gp-assistant" --text="Plot Info \n\n BURST-ID: ${BURST_ID} \n Start nonce: ${START_NONCE}\n Plot size: ${PLOT_SIZE} GB \( ${NONCES} nonces \) \n Stagger: ${STAGGER} MB \( ${STAGGER_NONCES} nonces \) \n Directory: ${PLOT_DIR} \n ¿Do you want to continue and start gpuPlotGenerator by Cryo?"
    case $? in
        0)
            return
            ;;
        1)
            questions
            ;;
        -1)
            unknown_eror
            ;;
         *)
             exit 0
	     ;;
    esac 
}
start_plotting(){
 # Iniciamos xterm y un segundo script, ya que zenity "--text-info" no permite hacer auto-scroll mientras se va desarrollando los procesos, y tiene un bug en el cual no permite terminar con el proceso que se esté ejecutando en segundo plano al cerrar la ventana de zenity, por tanto seguirían quedando procesos en segundo plano que el usuario no sería capaz de parar si no sabe usar la terminal.
 xterm -hold -e "./gpuminer_loop.sh ${PLOT_DIR} ${BURST_ID} ${START_NONCE} ${NONCES} ${STAGGER_NONCES} ${N_PLOTS} " 
}

unknown_error(){
    zenity --error --text="Unknown error, ask for support in http://www.burstforum.com"
    exit 1
}

hello
questions
diskspace
plot_previous
start_plotting
exit 0
