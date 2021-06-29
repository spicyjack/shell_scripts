#!/bin/sh
# Shell script to list installed Vim themes, then launch them in VIM using a
# "less" macro

VIM_RUNTIME_PATHS="
   /usr/local/share/vim
   /usr/share/vim
" # VIM_RUNTIME_PATHS

DIALOG_PATH=$(which dialog 2>/dev/null)
if [ "x${DIALOG_PATH}" = "x" ]; then
   echo "ERROR: 'dialog' not available, and is required to run this script"
   exit 1
fi

# assume we can continue...
DIALOG_TEMP=$(mktemp 2>/dev/null)
DIALOGRC=$(mktemp 2>/dev/null)
export DIALOGRC
# remove the tempfiles if the user exits the script
trap "rm -f $DIALOG_TEMP $DIALOGRC" 0 1 2 5 15

cat << EOHD > ${DIALOGRC}
use_shadow = OFF
use_colors = ON
screen_color = (BLACK,BLACK,ON)
shadow_color = (BLACK,BLUE,OFF)
dialog_color = (BLUE,BLACK,OFF)
title_color = (YELLOW,BLUE,ON)
border_color = (BLUE,BLACK,OFF)
border2_color=border_color
button_active_color = (YELLOW,BLUE,ON)
button_key_active_color = (YELLOW,RED,ON)
button_label_active_color = (YELLOW,BLUE,ON)
button_inactive_color = (WHITE,BLACK,OFF)
button_key_inactive_color = (BLACK,RED,ON)
button_label_inactive_color = (WHITE,BLACK,OFF)
menubox_color = dialog_color
menubox_border_color = border_color
menubox_border2_color = border_color
item_color = dialog_color
item_selected_color = button_active_color
tag_selected_color = (YELLOW,BLUE,ON)
tag_key_selected_color = (YELLOW,RED,ON)
tag_color = (BLACK,BLUE,OFF)
tag_key_color = (BLACK,RED,OFF)
uarrow_color = (GREEN,WHITE,ON)
darrow_color = uarrow_color
EOHD

VIM_INSTALL=""
for VIM_CHECK_PATH in $(echo $VIM_RUNTIME_PATHS);
do
   if [ -d $VIM_CHECK_PATH ]; then
      VIM_INSTALL_VER=$(ls $VIM_CHECK_PATH | grep '\d\{2\}$')
      VIM_PATH=${VIM_CHECK_PATH}/${VIM_INSTALL_VER}
      # use the first path that's found
      break
   fi
done

if [ "x${VIM_PATH}" = "x" ]; then
   echo "ERROR: can't find full VIM path"
   echo "Search directories:"
   echo $VIM_RUNTIME_PATHS
   exit 1
fi
if [ ! -d ${VIM_PATH}/colors ]; then
   echo "ERROR: can't find VIM 'colors' directory under '${VIM_PATH}'"
   exit 1
fi

#echo "Currently installed 'colors' files:"
VIM_COLOR_FILES_LIST=$(ls "${VIM_PATH}/colors/" \
   | grep "vim$" \
   | sed '{s!${VIM_PATH}/colors!!g; s/.vim$//;}')

COLOR_FILE_LIST=""
for COLOR_FILE in $(echo $VIM_COLOR_FILES_LIST);
do
   COLOR_FILE_LIST="${COLOR_FILE_LIST} ${COLOR_FILE} \"\" "
   #echo "- ${COLOR_FILE}"
done

# hopefully 'true' is in $PATH
SELECTED_COLOR=""
while true;
do
   CMD="${DIALOG_PATH} --clear --colors --title 'VIM Color Schemes'"
   if [ -n $SELECTED_COLOR ]; then
      CMD="${CMD} --default-item '${SELECTED_COLOR}'"
   fi
   CMD="${CMD} --menu \"Choose the VIM color scheme to view...\n"
   CMD="${CMD}(Once VIM starts, use the 'q' key to exit)\""
   # --menu parameters
   # 1) screen height
   # 2) screen width
   # 3) menu box height
   CMD="${CMD} 20 50 10 ${COLOR_FILE_LIST} 2>${DIALOG_TEMP}"
   #echo $CMD
   #sleep 5
   eval $CMD
   EXIT_STATUS=$?

   if [ $EXIT_STATUS -gt 0 ]; then
      # user pressed something else besides "OK"
      break
   fi

   SELECTED_COLOR=$(cat $DIALOG_TEMP)
   # this one works the treat
   # '-c': runs a command
   # '-S': sources a file
   # '-S' and '-c' are run at basically the same time
   # '--cmd' runs before anything else
   #      -c "highlight"
   vim --cmd 'let no_plugin_maps = 1' \
      -S '$VIMRUNTIME/syntax/hitest.vim' \
      -c "runtime! macros/less.vim" \
      -c "colorscheme ${SELECTED_COLOR}"

done

# clean up
rm -f $DIALOG_TEMP $DIALOGRC
unset DIALOGRC
