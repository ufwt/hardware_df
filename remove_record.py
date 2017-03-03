import json
import sys
import os

def delete(fullfile, line):
	record_file = open("record2.txt","r")
	record_str = record_file.readline()
	record_dict = json.loads(record_str)
	record_file.close()# load and close

	p = fullfile.rfind('/')
	key = fullfile[p+1:] # get the file name, used as the key of dict
	#print record_dict

	if record_dict.has_key(key):

		#print 'list=',record_dict[key]['fetch_list']
		item_deleted = 0
		
		i = len(record_dict[key]['fetch_list']) -1
		while( i >= 0): # check from rear to front, because the deletion could change the list length
			#print 'pair: ', record_dict[key]['fetch_list'][i] 
			if record_dict[key]['fetch_list'][i][0] == str(line) or record_dict[key]['fetch_list'][i][1] == str(line):
				print 'delete pair: ', record_dict[key]['fetch_list'][i], 'in file: ', key
				del record_dict[key]['fetch_list'][i]
				
				item_deleted = 1

			i = i - 1
		'''	
		for (x,y) in fl: #check fl, but delete from record_dict.[key]['fetch_list']
			print 'pair: ', (x,y) 
			if x == str(line) or y == str(line):
				record_dict[key]['fetch_list'].remove([x,y])
				print 'delete pair: ', (x,y) 
				item_deleted = 1 '''
		
		if item_deleted == 1: # when a fetch pair is deleted, we check whether the list if empty
			
			if(len(record_dict[key]['fetch_list']) == 0):	# if empty, the file should be removed.
				rmfile = 'stage2_switch/'+key
				os.remove(rmfile)
				print 'Remove file: ', rmfile
				del record_dict[key]

			new_record_str = json.dumps(record_dict)
			record_file = open("record2.txt","w")
			record_file.write(new_record_str) # rewrite the new record back to the file
			record_file.close()

			

	else:
		print 'Cannot not find key: ', key, 'line: ', line
		return

delete('switched-371---jmb38x_ms.c',659)
delete('switched-8---axs10x.c',91)