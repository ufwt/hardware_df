# print the final result in a way easy for manual review
import json

# get the number from the name
def get_num(name):
	p1 = name.find('switched-')+9
	p2 = name.rfind('---')

	#print 'num:',name[p1:p2]
	return name[p1:p2]

def print_pretty():
	record_file = open("record_converted.txt","r")
	record_str = record_file.readline()
	record_dict = json.loads(record_str)
	record_file.close()# load and close

	
	list_length = 1500
	l=[0]*list_length #initialize a list with zeros, length 1500


	for name in record_dict:
		num = int(get_num(name))
		l[num] = record_dict[name] # sort the records by the num in their filename

	count = 1
	i = 0
	while i < list_length:
		if l[i] == 0:
			pass
		else:
			for fetches in l[i]['fetch_list']:
				print '[', count, '] file: ', l[i]['origin_file'],fetches	
				count = count + 1
		i = i + 1

print_pretty()