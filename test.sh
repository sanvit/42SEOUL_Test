#!/bin/bash
echo "C Piscine Project Test Script"
echo "    by.   smun"
echo

export PROJECT=$1
export PRINT_RESULT=$2

find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'

compile() {
    gcc -Wall -Wextra -Werror -o test_ex$1 ex$1/*.c $DIR/$PROJECT/ex$1.c
}

test_c_exercise() {
    echo " === Test Exercise $1 === "
    DIR=$(dirname "$BASH_SOURCE")
    compile $1
    ./test_ex$1 >> utest
    if [[ $PRINT_RESULT == "p" ]]
    then
        echo " >> Your result <<"
        ./test_ex$1
        echo
        echo " >> Expected result <<"
        cat $DIR/$PROJECT/ex$1.result
        echo
    fi

    echo " >> diff result <<"
    diff -U 3 $DIR/$PROJECT/ex$1.result utest | cat -e
    echo
    DIFF_RESULT=$(diff -U 3 $DIR/$PROJECT/ex$1.result utest | cat -e)
    if [[ $DIFF_RESULT == "" ]]
    then
        echo " Diff OK :D"
    else
        echo " Diff KO :("
    fi

    echo
    rm -rf test_ex$1 utest
}

test_norminette() {
    norminette -R CheckForbiddenSourceHeader $(seq $1 $2 | xargs printf "ex%02d ")
}

run_shell_prepare() {
    sh $DIR/$PROJECT/$(printf "ex%02dprepare.sh" "$1")
}

run_shell_answer() {
    sh $DIR/$PROJECT/$(printf "ex%02d.sh" "$1")
}

test_shell_exercise() {
    echo " === Test Exercise $1 === "
    DIR=$(dirname "$BASH_SOURCE")

    cd $(printf "ex%02d" $1)
    if [[ $3 == "prepare" ]]
    then
        run_shell_prepare $1
    fi
    $2 >> ../utest
    run_shell_answer $1 >> ../result
    cd ..

    if [[ $PRINT_RESULT == "p" ]]
    then
        echo " >> Your result <<"
        cat utest
        echo
        echo " >> Expected result <<"
        cat result
        echo
    fi

    echo " >> diff result <<"
    diff -U 3 result utest | cat -e
    echo
    DIFF_RESULT=$(diff -U 3 result utest | cat -e)
    if [[ $DIFF_RESULT == "" ]]
    then
        echo " Diff OK :D"
    else
        echo " Diff KO :("
    fi

    echo
    rm -rf utest result
}

if [[ $PROJECT == "Shell00" ]]
then
    test_shell_exercise 0 "cat z"
    echo
    echo

    # Ex01 Test
    cd ex01
    echo " >> EX01 Your result << "
    tar -xf testShell00.tar
    ls -l testShell00
    echo
    echo "- 파일 퍼미션 확인: -r--r-xr-x"
    echo "- 파일 사이즈 확인: 40"
    echo "- 파일 날짜  확인: Jun 1 23:42 or 6 1 23:42"
    rm -rf testShell00
    cd ..
    echo
    echo

    # Ex02 Test
    cd Ex02
    echo " >> EX02 Your result << "
    tar -xf exo2.tar
    ls -l | grep -v "exo2.tar"
    echo
    echo " == 올바른 값 비교 =="
    echo total XXXX
    echo "drwx--xr-x  2 "$USER"  2020_seoul    ??  6  1 20:47 test0"
    echo "-rwx--xr--  1 "$USER"  2020_seoul     4  6  1 21:46 test1"
    echo "dr-x---r--  2 "$USER"  2020_seoul    ??  6  1 22:45 test2"
    echo "-r-----r--  2 "$USER"  2020_seoul     1  6  1 23:44 test3"
    echo "-rw-r----x  1 "$USER"  2020_seoul     2  6  1 23:43 test4"
    echo "-r-----r--  2 "$USER"  2020_seoul     1  6  1 23:44 test5"
    echo "lrwxr-xr-x  1 "$USER"  2020_seoul     5  6  1 22:20 test6 -> test0"
    echo
    rm -rf test0 test1 test2 test3 test4 test5 test6
    cd ..
    echo
    echo

    # Ex03 Test
    cd Ex03
    echo " >> EX03 Your result << "
    cat klist.txt
    cd ..
    echo
    echo

    test_shell_exercise 4 "sh midLS" prepare
    test_shell_exercise 5 "sh git_commit.sh"
    test_shell_exercise 6 "sh git_ignore.sh" prepare
    test_shell_exercise 7 "cat -e b"
    test_shell_exercise 8 "sh clean" prepare
    test_shell_exercise 9 "file -m ft_magic 42 24" prepare

elif [[ $PROJECT == "Shell01" ]]
then
    echo


elif [[ $PROJECT == "C00" ]]
then
    MAX_EXERCISE=8
    test_norminette 0 $MAX_EXERCISE
    for I in $(seq 0 $MAX_EXERCISE)
    do
        test_c_exercise $(printf "%02d" "$I")
    done


elif [[ $PROJECT == "C01" ]]
then
    MAX_EXERCISE=8
    test_norminette 0 $MAX_EXERCISE
    for I in $(seq 0 $MAX_EXERCISE)
    do
        test_c_exercise $(printf "%02d" "$I")
    done


elif [[ $PROJECT == "C02" ]]
then
    MAX_EXERCISE=12
    test_norminette 0 $MAX_EXERCISE
    for I in $(seq 0 $MAX_EXERCISE)
    do
        test_c_exercise $(printf "%02d" "$I")
    done
    echo " >> Your result <<"
    compile 12
    ./test_ex12 | cat -te
    rm -rf test_ex12


elif [[ $PROJECT == "C03" ]]
then
    MAX_EXERCISE=5
    test_norminette 0 $MAX_EXERCISE
    for I in $(seq 0 $MAX_EXERCISE)
    do
        test_c_exercise $(printf "%02d" "$I")
    done


elif [[ $PROJECT == "C04" ]]
then
    MAX_EXERCISE=2
    test_norminette 0 $MAX_EXERCISE
    for I in {0..2}
    do
        test_c_exercise $(printf "%02d" "$I")
    done
fi
