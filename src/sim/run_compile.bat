if exist work rmdir /S /Q work

vlib work
vlog ../tb/*.v
vlog ../auxillary/*.v
vlog ../auxillary/display_modules/*.v
vlog ../cpu/*.v
vlog ../*.v

