##Author: Louis Stefanski
##Date: 3/30/2023


#A script to create an executable file, run it, then clean up after itself
#The only files left after execution are the following:
#	copy.asm -> a copy of the file given to ensure it is safe
#	[fileName].asm -> the original file


#get file name
echo $'\nEnter file name: '
read fileName
echo -e "\e"


#ensure the fileName is not a .asm or .o
#if it is the script exits prompting the user to not use said extension
if  [[ "$fileName" == *.asm ]] || [[ "$fileName" ==  *.o ]] 
then
	echo -e "\e[31m\nInvalid input, please do not include .asm or .o\e[0m"...
	echo -e "\e[31m\nExiting now...\e[0m"
	exit 1
fi


#loop through externals array, use for linking later
for element in "${externals[@]}"
do
	echo "$element"
done

#create a copy of the asm file
cp ${fileName}'.asm' ./'copy.asm'

{ #try to remove the skel file if it exists
	rm $fileName
} || { #if it does not exist
	echo "Failed to remove executable file..."
}

#create driver.c
echo "int main() {int ret_status; ret_status = asm_main(); return ret_status;}" > driver.c
echo -e "\e[31m\nImplicit Delcaration Error should be ignored...\n\n\e[0m"

#create object file and compile
nasm -f elf64 -g ${fileName}'.asm'
gcc -no-pie -ggdb -o ${fileName} ${fileName}'.o' driver.c

#remove object file
rm ${fileName}'.o'

#run the file
#./${fileName}

#run debugger
gdb ${fileName}

#remove driver.c
rm driver.c

#remove the executable file
rm $fileName
