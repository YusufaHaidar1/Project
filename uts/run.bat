@echo off
setlocal
setlocal enabledelayedexpansion
ipconfig > ipconfig.txt

rem Mencari baris yang berisi IPv4 Address dan menyimpan nilainya ke variabel ip
for /f "tokens=2 delims=:" %%a in ('findstr /c:"IPv4 Address" ipconfig.txt') do (
  set _ipv4=%%a
)

rem Menghapus spasi di depan dan belakang variabel ip
set _ipv4=%_ipv4: =%
del ipconfig.txt

rem Mengubah .env flutter
copy .\flutter_survey_app\.env .env
for /f "delims=" %%a in (.env) do (
  set "line=%%a"
  if "!line:~0,11!"=="IP_ADDRESS=" set "line=IP_ADDRESS=!_ipv4!"
  echo !line!>>.env.new
)
del .env
move /y .env.new .\flutter_survey_app\.env

rem start laravel
cd .\laravel-backend_survey-api\
start "LaravelSurveyAPI" cmd /c php artisan serve --host=0.0.0.0

rem start flutter
cd ..\flutter_survey_app\
start cmd /c "flutter devices > devices.txt"
timeout /t 7
echo Pilih device yang ingin digunakan:
set count=0
for /f "tokens=1 delims=•" %%a in (devices.txt) do (
  set device[!count!]=%%a
  set /a count+=1
)
set /a count-=1
for /l %%f in (1,1,!count!) do echo %%f. !device[%%f]!
echo 0. exit
set /p choice=Masukkan nomor pilihan Anda: 
if %choice% geq 1 if %choice% leq %count% (
  set _device=!device[%choice%]!
  echo !_device!
  for /f "delims=" %%a in ('findstr /c:"!_device!" devices.txt') do (
    set linedev=%%a
  )
  rem Mengambil bagian kedua dari variabel line yang dipisahkan oleh tanda • dan menyimpannya ke variabel id
  for /f "tokens=2 delims=•" %%a in ('echo !linedev!') do (
    set iddev=%%a
  )
  echo !iddev!
  start "FlutterAPP" cmd /c flutter run -d !iddev!
  :loop
  tasklist /fi "WindowTitle eq FlutterAPP" 2>NUL | find /i /n "cmd.exe">NUL
  rem Jika proses masih ada, maka kembali ke label loop
  if "%ERRORLEVEL%"=="0" goto loop
)

rem end
del devices.txt
taskkill /f /fi "WindowTitle eq LaravelSurveyAPI" /t
endlocal