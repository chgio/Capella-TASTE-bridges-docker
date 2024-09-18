#!/bin/sh
/tmp/workspace/run-sample.sh > /tmp/workspace/out.txt

grep "In-Flight Entertainment System
 - IFE System
 - Passenger
 - Cabin Crew
 - Aircraft
 - Ground Operator" /tmp/workspace/out.txt
