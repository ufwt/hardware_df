

import json
class Tool:
	def __init__(self):
		self.old_result = open("record1.txt","r")
		self.new_result = open("record2.txt","w")
		self.buffer = ""
		self.curfile = "" # the file being processed
		self.main_record={} # To construct a large dict to hold all the record together,
							# which can be modified easily later on.
							#record = {}
							#record['origin_file'] = filename
							#record['1_fetch'] = first
							#record['2_fetch'] = second

	def get_curfile(self, origin, num): # get the file name of the switched one
		p = origin.rfind('/')
		filename = origin[p+1:]
		return 'switched-'+str(num)+'---'+filename

	def main(self):
		while True:
			line_str = self.old_result.readline()
			if not line_str:
				print "Finished converting."
				break
			else:
				line = line_str[:len(line_str)-1] #cut '\n'
				item_dict = json.loads(line) #switch to python dict
				originName = item_dict['origin_file'] 
				
				if self.buffer != originName: # got a new file
					self.buffer = originName  
					self.curfile = self.get_curfile(originName, item_dict['No.']) # get the new file name of the switched file
					fetches = []
					fetches.append((item_dict['1_fetch'], item_dict['2_fetch']))
					#print "if fetches:", fetches
					info = {'origin_file': originName, 'fetch_list': fetches}
					self.main_record[self.curfile] = info
					#print "if info:", info
					#print "if main", self.main_record

				else: # now procss fetches from the same file
					self.main_record[self.curfile]['fetch_list'].append((item_dict['1_fetch'], item_dict['2_fetch']))
					#print "else main", self.main_record
				
					
				

	def finish(self):
		self.old_result.close()
		
		main_record_str = json.dumps(self.main_record) 
		self.new_result.write(main_record_str)
		self.new_result.close()
		
		print "Finished."

		for key in self.main_record:
			print key, ": ", self.main_record[key]

###########################################
mytool = Tool()
mytool.main()
mytool.finish()