require 'fluentnode'
fs = require 'fs'
file_Content = "some_Text_"#.add_5_Random_Letters()
file_Name    = "here"
#temp_File = file_Content.save_As("#{file_Name}.txt".file_Create())

show_Text_File = (name)->
 console.log name
 fs.readFile name + '.txt', (err, data) ->
   if (err)
     throw err;
   console.log data.toString()


show_Text_File file_Name
show_Text_File file_Name + ".txt\0"
show_Text_File file_Name + ".txt"+String.fromCharCode(0)
show_Text_File file_Name + ".txt"+String.fromCharCode(0) + 'aaaaaaa'

#temp_File.assert_File_Exists()
#console.log temp_File.real_Path()
#console.log temp_File.file_Contents()
#get_Text_File = (name)->
#    file_Path = name + '.txt'
#console.log file_Path
#return file_Path.file_Contents()
#
#
#console.log get_Text_File(file_Name)
#console.log get_Text_File(file_Name + 'aaa/../' + file_Name )
#console.log get_Text_File(file_Name + ".txt"+String.fromCharCode(0))