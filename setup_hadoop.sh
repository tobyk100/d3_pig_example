#!/bin/bash

hadoop fs -mkdir d3pigex
hadoop fs -copyFromLocal premium.csv d3pigex
hadoop fs -copyFromLocal events.csv d3pigex
