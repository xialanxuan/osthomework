#!/bin/bash
#加anwser id

user=$USER
file="/home/$user/.question"

 
    num=`echo $#`

    if [ -d $file ]
        then
        chmod 755 $file
    else
        mkdir $file
        chmod 755 $file
        mkdir "/home/$user/.question/questions"
		chmod 755 "/home/$user/.question/questions/*"
        mkdir "/home/$user/.question/answers"
		chmod 755 "/home/$user/.question/questions/*"
        mkdir "/home/$user/.question/votes"
		chmod 755 "/home/$user/.question/questions/*"
    fi
    case $num in
        0) echo "You missed option">&1
           exit 1
           ;;
 #       1) echo "You missed option">&1
 #          exit 1
 #          ;;
    esac
#    if [[ "${comm[0]}" != "question" ]]
#        then echo "Sorry, I can only deal with question command">&1
#            exit 1
#    fi

    case "$1" in
        create)
            if [[ $num -lt 2 ]]
                then echo "here a question name is needed">&1
                exit 1
            fi
            if [[ $num -gt 3 ]]
                then echo "too many arguments">&1
                exit 1
            fi
            if [[ "$2" =~ "/" ]]
                then echo "Name can not contain forward slash">&1
                exit 1
            fi
            quesname=$2
            #echo "$quesname"
            if [ -d "/home/$user/.question/questions/$quesname" ]
                    then echo "question already exists">&1
                    exit 1   
