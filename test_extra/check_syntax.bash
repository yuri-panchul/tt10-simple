#!/usr/bin/env bash

iverilog -g2005-sv -s tb -I ../src ../src/*.sv ../src/*.v ../test/*.v
rm -rf a.out
