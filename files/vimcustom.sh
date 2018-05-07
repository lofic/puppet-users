test -f dotvim/.git/config

if [ $? -ne 0 ]; then
    git clone https://github.com/lofic/dotvim
else
    cd dotvim 1>/dev/null
    git pull
    cd - 1>/dev/null
fi

cd dotvim 1>/dev/null
./apply.sh
cd - 1>/dev/null
