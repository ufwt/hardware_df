# print the final result in a way easy for manual review
import json

def print_pretty():
	record_file = open("record2.txt","r")
	record_str = record_file.readline()
	record_dict = json.loads(record_str)
	record_file.close()# load and close

	count = 1

	for name in record_dict:
		for fetches in record_dict[name]['fetch_list']:
			print '[', count, '] file: ', name, 'fetches: ',fetches	
			count = count + 1


print_pretty()