#                else  mkdir -p "./.question/questions/$user"
            fi
            if [ $num -eq 2 ]
                then
                echo "question can not be empty, please enter question"
                read ques
                else ques=$3
            fi
                while true
                    do
                        if [[ $ques = "" ]]
                            then echo "question can not be empty"
                            read ques
                        elif [[ "$ques" =~ "====" ]]
                            then echo "question can not contain a sequence of ="
                            echo "please input new question"
                            read ques
                        else break
                        fi

                    done

                echo $ques > "/home/$user/.question/questions/$quesname"
				exit 0
            ;;

        answer)
            if [[ $num -lt 2 ]]
                then echo "here a question id is needed">&1
                exit 1
            fi
            if [[ $num -gt 4 ]]
                then echo "too many arguments">&1
                exit 1
            fi
            if [[ "$2" =~ "/" ]]
                then 
					quesuser=`echo $2 | cut -d'/' -f1` 
					quesname=`echo $2 | cut -d'/' -f2`
					#echo $quesuser,$quesname	
								
					if [[ -f "/home/$quesuser/.question/questions/$quesname" ]]
                    then
                        if [ $num -eq 2 ]
                            then
                            echo "you miss the answer name">&1
                            exit 1
                        else ansname=$3
                            if [[ "$ansname" =~ "/" ]]
                                then echo "answer name can not have / in it">&1
                                exit 1
                            fi
                            if [[ -d "/home/$user/.question/answers/$quesuser/$quesname" ]]
                                then
                               
                                    if [[ -f "/home/$user/.question/answers/$quesuser/$quesname/$ansname" ]]
                                        then echo "this answer name "$ansname" to "$quesuser/$quesname" already exist">&1
                                        exit 1
                                    fi
                                else mkdir -p "/home/$user/.question/answers/$quesuser/$quesname"
                            fi

                        fi
                        if [ $num -lt 4 ]
                            then
                            echo "answer cannot be empty"
                            read ans
                            else ans=$4
                        fi
                        while true
                            do
                            if [[ $ans = "" ]]
                                then echo "answer can not be empty"
                                read ans
                            elif [[ "$ans" =~ "====" ]]
                                then echo "answer can not contain a sequence of ="
                                echo "please input new answer"
                                read ans
                            else break
                            fi
                        done
                    else echo "there is no such question: "$queuser/$quesname>&1
                        exit 1
                fi
            else echo "question id should have a / in it">&1
                    exit 1
            fi
            echo $ans > "/home/$user/.question/answers/$quesuser/$quesname/$ansname"
			exit 0
            ;;
			
        list)
			get=0
            if [[ $num -gt 2 ]]
                then echo "too many arguments">&1
                exit 1
            fi
			#list questions of all users
            if [[ $num -eq 1 ]]
                then  				
					while read line
					do
						if [[ -r "/home/$line/.question/questions/" ]]
							then
								find "/home/$line/.question/questions/" -type f | cut -d'/' -f3,6
							fi
					done < 	"/home/unixtool/data/question/users"
            elif [[ $num -eq 2 ]]
			then
					get=0
					while read lines
					do
						if [[ $lines = "$2" ]]
							
							then 
								get=1
								if [[ -d "/home/$lines/.question/questions/" ]]
                        		then 
									if [[ `find "/home/$lines/.question/questions/"  -type f | wc -l` = 0 ]]
									then echo "$lines did not ask question"
									else find "/home/$lines/.question/questions/"  -type f | cut -d'/' -f3,6
									fi
                        		else echo "$lines does not have question directory">&1
                               		 exit 1
                    		 	fi
								break
						 fi
					done < 	"/home/unixtool/data/question/users"
				if [[ get -eq 0 ]]
					then echo "no such user">&1
						exit 1
					fi
            fi
			exit 0
            ;;
			
        vote)
            	if [[ $num -eq 1 ]]
              	 	    then echo "miss arguments">&1
                   	    exit 1
					elif [[ $num -eq 2 ]]
                		then echo "miss question id">&1
                    	exit 1              
				fi
	            if [[ $num -gt 4 ]]
	                then echo "too many arguments">&1
	                exit 1
	            fi
				
				if [[ "$2" != "up" && "$2" != "down" ]]
					then echo "you need vote either up or down" >&1
						exit 1
				fi

			    if [[ "$3" =~ "/" ]]
	                then 
			            vquesuser=`echo $3 | cut -d'/' -f1`
			            vquesname=`echo $3 | cut -d'/' -f2`
						#echo $vquesuser,$vquesname						
						if [[ -f "/home/$vquesuser/.question/questions/$vquesname" ]]
	                    then

							if [[ ! -d "/home/$user/.question/votes/$vquesuser" ]]
							 	then mkdir -p "/home/$user/.question/votes/$vquesuser/"
								fi
							 if [[ $num -eq 3 ]]
								then
									echo $2 >> "/home/$user/.question/votes/$vquesuser/$vquesname"					
							elif [[ $num -eq 4 ]] 
							then
									vansuser=`echo $4|cut -d'/' -f1`
									vansname=`echo $4|cut -d'/' -f2`
									#echo $vansuser/$vansname
									#echo $tmp
									if [[ -f "/home/$vansuser/.question/answers/$vquesuser/$vquesname/$vansname" ]]
										then
											echo "$2 $4" >> "/home/$user/.question/votes/$vquesuser/$vquesname"
										else echo "no such answer exits" >&1
											exit 1
									fi
								else echo "too many arguments">&1
									exit 1
							fi
						else echo "no such question "$vquesuser/$vquesname >&1
							exit 1
						fi
					else echo "wrong question id format" >&1
					fi	
				exit 0
			;;
			
		show|view)
			if [[ $num -lt 2 ]]; then
				echo "miss question id" >&1
				exit 1
			fi
			#there could be multiple question ids
	    	while [[ $# -gt 1 ]]; do
	    		#statements
	    		#v1=`echo $2`
				#echo $2
	            squesuser=`echo $2 | cut -d'/' -f1`
	            squesname=`echo $2 | cut -d'/' -f2`
				#echo $squesuser,$squesname
				
				
	        	if [[ -f "/home/$squesuser/.question/questions/$squesname" ]]; then
					count=0
					#go through all users, count the votes for this question
					while read lines
					do
						
						if [[ -r "/home/$lines/.question/votes/$squesuser/$squesname" ]]
							then
								#cat "/home/$lines/.question/votes/$squesuser/$squesname"
								
									#echo $line
									if [[ `cat "/home/$lines/.question/votes/$squesuser/$squesname" | egrep "^(up|down)$" | tail -1 | egrep "^up$" | wc -l` = 1 ]]; then
										count=$(expr $count + 1)
							
									elif [[ `cat "/home/$lines/.question/votes/$squesuser/$squesname" | egrep "^(up|down)$" | tail -1 | egrep "^down$" | wc -l` = 1 ]]
									then
										 count=$(expr $count - 1 )
									
									fi
									
								
									#echo $count, $lines,  $line
								
									
							fi
					done < 	"/home/unixtool/data/question/users"				
					echo $squesuser/$squesname
					echo $count
					showque=`head -1 "/home/$squesuser/.question/questions/$squesname"` 
					echo $showque
					echo "====="
					
					#go througth all users, count the votes for the answers to the question 
					while read lines
					do
						if [[ -d "/home/$lines/.question/answers/$squesuser/$squesname" ]]
							then
								path=/home/$lines/.question/answers/$squesuser/$squesname/	
								cd $path
								for filename in `ls`
								do
									if [[ -r "/home/$lines/.question/answers/$squesuser/$squesname/$filename" ]]; then
										#statements
										#echo $filename
									countans=0								
									while read aline
									do
										#echo $aline
										if [[ -r "/home/$aline/.question/votes/$squesuser/$squesname" ]] 
										then
											#cat "/home/$aline/.question/votes/$squesuser/$squesname"
											#echo "~~~~~~$lines/$filename"
											#cat "/home/$aline/.question/votes/$squesuser/$squesname" | egrep "(up|down) $lines/$filename"
											#echo "----"		
											if [[ `cat "/home/$aline/.question/votes/$squesuser/$squesname" | egrep "(up|down) $lines/$filename" | tail -1 | egrep "up" | wc -l` = 1 ]]; then
												countans=$(expr $countans + 1)
											elif [[ `cat "/home/$aline/.question/votes/$squesuser/$squesname" | egrep "(up|down) $lines/$filename" | tail -1 | egrep "down" | wc -l` = 1 ]]
											then
												 countans=$(expr $countans - 1 )
											fi
											#echo $contans
										fi							
									done < 	"/home/unixtool/data/question/users"
									echo $lines/$filename
									echo $countans
									cat "/home/$lines/.question/answers/$squesuser/$squesname/$filename"
									echo "====="	
								fi			
								done 																
							fi

					done < 	"/home/unixtool/data/question/users"
					 
								
				else echo "no such question exist ????" >&1
					exit 1
				fi
				shift 1
				echo
	    	done
		
			exit 0
		;;
		#get option will show all the answer to the question, the format would be: question get question_id
		get)
		
		if [[ $num -lt 2 ]]; then
			echo "miss question id" >&1
			exit 1
		fi

            gquesuser=`echo $2 | cut -d'/' -f1`
            gquesname=`echo $2 | cut -d'/' -f2`
			#echo $squesuser,$squesname
			
			
        	if [[ -f "/home/$gquesuser/.question/questions/$gquesname" ]]; then		
				#go througth all users, count the votes for the answers to the question 
				while read lines
				do
					if [[ -d "/home/$lines/.question/answers/$gquesuser/$gquesname" ]]
						then
							path=/home/$lines/.question/answers/$gquesuser/$gquesname/	
							cd $path
							for filename in `ls`
							do
								if [[ -r "/home/$lines/.question/answers/$gquesuser/$gquesname/$filename" ]]; then
									#statements
									echo $lines/$filename
									cat "/home/$lines/.question/answers/$gquesuser/$gquesname/$filename"
									echo "===="
							fi			
							done 																
						fi

				done < 	"/home/unixtool/data/question/users"
							
			else echo "no such question exist" >&2
				exit 1
			fi
		
	
		exit 0
		
		;;
		*)
		echo "no such option, please check your input" >&2
		exit 1
		;;
    esac












