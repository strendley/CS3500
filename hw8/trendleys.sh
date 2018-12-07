#Programmer: Skylar Trendley
#Professor: Leopold
#HW8 - Bash Scripting

#unzip all files into directories if they do not already exist
if [ ! -d "sampleInput" ] && [ ! -d "expectedOutput" ] && [ ! -d "submissions" ]
then
	unzip sampleInput.ZIP -d "sampleInput"
	unzip expectedOutput.ZIP -d "expectedOutput"
	unzip submissions.ZIP -d "submissions"
fi

#grab the number of files in the sampleInput directory
cd "sampleInput/"
inputCount=$(find "$@" -type f | wc -l)
cd ..

#if the a directory for actual output doesnt exist, make one
if [ ! -d "actualOutput" ]
then
	mkdir -p "actualOutput"
fi

#if a file named grades.txt already exists, remove it and make a better one
if [ -f "grades.txt" ]
then
	rm "grades.txt"
fi

#loop through the students
for studentFile in "submissions/"*.pl
do
	
	filename="${studentFile##*/}" #get the name of the file
	name="$(echo "$filename" | cut -f 1 -d '.')" #cut the extension off the file
	
	#if there isnt a spot for them in the actual output folder, make one
	if [ ! -d "actualOutput/$name" ] 
	then
		mkdir -p "actualOutput/$name"
	fi
	
	numChecked=0 #number of files checked
	numCorrect=0 #count number of inputs that are correct
	possiblyCheating="false" #place holder to check if student is cheating
		
	#loop through the input files in the student's directory
	for inputFile in "sampleInput/"*.txt
	do
		numChecked=$((numChecked+1)) #increment the number of files checked
		input="$(< $inputFile)" #cat the file contents into a var
		
		#compile the students prolog file
		swipl $studentFile $input > "actualOutput/$name/$numChecked.out"
		
		#cat the contents of their out file into a var
		actualOut="$(< actualOutput/$name/$numChecked.out)"
		
		#cat the contents of the expected output into a var
		expectedOut="$(< expectedOutput/input$numChecked.txt.out)"
		
		#if expected output and actual output vars match
		if diff <(echo "$actualOut") <(echo "$expectedOut")
		then
			numCorrect=$((numCorrect+1)) #increment the number of correct problems
			subContents="$(< submissions/$filename)" #put their submission into a var
			
			#check for hard coded words in their file
			cheating=$(cat ./submissions/$filename | grep -E -o "${input}") 
			
			#if they hardcoded a word into their submission
			if [[ -z "$cheating" ]]
			then
				possiblyCheating="false" #they didnt cheat
			else
				possiblyCheating="true" #they did cheat
			fi		
		fi
	done
	
	#calculate their score based on the number of problems they got correct
	score=$(echo $numCorrect / $inputCount | bc -l)
	
	#turn their score into a percentage and remove trailing zeros
	percentage=$(echo "$score * 100" | bc -l | sed '/\./ s/\.\{0,1\}0\{1,\}$//' )
	
	if $possiblyCheating = "true"
	then
		star="*"
	else
		star=""
	fi
	
	
	#send the grades to the grades.txt file
	echo $name $percentage$star >> grades.txt
			
done
