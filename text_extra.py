import os
import sys

text = sys.argv[1]
text_new = sys.argv[2]

lines = open(text).readlines()

fp = open(text_new,'w')
for s in lines:
    fp.write(s[:17]+s[17:].replace(' ','')) 
fp.close()

