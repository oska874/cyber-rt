#!/bin/bash

export LD_LIBRARY_PATH="build/local_depends/lib/"

export PROTOC="build/local_depends/bin/protoc"

if [ $# -ge 1 ]
then
    PROTOC=$1/local_depends/bin/protoc
    LD_LIBRARY_PATH=$1/local_depends/lib/
else
    echo "plese specific the build dir path"
    exit -1
fi

if [ -f $PROTOC ]
then
    echo "protoc=" $PROTOC
else
    echo "plese specific the build dir path contain protoc"
    exit -2
fi

#c++ protobuf
echo "generate c++ proto files"
for i in `ls cyber/proto/*.proto`
do
    $PROTOC -I. -Icyber/proto --cpp_out=.  $i
done

#python protobuf
echo "generate python proto files"
for i in `ls cyber/proto/*.proto`
do
    $PROTOC -I. -Icyber/proto --python_out=.  $i
done

echo "generate examples' proto files"
for i in `ls cyber/examples/proto/*.proto`
do
    $PROTOC -I. -Icyber/proto --cpp_out=.  $i
done

for i in `ls cyber/examples/proto/*.proto`
do
    $PROTOC -I. -Icyber/proto --python_out=.  $i
done

if [ ! -d "./py_proto" ]; then
  echo "py_proto directory does not exist, then create it"
  mkdir -p py_proto/cyber/proto
  mkdir -p py_proto/cyber/example/proto
  touch py_proto/cyber/__init__.py
  touch py_proto/cyber/proto/__init__.py
  touch py_proto/cyber/example/__init__.py
  touch py_proto/cyber/example/proto/__init__.py
else
  echo "py_proto directory  exist, delete and create it"
  rm -rf py_proto
  mkdir -p py_proto/cyber/proto
  mkdir -p py_proto/cyber/example/proto
  touch py_proto/cyber/__init__.py
  touch py_proto/cyber/proto/__init__.py
  touch py_proto/cyber/example/__init__.py
  touch py_proto/cyber/example/proto/__init__.py
fi

if [ ! -d "./log" ]
then
    mkdir log
fi

#move python protobuf file to destination path
echo "install python proto files"
mv `find ./cyber/proto -name "*pb2.py"` ./py_proto/cyber/proto
mv `find ./cyber/examples/proto -name "*pb2.py"` ./py_proto/cyber/example/proto
