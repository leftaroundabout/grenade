#!/bin/bash -eu
>>>>>>> Convert gen-mnist example to use LeCun training data; works
stack=cabal
trainset=train-images-idx3-ubyte.gz
trainlab=train-labels-idx1-ubyte.gz
testset=t10k-images-idx3-ubyte.gz
testlab=t10k-labels-idx1-ubyte.gz
url=http://yann.lecun.com/exdb/mnist
datadir="data"
args=""
case $1 in
  (-?*)
    echo >&2 "Missing initial data directory argument"
    exit 1;;
  (*)
    datadir=$1
    shift
    args="$@";;
esac
exec="$stack exec mnist --RTS -- $datadir $args +RTS -N -s"
if [ -f $datadir/$trainset ]
then
  $stack build mnist && $exec
 else
  mkdir -p $datadir
  echo "Attempting to download MNIST data"
  curl -o $datadir/$trainset $url/$trainset
  curl -o $datadir/$trainlab $url/$trainlab
  curl -o $datadir/$testset $url/$testset
  curl -o $datadir/$testlab $url/$testlab

  if [ -f $datadir/$trainset ]
   then
    $stack build mnist && $exec
   else
    echo "$datadir/$trainset does not exist. Please download MNIST files to $datadir/"
  fi
fi
