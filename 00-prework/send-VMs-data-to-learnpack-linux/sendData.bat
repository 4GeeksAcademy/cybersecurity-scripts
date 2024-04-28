@echo off 
set /a "count=0"
set id[0]=

set program_path=%programfiles%\Oracle\VirtualBox\VBoxManage

echo --------- > data.txt
for /f "tokens=*" %%a in ('"%program_path%" list vms') do (
  set "extracted_value="
  for /f "tokens=2* delims={*}" %%b in ("%%a") do (
    if not "%%b" == "" (     
      "%program_path%" showvminfo --machinereadable %%b >> data.txt    
    )
  )
  echo --------- >> data.txt
)


set /p url=Paste here your learnpack url: 
:: set url=localhost:3001

echo Sending data to %url%...
curl -X POST -F "file=@data.txt" %url%
del data.txt
