if [ -d work ]
then
        rm -r work
fi

vlib work
vlog ../tb/*.v
vlog ../auxillary/*.v
vlog ../auxillary/display_modules/*.v
vlog ../cpu/*.v
vlog ../*.v

