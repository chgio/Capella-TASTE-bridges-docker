#!/bin/sh
/workspace/sample/scripts/run-sample.sh > /tmp/out.txt

grep "In-Flight Entertainment System
 - IFE System
 - Passenger
 - Cabin Crew
 - Aircraft
 - Ground Operator" /tmp/out.txt
