require 'fluentnode'

xdescribe 'Test-File_Access', ->
  it 'char zero', ->
    file_Content = "some_Text_".add_5_Random_Letters()
    file_Name    = "here"
    temp_File = file_Content.save_As("#{file_Name}.txt".file_Create())
    temp_File.assert_File_Exists()
    console.log temp_File.real_Path()
    console.log temp_File.file_Contents()
    get_Text_File = (name)->
      file_Path = name + '.txt'
      console.log file_Path
      return file_Path.file_Contents()


    console.log get_Text_File(file_Name)
    console.log get_Text_File(file_Name + 'aaa/../' + file_Name )
    console.log get_Text_File(file_Name + ".txt"+String.fromCharCode(0))