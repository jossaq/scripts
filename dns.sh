#!/bin/bash
#code=$(fping -g 10.3.1.0/24 | grep alive)
#eval "$code"
fping -g 10.1.100.0/24 | grep --line-buffered alive | awk '{ print $1}' >>ip.ip
fping -g 10.1.102.0/24 | grep --line-buffered alive | awk '{ print $1}' >>ip.ip