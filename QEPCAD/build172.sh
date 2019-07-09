#Script to make QEPCAD and SLFQ, found here:
#http://d.hatena.ne.jp/ehito/20190107/1546864180

export CAS=~/CAS
mkdir $CAS
export qe=$CAS/qesource
export saclib=$CAS/saclib2.2.7
cd $CAS
wget https://www.usna.edu/Users/cs/wcbrown/qepcad/INSTALL/saclib2.2.7.tar.gz
tar zxvf ./saclib2.2.7.tar.gz -C ./
cd $saclib/bin
./sconf
./mkproto
./mkmake
./mklib all
cd $CAS
wget https://www.usna.edu/Users/cs/wcbrown/qepcad/INSTALL/qepcad-B.1.72.tar.gz
tar zxvf ./qepcad-B.1.72.tar.gz -C ./
cd $qe
sed -i "s/csh/sh/g" $qe/Makefile
make
sed -i "s/\#SINGULAR/SINGULAR/g" $qe/default.qepcadrc
cd $CAS
wget https://www.usna.edu/Users/cs/wcbrown/qepcad/SLFQ/simplify-1.20.tar.gz
tar zxvf ./simplify-1.20.tar.gz -C ./
cd ./simplify
make
#sudo ln -s $CAS/qesource/bin/qepcad /usr/local/bin/qepcad
#sudo ln -s $CAS/simplify/slfq /usr/local/bin/slfq
